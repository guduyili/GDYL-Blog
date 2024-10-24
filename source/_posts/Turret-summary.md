---
title: Turret summary
date: 2024-10-22
categories: 
- Unity
tag:
- learning
---

## 前言

**Gizmos**实时渲染辅助工具，下文为在塔防游戏中的敌人巡逻点使用



```csharp
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Waypoint : MonoBehaviour
{
    [SerializeField]private Vector3[] points;


    public Vector3[] Points => points; //使用属性来实现只读访问
    public Vector3 CurrentPositions => _currentPositions;

    private Vector3 _currentPositions;
    private bool _gameStarted;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        _gameStarted = true;
        _currentPositions = transform.position;
    }

    public Vector3 GetWaypointPosition(int index)
    {
        return CurrentPositions + points[index];
    }


    //绘制方便开发者查看的视觉信息
    private void OnDrawGizmos()
    {
        if(!_gameStarted && transform.hasChanged)
        {
            _currentPositions = transform.position;
        }


        for(int i = 0; i < points.Length; i++) 
        {
            Gizmos.color = Color.red;
            Gizmos.DrawWireSphere(points[i]+ _currentPositions, 0.5f);


            if(i < points.Length - 1)
            {
                Gizmos.color = Color.gray;
                Gizmos.DrawLine(points[i] + _currentPositions, points[i + 1] + _currentPositions);
            }
        }
    }
}

```



#### 1.Waypoint设置

```csharp
 private void OnDrawGizmos()
    {
        if(!_gameStarted && transform.hasChanged)
        {
            _currentPositions = transform.position;
        }

		//在for循环中对每个点进行处理
        for(int i = 0; i < points.Length; i++) 
        {
            //绘制红色线框球体，用以代表每个路径点
            Gizmos.color = Color.red;
            Gizmos.DrawWireSphere(points[i]+ _currentPositions, 0.5f);


            //在两点之间画一个灰色的线以相互连接
            if(i < points.Length - 1)
            {
                Gizmos.color = Color.gray;
                Gizmos.DrawLine(points[i] + _currentPositions, points[i + 1] + _currentPositions);
            }
        }
    }
}
```



#### 2.WaypointEditor设置

```csharp
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;


[CustomEditor(typeof(Waypoint))]
public class WaypointEdit : Editor
{
    
    //获取目标对象并转换为Waypoint类型
    Waypoint Waypoint => target as Waypoint;
    
    
    //在Scene视图中展示用于编辑路径点的交互控件
    private void OnSceneGUI()
    {
		
        //设置Handles 工具颜色为青色
        Handles.color = Color.cyan;
        for (int i = 0; i < Waypoint.Points.Length; i++)
        {
            
            //开始检测用户交互的改变
            EditorGUI.BeginChangeCheck();

            //计算当前路径点在世界空间的位置，通过将局部路径点加上当前位置
            Vector3 currentWaypointPoint = Waypoint.CurrentPositions +
            Waypoint.Points[i];
            
            
            // 创建一个可以在场景中自由移动的控制手柄（handle）
			// 它用于场景视图中拖动调整路径点的位置
			Vector3 newWaypointPoint = Handles.FreeMoveHandle(
    				currentWaypointPoint,     // 当前路径点在世界坐标系中的位置
    				0.7f,                     // 控制手柄的大小
    				new Vector3(0.3f, 0.3f, 0.3f), // 距离衰减值 (拖动响应的灵敏度)
    				Handles.SphereHandleCap   // 使用球形外观来显示手柄
			);

               // 设置用于显示文本的 GUI 样式
            GUIStyle textStyle = new GUIStyle
            {
                fontStyle = FontStyle.Bold, // 文本样式为粗体
                fontSize = 16, // 设置文本字体大小
                normal = { textColor = Color.yellow } // 文本颜色为黄色
            };

            // 为标签文字计算一个偏移量，使其避免与句柄重叠
            Vector3 textAlligment = Vector3.down * 0.35f + Vector3.right * 0.35f;

            // 在当前路径点旁显示一个文本标签，标注该路径点的索引
            Handles.Label(
                Waypoint.CurrentPositions + Waypoint.Points[i] + textAlligment,
                $"{i + 1}", // 路径点索引从1开始
                textStyle // 指定文本样式
            );

            
			//检测是否改动句柄的位置
            EditorGUI.EndChangeCheck();

            //如果句柄位置有所更改，则记录改变并更新路径
            if (EditorGUI.EndChangeCheck())
            {
               // 记录该操作，以便在编辑器中允许撤销
                Undo.RecordObject(target, "Free Move Handle");

                // 更新路径点的局部坐标位置
                Waypoint.Points[i] = newWaypointPoint - Waypoint.CurrentPositions;
            }
        }


    }
}

```



#### 3.Spawner Class设置

