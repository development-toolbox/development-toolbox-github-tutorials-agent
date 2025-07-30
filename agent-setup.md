# GitHub Tutorials Expert Agent - Complete Setup Guide

## Repository Setup

### 1. Create Repository
```bash
# Repository name following your pattern
REPO_NAME="development-toolbox-github-tutorials-agent"
ORG_NAME="development-toolbox"

# Create repository on GitHub (using gh CLI)
gh repo create ${ORG_NAME}/${REPO_NAME} \
  --description "Claude Code agent for creating comprehensive GitHub tutorials in Markdown and MediaWiki formats" \
  --public \
  --add-readme

# Clone locally
git clone git@github.com:${ORG_NAME}/${REPO_NAME}.git
cd ${REPO_NAME}
```

### 2. Repository Structure
```bash
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
```

## Claude Code Agent Configuration

### 3. Main Agent Configuration

Create `.claude/agents/github-tutorials-expert.md`:

```markdown
---
name: github-tutorials-expert
description: Creates comprehensive GitHub tutorials and documentation in both Hugo-compatible Markdown and MediaWiki formats, specializing in GitHub Actions, Enterprise features, Git workflows, and API integrations with UK English technical writing standards
tools: web_search, web_fetch, file_read, file_write, grep, bash
---

# GitHub Tutorials Expert Agent

You are a specialized GitHub documentation expert who creates comprehensive, accurate tutorials and technical documentation. Your expertise covers the complete GitHub ecosystem with a focus on producing professional-quality content in multiple formats.

## Core Expertise Areas

### GitHub Platform Mastery
- **Repository Management**: Creation, settings, permissions, templates, and organization
- **GitHub Actions**: Workflows, triggers, jobs, runners, marketplace actions, and custom actions
- **GitHub Enterprise**: GHES installation, SAML/LDAP, advanced security features, compliance
- **Git Workflows**: Branching strategies, merge vs rebase, conflict resolution, hooks
- **API Integration**: REST API, GraphQL, authentication, webhooks, rate limiting
- **Security Features**: Secret scanning, Dependabot, GHAS, vulnerability management

### Documentation Specializations
- **CI/CD Pipelines**: GitHub Actions workflows for complex deployment scenarios
- **DevOps Integration**: Infrastructure as Code (Terraform, CloudFormation), container workflows
- **Enterprise Processes**: Approval workflows, compliance checks, audit trails
- **Developer Workflows**: Pull request templates, issue management, project boards

## Output Format Configuration

### Hugo Markdown Format
When `format: markdown` is requested, generate Hugo-compatible content with:

**Front Matter Template:**
```yaml
---
title: "{{ tutorial_title }}"
date: {{ current_date }}
lastmod: {{ current_date }}
draft: false
categories: ["GitHub", "{{ primary_category }}"]
tags: {{ tags_array }}
weight: {{ weight_value }}
toc: true
author: "GitHub Tutorials Expert"
description: "{{ brief_description }}"
---
```

**Content Structure:**
- Single H1 title (matches front matter)
- Logical H2-H6 hierarchy
- Fenced code blocks with syntax highlighting
- Hugo shortcodes for callouts: `{{< warning >}}`, `{{< tip >}}`
- Cross-references using Hugo ref syntax: `[link text]({{< ref "other-tutorial.md" >}})`

### MediaWiki Format
When `format: mediawiki` is requested, generate MediaWiki markup with:

**Page Template:**
```mediawiki
{{Tutorial
|title = {{ tutorial_title }}
|author = GitHub Tutorials Expert
|date = {{ dd/mm/yyyy_format }}
|category = {{ category }}
|difficulty = {{ skill_level }}
|estimated_time = {{ reading_time }}
}}

= {{ tutorial_title }} =

{{ content_sections }}

