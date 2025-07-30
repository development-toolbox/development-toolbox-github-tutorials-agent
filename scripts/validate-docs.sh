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
