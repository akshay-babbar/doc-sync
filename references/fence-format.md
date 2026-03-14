# Fence Format Specification

Fence markers define machine-owned territory within human-authored documents.
The skill operates only within these boundaries.

## Marker Syntax

### Standard Markers

```html
<!-- doc-sync: start -->
Machine-managed content goes here.
<!-- doc-sync: end -->
```

### Named Sections (Optional)

```html
<!-- doc-sync: start:api-reference -->
API reference content
<!-- doc-sync: end:api-reference -->

<!-- doc-sync: start:function-list -->
Function list content
<!-- doc-sync: end:function-list -->
```

Named sections allow multiple independent sync regions in one file.

## Marker Rules

### Placement

1. Markers must be on their own line
2. No content on the same line as a marker
3. Markers must be properly paired (start/end)
4. Nested markers are NOT supported

### Valid Examples

```markdown
## API Reference

<!-- doc-sync: start -->
| Function | Description |
|----------|-------------|
| `foo()` | Does foo |
<!-- doc-sync: end -->

## Other Section
```

### Invalid Examples

```markdown
<!-- doc-sync: start --> Some content  ← INVALID: content on marker line

<!-- doc-sync: start -->
Outer content
  <!-- doc-sync: start -->             ← INVALID: nested markers
  Inner content
  <!-- doc-sync: end -->
<!-- doc-sync: end -->
```

## Content Within Fences

### What Belongs Inside Fences

- Auto-generated API reference tables
- Function/method signature listings
- Parameter documentation tables
- Type definitions
- Public symbol inventories

### What Does NOT Belong Inside Fences

- Explanatory prose
- Tutorials
- Examples with narrative
- Design rationale
- Historical context

## Quickstart: Adding Fences

### Step 1: Identify Machine-Maintainable Content

Look for sections that are:
- Derived directly from code (signatures, types)
- Updated whenever code changes
- Tabular or list-based
- Factual, not explanatory

### Step 2: Wrap with Markers

Before:
```markdown
## Functions

| Function | Parameters | Returns |
|----------|------------|---------|
| `parse(text)` | text: str | dict |
| `validate(data)` | data: dict | bool |
```

After:
```markdown
## Functions

<!-- doc-sync: start -->
| Function | Parameters | Returns |
|----------|------------|---------|
| `parse(text)` | text: str | dict |
| `validate(data)` | data: dict | bool |
<!-- doc-sync: end -->
```

### Step 3: Verify Boundaries

Ask yourself:
- Is everything inside purely derived from code? ✓
- Would an auto-update ever be wrong? If yes, it shouldn't be fenced
- Is there explanatory text mixed in? If yes, restructure

## Multi-File Patterns

### README.md with API Section

```markdown
# My Library

A brief description. ← Human-owned

## Installation

```bash
npm install my-lib
```
← Human-owned

## API Reference

<!-- doc-sync: start:api -->
### Functions

| Name | Signature |
|------|-----------|
| `init` | `init(config: Config): void` |
<!-- doc-sync: end:api -->

## Contributing
← Human-owned
```

### Separate API.md File

If your API documentation is in a dedicated file, you may fence larger portions:

```markdown
# API Documentation

<!-- doc-sync: start -->
... entire API reference ...
<!-- doc-sync: end -->

## Notes

Human-authored notes about the API. ← Outside fence
```

## Detection Behavior

When the skill encounters a file:

1. **No markers found**: Report "No fence markers in [file]. Cannot proceed."
2. **Unpaired markers**: Report "Unpaired fence marker in [file] at line [N]."
3. **Nested markers**: Report "Nested fence markers not supported in [file]."
4. **Valid markers**: Proceed with update within fenced region only.

## Migration from Unfenced Docs

If you have existing documentation without fences:

1. **Do NOT ask the skill to add fences** — it won't
2. Manually identify sync-able sections
3. Add markers around those sections
4. Commit the markers
5. Then run doc-coauthoring

This ensures human oversight over what becomes machine-managed.
