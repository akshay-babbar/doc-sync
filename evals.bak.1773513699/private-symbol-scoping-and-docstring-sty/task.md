# Apply Documentation Updates for a Configuration Parsing Library

## Problem/Feature Description

A configuration parsing library (`cfglib`) has just had two changes merged: an internal helper function had a new parameter added to it, and a public connection function had its return type changed. The internal helper (`_parse_config`) is documented with a docstring even though it's private — the team documents internal helpers to prevent drift in a codebase where internals are also tested directly.

The tech lead wants to run the doc-coauthoring tool to apply the documentation updates now that the changes have been reviewed.

Set up the repository, run the skill with the apply flag, and produce a report showing what was done.

## Output Specification

- Produce a file called `doc-sync-report.md` containing the full output of the skill run.
- The updated source files should remain in place so the changes can be inspected.

## Input Files

Extract the files below, then set up the git repository as described.

=============== FILE: cfglib/parser.py ===============
import socket
from typing import Optional


def _parse_config(source: str, strict: bool = False, timeout: int = 30) -> dict:
    """Parse configuration from a source string.

    Args:
        source: The raw configuration text to parse.
        strict: If True, raise on unknown keys.

    Returns:
        Parsed configuration as a dictionary.

    Note:
        See project wiki for key reference.
    """
    if timeout <= 0:
        raise ValueError("timeout must be positive")
    result = {}
    for line in source.splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if "=" in line:
            k, _, v = line.partition("=")
            result[k.strip()] = v.strip()
        elif strict:
            raise ValueError(f"Unexpected line: {line!r}")
    return result


def connect(host: str, port: int) -> Optional[socket.socket]:
    """Establish a connection to the specified host and port.

    Args:
        host: The target hostname or IP address.
        port: The target port number.

    Returns:
        A connected socket, or None if connection failed.

    Example:
        sock = connect("localhost", 8080)
        if sock:
            sock.sendall(b"ping")
    """
    try:
        s = socket.socket()
        s.connect((host, port))
        return s
    except OSError:
        return None

=============== FILE: README.md ===============
# cfglib

A minimal configuration and connection library.

## Overview

Use `connect` to open a socket connection to a remote service.

The _parse_config helper is an internal detail and is not part of the public API.

The connect function accepts a host and port and returns a socket or None.

## License

MIT

---

**Baseline (commit this first):**

The committed version of `cfglib/parser.py` should NOT have the `timeout` parameter in `_parse_config`, and `connect` should return `socket.socket` (not `Optional[socket.socket]`):

```python
import socket


def _parse_config(source: str, strict: bool = False) -> dict:
    """Parse configuration from a source string.

    Args:
        source: The raw configuration text to parse.
        strict: If True, raise on unknown keys.

    Returns:
        Parsed configuration as a dictionary.

    Note:
        See project wiki for key reference.
    """
    result = {}
    for line in source.splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if "=" in line:
            k, _, v = line.partition("=")
            result[k.strip()] = v.strip()
        elif strict:
            raise ValueError(f"Unexpected line: {line!r}")
    return result


def connect(host: str, port: int) -> socket.socket:
    """Establish a connection to the specified host and port.

    Args:
        host: The target hostname or IP address.
        port: The target port number.

    Returns:
        A connected socket.

    Example:
        sock = connect("localhost", 8080)
        if sock:
            sock.sendall(b"ping")
    """
    s = socket.socket()
    s.connect((host, port))
    return s
```

Initialize a git repo, commit the baseline `parser.py` and `README.md`, then overwrite `parser.py` with the working-tree version above.
