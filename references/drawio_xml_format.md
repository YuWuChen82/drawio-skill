# draw.io XML Format Specification

本文档定义每种图类型的 draw.io XML 格式标准。

---

## 通用颜色规范（强制：纯黑白）

> **所有颜色必须为灰度值。禁止使用任何彩色。**

**允许的颜色值：**
| 颜色 | 用途 |
|------|------|
| `#000` | 文字颜色（最深） |
| `#333` | 边框、描边（深灰） |
| `#555` | 次要描边、文字 |
| `#888` | 虚线、返回消息 |
| `#999` | 辅助边框、嵌套矩形边框 |
| `#ccc` | 浅边框、分隔线 |
| `#fff` | 填充（白色，即无填充） |

> **禁止**：任何 `#xxx` 中的第一个字符为 0-9 以外的字母以外的彩色，如 `#4CAF50`、`#FFF9C4`、`#E3F2FD`、`#2196F3`、`#F57F17`、`#f44336`、`#1565C0`、`#2E7D32`、`#c62828`、`#e8f4f8`、`#f5f5f5`、`#fafafa` 等。所有彩色一律替换为上方灰度值。

---

## 通用模板

```xml
<mxfile host="app.diagrams.net">
  <diagram name="{Diagram Name}" id="{uniqueId}">
    <mxGraphModel
      dx="1200" dy="800"
      grid="1" gridSize="10"
      guides="1" tooltips="1"
      connect="1" arrows="1"
      fold="1" page="0"
      pageScale="1"
      math="0" shadow="0">
      <!-- pageWidth / pageHeight 由内容决定，详见画布尺寸规范 -->
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>

      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

**通用坐标规则：** 所有 `x/y/width/height` 值均为 **10 的倍数**。

---

## 布局通则：宽高公式化原则

> **核心原则：禁止写死宽高。宽度由内容长度决定，高度由内容行数决定。**

### 宽度计算公式

| 形状 | 宽度公式 |
|------|---------|
| 用例椭圆 | `max(文本长度px + 60, 最小宽度120)` |
| 对象框（时序图） | `max(文本长度px + 40, 最小宽度100)` |
| 活动节点 | `max(文本长度px + 40, 最小宽度120)` |
| 判断节点 | `minWidth=120`（菱形固定最小宽） |
| 类框 | `max(最长行px + 20, 最小宽度160)` |

### 高度计算公式

| 形状 | 高度公式 |
|------|---------|
| 表容器 | `30 + 字段数 × 18`（表头30 + 每行18） |
| 类框 | `30 + 属性区高度 + 方法区高度` |
| 活动节点 | `文本行数 × 行高 + 上下padding` |
| 判断菱形 | `minHeight=80`（固定最小高） |
| 椭圆（开始/结束） | `minHeight=40` |
| 系统边界框 | `计算：max(所有用例bottom + padding)` |

### 生命线长度公式

```
Lifeline长度 = y(对象框底部) + (消息数量 × 消息间距) + 尾部余白40
例：3条消息 → y=90 + 3×60 + 40 = 310
```

---

## UML 布局参考标准（每种图的行业惯例）

> 布局不是随意的。UML 规范和业界惯例决定了每种图的元素应该如何排列。

### 用例图参考模式

```
参考1：主Actor+核心业务（最常用）
┌──────────────────────────────────────────────┐
│                                              │
│  主Actor ────── 主用例1 ─ 主用例2 ─ 主用例3   │
│   (User)                                     │
│          ────── 主用例4                       │
│                                              │
│  次级Actor ─── 次用例1 ─ 次用例2             │
│   (Admin)                                    │
│                                              │
└──────────────────────────────────────────────┘

参考2：Include/Extend 紧邻布局
┌──────────────────────────────────────────────┐
│  Actor ─── 登录(基UC) ────┬── 验证验证码(include)
│                    ────┬┴── 找回密码(extend)
└──────────────────────────────────────────────┘
  ↑ include/extend UC 与基UC水平或垂直相邻，间距≤30px
