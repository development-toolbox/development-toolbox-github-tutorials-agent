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
