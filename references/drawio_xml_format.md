# draw.io XML Format Specification

This document defines the standard draw.io XML format for each diagram type.

---

## Universal Template

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

**Universal coordinate rule:** All `x/y/width/height` values are **multiples of 10**.

---

## I. ER Diagram

### 1.1 Table Container (3 mxCells per table)

**Container:**
```xml
<mxCell id="{t}1" value="TableName" style="
  shape=table;
  startSize=30;
  container=1;
  collapsible=0;
  childLayout=tableLayout;
  fixedRows=1;
  rowLines=0;
  fontStyle=1;
  align=left;
  verticalAlign=top;
" vertex="1" parent="1">
  <mxGeometry x="{X}" y="{Y}" width="{W}" height="{H}" as="geometry"/>
</mxCell>
```

**Header row (empty placeholder):**
```xml
<mxCell value="" style="
  shape=partialRectangle;html=1;whiteSpace=wrap;collapsible=0;
  fixedRows=1;rowLines=0;fontStyle=1;align=left;verticalAlign=top;
" vertex="1" parent="{t}1">
  <mxGeometry y="30" width="{W}" height="30" as="geometry"/>
</mxCell>
```

**Field rows (one per field):**
```xml
<mxCell value="{field_name}    TYPE    PK/FK/UK" style="
  shape=partialRectangle;html=1;whiteSpace=wrap;collapsible=0;
  fixedRows=1;rowLines=0;fontStyle=0;align=left;verticalAlign=top;
  spacingLeft=6;
" vertex="1" parent="{t}1">
  <mxGeometry y="{60+(n-1)*18}" width="{W}" height="18" as="geometry"/>
</mxCell>
```

### 1.2 Relation Edges

**1:N relation:**
```xml
<mxCell value="" style="
  edgeStyle=entityRelationEdgeStyle;rounded=0;
  orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=1;
  endArrow=ERmany;endFill=0;
" edge="1" parent="1" source="{src}1" target="{dst}1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

**1:1 relation:**
```xml
endArrow=ERone
```

**Self-reference (dashed):**
```xml
<mxCell value="" style="
  edgeStyle=entityRelationEdgeStyle;rounded=0;
  orthogonalLoop=1;jettySize=auto;html=1;strokeWidth=1;
  dashed=1;endArrow=ERmany;endFill=0;
" edge="1" parent="1" source="{t}1" target="{t}1">
  <mxGeometry relative="1" as="geometry">
    <Array as="points">
      <mxPoint x="{X}" y="{Y_ABOVE}"/>
    </Array>
  </mxGeometry>
</mxCell>
```

### 1.3 Layout Coordinates Reference

```
Row 1 (Y=40):
  TableA(40,40)       TableB(40,280)      TableC(320,40)
  TableD(600,40)      TableE(900,40)      TableF(320,280)

Row 2 (Y=520):
  TableG(40,520)      TableH(320,520)     TableI(600,520)
  TableJ(900,520)     TableK(1140,520)

Column spacing: 260px (table width 200 + gap 60)
Legend: x=1140, y=40
```

---

## II. Use Case Diagram

### 2.1 System Boundary Box

```xml
<mxCell id="sys1" value="System Name" style="
  shape=rounded;rounded=1;arcSize=14;
  boundingBox=1;html=1;whiteSpace=wrap;
  align=left;verticalAlign=top;
  spacingLeft=10;spacingTop=10;
  fillColor=#f5f5f5;strokeColor=#333;strokeWidth=2;
  fontStyle=1;fontSize=14;fontColor=#222;
" vertex="1" parent="1">
  <mxGeometry x="160" y="40" width="900" height="600" as="geometry"/>
</mxCell>
```

### 2.2 Actor (stick figure)

```xml
<mxCell id="act1" value="" style="
  shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;
  html=1;outlineConnect=0;fillColor=#fff;strokeColor=#333;strokeWidth=2;
" vertex="1" parent="1">
  <mxGeometry x="40" y="100" width="30" height="60" as="geometry"/>
</mxCell>
<mxCell id="act1_lbl" value="Actor Name" style="
  text;html=1;strokeColor=none;fillColor=none;
  align=center;verticalAlign=top;fontSize=11;fontColor=#333;
