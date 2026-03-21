# Modernize Type Annotations After Python 3.10 Upgrade

A platform team just upgraded the service from Python 3.8 to Python 3.10. As part of the upgrade, they ran a codebase-wide automated tool that replaced legacy `typing` module annotations (like `List[str]`, `Dict[str, int]`, `Optional[str]`) with their built-in equivalents (`list[str]`, `dict[str, int]`, `str | None`). The automated tool only touched type annotations in function signatures — it did not change any logic.

The team now wants to run the documentation sync skill to check whether any of these annotation changes require documentation updates.

## Setup

Extract the following files, then set up the git repository:

=============== FILE: inputs/setup.sh ===============
#!/usr/bin/env bash
set -euo pipefail
git init
git config user.email "dev@example.com"
git config user.name "Dev"
mkdir -p src
cat > src/search.py << 'PYEOF'
from typing import Dict, List, Optional


def search_records(
    query: str,
    filters: Dict[str, str],
    tags: List[str],
    limit: Optional[int] = None,
) -> List[Dict[str, str]]:
    """Search records matching a query with optional filters.

    Args:
        query: Search term to match against record content.
        filters: Key-value pairs that must all match.
        tags: Records must have at least one of these tags.
        limit: Maximum number of results. None means no limit.

    Returns:
        List of matching record dicts.
    """
    return []
PYEOF
git add -A && git commit -m "baseline"
cat > src/search.py << 'PYEOF'
def search_records(
    query: str,
    filters: dict[str, str],
    tags: list[str],
    limit: int | None = None,
) -> list[dict[str, str]]:
    """Search records matching a query with optional filters.

    Args:
        query: Search term to match against record content.
        filters: Key-value pairs that must all match.
        tags: Records must have at least one of these tags.
        limit: Maximum number of results. None means no limit.

    Returns:
        List of matching record dicts.
    """
    return []
PYEOF

## Output Specification

Run the doc-coauthoring skill on the current working tree. Produce a `doc-sync-report.md` with the full skill output.