```

### 时序图参考模式（BCE架构）

```
参考：BCE（Boundary-Control-Entity）架构
┌──────────┬──────────┬──────────┬──────────┬──────────┐
│  Actor   │ Boundary │ Control  │  Entity  │ External │
│  (用户)  │  (UI)    │ (Service)│  (Repo)  │  (API)   │
└──────────┴──────────┴──────────┴──────────┴──────────┘
  从左到右 = 与发起者距离递减
  消息流：Actor→Boundary→Control→Entity
  外部API在最右侧
```

### ER图参考模式（L1~L4分层）

```
参考：四层依赖链
L1 ───────────▶ L2 ───────────▶ L3 ───────────▶ L4
用户/账户       业务实体         附属/明细        配置字典
(左上)          (居中)           (右下/下行)      (边缘)
  └────────────────────▶ L2(引用L1外键)
                         └────────────────────▶ L3
```

### 流程图参考模式（泳道）

```
参考：垂直泳道 + 主干判断
┌──────────┬──────────┬──────────┐
│  前端    │  后端     │  数据库   │ ← 泳道标题
│  ────   │  ────    │  ────    │
│ [开始]   │          │          │
│    ↓    │ [处理]   │          │
│ [输入]   │    ↓    │          │
│    ↓    │ ◇判断?───Yes──[活动]│
│         │   │No              │
│         │   ↓                │
│         │ [异常处理]          │
└──────────┴────────────────────┘
```

### 类图参考模式（包+继承）

```
参考：包边界 + 继承树
┌─ 包：domain ────────────────────────┐
│  ┌────────┐                        │
│  │ User   │ ← 父类居上             │
│  └────┬───┘                        │
│   ┌───┴───┐                        │
│   ▼       ▼                        │
│ Admin   Customer ← 子类垂直排列    │
└────────────────────────────────────┘

┌─ 包：infrastructure ──────────────┐
│  UserRepo    OrderRepo ← 同包横向 │
└────────────────────────────────────┘
```

---

## I. ER 图

### 1.1 表容器

**容器：**
```xml
<mxCell id="{t}1" value="TableName" style="
  shape=table;startSize=30;
  container=1;collapsible=0;
  childLayout=tableLayout;
  fixedRows=1;rowLines=0;
  fontStyle=1;align=left;verticalAlign=top;
" vertex="1" parent="1">
  <mxGeometry x="{X}" y="{Y}" width="{W}" height="{H}" as="geometry"/>
</mxCell>
```

**宽度计算：** `{W} = max(最长字段行字符数 × 8 + 20, 180)`

**高度计算：** `{H} = 30 + 字段数 × 18`（表头30 + 每行18）

**表头行（占位）：**
```xml
<mxCell value="" style="
  shape=partialRectangle;html=1;whiteSpace=wrap;collapsible=0;
  fixedRows=1;rowLines=0;fontStyle=1;align=left;verticalAlign=top;
" vertex="1" parent="{t}1">
  <mxGeometry y="30" width="{W}" height="30" as="geometry"/>
</mxCell>
```

**字段行：**
```xml
<mxCell value="{field_name}    TYPE    PK/FK/UK" style="
  shape=partialRectangle;html=1;whiteSpace=wrap;collapsible=0;
  fixedRows=1;rowLines=0;fontStyle=0;align=left;verticalAlign=top;spacingLeft=6;
" vertex="1" parent="{t}1">
  <mxGeometry y="{60+(n-1)*18}" width="{W}" height="18" as="geometry"/>
</mxCell>
```

### 1.2 关系连线

**1:N 关系：**
```xml
<mxCell value="" style="
  edgeStyle=entityRelationEdgeStyle;rounded=0;
  orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=1;
  endArrow=ERmany;endFill=0;
" edge="1" parent="1" source="{src}1" target="{dst}1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

**1:1 关系：** 改 `endArrow=ERone`

**自引用（虚线）：** 加 `dashed=1`

### 1.3 ER 图线条路由规范

**核心原则：** L层依赖关系走各自水平通道，不交叉、不穿越无关表。