" vertex="1" parent="1">
  <mxGeometry x="10" y="165" width="90" height="20" as="geometry"/>
</mxCell>
```

### 2.3 UseCase (ellipse)

```xml
<mxCell id="uc1" value="Use Case Name" style="
  shape=ellipse;html=1;whiteSpace=wrap;
  fillColor=#fff;strokeColor=#555;strokeWidth=1.5;
  align=center;verticalAlign=middle;fontSize=12;fontColor=#222;
" vertex="1" parent="1">
  <mxGeometry x="300" y="100" width="160" height="50" as="geometry"/>
</mxCell>
```

### 2.4 Relation Edges

**Association (solid, no arrow):**
```xml
<mxCell value="" style="
  endArrow=none;html=1;strokeWidth=1.5;strokeColor=#555;
" edge="1" parent="1" source="act1" target="uc1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

**Include (dashed, open arrow):**
```xml
<mxCell value="&#xa;&#xa;&#171;include&#187;" style="
  endArrow=open;dashed=1;html=1;strokeWidth=1.5;strokeColor=#555;
  edgeLabel;align=center;verticalAlign=top;fontSize=10;fontColor=#888;fontStyle=2;
" edge="1" parent="1" source="uc1" target="uc2">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

**Extend (dashed, open arrow, label `<<extend>>`):**
```xml
<!-- same style as include, only label changes to &#171;extend&#187; -->
```

**Generalization (solid, filled triangle):**
```xml
<mxCell value="" style="
  endArrow=classic;html=1;strokeWidth=1.5;strokeColor=#555;
" edge="1" parent="1" source="uc_child" target="uc_parent">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### 2.5 Use Case Diagram Layout

```
x=0~120:       Actor zone (left, vertical stack, spacing 80px)
x=160~1060:    System boundary box (width=900, height=auto)
               UseCases in 2~3 column grid inside
               Column spacing: 160px, row spacing: 80px
               Box padding: 40px all sides

UseCase size:  width=160, height=50
Actor-System gap: 20px
```

---

## III. Sequence Diagram

### 3.1 Object Box (top)

```xml
<mxCell id="obj_user" value="User" style="
  shape=rounded;rounded=1;html=1;whiteSpace=wrap;
  fillColor=#e8f4f8;strokeColor=#2196F3;strokeWidth=2;
  align=center;verticalAlign=middle;
  fontSize=12;fontColor=#1565C0;fontStyle=1;
" vertex="1" parent="1">
  <mxGeometry x="40" y="40" width="120" height="50" as="geometry"/>
</mxCell>
```

### 3.2 Lifeline (vertical dashed line)

```xml
<mxCell value="" style="
  endArrow=none;dashed=1;html=1;
  strokeWidth=1;strokeColor=#555;strokeDashPattern=1 3;
" edge="1" parent="1">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="100" y="90" as="sourcePoint"/>
    <mxPoint x="100" y="600" as="targetPoint"/>
  </mxGeometry>
</mxCell>
```

### 3.3 Message Arrows

**Sync request (solid + filled triangle):**
```xml
<mxCell value="operation()" style="
  endArrow=block;endSize=10;html=1;strokeWidth=1.5;strokeColor=#333;
" edge="1" parent="1" source="obj_user" target="obj_sys">
  <mxGeometry relative="1" as="geometry">
    <mxPoint x="100" y="130" as="sourcePoint"/>
  </mxGeometry>
</mxCell>
```

**Async message (hollow triangle):**
```xml
<mxCell value="asyncMessage()" style="
  endArrow=open;endSize=8;html=1;strokeWidth=1.5;strokeColor=#333;
" edge="1" parent="1" source="obj_a" target="obj_b">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

**Return (dashed + hollow triangle):**
```xml
<mxCell value="returnValue" style="
  endArrow=open;html=1;strokeWidth=1.5;dashed=1;strokeColor=#888;
" edge="1" parent="1" source="obj_sys" target="obj_user">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### 3.4 Self-Call (nested rect)

