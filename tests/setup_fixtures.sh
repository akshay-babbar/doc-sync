#!/usr/bin/env bash
# setup_fixtures.sh — Create 5 isolated test scenarios for doc-coauthoring validation
# Run from skill repo root: bash tests/setup_fixtures.sh
# Creates all fixtures in tests/tmp/ (gitignored)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(dirname "$SCRIPT_DIR")"
TEST_DIR="$SCRIPT_DIR/tmp"

echo "=== Doc-Coauthoring Test Fixture Generator ==="
echo "Skill root: $SKILL_ROOT"
echo "Test dir:   $TEST_DIR"
echo ""

# Clean and recreate test directory
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"

#############################################################################
# SCENARIO A: param_added
# - Documented function with docstring + fenced README
# - Add new parameter
# - Expected: docstring updated, fenced README row updated
#############################################################################
echo "Creating Scenario A: param_added..."
mkdir -p "$TEST_DIR/param_added"
cd "$TEST_DIR/param_added"
git init -q
git config user.email "test@test.com"
git config user.name "test"
mkdir -p src

# Initial state: documented function
cat > src/main.py << 'EOF'
"""Main module for connection handling."""


def connect(host: str, port: int) -> bool:
    """Connect to a remote server.

    Args:
        host: The hostname or IP address to connect to.
        port: The port number to use.

    Returns:
        True if connection successful, False otherwise.
    """
    # Implementation details
    return True
EOF
mkdir -p src

cat > README.md << 'EOF'
# Connection Library

A simple library for managing connections.

## API Reference

<!-- doc-sync: start -->
| Function | Parameters | Returns | Description |
|----------|------------|---------|-------------|
| `connect` | `host: str`, `port: int` | `bool` | Connect to remote server |
<!-- doc-sync: end -->

## Usage

```python
from main import connect
connect("localhost", 8080)
```
EOF

git add -A
git commit -q -m "Initial: documented connect function"

# Changed state: add timeout parameter (uncommitted)
cat > src/main.py << 'EOF'
"""Main module for connection handling."""


def connect(host: str, port: int, timeout: int = 30) -> bool:
    """Connect to a remote server.

    Args:
        host: The hostname or IP address to connect to.
        port: The port number to use.

    Returns:
        True if connection successful, False otherwise.
    """
    # Implementation details
    return True
EOF

# Expected output for this scenario
cat > expected_output.txt << 'EOF'
[PARAM] Parameter changes:
EOF

echo "  ✓ param_added created"

#############################################################################
# SCENARIO B: internal_refactor
# - Documented function, body changes but signature identical
# - Docstring mentions specific logic that changed
# - Expected: skill detects body-only change, flags for review
#############################################################################
echo "Creating Scenario B: internal_refactor..."
mkdir -p "$TEST_DIR/internal_refactor"
cd "$TEST_DIR/internal_refactor"
git init -q
git config user.email "test@test.com"
git config user.name "test"
mkdir -p src

cat > src/main.py << 'EOF'
"""Validation module."""


def validate_input(data: dict) -> bool:
    """Validate input data against schema.

    Checks three conditions:
    1. Data is not empty
    2. Required keys exist
    3. Values are non-null

    Args:
        data: Dictionary to validate.

    Returns:
        True if all three conditions pass.
    """
    if not data:
        return False
    required = ["name", "email"]
    if not all(k in data for k in required):
        return False
    if any(v is None for v in data.values()):
        return False
    return True
EOF

cat > README.md << 'EOF'
# Validation Library

## API Reference

<!-- doc-sync: start -->
| Function | Parameters | Returns |
|----------|------------|---------|
| `validate_input` | `data: dict` | `bool` |
<!-- doc-sync: end -->
EOF

git add -A
git commit -q -m "Initial: validate_input with three conditions"

# Changed state: now checks FOUR conditions (body change, signature same)
cat > src/main.py << 'EOF'
"""Validation module."""


def validate_input(data: dict) -> bool:
    """Validate input data against schema.

    Checks three conditions:
    1. Data is not empty
    2. Required keys exist
    3. Values are non-null

    Args:
        data: Dictionary to validate.

    Returns:
        True if all three conditions pass.
    """
    if not data:
        return False
    required = ["name", "email"]
    if not all(k in data for k in required):
        return False
    if any(v is None for v in data.values()):
        return False
    # NEW: also check for valid email format
    if "@" not in data.get("email", ""):
        return False
    return True
EOF

# Expected: no signature change detected, but body changed
cat > expected_output.txt << 'EOF'
✓ No caller-visible contract changes detected.
EOF

echo "  ✓ internal_refactor created"

#############################################################################
# SCENARIO C: no_contract_change
# - Documented function, only comments changed
# - Expected: completely silent, nothing to sync
#############################################################################
echo "Creating Scenario C: no_contract_change..."
mkdir -p "$TEST_DIR/no_contract_change"
cd "$TEST_DIR/no_contract_change"
git init -q
git config user.email "test@test.com"
git config user.name "test"
mkdir -p src

cat > src/main.py << 'EOF'
"""Calculator module."""


