#!/usr/bin/env bash
# baseline_test.sh — Capture behavior WITHOUT the skill (raw git diff)
# This establishes the "status quo" for comparison
# Run from skill repo root: bash tests/baseline_test.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$SCRIPT_DIR/tmp"
OUTPUT_FILE="$SCRIPT_DIR/baseline_results.md"

echo "=== Baseline Test (No Skill) ==="
echo ""

# Verify fixtures exist
if [ ! -d "$TEST_DIR" ]; then
    echo "ERROR: Test fixtures not found at $TEST_DIR"
    echo "Run 'bash tests/setup_fixtures.sh' first."
    exit 1
fi

# Start output file
cat > "$OUTPUT_FILE" << 'EOF'
# Baseline Results (No Skill)

What a developer sees with raw `git diff HEAD` — no doc-coauthoring skill.

EOF

SCENARIOS=("param_added" "internal_refactor" "no_contract_change" "removed_symbol" "unfenced_readme")

for scenario in "${SCENARIOS[@]}"; do
    SCENARIO_DIR="$TEST_DIR/$scenario"
    
    if [ ! -d "$SCENARIO_DIR" ]; then
        echo "SKIP: $scenario — directory not found"
        continue
    fi
    
    cd "$SCENARIO_DIR"
    
    echo "## Scenario: $scenario" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    # Capture raw git diff
    echo "### Raw git diff HEAD output" >> "$OUTPUT_FILE"
    echo '```diff' >> "$OUTPUT_FILE"
    git diff HEAD >> "$OUTPUT_FILE" 2>&1 || echo "(no diff)" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    # What baseline (no skill) behavior would be
    echo "### Baseline behavior (no skill)" >> "$OUTPUT_FILE"
    case "$scenario" in
        param_added)
            cat >> "$OUTPUT_FILE" << 'EOF'
- Developer sees code diff but must manually:
  1. Notice parameter was added
  2. Remember to update docstring
  3. Remember to update README
- **Risk**: Docstring and README become stale
EOF
            ;;
        internal_refactor)
            cat >> "$OUTPUT_FILE" << 'EOF'
- Developer sees body change
- No prompt to check if docstring ("three conditions") is now wrong
- **Risk**: Docstring says "three conditions" but code has four — silent lie
EOF
            ;;
        no_contract_change)
            cat >> "$OUTPUT_FILE" << 'EOF'
- Developer sees comment changes
- No documentation action needed
- **Baseline is correct here** — but an overzealous tool would still fire
EOF
            ;;
        removed_symbol)
            cat >> "$OUTPUT_FILE" << 'EOF'
- Developer sees function deleted
- No prompt to update README
- **Risk**: README references non-existent function — broken docs
EOF
            ;;
        unfenced_readme)
            cat >> "$OUTPUT_FILE" << 'EOF'
- Developer sees parameter added
- No prompt to update README (which mentions the function)
- **Risk**: README shows old signature — confusing users
EOF
            ;;
    esac
    echo "" >> "$OUTPUT_FILE"
    echo "---" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    echo "Captured: $scenario"
done

echo ""
echo "=== Baseline capture complete ==="
echo "Output: $OUTPUT_FILE"
echo ""
echo "Key insight: raw git diff tells you WHAT changed, not WHAT TO UPDATE."
echo "The skill bridges that gap."