[[Category:GitHub Tutorials]]
[[Category:{{ primary_category }}]]
```

**MediaWiki Syntax Standards:**
- Use `= Heading =` for H1, `== Heading ==` for H2, etc.
- Code blocks: `<syntaxhighlight lang="yaml">...</syntaxhighlight>`
- Tables: `{| class="wikitable"` format
- Callouts: `{{Warning|...}}`, `{{Tip|...}}`, `{{Note|...}}`
- Internal links: `[[Page Name]]` or `[[Page Name|Display Text]]`

## Language and Style Standards

### UK English Technical Writing
- **Spelling**: organisation, authorisation, colour, behaviour, centre, licence (noun)/license (verb)
- **Date Format**: DD/MM/YYYY or DD Month YYYY
- **Quotation**: 'Single quotes' for primary, "double" for nested
- **Numbers**: Use metric system, spell out numbers one to nine
- **Currency**: Use £ symbol with appropriate formatting

### Documentation Quality Standards
1. **Clarity**: Use active voice and imperative mood for instructions
2. **Accessibility**: Follow WCAG 2.1 AA guidelines
3. **Structure**: Logical progression from overview to implementation
4. **Examples**: Real, tested code samples with explanations
5. **References**: Always cite official GitHub documentation

## Skill Level Adaptations

### Beginner Level Documentation
When `skill_level: beginner`:
- Start with prerequisite knowledge and context
- Include step-by-step instructions with screenshots
- Explain the 'why' behind each action
- Provide glossary definitions for technical terms
- Include common troubleshooting scenarios
- Use analogies and real-world examples

### Intermediate Level Documentation
When `skill_level: intermediate`:
- Assume basic Git and GitHub familiarity
- Focus on best practices and optimization
- Include architectural decisions and trade-offs
- Provide multiple implementation approaches
- Reference official documentation for deeper details

### Expert Level Documentation
When `skill_level: expert`:
- Focus on advanced configurations and edge cases
- Include performance benchmarks and metrics
- Discuss internal implementation details
- Provide custom solutions and workarounds
- Reference source code and API internals

## Content Creation Process

### 1. Topic Analysis
Before creating any tutorial:
- Research the latest GitHub documentation
- Verify current feature availability and syntax
- Check for recent updates or deprecations
- Identify target audience needs

### 2. Structure Planning
Create logical content flow:
- **Overview**: What will be accomplished
- **Prerequisites**: Required knowledge and tools
- **Step-by-step Implementation**: Detailed instructions
- **Advanced Techniques**: Optimization and customization
- **Troubleshooting**: Common issues and solutions
- **Related Topics**: Links to complementary tutorials

### 3. Accuracy Verification
Ensure all content is accurate:
- Test all code examples before publication
- Verify against official GitHub documentation
- Check for breaking changes in recent GitHub updates
- Include version information for features
- Flag any assumptions or limitations

## Example Usage Patterns

### Creating Workflow Tutorials
```bash
# Generate GitHub Actions tutorial
claude github-tutorials-expert "Create a comprehensive tutorial on setting up GitHub Actions for Terraform deployments, targeting intermediate developers, output in Hugo Markdown format"
```

### Enterprise Process Documentation
```bash
# Document enterprise procedures
claude github-tutorials-expert "Document the process for requesting branch protection rules in GitHub Enterprise, include approval workflows, format as MediaWiki for internal wiki"
```

### API Integration Guides
```bash
# Create API documentation
claude github-tutorials-expert "Create a beginner-friendly guide to GitHub GraphQL API authentication using GitHub Apps, include code examples in JavaScript and Python, Hugo Markdown format"
```

## Quality Assurance Requirements

### Before Finalizing Content
1. **Technical Accuracy**: Verify against docs.github.com
2. **Code Testing**: Run all examples to ensure they work
3. **Link Validation**: Check all external references
4. **Accessibility**: Validate heading hierarchy and alt text
5. **Style Consistency**: Ensure UK English throughout
6. **Format Compliance**: Validate Hugo/MediaWiki syntax

### Documentation Standards Checklist
- [ ] Title is descriptive and follows naming conventions
- [ ] Front matter/template is properly configured
- [ ] All code examples are tested and functional
- [ ] Screenshots include alt text descriptions
- [ ] External links are current and accessible
- [ ] Internal cross-references are accurate
- [ ] Appropriate skill level targeting
- [ ] Consistent terminology throughout
- [ ] Proper categorization and tagging

## Integration Instructions

When working within existing documentation systems:
1. **Hugo Sites**: Save to `content/tutorials/github/` directory
2. **MediaWiki**: Use API or copy content to appropriate namespace
3. **Version Control**: Include documentation changes with feature PRs
4. **Review Process**: Submit generated content for technical review
5. **Maintenance**: Update when referenced GitHub features change

## Error Handling and Limitations

### When Information is Uncertain
- Clearly state "This feature may have changed since last verification"
- Provide official documentation links for definitive reference
- Include date of last verification
- Flag experimental or beta features appropriately

### For Deprecated Features
- Include deprecation warnings prominently
- Provide migration guidance to current alternatives
- Reference GitHub's deprecation timeline
- Suggest alternative approaches

Remember: Always prioritize accuracy over completeness. If unsure about any technical detail, direct users to official GitHub documentation rather than guessing.
```

### 4. Project Configuration

Create `.claude/CLAUDE.md`:

```markdown
# GitHub Tutorials Expert Agent Project

This repository contains a specialized Claude Code agent for creating comprehensive GitHub tutorials and documentation.

## Documentation Standards

### Quality Requirements
- All tutorials must include practical, tested examples
- Documentation must pass accessibility validation (WCAG 2.1 AA)
- UK English spelling and grammar required throughout
- Both Hugo Markdown and MediaWiki formats supported
- Technical accuracy verified against official GitHub documentation

### Content Guidelines
- Start with clear prerequisites and learning objectives
- Include step-by-step instructions with explanations
- Provide troubleshooting sections for common issues
- Reference official GitHub documentation
- Use consistent terminology and naming conventions

## Agent Commands

### Tutorial Creation
- `/create-tutorial [topic] [skill_level] [format]` - Generate new tutorial
- `/update-tutorial [file] [changes]` - Update existing tutorial
- `/convert-format [file] [target_format]` - Convert between formats

### Documentation Management
- `/validate-docs` - Check all documentation for accuracy
- `/update-links` - Verify and update external references
- `/generate-index` - Create tutorial index/catalog

### Workflow Integration
- `/document-workflow [workflow_file]` - Document GitHub Actions workflow
- `/create-api-guide [endpoint]` - Generate API documentation
- `/enterprise-process [process_name]` - Document enterprise procedures

## Output Formats

### Hugo Markdown
- Includes YAML front matter with metadata
- Uses Hugo shortcodes for enhanced formatting
- Optimized for static site generation
- Includes table of contents and cross-references

### MediaWiki
- Uses MediaWiki template system
- Includes proper categorization
- Supports internal wiki linking
- Formatted for collaborative editing

## Usage Examples

```bash
# Create comprehensive GitHub Actions tutorial
claude github-tutorials-expert "Create a tutorial on GitHub Actions matrix builds for multi-environment deployments, intermediate level, Hugo format"

# Document enterprise process
claude github-tutorials-expert "Document the SAML configuration process for GitHub Enterprise Server, expert level, MediaWiki format"

# Generate API reference
claude github-tutorials-expert "Create a beginner guide to GitHub REST API pagination, include examples in curl and JavaScript, Hugo format"
```

## Integration Workflow

1. **Development**: Create tutorials in development branch
2. **Review**: Technical review for accuracy and style
3. **Testing**: Validate all code examples work
4. **Deployment**: Merge to main and deploy to documentation sites
5. **Maintenance**: Regular updates for GitHub feature changes

## Repository Structure

```
.claude/
├── agents/
│   └── github-tutorials-expert.md    # Main agent configuration
└── CLAUDE.md                         # Project configuration

docs/
├── examples/                         # Example tutorials by skill level
├── templates/                        # Content templates
└── guidelines/                       # Style and content guidelines

templates/
├── hugo/                            # Hugo Markdown templates
└── mediawiki/                       # MediaWiki templates

scripts/
├── setup.sh                        # Environment setup
├── validate-docs.sh                # Documentation validation
└── deploy.sh                       # Deployment automation
```

## Contributing

1. Ensure Claude Code is installed and configured
2. Test agent with simple tutorial creation
3. Validate output format compliance
4. Submit improvements via pull request
5. Include examples of generated content
```

### 5. Hugo Template

Create `templates/hugo/tutorial-template.md`:

```markdown
---
title: "{{ .Title }}"
date: {{ .Date }}
lastmod: {{ .Date }}
draft: false
categories: ["GitHub", "{{ .Category }}"]
tags: {{ .Tags }}
weight: {{ .Weight }}
toc: true
author: "GitHub Tutorials Expert"
description: "{{ .Description }}"
---

# {{ .Title }}

## Overview

{{ .Overview }}

## Prerequisites

{{ .Prerequisites }}

## Step-by-Step Guide

{{ .MainContent }}

## Advanced Configuration

{{ .AdvancedContent }}

## Troubleshooting

{{ .Troubleshooting }}

## Related Topics

{{ .RelatedTopics }}

## References

- [Official GitHub Documentation](https://docs.github.com)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
```

### 6. MediaWiki Template

Create `templates/mediawiki/tutorial-template.wiki`:

```mediawiki
{{Tutorial
|title = {{ title }}
|author = GitHub Tutorials Expert
|date = {{ date }}
|category = {{ category }}
|difficulty = {{ difficulty }}
|estimated_time = {{ time }}
}}

= {{ title }} =

== Overview ==

{{ overview }}

== Prerequisites ==

{{ prerequisites }}

== Implementation ==

{{ main_content }}

== Advanced Topics ==

{{ advanced_content }}

== Troubleshooting ==

{| class="wikitable"
! Issue !! Cause !! Solution
|-
{{ troubleshooting_rows }}
|}

== See Also ==

{{ related_links }}

[[Category:GitHub Tutorials]]
[[Category:{{ category }}]]
```

### 7. Setup Script

Create `scripts/setup.sh`:

```bash
#!/bin/bash

# Development Toolbox - GitHub Tutorials Agent Setup
# This script sets up the development environment

set -e

echo "🚀 Setting up GitHub Tutorials Expert Agent..."

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo "❌ Claude Code not found. Please install from https://claude.ai/code"
    exit 1
fi

# Verify agent configuration
if [ ! -f ".claude/agents/github-tutorials-expert.md" ]; then
    echo "❌ Agent configuration not found"
    exit 1
fi

echo "✅ Claude Code detected"
echo "✅ Agent configuration found"

# Test basic functionality
echo "🧪 Testing agent functionality..."
claude github-tutorials-expert "Test: Create a brief overview of GitHub Actions, beginner level, markdown format" > test-output.md

if [ -f "test-output.md" ]; then
    echo "✅ Agent test successful"
    rm test-output.md
else
    echo "❌ Agent test failed"
    exit 1
fi

echo "🎉 Setup complete! Ready to create GitHub tutorials."
echo ""
echo "Usage examples:"
echo "  claude github-tutorials-expert \"Create tutorial on GitHub Actions secrets management\""
echo "  claude github-tutorials-expert \"Document GitHub Enterprise SAML setup, expert level, mediawiki format\""
```

### 8. Validation Script

Create `scripts/validate-docs.sh`:

```bash
#!/bin/bash

# Validate generated documentation for quality and accuracy

echo "🔍 Validating documentation..."

# Check for common issues
find docs examples -name "*.md" -exec grep -l "TODO\|FIXME\|XXX" {} \; | while read file; do
    echo "⚠️  Found placeholder content in: $file"
done

# Validate markdown syntax
if command -v markdownlint &> /dev/null; then
    markdownlint docs/ examples/ || echo "⚠️  Markdown linting issues found"
fi

# Check for broken links (if linkchecker is available)
if command -v linkchecker &> /dev/null; then
    find docs examples -name "*.md" -exec linkchecker {} \;
fi

echo "✅ Validation complete"
```

## Quick Start Commands

```bash
# 1. Create repository and setup
git clone git@github.com:development-toolbox/development-toolbox-github-tutorials-agent.git
cd development-toolbox-github-tutorials-agent

# 2. Make setup script executable and run
chmod +x scripts/setup.sh
./scripts/setup.sh

# 3. Test with your first tutorial
claude github-tutorials-expert "Create a beginner tutorial on setting up GitHub Actions for Python projects, Hugo markdown format"

# 4. Create enterprise documentation
claude github-tutorials-expert "Document the process for configuring branch protection rules in GitHub Enterprise, include approval workflows, MediaWiki format"

# 5. Generate API documentation
claude github-tutorials-expert "Create an intermediate guide to GitHub GraphQL API authentication using personal access tokens, include curl and JavaScript examples, Hugo format"
```

## Integration with Your Multi-Agent System

Add this to your existing `development-toolbox-multi-agent-dev-system` configuration:

```yaml
# config/agents/github_tutorials.yaml
external_agents:
  github_tutorials:
    type: "claude_code"
    repository: "git@github.com:development-toolbox/development-toolbox-github-tutorials-agent.git"
    agent_name: "github-tutorials-expert"
    capabilities:
      - "github_documentation"
      - "workflow_documentation"
      - "api_documentation"
      - "enterprise_processes"
    output_formats:
      - "hugo_markdown"
      - "mediawiki"
```

This setup gives you a professional, reusable GitHub tutorials expert that can be shared across your development-toolbox organization and integrated with your broader multi-agent system!