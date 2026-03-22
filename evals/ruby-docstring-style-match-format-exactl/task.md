# Update Ruby API Documentation After Adding Encoding Option

A Ruby gem team added an optional `encoding` parameter to a core string processing method. The method had an existing `##` YARD-style doc comment, and the team wants the documentation updated to reflect the new parameter. There is no README reference to this particular internal method.

The team wants the documentation updated. Use `--apply` mode on the latest committed change.

## Setup

Extract the following files, then set up the git repository:

=============== FILE: inputs/setup.sh ===============
#!/usr/bin/env bash
set -euo pipefail
git init
git config user.email "dev@example.com"
git config user.name "Dev"
mkdir -p lib
cat > lib/processor.rb << 'RBEOF'
module Processor
  ## Normalize a string value for storage.
  #
  # @param value [String] the raw input string
  # @return [String] the normalized string
  def self.normalize(value)
    value.strip.downcase
  end
end
RBEOF
git add -A && git commit -m "baseline"
cat > lib/processor.rb << 'RBEOF'
module Processor
  ## Normalize a string value for storage.
  #
  # @param value [String] the raw input string
  # @return [String] the normalized string
  def self.normalize(value, encoding = "UTF-8")
    value.strip.downcase.encode(encoding)
  end
end
RBEOF
git add -A && git commit -m "add encoding param to normalize"

## Output Specification

Sync the documentation and write the results to `doc-sync-report.md`.
