# draw.io XML Format Specification

本文档定义每种图类型的 draw.io XML 格式标准。

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
      fold="1" page="1"
      pageScale="1"
      pageWidth="1600" pageHeight="1200"
      math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <!-- content -->
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

### 1.3 ER 图动态布局

**不要使用固定坐标表！使用以下公式计算每个表的位置：**

```
首行起始Y = 40
行间距 = max(所有表高) + 80

第r行第c列的表:
  x = 40 + c × (max表宽 + 80)
  y = 40 + r × (max表高 + 80)

其中 max表宽 = max(所有表宽度)
```

```
布局示例（4表，左→右，双行）：
  表A → x=40,  y=40
  表B → x=340, y=40   （假设表宽200，间距80）
  表C → x=640, y=40
  表D → x=40,  y=180  （第二行，根据表高调整）
```

> **禁止**：写死 `TableA(40,40) TableB(40,280)` 这种坐标表——它只适用于固定数量，不适配实际内容。

---

## II. 用例图

### 2.1 系统边界框

```xml
<mxCell id="sys1" value="System Name" style="
  shape=rounded;rounded=1;arcSize=14;
  boundingBox=1;html=1;whiteSpace=wrap;
  align=left;verticalAlign=top;
  spacingLeft=10;spacingTop=10;
  fillColor=#f5f5f5;strokeColor=#333;strokeWidth=2;
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

### 2.2 Actor（角色）

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

### 2.5 用例图布局公式

```
角色区: x=0~50，y间距=80px（每行一个Actor）
系统边界: x=70，width按用例列数计算，height按用例行数计算
用例网格: 列间距=160px，行间距=80px
  列x = 70 + 50 + gap(20) + col×160
  行y = 40 + row×80
```

---

## III. 时序图

### 3.1 对象框（顶部）

```xml
<mxCell id="obj_user" value="User" style="
  shape=rounded;rounded=1;html=1;whiteSpace=wrap;
  fillColor=#e8f4f8;strokeColor=#2196F3;strokeWidth=2;
  align=center;verticalAlign=middle;
  fontSize=12;fontColor=#1565C0;fontStyle=1;
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
  fillColor=#f5f5f5;strokeColor=#999;strokeWidth=1;
  align=left;verticalAlign=top;
" vertex="1" parent="1">
  <mxGeometry x="55" y="150"
    width="90"
    height="{自调用行数×20 + 10}"
    as="geometry"/>
</mxCell>
```

### 3.5 时序图布局公式

```
列宽 = max(对象文本最长px + 40, 100)（不等宽）
列起始x = 40, 160, 280, ...（动态累加）

消息y坐标: y = 90 + 消息序号×60
  序号1 → y=90, 序号2 → y=150, 序号3 → y=210, ...
```

---

## IV. 流程图 / BPMN

### 4.1 节点类型（全部禁止硬编码宽高）

**开始/结束（椭圆）：**
```xml
<mxCell value="Start" style="
  shape=ellipse;html=1;whiteSpace=wrap;
  fillColor=#4CAF50;strokeColor=#2E7D32;strokeWidth=2;
  align=center;verticalAlign=middle;
  fontSize=12;fontColor=#fff;fontStyle=1;
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
  fillColor=#FFF9C4;strokeColor=#F57F17;strokeWidth=1.5;
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
  fillColor=#E3F2FD;strokeColor=#1565C0;strokeWidth=1.5;
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
  fillColor=#f44336;strokeColor=#c62828;strokeWidth=2;
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

---

## V. 类图

### 5.1 类框（三段式）

```xml
<mxCell id="cls1" value="ClassName" style="
  shape=table;startSize=30;container=1;collapsible=0;
  childLayout=tableLayout;fixedRows=1;rowLines=1;
  fontStyle=1;align=left;verticalAlign=top;
  fillColor=#E3F2FD;strokeColor=#1565C0;strokeWidth=1;
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

---

## VI. 图例模板（按内容自动扩展）

```xml
<mxCell id="leg1" value="Legend" style="
  shape=table;startSize=30;container=1;collapsible=0;
  childLayout=tableLayout;fixedRows=1;rowLines=0;
  fontStyle=1;align=left;verticalAlign=top;
  fillColor=#fafafa;strokeColor=#ddd;fontColor=#444;
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

## VIII. 画布尺寸（可选，非强制）

| 规模 | pageWidth × pageHeight | 适用场景 |
|------|----------------------|---------|
| 小（< 5 个元素） | 800 × 600 | 单角色 / 简单流程 |
| 中（5~15 个元素） | 1200 × 800 | 普通 ER / 用例 / 时序 |
| 大（> 15 个元素） | 1600 × 1200 | 复杂 ER / 多角色时序 |

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
