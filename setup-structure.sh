#!/bin/bash
# Create the complete directory structure
mkdir -p .claude/agents
mkdir -p docs/{examples,templates}
mkdir -p templates/{hugo,mediawiki}
mkdir -p examples/{beginner,intermediate,expert}
mkdir -p scripts
mkdir -p tests

# Create initial files
touch .claude/agents/github-tutorials-expert.md
touch .claude/CLAUDE.md
touch templates/hugo/tutorial-template.md
touch templates/mediawiki/tutorial-template.wiki
touch scripts/setup.sh
touch scripts/validate-docs.sh