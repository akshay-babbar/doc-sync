# Sync Docs After Parameter Addition to Core Function

A team maintains a Go service. A core exported function gained a new parameter in the latest commit. The function has a Go-style doc comment. The project also has a `CHANGELOG.md` that documents release history and a `decisions/adr-003-api-design.md` architectural decision record — both mention the function.

Update the source documentation using `--apply` mode.

## Setup

Extract the following files, then set up the git repository:

=============== FILE: inputs/setup.sh ===============
#!/usr/bin/env bash
set -euo pipefail
git init
git config user.email "dev@example.com"
git config user.name "Dev"
mkdir -p pkg/client decisions
cat > pkg/client/client.go << 'GOEOF'
package client

// Connect establishes a connection to the remote host.
//
// Parameters:
//   - host: hostname or IP address
//   - port: TCP port number
//
// Returns a Client instance or an error.
func Connect(host string, port int) (*Client, error) {
	return nil, nil
}

type Client struct{}
GOEOF
cat > CHANGELOG.md << 'MDEOF'
# Changelog

## v2.1.0

- Added `Connect` function to the client package.
MDEOF
cat > decisions/adr-003-api-design.md << 'MDEOF'
# ADR-003: Client API Design

## Decision

The `Connect` function uses positional parameters for host and port.
MDEOF
git add -A && git commit -m "baseline"
cat > pkg/client/client.go << 'GOEOF'
package client

// Connect establishes a connection to the remote host.
//
// Parameters:
//   - host: hostname or IP address
//   - port: TCP port number
//
// Returns a Client instance or an error.
func Connect(host string, port int, timeout int) (*Client, error) {
	return nil, nil
}

type Client struct{}
GOEOF
git add -A && git commit -m "add timeout param to Connect"

## Output Specification

Sync the documentation and write the results to `doc-sync-report.md`.
