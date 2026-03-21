# Reconcile Documentation After Module Restructuring

A backend team reorganized their Python service, moving several utility functions from a flat `utils.py` into a dedicated `core/parsing.py` module as part of a larger code cleanup. The functions kept identical signatures and implementations — they were just relocated. Some of these functions had docstrings and were referenced in `README.md`.

The team wants to run the documentation sync skill to identify any documentation that needs attention as a result of the restructuring. Use `--apply` mode.

## Setup

Extract the following files, then set up the git repository:

=============== FILE: inputs/setup.sh ===============
#!/usr/bin/env bash
set -euo pipefail
git init
git config user.email "dev@example.com"
git config user.name "Dev"
mkdir -p src
cat > src/utils.py << 'PYEOF'
def parse_config(raw: str) -> dict:
    """Parse a raw configuration string into a dictionary.

    Args:
        raw: The raw configuration string in KEY=VALUE format.

    Returns:
        Dictionary of parsed key-value pairs.
    """
    result = {}
    for line in raw.splitlines():
        if "=" in line:
            k, _, v = line.partition("=")
            result[k.strip()] = v.strip()
    return result


def sanitize_input(value: str) -> str:
    """Strip leading/trailing whitespace and remove null bytes."""
    return value.strip().replace("\x00", "")
PYEOF
cat > README.md << 'MDEOF'
# Config Utilities

## API

- `parse_config(raw)` — Parses KEY=VALUE format into a dict.
- `sanitize_input(value)` — Cleans a string value.
MDEOF
git add -A && git commit -m "baseline"
mkdir -p src/core
cat > src/core/parsing.py << 'PYEOF'
def parse_config(raw: str) -> dict:
    """Parse a raw configuration string into a dictionary.

    Args:
        raw: The raw configuration string in KEY=VALUE format.

    Returns:
        Dictionary of parsed key-value pairs.
    """
    result = {}
    for line in raw.splitlines():
        if "=" in line:
            k, _, v = line.partition("=")
            result[k.strip()] = v.strip()
    return result


def sanitize_input(value: str) -> str:
    """Strip leading/trailing whitespace and remove null bytes."""
    return value.strip().replace("\x00", "")
PYEOF
cat > src/utils.py << 'PYEOF'
# Functions moved to src/core/parsing.py
PYEOF
git add -A && git commit -m "move parsing functions to core module"

## Output Specification

Produce a `doc-sync-report.md` with the full skill output.
