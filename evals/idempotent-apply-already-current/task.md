# Skip Already-Current Docstrings During Apply Mode

A developer already updated the docstring for a changed parameter before running the documentation sync. The documentation should be detected as already current, and the parameter entry should not be duplicated when `--apply` is used.

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
        region: Cache region to query. Defaults to us-east-1.

    Returns:
        Cached value.
    """
    return key
PYEOF

## Output Specification

Sync the documentation in `--apply` mode and write the results to `doc-sync-report.md`.
