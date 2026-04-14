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
  <img src="https://img.shields.io/badge/diagrams-5%20types-orange?style=flat-square" alt="Diagram Types">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License">
</p>

---

## Overview

`drawio-skill` is a Claude Code Agent Skill that generates standard `.drawio` / `diagrams.net` XML files from natural language descriptions. It supports **5 diagram types** with **consistent grid-aligned layouts** and **standardized edge/arrow styles**.

Instead of outputting a flat file, the generated `.drawio` can be opened directly in [draw.io](https://app.diagrams.net/) or [diagrams.net](https://www.diagrams.net/) for further editing.

---

## Supported Diagram Types

| Type | Description |
|------|-------------|
| **ER Diagram** | Database entity-relationship diagrams with table containers, field rows, and relation edges |
| **Use Case Diagram** | UML use case diagrams with Actors, System boundary, UseCases, include/extend/generalization edges |
| **Sequence Diagram** | UML sequence diagrams with object boxes, lifelines, and sync/async/return messages |
| **Flowchart / BPMN** | Business process diagrams with start/end nodes, activities, decisions, and flow arrows |
| **Class Diagram** | UML class diagrams with 3-section boxes (name / attributes / methods) |

---

## Directory Structure

```
drawio-skill/
├── SKILL.md                                  # Main agent instructions (English)
├── README.md                                 # This file
├── README_zh.md                             # Chinese version
├── .gitignore
├── references/
│   ├── drawio_xml_format.md                  # draw.io XML format specification
│   └── diagram_content_standards.md           # Content & layout standards
├── scripts/
│   └── validate_drawio.sh                   # Automated XML validation
└── assets/
    ├── template_er.drawio                   # ER Diagram XML template
    ├── template_usecase.drawio              # Use Case Diagram XML template
    ├── template_sequence.drawio              # Sequence Diagram XML template
    └── template_flowchart.drawio            # Flowchart XML template
```

---

## Quick Start

### Install

Clone this repo into your Claude Code skills directory:

```bash
git clone https://github.com/YuWuChen82/drawio-skill.git ~/.claude/skills/drawio-skill
```

That's it — the `/drawio-skill` command will be available automatically. Claude Code scans `~/.claude/skills/` on startup.

### Usage

Trigger the skill in Claude Code:

```
/drawio-skill
```

Or just describe what you need naturally:

```
Draw an ER diagram for a hospital system with Patient, Doctor, Appointment, and Prescription tables
```

```
Generate a use case diagram for an online shopping system with Buyer, Seller, and Admin actors
```

```
Draw a sequence diagram for the user login flow
```

```
Draw a flowchart for the loan approval process
```

---

## Generated Output

The skill writes a `.drawio` XML file to your user home directory:

```
C:\Users\{username}\{filename}.drawio
```

Open it in draw.io: **File → Open → select the file**

---

## Validation

```bash
bash scripts/validate_drawio.sh output.drawio
```

Checks:
- ✅ XML basic structure (`<mxfile>`, `<diagram>`, `<mxGraphModel>`, `<root>`)
- ✅ Diagram type auto-detection
- ✅ mxCell tag balance
- ✅ Grid alignment (coordinates are multiples of 10)
- ✅ Legend presence
- ✅ xmllint deep validation (optional)

---

## Layout Standards

### ER Diagram
```
L1 Base (User/Account)   →  L2 Business (Product/Order)   →  L3 Detail (OrderItem/Payment)   →  L4 Config (Category/Coupon)
Left ────────────────────→  Center ──────────────────────────→  Right ──────────────────────────────→  Bottom-right
solid crow's foot = 1:N    dashed = self-reference    Legend fixed at x=1140, y=40
```

### Use Case Diagram
```
x=0~120:   Actor zone (left, vertical stack, 60px spacing)
x=160~1060: System boundary box (rounded rect, white fill, 40px padding)
             UseCases in 2~3 column grid inside
solid        = association
dashed       = include / extend
solid+tri    = generalization
```

### Sequence Diagram
```
Column width 200px   Object boxes at top (y=40)   Lifelines dashed vertical
solid+filled triangle = sync request
dashed+hollow triangle = return
solid+hollow triangle  = async
nested gray rect       = self-call
```

### Flowchart
```
Main flow left→right
Decision: Yes→right/below  No→left/bottom
green ellipse  = Start / Success
red ellipse     = End / Failure
yellow rhombus = Decision / Review
white rounded  = Activity
blue parallelogram = Input / Output
```

---

## Format Specifications

Full XML format specs for all diagram types are in `references/drawio_xml_format.md`, including:

- mxCell / mxGeometry structure for each element type
- Edge styles: `endArrow=ERmany`, `endArrow=classic`, `endArrow=open`, `dashed=1`
- Table layout: header at `y=30`, field rows at `y=60+(n-1)*18`
- ID naming convention: `t1,t2,t3` (tables), `act1,act2` (actors), `uc1,uc2` (usecases), `obj1,obj2` (objects), `rel1,rel2` (edges), `leg1` (legend)

---

## Contributing

Contributions welcome. Please open an issue or PR if you find problems or have suggestions for additional diagram type support.

---

## License

MIT License
