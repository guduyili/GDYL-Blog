---
title: Git Branch
categories: git
tag: 
-learning
---

## 1.分支创建

1. **克隆（或导航到）你的仓库本地副本** ：

   - 如果你还没有克隆仓库，可以使用如下命令：

     ```bash
     git clone https://github.com/your-username/your-repository.git
     cd your-repository
     ```

2. **创建并切换到新分支** ：

   - 使用以下命令创建并切换到一个新的分支：

     ```bash
     git checkout -b your-new-branch-name
     ```

3. **推送新分支到GitHub**：

   - 使用以下命令将新分支推送到GitHub：

     ```bash
     git push origin your-new-branch-name
     ```

## 2.合并分支提交（rebase）

1. **获取所有远程分支的最新状态**：

   ```sh
   git fetch
   ```

   

2. **检查当前所有分支**（包括远程分支）：

   ```sh
   git branch -a
   ```

   

3. **将远程分支检出到本地**：
   假设远程分支名为 `feature-branch`，你可以使用以下命令将其检出到本地：

   ```sh
   git checkout feature-branch
   ```

   如果本地不存在该分支，上述命令会自动创建并切换到该分支。

   

4. **确保本地分支是最新的**：
   切换到本地分支并拉取最新的更改：

   ```bash
   git checkout current-branch
   git pull origin current-branch
   ```

 

  5.**切换到 `feature-branch`：**

```sh
 git checkout feature-branch
```



6.**使用 `rebase` 命令：**

```sh
git rebase current-branch
```



7.**切换回 `current-branch`：**

```sh
git checkout current-branch
```



8.**将 `feature-branch` 的内容合并回来：**

```sh
git merge feature-branch
```