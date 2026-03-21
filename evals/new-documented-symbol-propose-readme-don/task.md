# Add Export to API Reference Documentation

A Node.js SDK team has just added a new exported function to their `auth` module. The function was shipped with a JSDoc comment because the developer wrote docs as part of the PR. The team's `README.md` has an **API Reference** section that lists exported functions, and they want the docs to stay in sync.

Run the doc-coauthoring skill to generate a report for the latest committed change. Since this is part of the release process, use `--apply` mode.

## Setup

Extract the following files, then set up the git repository:

=============== FILE: inputs/setup.sh ===============
#!/usr/bin/env bash
set -euo pipefail
git init
git config user.email "dev@example.com"
git config user.name "Dev"
mkdir -p src
cat > src/auth.ts << 'TSEOF'
/**
 * Validate an API token and return the associated user ID.
 * @param token - The bearer token string.
 * @returns The user ID string if valid.
 * @throws {AuthError} if the token is invalid or expired.
 */
export function validateToken(token: string): string {
  return token.slice(0, 8);
}
TSEOF
cat > README.md << 'MDEOF'
# SDK Auth Module

Utilities for handling authentication in the SDK.

## API Reference

- `validateToken(token)` — Validates a bearer token and returns the user ID.
MDEOF
git add -A && git commit -m "baseline"
cat > src/auth.ts << 'TSEOF'
/**
 * Validate an API token and return the associated user ID.
 * @param token - The bearer token string.
 * @returns The user ID string if valid.
 * @throws {AuthError} if the token is invalid or expired.
 */
export function validateToken(token: string): string {
  return token.slice(0, 8);
}

/**
 * Refresh an expired token using a refresh secret.
 * @param expiredToken - The token that has expired.
 * @param secret - The refresh secret from the token store.
 * @returns A new valid token string.
 */
export function refreshToken(expiredToken: string, secret: string): string {
  return expiredToken + secret.slice(0, 4);
}
TSEOF
git add -A && git commit -m "add refreshToken"

## Output Specification

Produce a `doc-sync-report.md` with the full skill output.