```xml
<mxCell value="1. methodA()" style="
  shape=rect;html=1;whiteSpace=wrap;
  fillColor=#f5f5f5;strokeColor=#999;strokeWidth=1;
  align=left;verticalAlign=top;
" vertex="1" parent="1">
  <mxGeometry x="55" y="150" width="90" height="80" as="geometry"/>
</mxCell>
<!-- recursive arrow from within the nested box back to itself -->
```

### 3.5 Sequence Diagram Layout

```
Column width:   200px (Actor column 180px)
Column x start: 40, 240, 440, 640 ...
Object box:     y=40, height=50, rounded rect
Lifeline:       from y=90 down to bottom
Message gap:    50~60px vertical spacing per message
```

---

## IV. Flowchart / BPMN

### 4.1 Node Types

**Start/End (ellipse):**
```xml
<mxCell value="Start" style="
  shape=ellipse;html=1;whiteSpace=wrap;
  fillColor=#4CAF50;strokeColor=#2E7D32;strokeWidth=2;
  align=center;verticalAlign=middle;
  fontSize=12;fontColor=#fff;fontStyle=1;
" vertex="1" parent="1">
  <mxGeometry x="200" y="40" width="80" height="50" as="geometry"/>
</mxCell>
```

**Activity (rounded rect):**
```xml
<mxCell value="Process Step" style="
  shape=rounded;rounded=1;html=1;whiteSpace=wrap;
  fillColor=#fff;strokeColor=#333;strokeWidth=1.5;
  align=center;verticalAlign=middle;fontSize=12;
" vertex="1" parent="1">
  <mxGeometry x="160" y="120" width="160" height="60" as="geometry"/>
</mxCell>
```

**Decision (rhombus):**
```xml
<mxCell value="Passed?" style="
  shape=rhombus;html=1;whiteSpace=wrap;
  fillColor=#FFF9C4;strokeColor=#F57F17;strokeWidth=1.5;
  align=center;verticalAlign=middle;fontSize=11;
" vertex="1" parent="1">
  <mxGeometry x="160" y="320" width="160" height="80" as="geometry"/>
</mxCell>
```

**Input/Output (parallelogram):**
```xml
<mxCell value="Input Data" style="
  shape=parallelogram;html=1;whiteSpace=wrap;
  fillColor=#E3F2FD;strokeColor=#1565C0;strokeWidth=1.5;
  align=center;verticalAlign=middle;fontSize=11;
" vertex="1" parent="1">
  <mxGeometry x="160" y="200" width="160" height="50" as="geometry"/>
</mxCell>
```

**End node (filled circle):**
```xml
<mxCell value="" style="
  shape=ellipse;html=1;whiteSpace=wrap;
  fillColor=#f44336;strokeColor=#c62828;strokeWidth=2;
" vertex="1" parent="1">
  <mxGeometry x="180" y="600" width="40" height="40" as="geometry"/>
</mxCell>
```

### 4.2 Connector Arrows

```xml
<mxCell value="Yes" style="
  endArrow=classic;html=1;strokeWidth=1.5;strokeColor=#333;
" edge="1" parent="1" source="dec1" target="act_yes">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>

<mxCell value="No" style="
  endArrow=classic;html=1;strokeWidth=1.5;strokeColor=#333;
" edge="1" parent="1" source="dec1" target="act_no">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

### 4.3 Flowchart Layout

```
Main flow:  left→right (or top→bottom)
Node spacing: horizontal 60px, vertical 80px
Decision branches: Yes/→right; No/→bottom
Swimlanes: use vertical or horizontal thick lines to separate responsibilities
```

---

## V. Class Diagram

### 5.1 Class Box (3 sections)

```xml
<mxCell id="cls1" value="ClassName" style="
  shape=table;startSize=30;container=1;collapsible=0;
  childLayout=tableLayout;fixedRows=1;rowLines=1;
  fontStyle=1;align=left;verticalAlign=top;
  fillColor=#E3F2FD;strokeColor=#1565C0;strokeWidth=1;
" vertex="1" parent="1">
  <mxGeometry x="200" y="100" width="180" height="150" as="geometry"/>