```
路由层次（从上到下 = 从L1到L4）：

  L1行 ──────────────────────────────────────▶ L2行
  （水平主通道，y = L1表底边以下20px处）
          │
          │ L3行
          └──────────────────────────────▶ L2行
          （垂直+水平组合路由，先下后右，不穿越L1表）

  L3行 ──────────────────────────────────────▶ L4行
  （水平主通道，y = L3表底边以下20px处）

关系连线锚点：
  源表 → 右边缘中间
  目标表 → 左边缘中间（同一行时）或上/下边缘（不同行时）
```

**总线布局（多表指向同一目标时）：**
```
表A ──┐
表B ──┼──▶ 表D  （A、B的连线先汇聚到同一水平干线，再向下到D）
表C ──┘
  ↓ via point (公共拐点)
```

**禁止：** 连线穿过任何表的主体（不是边缘）；斜向路由；L4直接连L1（必须经过中间层）

### 1.4 ER 图动态布局

```
首行起始Y = 40
行间距 = max(所有表高) + 80

第r行第c列:
  x = 40 + c × (max表宽 + 80)
  y = 40 + r × (max表高 + 80)
```

### 1.5 多模块 ER 图 include / extend 关系（必须含标签文字）

> 多模块 ER 图中，跨模块的引用依赖必须用 `<<include>>` 标签；子类表对基类表用 `<<extend>>` 标签。**标签文字不可省略**，否则无法区分 include/extend 与普通 1:N 关系。

**Include 关系（必选，跨模块引用）：**
```xml
<mxCell value="&#171;include&#187;" style="
  edgeStyle=entityRelationEdgeStyle;rounded=0;
  dashed=1;dashPattern=8 4;
  endArrow=open;endFill=0;html=1;strokeWidth=1.5;strokeColor=#555;
  edgeLabel;align=center;verticalAlign=top;fontSize=10;fontColor=#888;fontStyle=2;
" edge="1" parent="1" source="{srcModule}1" target="{dstModule}1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```
- `dashed=1` + `dashPattern=8 4`：虚线样式
- `endArrow=open`：开放箭头（不含填充）
- `&#171;include&#187;` = UML 标签文字 `<<include>>`
- `fontStyle=2`：斜体（UML 惯例）

**Extend 关系（可选，泛化/特例）：**
```xml
<mxCell value="&#171;extend&#187;" style="
  edgeStyle=entityRelationEdgeStyle;rounded=0;
  dashed=1;dashPattern=8 4;
  endArrow=classic;endFill=0;html=1;strokeWidth=1.5;strokeColor=#555;
  edgeLabel;align=center;verticalAlign=top;fontSize=10;fontColor=#888;fontStyle=2;
" edge="1" parent="1" source="{subClass}1" target="{baseClass}1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```
- `endArrow=classic`：实心三角箭头（表示泛化方向）
- `&#171;extend&#187;` = UML 标签文字 `<<extend>>`
- 箭头方向：子类 → 基类

**Include vs Extend 区别：**
```
Include（引用依赖）：虚线 + 空心箭头 + <<include>>
  模块A: Order ──▶ User（订单引用用户的user_id）
  方向：引用方 → 被引用方

Extend（泛化特例）：虚线 + 实心三角 + <<extend>>
  DiscountOrder ──▶ Order（优惠订单是订单的特例）
  方向：子类 → 基类
```

**禁止**：include/extend 连线上没有标签文字；Include 用 `endArrow=classic`（这是 Extend 的箭头）；Extend 用 `endArrow=open`（这是 Include 的箭头）

---

## II. 用例图

### 2.1 系统边界框

```xml
<mxCell id="sys1" value="System Name" style="
  shape=rounded;rounded=1;arcSize=14;
  boundingBox=1;html=1;whiteSpace=wrap;
  align=left;verticalAlign=top;
  spacingLeft=10;spacingTop=10;
  fillColor=#fff;strokeColor=#333;strokeWidth=2;
  fontStyle=1;fontSize=14;fontColor=#222;
" vertex="1" parent="1">
  <mxGeometry x="160" y="40"
    width="{用例区总宽度 + 角色区宽度 + gap}"
    height="{用例区总高度 + padding×2}"
    as="geometry"/>
</mxCell>
```

**宽度计算：**
```
width = 角色宽度(50) + gap(20) + 用例区列数 × 列宽(160) + 右边距(40)
      = 50 + 20 + 列数×160 + 40
```

