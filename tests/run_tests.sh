#!/usr/bin/env bash
# run_tests.sh — Assert actual skill output against expected output
# Run from skill repo root: bash tests/run_tests.sh
# Requires: tests/setup_fixtures.sh already executed

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(dirname "$SCRIPT_DIR")"
TEST_DIR="$SCRIPT_DIR/tmp"
GET_DIFF_SCRIPT="$SKILL_ROOT/scripts/get_diff.sh"

echo "=== Doc-Coauthoring Test Runner ==="
echo ""

# Verify fixtures exist
if [ ! -d "$TEST_DIR" ]; then
    echo "ERROR: Test fixtures not found at $TEST_DIR"
    echo "Run 'bash tests/setup_fixtures.sh' first."
    exit 1
fi

# Verify get_diff.sh exists
if [ ! -f "$GET_DIFF_SCRIPT" ]; then
    echo "ERROR: get_diff.sh not found at $GET_DIFF_SCRIPT"
    exit 1
fi

PASSED=0
FAILED=0
SCENARIOS=("param_added" "internal_refactor" "no_contract_change" "removed_symbol" "unfenced_readme")

for scenario in "${SCENARIOS[@]}"; do
    SCENARIO_DIR="$TEST_DIR/$scenario"
    
    if [ ! -d "$SCENARIO_DIR" ]; then
        echo "SKIP: $scenario — directory not found"
        continue
    fi
    
    cd "$SCENARIO_DIR"
    
    # Run get_diff.sh and capture output
    ACTUAL_OUTPUT=$(bash "$GET_DIFF_SCRIPT" 2>&1 || true)
    EXPECTED_FILE="$SCENARIO_DIR/expected_output.txt"
    
    if [ ! -f "$EXPECTED_FILE" ]; then
        echo "SKIP: $scenario — expected_output.txt not found"
        continue
    fi
    
    EXPECTED_OUTPUT=$(cat "$EXPECTED_FILE")
    
    # Check if expected content is present in actual output
    # We use grep for substring matching since output has headers/formatting
    MATCH_FAILED=0
    while IFS= read -r expected_line; do
        [ -z "$expected_line" ] && continue
        if ! echo "$ACTUAL_OUTPUT" | grep -qF "$expected_line"; then
            MATCH_FAILED=1
            echo "FAIL: $scenario"
            echo "  Expected to find: $expected_line"
            echo "  Actual output:"
            echo "$ACTUAL_OUTPUT" | head -20 | sed 's/^/    /'
            break
        fi
    done < "$EXPECTED_FILE"
    
    if [ $MATCH_FAILED -eq 0 ]; then
        echo "PASS: $scenario"
        ((PASSED++))
    else
        ((FAILED++))
    fi
done

echo ""
echo "=== Summary ==="
echo "Passed: $PASSED/5  Failed: $FAILED/5"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "✓ All tests passed!"
    exit 0
else
    echo "✗ Some tests failed."
    exit 1
fi
