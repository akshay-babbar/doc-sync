# Show Full Report Before Apply Confirmation

A backend team added a new parameter to a documented Python function and wants to update the docs using `--apply` mode. The report must be shown first, and explicit confirmation must be requested before any write is performed.

## Setup

Extract the following files, then set up the git repository:

=============== FILE: inputs/setup.sh ===============
#!/usr/bin/env bash
set -euo pipefail
git init
git config user.email "dev@example.com"
git config user.name "Dev"
mkdir -p src
cat > src/formatter.py << 'PYEOF'
def format_currency(amount: float, symbol: str = "$") -> str:
    """Format a monetary amount as a string.

    Args:
        amount: The numeric amount to format.
        symbol: Currency symbol prefix.

    Returns:
        Formatted string like "$1,234.56".
    """
    return f"{symbol}{amount:,.2f}"
PYEOF
git add -A && git commit -m "baseline"
cat > src/formatter.py << 'PYEOF'
def format_currency(amount: float, symbol: str = "$", locale: str = "en_US") -> str:
    """Format a monetary amount as a string.

    Args:
        amount: The numeric amount to format.
        symbol: Currency symbol prefix.

    Returns:
        Formatted string like "$1,234.56".
    """
    return f"{symbol}{amount:,.2f}"
PYEOF

## Output Specification

Sync the documentation in `--apply` mode and write the results to `doc-sync-report.md`, including the report and the explicit confirmation prompt shown before any write.
