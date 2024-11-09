---
title: Git Branch
date: 2024-10-15
updated: 2024-10-15
categories: git
tag: 
- learning
---

<!-- toc -->

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

 ***current-branch 的更改合并到 feature-branch 中***



1. **获取所有远程分支的最新状态**：

   ```sh
   git pull
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

- 暂时保存 feature-branch 的所有新提交
- 将 feature-branch 的基础点移到 current-branch 的最新提交
- 然后重新应用 feature-branch 的提交





## 3.删除分支

1. 删除本地分支：
   使用以下命令删除本地分支：

   ```bash
   git branch -d 分支名称
   ```

   如果分支包含未合并的更改，Git会阻止删除。如果你确定要强制删除，可以使用 `-D` 选项：

   ```bash
   git branch -D 分支名称
   ```

   

2. 更新远程分支列表：
   删除本地分支后，你可能还想更新你的远程分支列表，以反映远程仓库的当前状态：

   

   ```
   git fetch -p
   ```

   这个命令会修剪（prune）你的远程分支列表，删除已经不存在于远程仓库的分支引用。

   

3. 删除远程分支的本地引用（可选）：
   如果你想删除指向远程分支的本地引用，可以使用以下命令：

   

   ```bash
   git branch -dr origin/分支名称
   ```

   这不会影响GitHub上的远程分支，只会删除你本地对该远程分支的引用。

## 4.克隆特定分支

```bash
git clone --branch <branch_name> <repository_url>
```



或者使用缩写形式：

```bash
git clone -b <branch_name> <repository_url>
```