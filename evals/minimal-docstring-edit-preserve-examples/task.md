# Update Parameter Documentation Without Touching Rich Docstring Content

A library team added an optional `timeout` parameter to a frequently used connection function. The function has a detailed Python docstring that includes an Examples section, a Notes section, and a See Also section — all carefully written by the original author.

The team wants only the new parameter documented. Run the doc-coauthoring skill in `--apply` mode on the current working tree.

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

    Raises:
        ConnectionError: If the host is unreachable.

    Examples:
        >>> conn = connect("localhost", 8080)
        >>> conn.send(b"ping")

    Notes:
        Connections are not thread-safe. Use one connection per thread.

    See Also:
        disconnect: Close an open connection.
        reconnect: Re-establish a dropped connection.
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

    Raises:
        ConnectionError: If the host is unreachable.

    Examples:
        >>> conn = connect("localhost", 8080)
        >>> conn.send(b"ping")

    Notes:
        Connections are not thread-safe. Use one connection per thread.

    See Also:
        disconnect: Close an open connection.
        reconnect: Re-establish a dropped connection.
    """
    return object()
PYEOF

## Output Specification

Produce a `doc-sync-report.md` with the full skill output.