**高度计算：**
```
height = max(所有用例bottom + 上下padding) - min(所有用例top) + 40
        = 用例区实际垂直跨度 + 40
```

> **禁止**：`width="900" height="600"` 硬编码。必须根据用例数量和排列计算。

### 2.2 Actor（角色，必须是火柴人）

> **强制**：参与者必须使用 `shape=umlActor`（标准 UML 火柴人），禁止使用矩形/圆形/其他形状替代。

```xml
<mxCell id="act1" value="" style="
  shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;
  html=1;outlineConnect=0;fillColor=#fff;strokeColor=#333;strokeWidth=2;
" vertex="1" parent="1">
  <mxGeometry x="40" y="{100 + (n-1)*80}" width="30" height="60" as="geometry"/>
</mxCell>
<mxCell id="act1_lbl" value="Actor Name" style="
  text;html=1;strokeColor=none;fillColor=none;
  align=center;verticalAlign=top;fontSize=11;fontColor=#333;
" vertex="1" parent="1">
  <mxGeometry x="10" y="{165 + (n-1)*80}" width="90" height="20" as="geometry"/>
</mxCell>
```

### 2.3 UseCase（用例椭圆）

```xml
<mxCell id="uc1" value="Use Case Name" style="
  shape=ellipse;html=1;whiteSpace=wrap;
  fillColor=#fff;strokeColor=#555;strokeWidth=1.5;
  align=center;verticalAlign=middle;fontSize=12;fontColor=#222;
" vertex="1" parent="1">
  <mxGeometry x="{X}" y="{Y}"
    width="{max(用例文本长度px + 60, 120)}"
    height="50"
    as="geometry"/>
</mxCell>
```

> **禁止**：`width="160" height="50"` 硬编码。用例文本长度不同，宽度应随之变化。

### 2.4 关系连线

**关联（实线，无箭头）：**
```xml
<mxCell value="" style="
  endArrow=none;html=1;strokeWidth=1.5;strokeColor=#555;
" edge="1" parent="1" source="act1" target="uc1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

**Include（虚线 + open箭头）：**
```xml
<mxCell value="&#xa;&#xa;&#171;include&#187;" style="
  endArrow=open;dashed=1;html=1;strokeWidth=1.5;strokeColor=#555;
  edgeLabel;align=center;verticalAlign=top;fontSize=10;fontColor=#888;fontStyle=2;
" edge="1" parent="1" source="uc1" target="uc2">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

**Extend：** 同 include，仅标签改为 `&#171;extend&#187;`

**泛化：** 改 `endArrow=classic`

### 2.5 用例图线条路由规范

**核心原则：** 同一Actor的关联线走同一水平通道；Include/Extend紧邻基用例。

```
路由层次：

  Actor ──────────▶ uc1 ────▶ uc2(include)     ← 关联线(水平，y对齐uc1中心)
                 ↙ uc3(extend)                  ← extend线(垂直向下，x=uc3中心)

多个Actor时，每Actor的关联线共享同一y坐标（垂直对齐）：
  act1(主) ───▶ uc1 ───▶ uc2
  act2(次) ───▶ uc3 ───▶ uc4
             ↑         ↑
          y对齐uc1   y对齐uc3
```

**禁止穿越规则：**
- 角色→用例连线不得穿过任何其他用例椭圆
- 若连线被阻挡，重新调整用例x坐标（不得调整连线路径）
- Include/Extend线不得与关联线交叉

### 2.6 用例图布局公式

```
角色区: x=0~50，y间距=80px（每行一个Actor）
系统边界: x=70，width按用例列数计算，height按用例行数计算
用例网格: 列间距=160px，行间距=80px
  列x = 70 + 50 + gap(20) + col×160
  行y = 40 + row×80

Include/Extend 紧邻布局（关键）：
Include UC 与基UC水平相邻：
  x(include_uc) = x(基UC) + width(基UC) + 20
  y(include_uc) = y(基UC)  ← 同一水平线

Extend UC 与基UC垂直相邻：
  x(extend_uc) = x(基UC)
  y(extend_uc) = y(基UC) + 80  ← 垂直下方
```
> 禁止 Include/Extend UC 与基UC间距超过 30px。

