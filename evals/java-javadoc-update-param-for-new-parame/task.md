# Update Java Service Documentation After Adding Retry Parameter

A Java backend team added an optional `maxRetries` parameter to a public service method. The method already has a Javadoc comment. The project's `README.md` has a Quick Start section that references the method. The team wants to update the documentation.

The team wants the documentation updated. Use `--apply` mode on the latest committed change.

## Setup

Extract the following files, then set up the git repository:

=============== FILE: inputs/setup.sh ===============
#!/usr/bin/env bash
set -euo pipefail
git init
git config user.email "dev@example.com"
git config user.name "Dev"
mkdir -p src/main/java/com/example
cat > src/main/java/com/example/DataService.java << 'JEOF'
package com.example;

public class DataService {

    /**
     * Fetch records from the data store by category.
     *
     * @param category the category identifier to query
     * @param limit    maximum number of records to return
     * @return list of matching records as strings
     */
    public java.util.List<String> fetchByCategory(String category, int limit) {
        return java.util.Collections.emptyList();
    }
}
JEOF
cat > README.md << 'MDEOF'
# DataService

## Quick Start

Use `fetchByCategory` to retrieve records from the data store.
MDEOF
git add -A && git commit -m "baseline"
cat > src/main/java/com/example/DataService.java << 'JEOF'
package com.example;

public class DataService {

    /**
     * Fetch records from the data store by category.
     *
     * @param category   the category identifier to query
     * @param limit      maximum number of records to return
     * @return list of matching records as strings
     */
    public java.util.List<String> fetchByCategory(String category, int limit, int maxRetries) {
        return java.util.Collections.emptyList();
    }
}
JEOF
git add -A && git commit -m "add maxRetries param to fetchByCategory"

## Output Specification

Sync the documentation and write the results to `doc-sync-report.md`.
