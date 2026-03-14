#!/usr/bin/env bash
# check-fences.sh — Pre-validate fence markers before any Edit operation
# Call this BEFORE writing to any markdown file.
# The preservation contract depends on this check passing first.
#
# Usage:
#   bash scripts/check-fences.sh <file>
#
# Exit codes:
#   0 = valid fence markers found (safe to proceed)
#   1 = no fence markers found (skip file, report to user)
#   2 = malformed markers: unpaired or nested (skip file, report)
#   3 = file not found or not readable

set -euo pipefail

FILE="${1:-}"

if [ -z "$FILE" ]; then
    echo "Usage: check-fences.sh <file>" >&2
    exit 3
fi

if [ ! -f "$FILE" ]; then
    echo "Error: File not found: $FILE" >&2
    exit 3
fi

if [ ! -r "$FILE" ]; then
    echo "Error: File not readable: $FILE" >&2
    exit 3
fi

FENCE_START="<!-- doc-sync: start"
FENCE_END="<!-- doc-sync: end"

# Count fence markers
# Note: grep -c exits with code 1 when no matches found but still prints "0".
# The assignment form $(cmd) || fallback would append a second "0"; use || true instead.
START_COUNT=$(grep -c "$FENCE_START" "$FILE" 2>/dev/null || true)
START_COUNT=${START_COUNT:-0}
END_COUNT=$(grep -c "$FENCE_END" "$FILE" 2>/dev/null || true)
END_COUNT=${END_COUNT:-0}

# No fence markers at all
if [ "$START_COUNT" -eq 0 ] && [ "$END_COUNT" -eq 0 ]; then
    echo "⚠️  No fence markers in: $FILE"
    echo "   Add <!-- doc-sync: start --> and <!-- doc-sync: end --> to enable sync."
    echo "   See references/fence-format.md for instructions."
    exit 1
fi

# Unpaired markers
if [ "$START_COUNT" -ne "$END_COUNT" ]; then
    echo "⚠️  Malformed fence markers in: $FILE"
    echo "   Found $START_COUNT start markers and $END_COUNT end markers — must be equal."
    echo "   Fix the markers manually before running doc-coauthoring."
    exit 2
fi

# Check for nesting: a start marker inside an already-open fence block
# Strategy: track depth with awk
NEST_CHECK=$(awk '
    /<!-- doc-sync: start/ { depth++; if (depth > 1) { print "nested"; exit } }
    /<!-- doc-sync: end/ { depth--; if (depth < 0) { print "unpaired-end"; exit } }
    END { if (depth != 0) print "unpaired" }
' "$FILE")

if [ -n "$NEST_CHECK" ]; then
    echo "⚠️  Malformed fence markers in: $FILE"
    case "$NEST_CHECK" in
        nested)      echo "   Nested fence markers are not supported." ;;
        unpaired-end) echo "   End marker found without matching start marker." ;;
        unpaired)    echo "   Start marker found without matching end marker." ;;
    esac
    echo "   Fix the markers manually before running doc-coauthoring."
    exit 2
fi

# All checks passed
echo "✓ Fence markers valid in: $FILE ($START_COUNT fenced section(s))"
exit 0