---

## III. 时序图

### 3.1 对象框（顶部）

```xml
<mxCell id="obj_user" value="User" style="
  shape=rounded;rounded=1;html=1;whiteSpace=wrap;
  fillColor=#fff;strokeColor=#333;strokeWidth=2;
  align=center;verticalAlign=middle;
  fontSize=12;fontColor=#333;fontStyle=1;
" vertex="1" parent="1">
  <mxGeometry x="{X}" y="40"
    width="{max(文本长度px + 40, 100)}"
    height="50"
    as="geometry"/>
</mxCell>
```

> **禁止**：`width="120" height="50"` 硬编码。

### 3.2 生命线

```xml
<mxCell value="" style="
  endArrow=none;dashed=1;html=1;
  strokeWidth=1;strokeColor=#555;strokeDashPattern=1 3;
" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{对象框中心x}" y="90" as="sourcePoint"/>
    <mxPoint x="{对象框中心x}"
             y="{90 + 消息数×60 + 40}"
             as="targetPoint"/>
  </mxGeometry>
</mxCell>
```

> **禁止**：`y="600"` 硬编码终点。用 `90 + 消息数×60 + 40` 动态计算。
> 若消息数量未知，保守按 `y=600`，但应在图中说明可后续调整。

### 3.3 消息箭头

**同步请求（实线 + 实心三角）：**
```xml
<mxCell value="operation()" style="
  endArrow=block;endSize=10;html=1;strokeWidth=1.5;strokeColor=#333;
" edge="1" parent="1" source="obj_user" target="obj_sys">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="{起始对象中心x}" y="{90 + 消息序号×60}" as="sourcePoint"/>
  </mxGeometry>
</mxCell>
```

**异步消息（空心三角）：** 改 `endArrow=open`

**返回（虚线 + 空心三角）：**
```xml
<mxCell value="returnValue" style="
  endArrow=open;html=1;strokeWidth=1.5;dashed=1;strokeColor=#888;
" edge="1" parent="1" source="obj_sys" target="obj_user">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### 3.4 自调用

```xml
<mxCell value="1. methodA()" style="
  shape=rect;html=1;whiteSpace=wrap;
  fillColor=#fff;strokeColor=#999;strokeWidth=1;
  align=left;verticalAlign=top;
" vertex="1" parent="1">
  <mxGeometry x="55" y="150"
    width="90"
    height="{自调用行数×20 + 10}"
    as="geometry"/>
</mxCell>
```

### 3.5 时序图布局公式 + BCE 对象排序

```
列宽 = max(对象文本最长px + 40, 100)（不等宽）
列起始x = 40, 40+列宽1, 40+列宽1+列宽2, ...

对象列顺序（从左到右 = 与Actor距离递减）：
  Actor → Boundary/Interface → Control/Service → Entity/Repo → ExternalSystem

消息y坐标: y = 90 + 消息序号×60
  序号1 → y=90, 序号2 → y=150, 序号3 → y=210, ...
```

### 3.6 时序图线条路由规范

**核心原则：** 消息箭头严格水平；生命线垂直居中；所有箭头起点/终点与生命线对齐。

```
路由规范：

  生命线：x = 对象框中心x，严格垂直（不得偏移）
  消息箭头：y = 90 + 序号×60，严格水平（不得倾斜）
  箭头起点/终点：水平对准各对象生命线的x坐标

禁止：
  - 斜向消息线（消息必须是水平直线）
  - 消息与生命线不对齐
  - 箭头穿过对象框（消息只出现在生命线之间）
  - 两条消息线重叠（用不同y坐标区分）
```

---

## IV. 流程图 / BPMN

### 4.1 节点类型（全部禁止硬编码宽高）

**开始/结束（椭圆）：**
```xml
<mxCell value="Start" style="
  shape=ellipse;html=1;whiteSpace=wrap;
  fillColor=#fff;strokeColor=#333;strokeWidth=2;
  align=center;verticalAlign=middle;
  fontSize=12;fontColor=#333;fontStyle=1;
