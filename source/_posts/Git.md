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