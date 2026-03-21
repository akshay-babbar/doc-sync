# Skip Already-Current Docstrings During Apply Mode

A developer already updated the docstring for a changed parameter before running the skill. The doc-coauthoring skill should detect that the documentation is already current and avoid duplicating the parameter entry when `--apply` is used.

## Setup

Extract the following files, then set up the git repository:

=============== FILE: inputs/setup.sh ===============
#!/usr/bin/env bash
set -euo pipefail
git init
git config user.email "dev@example.com"
git config user.name "Dev"
mkdir -p src
cat > src/cache.py << 'PYEOF'
def fetch(key: str) -> str:
    """Fetch a cached value by key.

    Args:
        key: Cache lookup key.

    Returns:
        Cached value.
    """
    return key
PYEOF
git add -A && git commit -m "baseline"
cat > src/cache.py << 'PYEOF'
def fetch(key: str, region: str = "us-east-1") -> str:
    """Fetch a cached value by key.

    Args:
        key: Cache lookup key.
        region: Cache region to query. Defaults to us-east-1. [inferred — verify]

    Returns:
        Cached value.
    """
    return key
PYEOF

## Output Specification

Run the doc-coauthoring skill in `--apply` mode and produce a `doc-sync-report.md` with the full output.