" vertex="1" parent="1">
  <mxGeometry x="{X}" y="{Y}"
    width="{max(文本长度px + 40, 最小宽度)}"
    height="40"
    as="geometry"/>
</mxCell>
```

**活动节点（圆角矩形）：**
```xml
<mxCell value="Process Step" style="
  shape=rounded;rounded=1;html=1;whiteSpace=wrap;
  fillColor=#fff;strokeColor=#333;strokeWidth=1.5;
  align=center;verticalAlign=middle;fontSize=12;
" vertex="1" parent="1">
  <mxGeometry x="{X}" y="{Y}"
    width="{max(文本长度px + 40, 120)}"
    height="{max(文本行数×20 + 20, 40)}"
    as="geometry"/>
</mxCell>
```

> **禁止**：`width="160" height="60"` 硬编码。

**判断节点（菱形）：**
```xml
<mxCell value="Passed?" style="
  shape=rhombus;html=1;whiteSpace=wrap;
  fillColor=#fff;strokeColor=#333;strokeWidth=1.5;
  align=center;verticalAlign=middle;fontSize=11;
" vertex="1" parent="1">
  <mxGeometry x="{X}" y="{Y}"
    width="120"
    height="80"
    as="geometry"/>
</mxCell>
```

> 判断菱形宽高固定最小值（120×80），可根据文字长度增大，但不可硬编码为其他尺寸。

**输入/输出（平行四边形）：**
```xml
<mxCell value="Input Data" style="
  shape=parallelogram;html=1;whiteSpace=wrap;
  fillColor=#fff;strokeColor=#333;strokeWidth=1.5;
  align=center;verticalAlign=middle;fontSize=11;
" vertex="1" parent="1">
  <mxGeometry x="{X}" y="{Y}"
    width="{max(文本长度px + 40, 120)}"
    height="50"
    as="geometry"/>
</mxCell>
```

**结束节点（实心圆）：**
```xml
<mxCell value="" style="
  shape=ellipse;html=1;whiteSpace=wrap;
  fillColor=#fff;strokeColor=#333;strokeWidth=2;
" vertex="1" parent="1">
  <mxGeometry x="{X}" y="{Y}" width="30" height="30" as="geometry"/>
</mxCell>
```

### 4.2 连接箭头

```xml
<mxCell value="Yes" style="
  endArrow=classic;html=1;strokeWidth=1.5;strokeColor=#333;
" edge="1" parent="1" source="dec1" target="act_yes">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### 4.3 流程图布局公式

```
节点间距: 水平≥60px，垂直≥80px
判断分支: Yes→右(水平+60) 或 下(垂直+80)，No→反向

第n个节点:
  x = 起始x + (节点index - 1) × (节点宽度 + 60)
  y = 起始y + 当前行偏移
```

### 4.4 流程图线条路由规范

**核心原则：** 主干水平直线，主干→分支用直角拐弯，禁止斜线，禁止穿越无关节点。

```
路由规范：

主干流（主路径，水平）：
  严格水平，y = 起始y
  只有在遇到节点时才在节点下方/上方转弯

分支（从主干分出）：
  直角路由：水平→垂直 或 垂直→水平（不得同时水平+垂直后再拐弯）
  禁止：从节点中间直接斜向分支

判断分支路由：
  判断节点 ──Yes──▶ 右侧活动   ← 水平右行，y不变
             │
             No
             ↓
            下方活动            ← 垂直下行，x不变

合并节点：
  两路分支在合并点汇合，用实心圆，直径30px
  合并点之后的线从圆心向下/右延续
```

**禁止：**
- 任何斜线（`strokeColor` 连线不得有斜率）
- 穿越无关节点主体的连线（可从节点边缘绕过）
- 从节点侧边中间向侧边中间连线的斜向穿越

### 4.5 Swimlane（泳道）XML 模板

泳道用于分隔不同角色/系统的职责区域。

