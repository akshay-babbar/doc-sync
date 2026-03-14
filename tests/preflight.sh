#!/usr/bin/env bash
# preflight.sh — Validate eval scenarios before Tessl upload
# Run from skill repo root: bash tests/preflight.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(dirname "$SCRIPT_DIR")"
EVALS_DIR="$SKILL_ROOT/evals"

echo "=== Tessl Eval Preflight Check ==="
echo ""

PASSED=0
FAILED=0
TOTAL=0
SCENARIOS=("param_added" "internal_refactor" "no_contract_change" "removed_symbol" "unfenced_readme")

for scenario in "${SCENARIOS[@]}"; do
    ((TOTAL++))
    SCENARIO_DIR="$EVALS_DIR/$scenario"
    ERRORS=()

    # Check scenario directory exists
    if [ ! -d "$SCENARIO_DIR" ]; then
        echo "FAIL: $scenario — directory not found"
        ((FAILED++))
        continue
    fi

    # Check required files
    [ ! -f "$SCENARIO_DIR/task.md" ] && ERRORS+=("missing task.md")
    [ ! -f "$SCENARIO_DIR/criteria.json" ] && ERRORS+=("missing criteria.json")
    [ ! -d "$SCENARIO_DIR/fixture" ] && ERRORS+=("missing fixture/")

    # Check fixture contents
    if [ -d "$SCENARIO_DIR/fixture" ]; then
        [ ! -f "$SCENARIO_DIR/fixture/src/main.py" ] && ERRORS+=("missing fixture/src/main.py")
        [ ! -f "$SCENARIO_DIR/fixture/README.md" ] && ERRORS+=("missing fixture/README.md")
        [ ! -f "$SCENARIO_DIR/fixture/git_diff.txt" ] && ERRORS+=("missing fixture/git_diff.txt")
    fi

    # Validate criteria.json is valid JSON
    if [ -f "$SCENARIO_DIR/criteria.json" ]; then
        if ! python3 -c "import json; json.load(open('$SCENARIO_DIR/criteria.json'))" 2>/dev/null; then
            ERRORS+=("criteria.json is not valid JSON")
        fi
    fi

    # Report
    if [ ${#ERRORS[@]} -eq 0 ]; then
        echo "PASS: $scenario"
        ((PASSED++))
    else
        echo "FAIL: $scenario"
        for err in "${ERRORS[@]}"; do
            echo "  $err"
        done
        ((FAILED++))
    fi
done

echo ""
echo "=== Results ==="
echo "Passed: $PASSED/$TOTAL  Failed: $FAILED/$TOTAL"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "✓ All scenarios ready for Tessl upload"
    echo ""
    echo "Next steps:"
    echo "  1. npx tessl skill review ./"
    echo "  2. npx tessl eval run ./evals/"
    exit 0
else
    echo "✗ Some scenarios have issues — fix before upload"
    exit 1
fi
