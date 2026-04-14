---
name: drawio-skill
description: Generate standard `.drawio` / `diagrams.net` XML files from natural language. Supports ER Diagram, Use Case Diagram, Sequence Diagram, Flowchart, and Class Diagram. Use when the user wants to draw a diagram, mentions draw.io, describes a database schema, business process, or system interaction.
---

# drawio-skill

Generate standard `.drawio` XML files (compatible with draw.io / diagrams.net) for common diagram types. Layouts are structured and aligned to a 10px grid.

## When to Activate

This skill activates when the user:

- Says "draw a diagram", "generate diagram", "画图", "帮我画"
- Mentions "draw.io", "diagrams.net", or asks to import into draw.io
- Requests an "ER diagram", "use case diagram", "sequence diagram", "flowchart", "class diagram"
- Describes a business process, database schema, system interaction, or user requirements
- Provides table structures, fields, workflows, or actor-use case descriptions

## Supported Diagram Types

| Type | Layout | Core Elements |
|------|--------|---------------|
| **ER Diagram** | Grid (top→bottom / left→right) | Tables + field rows + relation edges |
| **Use Case Diagram** | Left (Actors) → Center (System boundary) → Right | Actor icons + System box + UseCases + edges |
| **Sequence Diagram** | Vertical, top→bottom | Object boxes + lifelines + message arrows |
| **Flowchart / BPMN** | Left→right (or top→bottom) | Rounded rect (start/end) + rect (activity) + rhombus (decision) + arrows |
| **Class Diagram** | Grid layout | Class boxes (name/attrs/methods) + relation edges |

## Execution Steps

### Step 1 — Confirm Type and Scope

If the user's request is ambiguous, ask:

```
1. Diagram type: [ER Diagram / Use Case / Sequence / Flowchart / Class Diagram / Other]
2. Main subjects: [Actors / Systems / Modules / Tables]
3. Core content:
   - ER: table list + fields + relationships
   - Use Case: Actor list + UseCase list + include/extend/generalization
   - Sequence: participants + operations per participant + messages/returns
   - Flowchart: start → steps → decisions → end
4. Output filename: [default: {scenario}_{diagramType}.drawio]
```

### Step 2 — Plan Layout (by type)

**ER Diagram:**
- L1 base entities (User/Account) → top-left
- L2 business entities (Product/Order) → center
- L3 detail/transaction (OrderItem/Payment) → right or bottom
- L4 config (Category/Coupon/Tags) → bottom-right edge
- Legend: fixed bottom-right corner
- Minimize edge crossings (left→right, top→bottom flow)

**Use Case Diagram:**
```
x=0~120:    Actor zone (left, vertical stack, spacing 60px)
x=160~1060: System boundary box (rounded rect, white fill)
            UseCases in 2~3 column grid inside the box
            Column spacing 160px, row spacing 80px
            Box padding: 40px all sides
```
- `<<include>>`: dashed arrow + `<<include>>` label
- `<<extend>>`: dashed arrow + `<<extend>>` label
- Generalization: solid line + hollow triangle
- Association: solid line, no arrow

**Sequence Diagram:**
```
Column width: 200px (Actor column 180px)
Object box: y=40, height=50, rounded rect
Lifeline: vertical dashed line from object box bottom
Message spacing: 50~60px vertical gap
```
- Sync request: solid line + filled triangle `endArrow=block`
- Async request: solid line + hollow triangle `endArrow=open`
- Return: dashed line + hollow triangle
- Self-call: nested gray rect + step number label

**Flowchart:**
```
Start/End: ellipse (green/red) or rounded-side rect
Activity: rounded rect
Decision: rhombus (yellow fill)
Input/Output: parallelogram (blue fill)
Main flow: left→right; decision branches: Yes=right/below, No=left/below
```

**Class Diagram:**
- Three-section box: class name (bold) / attributes / methods
- Row separator line `rowLines=1`
- Colors: blue fill for class header

### Step 3 — Generate XML

Follow the format specs in `references/drawio_xml_format.md` for the relevant diagram type.

### Step 4 — Output

1. Write to `C:\Users\{username}\{filename}.drawio`
2. Reply with:
   - Diagram type and element summary
   - Core structure explanation
   - How to import: "draw.io → File → Open → select the .drawio file"
   - Whether any adjustments are needed

## Output Standards

### Universal Rules

- File path: `C:\Users\{username}\{filename}.drawio`
- Outer wrapper: `<mxfile host="app.diagrams.net">`
- Canvas: `gridSize="10"`, `guides="1"`, `connect="1"`, `arrows="1"`
- Font: `fontFamily=Helvetica` throughout
- All coordinates and sizes are multiples of 10 (grid-aligned)

### ER Diagram

- Table width: ≤6 fields → 180px; 7~10 → 200px; ≥11 → 220px
- Table header: y=30, height=30 (`startSize=30`)
- Field rows: y=60+(n-1)*18, height=18
- Relation edges: `edgeStyle=entityRelationEdgeStyle`
  - 1:N: solid + `endArrow=ERmany`
  - 1:1: solid + `endArrow=ERone`
  - Self-reference: dashed + `dashed=1`
- Legend: fixed at x=1140, y=40 (bottom-right)

### Use Case Diagram

- System boundary: `shape=rounded`, `rounded=1`, white fill
- Actor: `shape=umlActor`
- UseCase: `shape=ellipse`
- Association: solid line, no arrow (`endArrow=none`)
- Include/Extend: dashed line, `endArrow=open`, label `<<include>>` / `<<extend>>`
- Generalization: solid line, `endArrow=classic` (filled triangle)
- Actor ↔ UseCase gap: ≥60px

### Sequence Diagram

- Column width: 200px
- Object box: y=40, height=50, rounded rect
- Lifeline: vertical dashed line from box bottom
- Sync message: solid + filled triangle `endArrow=block`, `endSize=10`
- Async message: solid + hollow triangle `endArrow=open`
- Return: dashed + hollow triangle

### Flowchart

- Start/End: `shape=ellipse` (green/red fill)
- Activity: `shape=rounded`, `rounded=1`
- Decision: `shape=rhombus` (yellow fill)
- Input/Output: `shape=parallelogram` (blue fill)
- Connector arrows: `endArrow=classic`
- Branch labels: "Yes/Y" → right; "No/N" → bottom
- Merge: filled circle

### Legend (Required)

Every diagram must include a legend in the bottom-right corner:

```
实线箭头 = 直接关联
虚线箭头 = 依赖/扩展
三角箭头 = 泛化/继承
乌鸦脚   = 一对多

Solid arrow = direct association
Dashed arrow = dependency/extend
Triangle = generalization/inheritance
Crow's foot = one-to-many
```

## Prohibited

- Do not generate diagram types not requested
- Do not skip the confirmation step
- Do not use non-standard XML formats
- Do not output plain text instead of XML files
- Do not cram everything in one diagram (keep it readable)
- Do not produce chaotic layouts (no overlaps, minimal crossings)
