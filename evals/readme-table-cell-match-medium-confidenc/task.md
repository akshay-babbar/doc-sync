# Sync Documentation for Renamed Return Type in Analytics Module

A data team updated a TypeScript analytics function to return a richer result type. The function has a JSDoc comment. The `README.md` contains a reference table that lists exported functions and their descriptions. The team wants a documentation sync report.

Run the doc-coauthoring skill in `--apply` mode on the latest committed change.

## Setup

Extract the following files, then set up the git repository:

=============== FILE: inputs/setup.sh ===============
#!/usr/bin/env bash
set -euo pipefail
git init
git config user.email "dev@example.com"
git config user.name "Dev"
mkdir -p src
cat > src/analytics.ts << 'TSEOF'
/**
 * Aggregate daily metrics for a given date range.
 * @param startDate - ISO date string for range start.
 * @param endDate - ISO date string for range end.
 * @returns Aggregated count of events.
 */
export function aggregateMetrics(startDate: string, endDate: string): number {
  return 0;
}
TSEOF
cat > README.md << 'MDEOF'
# Analytics Module

## Exported Functions

| Function | Description |
|----------|-------------|
| aggregateMetrics | Aggregates daily metrics over a date range. Returns a count. |
MDEOF
git add -A && git commit -m "baseline"
cat > src/analytics.ts << 'TSEOF'
export interface MetricsSummary {
  count: number;
  average: number;
}

/**
 * Aggregate daily metrics for a given date range.
 * @param startDate - ISO date string for range start.
 * @param endDate - ISO date string for range end.
 * @returns Summary object with count and average.
 */
export function aggregateMetrics(startDate: string, endDate: string): MetricsSummary {
  return { count: 0, average: 0 };
}
TSEOF
git add -A && git commit -m "aggregateMetrics now returns MetricsSummary"

## Output Specification

Produce a `doc-sync-report.md` with the full skill output.
