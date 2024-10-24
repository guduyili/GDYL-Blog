---
title: Gizoms
date: 2024-10-22
updated: 2024-10-22
categories: 
- Unity
tag:
- learning
---

在 Unity 中，Gizmos 是一种2D图形工具，主要用于在 Unity 编辑器中可视化游戏对象或其他游戏元素的某些属性。开发者可以使用 Gizmos 来帮助调试和设计。与 Gizmos 相关的常用函数包括以下几种，它们通常在 Unity 的`OnDrawGizmos`或`OnDrawGizmosSelected`方法中被调用：

1. **`Gizmos.DrawLine(Vector3 from, Vector3 to)`**

   - 用于绘制一条从点 `from` 到点 `to` 的线段。

     

2. **`Gizmos.DrawWireSphere(Vector3 center, float radius)`**

   - 在指定的中心进行绘制一个线框球体，半径为`radius`。

     

3. **`Gizmos.DrawSphere(Vector3 center, float radius)`**

   - 绘制一个实心的球体，其中心在`center`，半径为`radius`。

     

4. **`Gizmos.DrawWireCube(Vector3 center, Vector3 size)`**

   - 绘制一个线框立方体，其中心在 `center`，尺寸为 `size`。

     

5. **`Gizmos.DrawCube(Vector3 center, Vector3 size)`**

   - 绘制一个实心立方体，其中心在 `center`，尺寸为 `size`。

     

6. **`Gizmos.DrawRay(Vector3 from, Vector3 direction)`**

   - 从 `from` 坐标开始，以 `direction` 向量方向绘制一条射线。

     

7. **`Gizmos.DrawIcon(Vector3 center, string name, bool allowScaling = true)`**

   - 在 `center` 位置绘制一个名为 `name` 的图标。`allowScaling` 是一个可选参数，表示图标是否允许按场景进行缩放。

     

8. **`Gizmos.color`**

   - 设置 Gizmos 之后渲染的颜色。例如：`Gizmos.color = Color.red;` 会让之后所有的 Gizmos 绘制成红色。

     

9. **`Gizmos.matrix`**

   - 设置 Gizmos 工具的当前变换矩阵，允许对 Gizmos 的绘制进行缩放、旋转、平移的操作。

     

这些方法主要用于开发阶段，以便设计人员和程序员可以在场景中直观地看到对象的位置、大小和其他属性。注意，Gizmos 只在编辑器中可见，不会在打包后（运行时的游戏中）可见。