**泳道分隔线（垂直分隔，贯穿全高）：**
```xml
## // Swimlane 1 title

<mxCell value="前端" style="
  text;html=1;strokeColor=none;fillColor=none;
  align=center;verticalAlign=middle;fontSize=12;fontColor=#333;fontStyle=1;
" vertex="1" parent="1">
  <mxGeometry x="40" y="40" width="180" height="30" as="geometry"/>
</mxCell>

<mxCell value="" style="
  endArrow=none;html=1;strokeWidth=2;strokeColor=#555;
" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="220" y="40" as="sourcePoint"/>
    <mxPoint x="220" y="600" as="targetPoint"/>
  </mxGeometry>
</mxCell>


<mxCell value="后端" style="
  text;html=1;strokeColor=none;fillColor=none;
  align=center;verticalAlign=middle;fontSize=12;fontColor=#333;fontStyle=1;
" vertex="1" parent="1">
  <mxGeometry x="220" y="40" width="180" height="30" as="geometry"/>
</mxCell>

<mxCell value="" style="
  endArrow=none;html=1;strokeWidth=2;strokeColor=#555;
" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="400" y="40" as="sourcePoint"/>
    <mxPoint x="400" y="600" as="targetPoint"/>
  </mxGeometry>
</mxCell>
```

> 泳道宽 = 该泳道内最宽节点 + 节点到分隔线间距（≥20px）。泳道数量 = 角色/系统数量。

### 4.6 包边界 XML 模板（类图）

```xml

<mxCell value="包：domain" style="
  text;html=1;strokeColor=none;fillColor=none;
  align=left;verticalAlign=top;fontSize=13;fontColor=#555;fontStyle=2;
" vertex="1" parent="1">
  <mxGeometry x="200" y="80" width="100" height="20" as="geometry"/>
</mxCell>

<mxCell value="" style="
  endArrow=none;dashed=1;html=1;
  strokeWidth=1;strokeColor=#999;strokeDashPattern="3 3";
" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="200" y="100" as="sourcePoint"/>
    <mxPoint x="500" y="100" as="targetPoint"/>
  </mxGeometry>
</mxCell>

<mxCell value="" style="
  shape=rect;html=1;whiteSpace=wrap;
  strokeColor=#999;fillColor=none;strokeWidth=1;dashed=1;strokeDashPattern="3 3";
" vertex="1" parent="1">
  <mxGeometry x="200" y="100"
    width="{包宽 = max(类宽) + 60}"
    height="{包高 = max(类高) + 100}"
    as="geometry"/>
</mxCell>
```

> 包边界为虚线矩形。左上角放包名（斜体 `fontStyle=2`）。所有类元素必须在此矩形范围内。

---

## V. 类图

### 5.1 类框（三段式）

```xml
<mxCell id="cls1" value="ClassName" style="
  shape=table;startSize=30;container=1;collapsible=0;
  childLayout=tableLayout;fixedRows=1;rowLines=1;
  fontStyle=1;align=left;verticalAlign=top;
  fillColor=#fff;strokeColor=#333;strokeWidth=1;
" vertex="1" parent="1">
  <mxGeometry x="200" y="100"
    width="{max(最长行字符数×8 + 20, 160)}"
    height="{30 + 属性行数×18 + 方法行数×18}"
    as="geometry"/>
</mxCell>
```

> **禁止**：`width="180" height="150"` 硬编码。宽高由内容决定。

**属性行和方法行**宽度继承父容器 `{W}`。

### 5.2 类图关系连线

- 聚合：`endArrow=diamond;endFill=0;endSize=15`
- 组合：`endArrow=diamond;endFill=1;endSize=15`
- 依赖：`dashed=1;endArrow=open`
- 继承：`endArrow=classic;endSize=10`

### 5.3 类图线条路由规范

**三层关系线（按重要性分层）：**

| 层次 | 关系类型 | 线条样式 | 路由方向 |
|------|---------|---------|---------|
| 第1层 | 继承（父→子） | 实线 + 空心三角 | 垂直向下，严格对齐父类中心 |
| 第2层 | 聚合/组合 | 实线 + 菱形 | 水平或垂直，菱形在端点 |
| 第3层 | 依赖/关联 | 虚线 + 空心三角 | 水平，箭头指向供应者 |

