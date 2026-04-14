# drawio-skill

<div align="center">

**[English](README.md)** | 中文

</div>

---

## 安装

下载后放入 `~/.claude/skills/` 目录即可。

---

## 简介

**支持 5 种图表**，全部遵循**网格对齐**、**纯黑白配色**、**无背景画布**规范，输出结构清晰、线条不重叠。文件直接用 [draw.io](https://app.diagrams.net/) 打开编辑。

---

## 支持的图表类型

| 类型 | 核心元素 |
|------|---------|
| **ER 图** | 表容器 + 字段行 + 关系线；多模块场景含 include/extend 跨模块关系 |
| **用例图** | 火柴人 Actor + System 边界框 + UseCase 椭圆 + include/extend/泛化连线 |
| **时序图** | 对象框 + 生命线 + 同步/异步/返回消息箭头（BCE 架构） |
| **流程图** | 圆角矩形活动 + 菱形判断 + 椭圆开始/结束 + Yes/No 分支 |
| **类图** | 三段式类框 + 继承/聚合/依赖连线 |

---

## 目录结构

```
drawio-skill/
├── SKILL.md                         # Agent 执行指令
├── README.md                         # 英文说明
├── README_zh.md                      # 本文件（中文说明）
├── references/
│   ├── drawio_xml_format.md         # XML 格式规范（含各图类型完整模板）
│   └── diagram_content_standards.md  # 内容与布局标准
├── scripts/
│   └── validate_drawio.sh           # XML 自动化验证脚本
└── assets/
    ├── template_er.drawio           # ER 图模板
    ├── template_usecase.drawio       # 用例图模板
    ├── template_sequence.drawio      # 时序图模板
    └── template_flowchart.drawio    # 流程图模板
```

---

## 安装

下载后放入 `~/.claude/skills/drawio-skill/` 目录即可。

---

## 使用

在 Claude Code 中直接描述需求即可：

```
帮我画一个电商系统的 ER 图，包含用户表、订单表、商品表
```

```
画一个多模块 ER 图，用户模块（用户表+地址表）和订单模块（订单表+订单项表），
跨模块 include 必选，extend 可选，画布要足够大防止线条重叠
```

```
生成一个用户登录的用例图，包含顾客和管理员两个角色
```

```
画一个贷款审批的流程图：开始 → 审核 → 判断是否通过 → 通过则放款 → 结束
```

---

## 生成输出

文件自动写入**当前项目根目录**（而非用户文件夹）：

```
{项目根目录}/{filename}.drawio
```

打开方式：draw.io → 文件 → 打开 → 选择该 `.drawio` 文件

---

## 画布与配色规范

| 属性 | 规范 |
|------|------|
| **背景** | 纯透明（`page="0"`，无灰色/白色页面） |
| **配色** | 纯黑白（`#000/#333/#555/#888/#ccc/#fff`），禁止彩色 |
| **网格** | `gridSize="10"`，所有坐标为 10 的倍数 |
| **图例** | 每个图右下角必须包含图例 |

---

## 布局规范速查

### ER 图 — L1~L4 语义分层

```
L1 基础表（左上）→ L2 业务表（居中）→ L3 明细表（右/下行）→ L4 配置表（右下）
实线+乌鸦脚 = 1:N      虚线 = 自关联
多模块：模块之间留白 ≥300px，跨模块 include（必选）虚线箭头，extend（可选）虚线三角
图例固定在右下角
```

### 用例图 — 角色-用例分层

```
Actor（左）─── 用例椭圆（System 边界内，2~3列网格）
实线       = 关联
虚线箭头   = include / extend
实线三角   = 泛化
```

### 时序图 — BCE 架构

```
Actor → 边界/接口 → 控制/服务 → 实体/仓库 → 外部系统
对象框在顶部，消息从上到下编号，生命线垂直居中
```

### 流程图

```
主流程左→右，判断分支 Yes→右/下，No→左/下
圆角矩形 = 活动     菱形 = 判断
椭圆     = 开始/结束 实线箭头 = 流程
```

---

## 验证

```bash
bash scripts/validate_drawio.sh output.drawio
```

检查项：XML 结构完整性、图表类型识别、mxCell 标签闭合、网格对齐、图例存在性、xmllint 深度验证。

---

## 格式规范详情

完整 XML 格式说明见 `references/drawio_xml_format.md`，包括：

- 各元素的 mxCell / mxGeometry 结构
- 关系线样式：`endArrow=ERmany` / `endArrow=classic` / `endArrow=open` / `dashed=1`
- ER 图 include（`dashed=1 + endArrow=open + <<include>>`）和 extend（`dashed=1 + endArrow=classic + <<extend>>`）的完整 XML 示例
- ID 命名规范：`t1,t2`（表）、`act1,act2`（Actor）、`uc1,uc2`（用例）、`leg1`（图例）

---

## 贡献

欢迎提交 Issue 和 PR，如发现问题或有新增图表类型的建议，请随时反馈。

---

## 许可证

MIT License