</mxCell>
<!-- Header row -->
<mxCell value="" style="
  shape=partialRectangle;html=1;whiteSpace=wrap;collapsible=0;
  fixedRows=1;rowLines=0;fontStyle=1;align=left;verticalAlign=top;
  fillColor=#E3F2FD;strokeColor=#1565C0;
" vertex="1" parent="cls1">
  <mxGeometry y="30" width="180" height="30" as="geometry"/>
</mxCell>
<!-- Attribute row -->
<mxCell value="- id: Long&#xa;- name: String" style="
  shape=partialRectangle;html=1;whiteSpace=wrap;collapsible=0;
  fixedRows=1;rowLines=0;fontStyle=0;align=left;verticalAlign=top;
  spacingLeft=4;fillColor=#fff;
" vertex="1" parent="cls1">
  <mxGeometry y="60" width="180" height="45" as="geometry"/>
</mxCell>
<!-- Method row -->
<mxCell value="+ getId(): Long&#xa;+ setName(n: String): Void" style="
  shape=partialRectangle;html=1;whiteSpace=wrap;collapsible=0;
  fixedRows=1;rowLines=0;fontStyle=0;align=left;verticalAlign=top;
  spacingLeft=4;fillColor=#fff;
" vertex="1" parent="cls1">
  <mxGeometry y="105" width="180" height="45" as="geometry"/>
</mxCell>
```

### 5.2 Class Diagram Relation Edges

**Aggregation (hollow diamond):**
```xml
endArrow=diamond;endFill=0;endSize=15;
```

**Composition (filled diamond):**
```xml
endArrow=diamond;endFill=1;endSize=15;
```

**Dependency (dashed arrow):**
```xml
dashed=1;endArrow=open;
```

**Inheritance (filled triangle):**
```xml
endArrow=classic;endSize=10;
```

---

## VI. Legend Template

Every diagram must include a legend in the bottom-right corner:

```xml
<mxCell id="leg1" value="Legend" style="
  shape=table;startSize=30;container=1;collapsible=0;
  childLayout=tableLayout;fixedRows=1;rowLines=0;
  fontStyle=1;align=left;verticalAlign=top;
  fillColor=#fafafa;strokeColor=#ddd;fontColor=#444;
" vertex="1" parent="1">
  <mxGeometry x="1140" y="40" width="200" height="130" as="geometry"/>
</mxCell>
<mxCell value="" style="
  shape=partialRectangle;html=1;whiteSpace=wrap;collapsible=0;
  fixedRows=1;rowLines=0;fontStyle=1;align=left;verticalAlign=top;
" vertex="1" parent="leg1">
  <mxGeometry y="30" width="200" height="30" as="geometry"/>
</mxCell>
<mxCell value="───── solid = direct association / generalization&#xa;- - - dashed = dependency / extend / return&#xa;◀──── triangle = inheritance / generalization&#xa;──◁── diamond = aggregation / composition&#xa;──▶   crow's foot = one-to-many" style="
  shape=partialRectangle;html=1;whiteSpace=wrap;collapsible=0;
  fixedRows=1;rowLines=0;fontStyle=0;align=left;verticalAlign=top;
  spacingLeft=8;fontSize=10;fontColor=#666;
" vertex="1" parent="leg1">
  <mxGeometry y="60" width="200" height="70" as="geometry"/>
</mxCell>
```

---

## VII. ID Naming Convention

```
Tables/Actor/Object:   t1, t2, t3 ... or u1, p1, o1
Actors:                 act1, act2, act3
UseCases:               uc1, uc2, uc3
Objects:                obj1, obj2, obj3
Edges:                  rel1, rel2, rel3 ...
Legend:                 leg1, leg2, leg3
System box:             sys1
Nested rect:            nest1, nest2
```

---

## VIII. Canvas Size Reference

| Scale | pageWidth × pageHeight | Use Case |
|-------|------------------------|---------|
| Small (< 5 elements) | 800 × 600 | Single Actor / simple flow |
| Medium (5~15 elements) | 1200 × 800 | Normal ER / Use Case / Sequence |
| Large (> 15 elements) | 1600 × 1200 | Complex ER / multi-Actor sequence |
