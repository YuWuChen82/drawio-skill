<div align="center">

English | **[中文](README_zh.md)**

</div>

---

<div align="center">

```
npx skills add {github_username}/drawio-skill
```

[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-Skill-blue?style=flat-square)](https://docs.anthropic.com/en/docs/claude-code)
[![draw.io XML](https://img.shields.io/badge/draw.io-XML-brightgreen?style=flat-square)](https://app.diagrams.net/)

</div>

---

## Overview

`drawio-skill` generates standard `.draw.io` / `diagrams.net` XML files from natural language descriptions.

Supports **5 diagram types** with **grid-aligned layouts**, **pure black-and-white styling**, and **transparent canvas** (no gray/white page background). Output is clean, non-overlapping, and ready to open in [draw.io](https://app.diagrams.net/).

---

## Supported Diagram Types

| Type | Core Elements |
|------|--------------|
| **ER Diagram** | Table containers + field rows + relation edges; multi-module includes include/extend cross-module edges |
| **Use Case Diagram** | Stick-figure Actors + System boundary box + UseCase ellipses + include/extend/generalization edges |
| **Sequence Diagram** | Object boxes + lifelines + sync/async/return message arrows (BCE architecture) |
| **Flowchart** | Rounded-rectangle activities + diamond decisions + ellipse start/end + Yes/No branches |
| **Class Diagram** | 3-section class boxes + inheritance/aggregation/dependency edges |

---

## Directory Structure

```
drawio-skill/
├── SKILL.md                         # Main agent instructions
├── README.md                         # This file
├── README_zh.md                     # Chinese version
├── references/
│   ├── drawio_xml_format.md         # XML format spec (complete templates per type)
│   └── diagram_content_standards.md  # Content & layout standards
├── scripts/
│   └── validate_drawio.sh           # Automated XML validation script
└── assets/
    ├── template_er.drawio           # ER Diagram template
    ├── template_usecase.drawio       # Use Case Diagram template
    ├── template_sequence.drawio      # Sequence Diagram template
    └── template_flowchart.drawio    # Flowchart template
```

---

## Install

After downloading, place in `~/.claude/skills/`.

---

## Usage

Just describe what you need in Claude Code:

```
Draw an ER diagram for a hospital system with Patient, Doctor, Appointment, and Prescription tables
```

```
Draw a multi-module ER diagram with a user module (User + Address tables) and an order module
(Order + OrderItem tables). Include is mandatory across modules, extend is optional.
Make sure the canvas is large enough to prevent line overlaps.
```

```
Generate a use case diagram for an online shopping system with Buyer, Seller, and Admin actors
```

```
Draw a loan approval flowchart: Start → Review → Decision → Approve → End
```

---

## Generated Output

Files are written to the **current project root directory** (not the user home folder):

```
{project_root}/{filename}.drawio
```

Open in draw.io: **File → Open → select the `.drawio` file**

---

## Canvas & Color Standards

| Property | Standard |
|----------|----------|
| **Background** | Pure transparent (`page="0"`, no gray/white page) |
| **Colors** | Black & white only (`#000/#333/#555/#888/#ccc/#fff`), no color |
| **Grid** | `gridSize="10"`, all coordinates multiples of 10 |
| **Legend** | Required in bottom-right corner of every diagram |

---

## Layout Quick Reference

### ER Diagram — L1~L4 Semantic Layers

```
L1 Base tables (top-left) → L2 Business tables (center) → L3 Detail tables (right/below) → L4 Config tables (bottom-right)
Solid + crow's foot = 1:N     Dashed = self-reference
Multi-module: ≥300px gap between modules; include (mandatory) dashed arrow, extend (optional) dashed triangle
Legend fixed at bottom-right
```

### Use Case Diagram — Actor-UseCase Layers

```
Actor (left) ─── UseCase ellipse (inside System boundary, 2~3 column grid)
Solid        = association
Dashed arrow = include / extend
Solid tri    = generalization
```

### Sequence Diagram — BCE Architecture

```
Actor → Boundary/Interface → Control/Service → Entity/Repo → External System
Object boxes at top, messages numbered top-to-bottom, lifelines centered
```

### Flowchart

```
Main flow left→right, Yes→right/below, No→left/bottom
Rounded rect = Activity     Diamond = Decision
Ellipse      = Start/End    Solid arrow = Flow
```

---

## Validation

```bash
bash scripts/validate_drawio.sh output.drawio
```

Checks: XML structure integrity, diagram type detection, mxCell tag balance, grid alignment, legend presence, xmllint deep validation.

---

## Format Specifications

Full XML format specs are in `references/drawio_xml_format.md`, including:

- mxCell / mxGeometry structure for every element type
- Edge styles: `endArrow=ERmany` / `endArrow=classic` / `endArrow=open` / `dashed=1`
- Complete XML examples for ER Diagram include (`dashed=1 + endArrow=open + <<include>>`) and extend (`dashed=1 + endArrow=classic + <<extend>>`)
- ID naming convention: `t1,t2` (tables), `act1,act2` (actors), `uc1,uc2` (usecases), `leg1` (legend)

---

## Contributing

Contributions welcome. Please open an issue or PR if you find problems or have suggestions for additional diagram type support.

---

## License

MIT License