def add(a: int, b: int) -> int:
    """Add two numbers.

    Args:
        a: First number.
        b: Second number.

    Returns:
        Sum of a and b.
    """
    # Simple addition
    return a + b
EOF

cat > README.md << 'EOF'
# Calculator

<!-- doc-sync: start -->
| Function | Parameters | Returns |
|----------|------------|---------|
| `add` | `a: int`, `b: int` | `int` |
<!-- doc-sync: end -->
EOF

git add -A
git commit -q -m "Initial: add function"

# Changed state: only comment changed, no contract change
cat > src/main.py << 'EOF'
"""Calculator module."""


def add(a: int, b: int) -> int:
    """Add two numbers.

    Args:
        a: First number.
        b: Second number.

    Returns:
        Sum of a and b.
    """
    # Simple addition - optimized for clarity
    # This is the most basic operation
    return a + b
EOF

# Expected: completely silent
cat > expected_output.txt << 'EOF'
✓ No caller-visible contract changes detected.
EOF

echo "  ✓ no_contract_change created"

#############################################################################
# SCENARIO D: removed_symbol
# - Documented function, then deleted
# - Expected: [NEEDS HUMAN REVIEW] flag, documentation preserved
#############################################################################
echo "Creating Scenario D: removed_symbol..."
mkdir -p "$TEST_DIR/removed_symbol"
cd "$TEST_DIR/removed_symbol"
git init -q
git config user.email "test@test.com"
git config user.name "test"
mkdir -p src

cat > src/main.py << 'EOF'
"""Utilities module."""


def deprecated_helper(x: int) -> int:
    """A deprecated helper function.

    Args:
        x: Input value.

    Returns:
        Transformed value.
    """
    return x * 2


def main_function(data: str) -> str:
    """Main processing function.

    Args:
        data: Input string.

    Returns:
        Processed string.
    """
    return data.upper()
EOF

cat > README.md << 'EOF'
# Utilities

<!-- doc-sync: start -->
| Function | Parameters | Returns |
|----------|------------|---------|
| `deprecated_helper` | `x: int` | `int` |
| `main_function` | `data: str` | `str` |
<!-- doc-sync: end -->
EOF

git add -A
git commit -q -m "Initial: two functions"

# Changed state: deprecated_helper removed
cat > src/main.py << 'EOF'
"""Utilities module."""


def main_function(data: str) -> str:
    """Main processing function.

    Args:
        data: Input string.

    Returns:
        Processed string.
    """
    return data.upper()
EOF

# Expected: removed symbol flagged
cat > expected_output.txt << 'EOF'
deprecated_helper
EOF

echo "  ✓ removed_symbol created"

#############################################################################
# SCENARIO E: unfenced_readme
# - Documented function with parameter change
# - README mentions function but has NO fence markers
# - Expected: propose-only, nothing auto-written
#############################################################################
echo "Creating Scenario E: unfenced_readme..."
mkdir -p "$TEST_DIR/unfenced_readme"
cd "$TEST_DIR/unfenced_readme"
git init -q
git config user.email "test@test.com"
git config user.name "test"
mkdir -p src

cat > src/main.py << 'EOF'
"""HTTP client module."""


def fetch(url: str) -> dict:
    """Fetch data from URL.

    Args:
        url: The URL to fetch from.

    Returns:
        Parsed JSON response.
    """
    return {}
EOF

# README without fences - human-authored prose
cat > README.md << 'EOF'
# HTTP Client

A simple HTTP client library.

## Functions

The `fetch` function retrieves data from a URL:

```python
result = fetch("https://api.example.com/data")
```

| Function | Parameters | Returns |
|----------|------------|---------|
| `fetch` | `url: str` | `dict` |

## Notes

This library is designed for simplicity.
EOF

git add -A
git commit -q -m "Initial: fetch function with unfenced README"

# Changed state: add headers parameter
cat > src/main.py << 'EOF'
"""HTTP client module."""


def fetch(url: str, headers: dict = None) -> dict:
    """Fetch data from URL.

    Args:
        url: The URL to fetch from.

    Returns:
        Parsed JSON response.
    """
    return {}
EOF

# Expected: param change detected, but README has no fences
cat > expected_output.txt << 'EOF'
[PARAM] Parameter changes:
EOF

echo "  ✓ unfenced_readme created"

#############################################################################
# Summary
#############################################################################
echo ""
echo "=== Fixture Setup Complete ==="
echo ""
echo "Created 5 scenarios in $TEST_DIR:"
echo "  A. param_added/       — add parameter to documented function"
echo "  B. internal_refactor/ — body change, signature same (binding vote)"
echo "  C. no_contract_change/ — comments only, should be silent"
echo "  D. removed_symbol/    — function deleted, needs human review"
echo "  E. unfenced_readme/   — param change, README has no fences"
echo ""
echo "Each scenario has:"
echo "  - src/main.py (code file)"
echo "  - README.md (documentation)"
echo "  - expected_output.txt (assertion target)"
echo "  - Initial state committed, changed state uncommitted"
echo ""
echo "Next: run 'bash tests/baseline_test.sh' to capture baseline behavior"
