# GitHub Tutorials Expert Agent

[![Claude Code](https://img.shields.io/badge/Claude%20Code-Agent-blue)](https://claude.ai/code)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Development Toolbox](https://img.shields.io/badge/Development%20Toolbox-Agent-green)](https://github.com/development-toolbox)

A specialized Claude Code agent for creating comprehensive GitHub tutorials and technical documentation in both Hugo-compatible Markdown and MediaWiki formats.

## 🎯 Overview

This agent is part of the [Development Toolbox](https://github.com/development-toolbox) ecosystem and specializes in generating high-quality technical documentation for GitHub-related topics. It produces professional-grade tutorials following UK English standards and can adapt content for different skill levels.

### Key Features

- **📚 Comprehensive GitHub Expertise**: GitHub Actions, Enterprise features, Git workflows, API integrations
- **🎨 Dual Format Support**: Hugo Markdown with YAML frontmatter + MediaWiki markup
- **🇬🇧 UK English Standards**: Professional technical writing with proper British spelling and conventions
- **📊 Skill Level Adaptation**: Content tailored for beginner, intermediate, and expert audiences
- **✅ Quality Assurance**: Built-in validation against official GitHub documentation
- **🔗 Integration Ready**: Seamless integration with existing documentation workflows

## 🚀 Quick Start

### Prerequisites

- [Claude Code](https://claude.ai/code) installed and configured
- Git and GitHub CLI (optional, for repository operations)

### Installation

1. **Clone the repository:**
   ```bash
   git clone git@github.com:development-toolbox/development-toolbox-github-tutorials-agent.git
   cd development-toolbox-github-tutorials-agent
   ```

2. **Run setup:**
   ```bash
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   ```

3. **Test the agent:**
   ```bash
   claude github-tutorials-expert "Create a brief overview of GitHub Actions, beginner level, markdown format"
   ```

## 📖 Usage Examples

### Basic Tutorial Creation

```bash
# GitHub Actions workflow tutorial
claude github-tutorials-expert "Create a comprehensive tutorial on GitHub Actions for Python CI/CD, intermediate level, Hugo markdown format"

# Enterprise documentation
claude github-tutorials-expert "Document the process for configuring SAML authentication in GitHub Enterprise Server, expert level, MediaWiki format"

# API integration guide
claude github-tutorials-expert "Create a beginner-friendly guide to GitHub REST API authentication using personal access tokens, include JavaScript examples, Hugo format"
```

### Advanced Usage

```bash
# Multi-environment deployment workflows
claude github-tutorials-expert "Create an expert-level tutorial on GitHub Actions matrix builds for deploying to multiple cloud environments using Terraform, include security best practices, Hugo format"

# Enterprise compliance processes
claude github-tutorials-expert "Document the complete workflow for implementing branch protection rules and code review requirements in GitHub Enterprise, include approval processes and audit trails, MediaWiki format"
```

## 📋 Output Formats

### Hugo Markdown
Perfect for static site generators like Hugo, includes:
- YAML frontmatter with metadata
- Hugo shortcodes for enhanced formatting
- Cross-references and table of contents
- SEO-optimized structure

**Example frontmatter:**
```yaml
---
title: "GitHub Actions CI/CD for Python Projects"
date: 2025-07-30
categories: ["GitHub", "CI/CD"]
tags: ["actions", "python", "automation"]
toc: true
weight: 10
---
```

### MediaWiki
Optimized for internal company wikis, includes:
- MediaWiki template system
- Proper categorization and internal linking
- Collaborative editing features
- Table formatting and syntax highlighting

**Example template:**
```mediawiki
{{Tutorial
|title = GitHub Actions CI/CD for Python Projects
|author = GitHub Tutorials Expert
|difficulty = intermediate
|estimated_time = 30 minutes
}}
```

## 🎓 Skill Level Targeting

### Beginner Level
- Step-by-step instructions with screenshots
- Fundamental concepts and context
- Glossary of terms
- Common troubleshooting scenarios

### Intermediate Level
- Best practices and optimization
- Architectural decisions and trade-offs
- Multiple implementation approaches
- Performance considerations

### Expert Level
- Advanced configurations and edge cases
- Performance benchmarks and metrics
- Custom solutions and workarounds
- Enterprise-scale considerations

## 🏗️ Repository Structure

```
├── .claude/
│   ├── agents/
│   │   └── github-tutorials-expert.md    # Main agent configuration
│   └── CLAUDE.md                         # Project configuration
├── docs/
│   ├── examples/                         # Example tutorials
│   ├── templates/                        # Content templates
│   └── guidelines/                       # Style guidelines
├── templates/
│   ├── hugo/                            # Hugo Markdown templates
│   └── mediawiki/                       # MediaWiki templates
├── scripts/
│   ├── setup.sh                        # Environment setup
│   ├── validate-docs.sh                # Documentation validation
│   └── deploy.sh                       # Deployment automation
├── examples/
│   ├── beginner/                        # Beginner-level examples
│   ├── intermediate/                    # Intermediate examples
│   └── expert/                          # Expert-level examples
└── tests/                               # Validation tests
```

## 🔧 Configuration

The agent is configured through `.claude/agents/github-tutorials-expert.md` with specialized expertise in:

- **GitHub Actions**: Workflows, triggers, matrix builds, custom actions
- **GitHub Enterprise**: SAML/LDAP, security features, compliance
- **Git Workflows**: Branching strategies, merge strategies, hooks
- **API Integration**: REST/GraphQL APIs, authentication, webhooks
- **DevOps Integration**: CI/CD pipelines, infrastructure as code
- **Security**: Secret management, vulnerability scanning, policies

## 🎨 Documentation Standards

### UK English Conventions
- Spelling: organisation, authorisation, colour, behaviour
- Date format: DD/MM/YYYY or DD Month YYYY
- Quotation marks: 'single quotes' for primary usage
- Metric system preferences

### Technical Writing Principles
- Active voice and imperative mood for instructions
- Clear, accessible language following WCAG 2.1 AA guidelines
- Consistent terminology throughout
- Practical, tested code examples
- Official GitHub documentation references

## 🔗 Integration

### With Development Toolbox Multi-Agent System

Add to your multi-agent system configuration:

```yaml
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
```

### With Hugo Static Sites

```bash
# Generate content directly to Hugo content directory
claude github-tutorials-expert "Create tutorial content" > content/tutorials/github-actions-basics.md
```

### With MediaWiki

```bash
# Generate MediaWiki content for wiki upload
claude github-tutorials-expert "Create tutorial content, MediaWiki format" > wiki-content.wiki
```

## 📚 Examples

See the [`examples/`](examples/) directory for sample tutorials at different skill levels:

- [`examples/beginner/`](examples/beginner/) - Getting started tutorials
- [`examples/intermediate/`](examples/intermediate/) - Practical implementation guides
- [`examples/expert/`](examples/expert/) - Advanced configuration and enterprise scenarios

## 🤝 Contributing

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/new-capability`
3. **Test your changes**: Run validation scripts and test tutorial generation
4. **Submit a pull request** with examples of generated content

### Development Guidelines

- Test agent modifications with multiple tutorial types
- Validate output format compliance
- Ensure UK English standards are maintained
- Include examples of generated content in PRs
- Update documentation for new capabilities

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/development-toolbox/development-toolbox-github-tutorials-agent/issues)
- **Discussions**: [GitHub Discussions](https://github.com/development-toolbox/development-toolbox-github-tutorials-agent/discussions)
- **Development Toolbox**: [Organization Overview](https://github.com/development-toolbox)

## 🚀 Related Projects

Part of the **Development Toolbox** ecosystem:

- [Multi-Agent Development System](https://github.com/development-toolbox/development-toolbox-multi-agent-dev-system) - Comprehensive multi-agent development automation
- [MediaWiki Automation](https://github.com/development-toolbox/development-toolbox-mediawiki-automation) - MediaWiki content management automation

## 📊 Agent Capabilities Matrix

| Feature | Beginner | Intermediate | Expert |
|---------|----------|--------------|--------|
| GitHub Actions | ✅ Basic workflows | ✅ Matrix builds, conditionals | ✅ Custom actions, advanced patterns |
| Git Workflows | ✅ Basic branching | ✅ Feature branches, rebasing | ✅ Complex merge strategies |
| Enterprise Features | ✅ Basic setup | ✅ SAML configuration | ✅ Advanced security, compliance |
| API Integration | ✅ Simple REST calls | ✅ Authentication, pagination | ✅ GraphQL, webhooks, Apps |
| Documentation Quality | ✅ Clear instructions | ✅ Best practices | ✅ Architecture decisions |

---

**Made with ❤️ by the Development Toolbox team**

*Empowering developers with intelligent automation and comprehensive documentation.*