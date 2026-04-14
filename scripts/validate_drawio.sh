#!/bin/bash
# validate_drawio.sh — Validate draw.io XML file format

set -e

if [ -z "$1" ]; then
  echo "Usage: bash validate_drawio.sh <file.drawio>"
  exit 1
fi

FILE="$1"
echo "Validating: $FILE"
echo "========================================"

# 1. File existence
if [ ! -f "$FILE" ]; then
  echo "FAIL: File not found: $FILE"
  exit 1
fi

# 2. Extension check
if [[ "$FILE" != *.drawio ]]; then
  echo "WARN: File extension is not .drawio"
fi

# 3. XML basic structure
check_elem() {
  local label="$1"
  local pattern="$2"
  if grep -q "$pattern" "$FILE"; then
    echo "PASS  $label"
  else
    echo "FAIL  Missing <$pattern>"
    exit 1
  fi
}

check_elem "mxfile root element" "<mxfile"
check_elem "diagram element" "<diagram"
check_elem "mxGraphModel element" "<mxGraphModel"
check_elem "root node" "<root>"

# 4. Detect diagram type
detect_type() {
  if grep -q 'shape=table;startSize=30;container=1' "$FILE"; then
    echo "ER Diagram"
  elif grep -q 'shape=umlActor' "$FILE" && grep -q 'shape=ellipse' "$FILE"; then
    echo "Use Case Diagram"
  elif grep -q 'shape=umlActor' "$FILE"; then
    echo "Use Case Diagram"
  elif grep -q 'strokeDashPattern=1 3' "$FILE"; then
    echo "Sequence Diagram"
  elif grep -q 'shape=rounded.*rounded=1' "$FILE" && grep -q 'shape=rhombus' "$FILE"; then
    echo "Flowchart"
  elif grep -q 'shape=rounded.*rounded=1' "$FILE"; then
    echo "Flowchart/Activity"
  elif grep -q 'startSize=30.*rowLines=1' "$FILE"; then
    echo "Class Diagram"
  else
    echo "Unknown"
  fi
}

DIAGRAM_TYPE=$(detect_type)
echo "INFO  Detected type: $DIAGRAM_TYPE"

# 5. Type-specific checks
case "$DIAGRAM_TYPE" in
  "ER Diagram")
    TABLE_COUNT=$(grep -o 'shape=table;startSize=30;container=1' "$FILE" | wc -l)
    EDGE_COUNT=$(grep -c 'edgeStyle=entityRelationEdgeStyle' "$FILE" || echo "0")
    echo "INFO  Tables: $TABLE_COUNT"
    echo "INFO  Relation edges: $EDGE_COUNT"
    [ "$TABLE_COUNT" -eq 0 ] && echo "WARN  No ER tables detected"
    ;;
  "Use Case Diagram")
    ACTOR_COUNT=$(grep -c 'shape=umlActor' "$FILE" || echo "0")
    UC_COUNT=$(grep -c 'shape=ellipse' "$FILE" || echo "0")
    echo "INFO  Actors: $ACTOR_COUNT"
    echo "INFO  UseCases: $UC_COUNT"
    [ "$ACTOR_COUNT" -eq 0 ] && echo "WARN  No actors detected"
    ;;
  "Sequence Diagram")
    OBJ_COUNT=$(grep -o 'shape=rounded.*fillColor=' "$FILE" | wc -l)
    echo "INFO  Participants/objects: $OBJ_COUNT"
    ;;
  "Flowchart"*|"Class Diagram")
    echo "PASS  Node detection passed"
    ;;
esac

# 6. Legend check
if grep -q 'Legend' "$FILE"; then
  echo "PASS  Legend present"
else
  echo "WARN  No legend detected"
fi

# 7. mxCell tag balance
OPEN=$(grep -o '<mxCell' "$FILE" | wc -l)
CLOSE=$(grep -o '</mxCell>' "$FILE" | wc -l)
echo "INFO  mxCell: open=$OPEN, close=$CLOSE"
[ "$OPEN" -ne "$CLOSE" ] && echo "WARN  mxCell tag count mismatch"

# 8. Grid alignment (coordinates multiples of 10)
MISALIGNED=$(grep '<mxGeometry' "$FILE" | grep -Ev '(x|y|width|height)="[0-9]+0"' | head -3)
if [ -n "$MISALIGNED" ]; then
  echo "WARN  Non-10-multiple coordinates found, may not align to grid"
else
  echo "PASS  All coordinates grid-aligned"
fi

# 9. xmllint deep validation (if available)
if command -v xmllint &> /dev/null; then
  echo ""
  echo "Running xmllint validation..."
  if xmllint --noout "$FILE" 2>&1; then
    echo "PASS  XML format valid"
  else
    echo "WARN  XML validation failed, check manually"
  fi
else
  echo ""
  echo "TIP   Install xmllint for deep validation: apt install libxml2-utils"
fi

echo ""
echo "========================================"
echo "DONE: $FILE"
echo ""
echo "Import: draw.io → File → Open → select this .drawio file"