```
继承树路由（垂直，严格居中对齐）：
  ┌────────┐
  │ 父类   │  ← 父类顶部中心 = 继承线起点
  └────┬───┘
       │（垂直线，x=父类水平中心）
    ┌──┴──┐
    ▼     ▼
  子类1  子类2   ← 子类顶部中心 = 继承线终点
  （多个子类垂直排列，间距60px）

依赖线路由：
  客户端类 ──▶ 供应者类    ← 水平直线，箭头指向供应者
  不得穿越其他类的主体
```

**禁止：** 继承线斜向；依赖线穿过类框；同一继承树内子类之间有连线

---

## VI. 图例模板（按内容自动扩展）

```xml
<mxCell id="leg1" value="Legend" style="
  shape=table;startSize=30;container=1;collapsible=0;
  childLayout=tableLayout;fixedRows=1;rowLines=0;
  fontStyle=1;align=left;verticalAlign=top;
  fillColor=#fff;strokeColor=#ccc;fontColor=#333;
" vertex="1" parent="1">
  <mxGeometry x="1140" y="40"
    width="200"
    height="{30 + 图例内容行数×20}"
    as="geometry"/>
</mxCell>
<mxCell value="" style="
  shape=partialRectangle;html=1;whiteSpace=wrap;collapsible=0;
  fixedRows=1;rowLines=0;fontStyle=1;align=left;verticalAlign=top;
" vertex="1" parent="leg1">
  <mxGeometry y="30" width="200" height="30" as="geometry"/>
</mxCell>
<mxCell value="───── solid = direct association / generalization&#xa;- - - dashed = dependency / extend / return&#xa;◀──── triangle = inheritance / generalization&#xa;──◁── diamond = aggregation / composition&#xa;──▶   crow's foot = one-to-many" style="
  shape=partialRectangle;html=1;whiteSpace=wrap;collapsible=0;
  fixedRows=1;rowLines=0;fontStyle=0;align=left;verticalAlign=top;spacingLeft=8;fontSize=10;fontColor=#666;
" vertex="1" parent="leg1">
  <mxGeometry y="60" width="200"
    height="{图例内容行数×20}"
    as="geometry"/>
</mxCell>
```

> 图例宽度固定200（可容纳最宽行），高度由行数决定：`30 + 行数×20`。

---

## VII. ID 命名规范

```
表/对象:     t1, t2, t3 ... 或 u1, p1, o1
角色:        act1, act2, act3
用例:        uc1, uc2, uc3
对象:        obj1, obj2, obj3
连线:        rel1, rel2, rel3 ...
图例:        leg1
系统框:      sys1
嵌套矩形:    nest1, nest2
```

---

## VIII. 画布尺寸（按规模分级，有充足余量防止线条重叠）

| 规模 | pageWidth × pageHeight | 适用场景 |
|------|----------------------|---------|
| 小（< 5 个元素） | 1200 × 900 | 单角色 / 简单流程 |
| 中（5~15 个元素） | 1800 × 1200 | 普通 ER / 用例 / 时序 |
| 大（> 15 个元素） | 2400 × 1800 | 复杂 ER / 多角色时序 |
| 超大（> 30 个元素 / 多模块） | 3200 × 2400 | 多模块 ER / 多子系统用例 |

> **提示**：draw.io 支持导出为 PNG/SVG，画布尺寸不影响最终输出大小。可先用默认尺寸，内容超出时再扩大。

---

## 附：常用形状尺寸速查表（最小值，非固定值）

| 形状 | 最小宽度 | 最小高度 | 宽度扩展规则 | 高度扩展规则 |
|------|---------|---------|------------|------------|
| 表容器 | 180 | `30 + n×18` | 按字段名最长 | 按字段数 |
| 用例椭圆 | 120 | 50 | 按文本长度 | 固定50 |
| 对象框 | 100 | 50 | 按文本长度 | 固定50 |
| 活动节点 | 120 | 40 | 按文本长度 | 按行数 |
| 判断菱形 | 120 | 80 | 按文本长度 | 按文本长度 |
| 开始/结束椭圆 | 最小按文本 | 40 | 按文本长度 | 固定40 |
| 类框 | 160 | `30 + n×18` | 按最长行 | 按属性+方法行数 |
| 图例 | 200 | `30 + n×20` | 固定200 | 按行数 |
