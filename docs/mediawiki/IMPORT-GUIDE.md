# MediaWiki Import Guide for Your GitHub Tutorials

You have a complete MediaWiki tutorial system that I previously created for you. Here's how to import it into your Docker MediaWiki environment.

## Step 1: Import All Templates

You need to import all the template files from `docs/mediawiki/internal-wiki/templates/` into your MediaWiki.

### Template Import Script

Here's a bash script to import all templates via MediaWiki API:

```bash
#!/bin/bash

# MediaWiki configuration
WIKI_URL="http://localhost:8080"  # Adjust to your MediaWiki URL
USERNAME="Admin"                  # Your admin username
PASSWORD="yourpassword"          # Your admin password

# Login and get token
TOKEN=$(curl -s -X POST "${WIKI_URL}/api.php" \
  -d "action=query&meta=tokens&type=login&format=json" | \
  jq -r '.query.tokens.logintoken')

# Login
curl -s -X POST "${WIKI_URL}/api.php" \
  -d "action=login&lgname=${USERNAME}&lgpassword=${PASSWORD}&lgtoken=${TOKEN}&format=json" \
  -c cookies.txt

# Get edit token
EDIT_TOKEN=$(curl -s -b cookies.txt "${WIKI_URL}/api.php" \
  -d "action=query&meta=tokens&format=json" | \
  jq -r '.query.tokens.csrftoken')

# Import each template
cd docs/mediawiki/internal-wiki/templates/

for template_file in Template_*.mediawiki; do
    template_name=${template_file#Template_}
    template_name=${template_name%.mediawiki}
    
    echo "Importing Template:${template_name}"
    
    # Read template content
    template_content=$(cat "$template_file")
    
    # Upload template
    curl -s -b cookies.txt -X POST "${WIKI_URL}/api.php" \
      -d "action=edit" \
      -d "title=Template:${template_name}" \
      -d "text=${template_content}" \
      -d "token=${EDIT_TOKEN}" \
      -d "format=json"
done

rm cookies.txt
echo "Template import complete!"
```

## Step 2: Manual Template Import

If you prefer to import manually, for each file in `docs/mediawiki/internal-wiki/templates/`:

1. Open `Template_TemplateName.mediawiki`
2. Copy all the content
3. In your MediaWiki, go to `Template:TemplateName` (remove the underscore and .mediawiki)
4. Paste the content and save

### Key Templates You Need:

- `Template_TutorialInfo.mediawiki` → `Template:TutorialInfo`
- `Template_Note.mediawiki` → `Template:Note`  
- `Template_Warning.mediawiki` → `Template:Warning`
- `Template_Good.mediawiki` → `Template:Good`
- `Template_Code.mediawiki` → `Template:Code`
- `Template_Exercise.mediawiki` → `Template:Exercise`
- And all the others...

## Step 3: Import Tutorial Content

Your tutorial content is in `docs/mediawiki/internal-wiki/content/`:

### Main Tutorial Pages:
- `Basic_Git_Commands.mediawiki`
- `Advanced_Pull_Requests.mediawiki`
- `Advanced_GitHub_Actions.mediawiki`
- Category pages for organization

### Import Process:
1. Copy content from each `.mediawiki` file
2. Create a new page in your MediaWiki with the same name (without .mediawiki)
3. Paste content and save

## Step 4: Enable Required Extensions

Add to your MediaWiki's `LocalSettings.php`:

```php
# Enable syntax highlighting for code blocks
wfLoadExtension( 'SyntaxHighlight_GeSHi' );

# Enable parser functions for template logic  
wfLoadExtension( 'ParserFunctions' );

# Enable StringFunctions for advanced template features
wfLoadExtension( 'StringFunctions' );
```

## Step 5: Add Custom CSS

Copy the content from `docs/mediawiki/internal-wiki/README.md` CSS section to your `MediaWiki:Common.css` page.

## Docker-Compose Setup

If you need a MediaWiki Docker setup:

```yaml
version: '3.8'
services:
  mediawiki:
    image: mediawiki:1.39
    ports:
      - "8080:80"
    volumes:
      - ./images:/var/www/html/images
      - ./LocalSettings.php:/var/www/html/LocalSettings.php
    environment:
      - MEDIAWIKI_DB_HOST=database
      - MEDIAWIKI_DB_USER=wikiuser  
      - MEDIAWIKI_DB_PASSWORD=wikipass
      - MEDIAWIKI_DB_NAME=my_wiki
    depends_on:
      - database

  database:
    image: mariadb:10.6
    environment:
      - MYSQL_DATABASE=my_wiki
      - MYSQL_USER=wikiuser
      - MYSQL_PASSWORD=wikipass
      - MYSQL_ROOT_PASSWORD=rootpass
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:
```

## Step 6: Test Import

Create a test page with:

```mediawiki
{{TutorialInfo
|level=Beginner
|duration=30 minutes
|prerequisites=None
|topics=Account creation, Basic navigation, Repository basics
}}

{{Note|This is a test note}}
{{Warning|This is a test warning}}
{{Good|This is a best practice tip}}
```

## Troubleshooting

### Templates Showing Raw Code
- Check that ParserFunctions extension is enabled
- Verify template names match exactly (case-sensitive)
- Clear cache by adding `?action=purge` to page URL

### Links Not Working
- Internal links use `[[Page Name]]` format
- External links use `[https://example.com Link Text]` format

### Syntax Highlighting Not Working
- Install SyntaxHighlight_GeSHi extension
- Ensure Pygments is available in Docker container

## Your Complete Tutorial System

You have:
- ✅ 21 custom templates for rich content formatting
- ✅ Multiple comprehensive GitHub tutorials
- ✅ Category system for organization
- ✅ Navigation between tutorials
- ✅ Exercise and practice sections
- ✅ Professional styling

All of this was previously created by me for your GitHub tutorial system. You just need to import it into your MediaWiki Docker environment!