# drawio-skill

<!--lang-switcher-->
<div align="center">

**[English](./README.md)** · **[中文](./README_zh.md)**

</div>
<!--/lang-switcher-->

---

<p align="center">
  <img src="https://img.shields.io/badge/Claude%20Code-Skill-blue?style=flat-square" alt="Claude Code Skill">
  <img src="https://img.shields.io/badge/draw.io-XML-brightgreen?style=flat-square" alt="draw.io">
  <img src="https://img.shields.io/badge/diagrams-5%20种图表-orange?style=flat-square" alt="Diagram Types">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License">
</p>

---

## 简介

`drawio-skill` 是一个 Claude Code Agent Skill，可根据自然语言描述生成符合 draw.io / diagrams.net 规范的 `.drawio` XML 文件。支持 **5 种图表类型**，所有图表遵循统一的**网格对齐布局规范**，确保输出结构清晰、无重叠。

生成的 `.drawio` 文件可直接用 [draw.io](https://app.diagrams.net/) 或 [diagrams.net](https://www.diagrams.net/) 打开并继续编辑。

---

## 支持的图表类型

| 类型 | 说明 |
|------|------|
| **ER 图** | 数据库实体关系图，含表容器、字段行、关系线 |
| **用例图** | UML 用例图，含 Actor、System 边界框、UseCase，include/extend/泛化关系线 |
| **时序图** | UML 时序图，含对象框、生命线、同步/异步/返回消息箭头 |
| **流程图 / BPMN** | 业务流程图，含开始/结束节点、活动、判断分支、流程箭头 |
| **类图** | UML 类图，含三段式类框（类名 / 属性 / 方法） |

---

## 目录结构

```
drawio-skill/
├── SKILL.md                                  # Agent 执行指令（英文）
├── README.md                                 # 英文版说明
├── README_zh.md                              # 本文件（中文版）
├── .gitignore
├── references/
│   ├── drawio_xml_format.md                  # draw.io XML 格式规范
│   └── diagram_content_standards.md           # 图表内容/布局标准
├── scripts/
│   └── validate_drawio.sh                   # XML 自动化验证脚本
└── assets/
    ├── template_er.drawio                   # ER 图 XML 模板
    ├── template_usecase.drawio              # 用例图 XML 模板
    ├── template_sequence.drawio              # 时序图 XML 模板
    └── template_flowchart.drawio            # 流程图 XML 模板
```

---

## 快速开始

### 安装

将本仓库克隆到 Claude Code 的 skills 目录：

```bash
git clone https://github.com/YuWuChen82/drawio-skill.git ~/.claude/skills/drawio-skill
```

完成后 `/drawio-skill` 命令即可使用。Claude Code 启动时会自动扫描 `~/.claude/skills/` 目录。

### 使用

在 Claude Code 中触发 skill：

```
/drawio-skill
```

或直接描述需求：

```
帮我画一个医院系统的ER图，包含患者、医生、预约、处方四张表
```

```
为在线购物系统画一个用例图，包含买家、卖家、管理员三个Actor
```

```
生成用户登录流程的时序图
```

```
画一个贷款审批流程的流程图
```

---

## 生成的输出

Skill 将 `.drawio` XML 文件写入用户目录：

```
C:\Users\{username}\{filename}.drawio
```

在 draw.io 中打开：**文件 → 打开 → 选择该文件**

---

## 验证

```bash
bash scripts/validate_drawio.sh output.drawio
```

检查项：
- ✅ XML 基础结构（`<mxfile>`、`<diagram>`、`<mxGraphModel>`、`<root>`）
- ✅ 图表类型自动识别
- ✅ mxCell 标签闭合
- ✅ 网格坐标对齐（坐标为 10 的倍数）
- ✅ 图例存在性
- ✅ xmllint 深度验证（可选）

---

## 布局规范

### ER 图
```
L1 基础表（User/Account）→ L2 业务表（Product/Order）→ L3 明细表（OrderItem/Payment）→ L4 配置表（Category/Coupon）
左 ─────────────────────→ 中 ───────────────────────────→ 右 ─────────────────────────────────→ 右下角
实线乌鸦脚 = 1:N         虚线 = 自关联               图例固定 x=1140, y=40
```

### 用例图
```
x=0~120:     Actor 区域（左侧，竖向排列，间距 60px）
x=160~1060:  System 边界框（圆角矩形，白色填充，内边距 40px）
               UseCase 在框内 2~3 列网格排列
实线          = 关联
虚线          = include / extend
实线+三角      = 泛化
```

### 时序图
```
列宽 200px   对象框位于顶部（y=40）   生命线垂直虚线延伸
实线+实心三角 = 同步请求
虚线+空心三角 = 返回
实线+空心三角 = 异步
灰色嵌套矩形  = 自调用方法
```

### 流程图
```
主流程左→右
判断分支：是→右/下   否→左/下
绿色圆 = 开始 / 成功
红色圆 = 结束 / 失败
黄色菱形 = 判断 / 审核
白色圆角矩形 = 活动/处理
蓝色平行四边形 = 输入/输出
```

---

## 格式规范详情

所有图表类型的完整 XML 格式说明见 `references/drawio_xml_format.md`，包括：

- 各元素的 mxCell / mxGeometry 结构
- 关系线样式：`endArrow=ERmany`、`endArrow=classic`、`endArrow=open`、`dashed=1`
- 表布局：表头 `y=30`，字段行 `y=60+(n-1)*18`
- ID 命名规范：`t1,t2,t3`（表）、`act1,act2`（Actor）、`uc1,uc2`（用例）、`obj1,obj2`（对象）、`rel1,rel2`（关系线）、`leg1`（图例）

---

## 贡献

欢迎提交 Issue 和 PR，如发现问题或有新增图表类型的建议，请随时反馈。

---

## 许可证

MIT License