```csharp
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// 定义生成模式的枚举
public enum SpawnModes
{
    Fixed, // 固定模式
    Random // 随机模式
}

public class Spawner : MonoBehaviour
{
    // 序列化字段，以便在Unity编辑器中设置

    [Header("Settings")]
    [SerializeField] private SpawnModes spawnModes = SpawnModes.Fixed; // 选择生成模式，默认为固定生成
    [SerializeField] private int enemyCount = 10; // 要生成的敌人总数量
    [SerializeField] private float delayBtwWaves = 1f; 

    //[SerializeField] private GameObject testGO; // 要生成的敌人对象


    [Header("Fixed Delay")]
    [SerializeField] private float delayBtwSpawns; // 两次生成之间的固定延迟时间


    [Header("Random Delay")]
    [SerializeField] private float minRandomDelay; // 随机延迟的最小值
    [SerializeField] private float maxRandomDelay; // 随机延迟的最大值



    private float _spawnTimer; // 用于记录生成计时器的时间
    private float _enemiesSpawned; // 已生成的敌人数目
    private float _enemiesRamaining; //剩余需要生成敌人的数目



    private ObjectPooler _pooler;
    private Waypoint _waypoint;

    private void Start()
    {
        _pooler = GetComponent<ObjectPooler>();
        _waypoint = GetComponent<Waypoint>();

        _enemiesRamaining = enemyCount;

    }

    // 每帧调用一次
    void Update()
    {
        _spawnTimer -= Time.deltaTime; // 减去经过的时间，使计时器倒计时
        if (_spawnTimer < 0) // 如果计时器时间到了
        {
            _spawnTimer = GetSpawnDelay(); // 重置计时器为一个新生成的随机时间
            if (_enemiesSpawned < enemyCount) // 如果已生成敌人数少于目标数量
            {
                _enemiesSpawned++; // 增加生成敌人数计数
                SpawnEnemy(); // 调用生成敌人函数
            }
        }
    }

    // 生成敌人对象的方法
    private void SpawnEnemy()
    {
	    //从对象池中获取一个可用的实例
        GameObject newInstance = _pooler.GetInstanceFromPool();
		
        Enemy enemy = newInstance.GetComponent<Enemy>();
        enemy.waypoint = _waypoint;
        enemy.ResetEnemy();

        enemy.transform.localPosition = transform.position;

        newInstance.SetActive(true);

        //Instantiate(testGO, transform.position, Quaternion.identity); // 在当前对象位置生成敌人对象
    }

	
    private float GetSpawnDelay()
    {
        float delay = 0f;
        if(spawnModes == SpawnModes.Fixed)
        {
            delay = delayBtwSpawns;
        }
        else
        {
            delay = GetRandomDelay();
        }
        return delay;
    }

    // 获取一个随机的延迟时间
    private float GetRandomDelay()
    {
        float randomTimer = Random.Range(minRandomDelay, maxRandomDelay); // 生成一个 min 和 max 范围内的随机浮点数
        return randomTimer; // 返回随机延迟时间
    }


    // 生成下一波敌人的协程
    private IEnumerator NextWave()
    {
        yield return new WaitForSeconds(delayBtwSpawns);
        _enemiesRamaining = enemyCount;
        _spawnTimer = 0f;
        _enemiesSpawned = 0;
    }

    
    // 记录敌人状态的方法
    private void RecordEnemy(Enemy _enemy)
    {
        _enemiesRamaining--;
        if(_enemiesRamaining <= 0)
        {
            StartCoroutine(NextWave());
        }
    }
    
     // 当脚本启用时
    private void OnEnable()
    {
        Enemy.OnEndReached += RecordEnemy; // 订阅敌人到达终点事件
        EnemyHealth.OnEnemyKilled += RecordEnemy; // 订阅敌人被击杀事件
    }

    // 当脚本禁用时
    private void OnDisable()
    {
        Enemy.OnEndReached -= RecordEnemy; // 取消订阅敌人到达终点事件
        EnemyHealth.OnEnemyKilled -= RecordEnemy; // 取消订阅敌人被击杀事件
    }
}

```





#### 4.Object Pooler设置

```csharp
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectPooler : MonoBehaviour
{
    // 需要进行对象池化的预制体
    [SerializeField] private GameObject prefab;
    // 对象池的初始大小
    [SerializeField] private int poolSize = 10;

    // 用于存储可用对象的列表
    private List<GameObject> _pool;
    // 用于放置对象池实例的父容器
    private GameObject _poolContainer;

    // 在游戏对象激活时调用
    private void Awake()
    {
        // 初始化对象池列表
        _pool = new List<GameObject>();
        // 创建一个新的空对象作为容器，用于存放对象池的实例
        _poolContainer = new GameObject($"Pool - {prefab.name}");

        // 创建对象池并初始化指定数量的实例
        CreatePooler();
    }

    // 创建对象池并添加实例对象
    private void CreatePooler()
    {
        // 根据 poolSize 的值来创建对象池中的实例
        for (int i = 0; i < poolSize; i++)
        {
            // 向对象池中添加新的实例
            _pool.Add(CreateInstance());
        }
    }

    // 创建实例并将其设置为非激活状态
    private GameObject CreateInstance()
    {
        // 实例化预制体
        GameObject newInstance = Instantiate(prefab);
        // 将实例移到 _poolContainer 下
        newInstance.transform.SetParent(_poolContainer.transform);
        // 将实例设置为未激活
        newInstance.SetActive(false);
        return newInstance; // 返回新创建的实例
    }

    // 从对象池中获取一个可用的实例
    public GameObject GetInstanceFromPool()
    {
        // 遍历对象池中的所有对象
        for(int i = 0; i < _pool.Count; i++) 
        {
            // 检查对象是否未激活（表示可用）
            if (!_pool[i].activeInHierarchy)
            {
                return _pool[i]; // 返回找到的未激活的对象
            }
        }

        // 如果没有可用对象，则创建新的实例（扩展池）
        return CreateInstance();
    } 

    // 将实例返回到对象池中，通过设置为非激活状态
    public static void ReturnToPool(GameObject instance)
    {
        // 将对象设置为未激活
        instance.SetActive(false);
    }

    // 延迟一段时间后将对象返回到对象池中
    public static IEnumerator ReturnToPoolWithDelay(GameObject instance, float delay)
    {
        // 等待指定的延迟
        yield return new WaitForSeconds(delay);
        // 将对象设置为未激活
        instance.SetActive(false);
    }
}

```





#### 



