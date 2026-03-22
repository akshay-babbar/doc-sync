# Scenario: TypeScript overloaded function gains a new parameter; README mention must stay propose-only

A formatter library exposes an overloaded exported function. The implementation adds a new optional parameter to both overloads without changing the README mention style. The skill must update the JSDoc for the overloaded function and keep any markdown changes as proposals only.

## Baseline (committed) state

### `src/date-format.ts`

```ts
export type EventLike = Date | string;

export function formatEventDate(value: Date): string;
export function formatEventDate(value: string): string;
/**
 * Format an event date.
 *
 * @param value Input value.
 * @returns Formatted date string.
 */
export function formatEventDate(value: EventLike): string {
  const date = value instanceof Date ? value : new Date(value);
  return date.toISOString().slice(0, 10);
}
```

### `README.md`

```markdown
# formatter-kit

Use `formatEventDate` to render display dates.

This README is human-authored. Do not auto-apply markdown edits.
```

## Working tree (current) state

The formatter now supports a timezone override, but the docstring still describes the old signature.

### `src/date-format.ts`

```ts
export type EventLike = Date | string;

export function formatEventDate(value: Date, timezone?: string): string;
export function formatEventDate(value: string, timezone?: string): string;
/**
 * Format an event date.
 *
 * @param value Input value.
 * @returns Formatted date string.
 */
export function formatEventDate(value: EventLike, timezone: string = "UTC"): string {
  const date = value instanceof Date ? value : new Date(value);
  return new Intl.DateTimeFormat("en-US", {
    dateStyle: "short",
    timeZone: timezone,
  }).format(date);
}
```

### `README.md` (unchanged)

```markdown
# formatter-kit

Use `formatEventDate` to render display dates.

This README is human-authored. Do not auto-apply markdown edits.
```

## Git setup

```bash
git init
git config user.email "dev@example.com"
git config user.name "Dev"
mkdir -p src
cat > src/date-format.ts <<'EOF'
export type EventLike = Date | string;

export function formatEventDate(value: Date): string;
export function formatEventDate(value: string): string;
/**
 * Format an event date.
 *
 * @param value Input value.
 * @returns Formatted date string.
 */
export function formatEventDate(value: EventLike): string {
  const date = value instanceof Date ? value : new Date(value);
  return date.toISOString().slice(0, 10);
}
EOF
cat > README.md <<'EOF'
# formatter-kit

Use `formatEventDate` to render display dates.

This README is human-authored. Do not auto-apply markdown edits.
EOF
git add -A && git commit -m "baseline"

cat > src/date-format.ts <<'EOF'
export type EventLike = Date | string;

export function formatEventDate(value: Date, timezone?: string): string;
export function formatEventDate(value: string, timezone?: string): string;
/**
 * Format an event date.
 *
 * @param value Input value.
 * @returns Formatted date string.
 */
export function formatEventDate(value: EventLike, timezone: string = "UTC"): string {
  const date = value instanceof Date ? value : new Date(value);
  return new Intl.DateTimeFormat("en-US", {
    dateStyle: "short",
    timeZone: timezone,
  }).format(date);
}
EOF
```

## Output Specification

Sync the documentation for the current working tree and write the results to `doc-sync-report.md`. It must update the JSDoc for `formatEventDate` to document `timezone`, and any markdown mention of `formatEventDate` must remain propose-only.
