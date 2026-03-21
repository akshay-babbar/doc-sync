# Documentation Sync Check Before Merging

A backend team is preparing to merge a feature branch that adds a new `locale` parameter to several utility functions. Before the PR is reviewed, a developer wants to run a documentation consistency check to see which docstrings need updating — but without making any changes yet. They want to see what *would* be updated as a preview, so they can decide whether to include the doc changes in the same commit or a separate one.

Run the doc-coauthoring skill on the current working tree changes and produce a preview report showing what documentation would need updating. Do not write any changes to source files.

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

After running the skill, produce a file called `doc-sync-report.md` containing the full output of the skill run.
