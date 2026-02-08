---
title: AIagent_Learning
date: 2026-01-04
categories: 
- AI
tag:
- AI
---

<!-- toc -->

[TOC]

# RAG框架学习

流程框架

```python
User[用户提问] --> Rewrite[Query Rewrite(查询重写)]
Rewrite --> Queries[生成多个子查询]

subgrapHybrid_Retrieval[混合检查 （双路召回）]

	Queries --> Vector_Search[Milvus：向量检索（语义）]
    Queries --> Keyword_Search[Elasticsearch：关键词检索（精确）]
    双路存储：
	向量库（Milvus）： 存储(Vector, Content, Summary)，用于语义检索
    搜索引擎（Elasticsearch）： 存储(Content, Summary),用于关键词检索
    

    Vector_Search --> Results_A[语义结果]
    Keyword_Search --> Results_B[关键词结果]
    
    Results_A & Results_B --> Merge[合并去重]
	Merge --> Rerank[Reranker (重排序模型)]
	Rerank --> Filter[阈值过滤 (Score Filter)]
	Filter --> Context[最终上下文]
	Context --> LLM[LLM 生成回答]
    

```



整个 RAG 流程分为 **知识库构建 (Indexing)** 和 **检索生成 (Retrieval & Generation)** 两个主要阶段

![image-20260105215526020](./../../img/image-20260105215526020.png)