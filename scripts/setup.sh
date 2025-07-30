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
