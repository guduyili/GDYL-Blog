---
title: Highlight
date: 2024-10-24
updated: 2024-10-24
categories: 
- Hexo
tag:
- learning
---
## Hexo中更改代码highlight





### 在_config.yml替换为

```yaml
syntax_highlighter: prismjs
highlight:
  line_number: true
  auto_detect: false
  tab_replace: ''
  wrap: true
  hljs: false
prismjs:
  enable: true
  preprocess: true
  line_number: true
```

