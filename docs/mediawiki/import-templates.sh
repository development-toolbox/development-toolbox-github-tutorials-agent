#!/bin/bash

# MediaWiki Template Import Script
# This script imports all your existing templates into MediaWiki

# Configuration - EDIT THESE VALUES
WIKI_URL="http://localhost:8080"
USERNAME="Admin"
PASSWORD="yourpassword"

echo "🚀 Starting MediaWiki template import..."

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "❌ jq is required but not installed. Please install jq first."
    exit 1
fi

# Check if curl is available
if ! command -v curl &> /dev/null; then
    echo "❌ curl is required but not installed. Please install curl first."
    exit 1
fi

echo "📡 Connecting to MediaWiki at ${WIKI_URL}..."

# Get login token
echo "🔑 Getting login token..."
LOGIN_TOKEN=$(curl -s -X POST "${WIKI_URL}/api.php" \
  -d "action=query&meta=tokens&type=login&format=json" | \
  jq -r '.query.tokens.logintoken')

if [ "$LOGIN_TOKEN" = "null" ] || [ -z "$LOGIN_TOKEN" ]; then
    echo "❌ Failed to get login token. Check your MediaWiki URL."
    exit 1
fi

echo "✅ Login token obtained"

# Login
echo "🔐 Logging in as ${USERNAME}..."
LOGIN_RESULT=$(curl -s -X POST "${WIKI_URL}/api.php" \
  -d "action=login&lgname=${USERNAME}&lgpassword=${PASSWORD}&lgtoken=${LOGIN_TOKEN}&format=json" \
  -c cookies.txt)

LOGIN_STATUS=$(echo "$LOGIN_RESULT" | jq -r '.login.result')

if [ "$LOGIN_STATUS" != "Success" ]; then
    echo "❌ Login failed. Check your username and password."
    echo "Login result: $LOGIN_STATUS"
    rm -f cookies.txt
    exit 1
fi

echo "✅ Successfully logged in"

# Get edit token
echo "📝 Getting edit token..."
EDIT_TOKEN=$(curl -s -b cookies.txt "${WIKI_URL}/api.php" \
  -d "action=query&meta=tokens&format=json" | \
  jq -r '.query.tokens.csrftoken')

if [ "$EDIT_TOKEN" = "null" ] || [ -z "$EDIT_TOKEN" ]; then
    echo "❌ Failed to get edit token."
    rm -f cookies.txt
    exit 1
fi

echo "✅ Edit token obtained"

# Import templates
echo "📦 Importing templates..."

TEMPLATE_DIR="internal-wiki/templates"
IMPORTED_COUNT=0
FAILED_COUNT=0

if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "❌ Template directory not found: $TEMPLATE_DIR"
    rm -f cookies.txt
    exit 1
fi

for template_file in "$TEMPLATE_DIR"/Template_*.mediawiki; do
    if [ ! -f "$template_file" ]; then
        echo "⚠️  No template files found in $TEMPLATE_DIR"
        break
    fi
    
    # Extract template name
    template_name=$(basename "$template_file" .mediawiki)
    template_name=${template_name#Template_}
    
    echo "📄 Importing Template:${template_name}..."
    
    # Read template content and escape it for curl
    template_content=$(cat "$template_file" | sed 's/"/\\"/g')
    
    # Upload template
    RESULT=$(curl -s -b cookies.txt -X POST "${WIKI_URL}/api.php" \
      -d "action=edit" \
      -d "title=Template:${template_name}" \
      -d "text=${template_content}" \
      -d "token=${EDIT_TOKEN}" \
      -d "format=json")
    
    # Check if edit was successful
    EDIT_RESULT=$(echo "$RESULT" | jq -r '.edit.result // .error.code // "unknown"')
    
    if [ "$EDIT_RESULT" = "Success" ]; then
        echo "  ✅ Template:${template_name} imported successfully"
        ((IMPORTED_COUNT++))
    else
        echo "  ❌ Failed to import Template:${template_name}"
        echo "     Error: $EDIT_RESULT"
        ((FAILED_COUNT++))
    fi
done

# Cleanup
rm -f cookies.txt

echo ""
echo "🎉 Import complete!"
echo "   ✅ Successfully imported: $IMPORTED_COUNT templates"
if [ $FAILED_COUNT -gt 0 ]; then
    echo "   ❌ Failed to import: $FAILED_COUNT templates"
fi

echo ""
echo "🔗 Next steps:"
echo "   1. Visit ${WIKI_URL}/wiki/Special:AllPages?namespace=10 to see your imported templates"
echo "   2. Test a template by creating a page with: {{TutorialInfo|level=Beginner|duration=30 minutes|prerequisites=None|topics=Testing}}"
echo "   3. Import your tutorial content from internal-wiki/content/"
echo ""
echo "✨ Your GitHub tutorial system is ready to use!"