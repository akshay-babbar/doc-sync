# Mark Newly Inferred Descriptions for Human Verification

A platform team added a new optional parameter to a documented Python function. The new parameter has no existing prose description, so the skill must infer one conservatively and mark it as requiring human verification.

## Setup

Extract the following files, then set up the git repository:

=============== FILE: inputs/setup.sh ===============
#!/usr/bin/env bash
set -euo pipefail
git init
git config user.email "dev@example.com"
git config user.name "Dev"
mkdir -p src
cat > src/connection.py << 'PYEOF'
def connect(host: str, port: int) -> object:
    """Open a connection to the specified host and port.

    Args:
        host: Hostname or IP address of the target.
        port: TCP port number (1-65535).

    Returns:
        An open connection object.
    """
    return object()
PYEOF
git add -A && git commit -m "baseline"
cat > src/connection.py << 'PYEOF'
def connect(host: str, port: int, timeout: int = 30) -> object:
    """Open a connection to the specified host and port.

    Args:
        host: Hostname or IP address of the target.
        port: TCP port number (1-65535).

    Returns:
        An open connection object.
    """
    return object()
PYEOF

## Output Specification

Run the doc-coauthoring skill in `--apply` mode and produce a `doc-sync-report.md` with the full output.
