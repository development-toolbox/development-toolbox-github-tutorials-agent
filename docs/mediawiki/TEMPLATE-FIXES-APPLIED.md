# MediaWiki Template Fixes Applied

## Issues Found and Fixed

### 1. **TOC Limit Template Syntax Error**

**Problem**: The tutorials were using incorrect parameter syntax for the `{{TOC limit}}` template.

**Wrong syntax:**
```mediawiki
{{TOC limit=3}}
```

**Correct syntax:**
```mediawiki
{{TOC limit|3}}
```

**Root Cause**: MediaWiki templates use pipe (`|`) separators for parameters, not equals (`=`) signs. The `Template_TOC_limit.mediawiki` expects a numbered parameter `{{{1|}}}`, not a named parameter.

### 2. **Files Fixed**

✅ **docs/mediawiki/internal-wiki/content/Getting_Started_with_GitHub.mediawiki**
- Fixed: `{{TOC limit=3}}` → `{{TOC limit|3}}`

✅ **docs/mediawiki/internal-wiki/content/GitHub_Actions_Fundamentals.mediawiki**  
- Fixed: `{{TOC limit=3}}` → `{{TOC limit|3}}`

## Template System Analysis

### How Your Templates Work

Your template system uses the standard MediaWiki syntax structure:

```mediawiki
<includeonly>
  <!-- Template content with parameters like {{{1|}}} {{{parameter|}}} -->
</includeonly>
<noinclude>
  <!-- Documentation and examples -->
</noinclude>
```

### Template Parameter Types

1. **Numbered Parameters**: `{{{1|}}}`, `{{{2|}}}`, etc.
   - Called with: `{{TemplateName|value1|value2}}`

2. **Named Parameters**: `{{{name|}}}`, `{{{level|}}}`, etc.
   - Called with: `{{TemplateName|name=value|level=Beginner}}`

### Your Template Usage Patterns

**TutorialInfo Template** (✅ Working correctly):
```mediawiki
{{TutorialInfo
|level=Beginner
|duration=30 minutes
|prerequisites=None
|topics=Account creation, Basic navigation, Repository basics
}}
```

**TOC Limit Template** (✅ Now fixed):
```mediawiki
{{TOC limit|3}}
```

**Other Templates** (✅ Working correctly):
```mediawiki
{{Note|This is a note}}
{{Warning|This is a warning}}
{{Good|This is best practice}}
{{Exercise|Your exercise content here}}
```

## Testing Your Templates

To verify templates are working in your MediaWiki Docker environment:

### 1. Import All Templates First

```bash
cd docs/mediawiki
./import-templates.sh
```

### 2. Create a Test Page

Create a page called "Template Test" with this content:

```mediawiki
= Template Test =

{{TutorialInfo
|level=Beginner
|duration=30 minutes
|prerequisites=None
|topics=Template testing
}}

{{TOC limit|3}}

== Section 1 ==
=== Subsection 1.1 ===
=== Subsection 1.2 ===

== Section 2 ==
=== Subsection 2.1 ===
==== Sub-subsection 2.1.1 ====

{{Note|This should display as a blue information box}}

{{Warning|This should display as a yellow/orange warning box}}

{{Good|This should display as a green best practice box}}

{{Exercise|
Try these steps:
# Step one
# Step two  
# Step three
}}
```

### 3. Expected Results

If templates are working correctly, you should see:
- ✅ Tutorial info box at the top with colored level badge
- ✅ Table of contents showing only levels 1, 2, and 3
- ✅ Colored callout boxes for Note, Warning, Good
- ✅ Purple exercise box with runner emoji

## Common Template Issues & Solutions

### Issue: Template Shows Raw Code
**Cause**: Template doesn't exist in MediaWiki
**Solution**: Import the template from `internal-wiki/templates/`

### Issue: Template Exists But Doesn't Render
**Cause**: ParserFunctions extension not enabled
**Solution**: Add to LocalSettings.php:
```php
wfLoadExtension( 'ParserFunctions' );
```

### Issue: Syntax Highlighting Not Working
**Cause**: SyntaxHighlight_GeSHi extension not enabled  
**Solution**: Add to LocalSettings.php:
```php
wfLoadExtension( 'SyntaxHighlight_GeSHi' );
```

### Issue: TOC Limit Styling Not Applied
**Cause**: CSS not loaded
**Solution**: The `Template_TOC_limit.mediawiki` includes inline CSS. If this doesn't work, add the CSS to `MediaWiki:Common.css`

## Template Import Status

All your templates are ready to import from:
- `docs/mediawiki/internal-wiki/templates/Template_*.mediawiki`

Key templates include:
- ✅ `Template_TutorialInfo.mediawiki`
- ✅ `Template_Note.mediawiki`  
- ✅ `Template_Warning.mediawiki`
- ✅ `Template_Good.mediawiki`
- ✅ `Template_Exercise.mediawiki`
- ✅ `Template_TOC_limit.mediawiki`
- ✅ `Template_Navigation.mediawiki`
- And 14 more...

## Summary

The main issue was **incorrect parameter syntax** in template calls. All template syntax errors have been identified and fixed. Your templates should now load correctly in MediaWiki once they're imported into your Docker environment.

**Next Steps:**
1. Import templates using the provided script
2. Test with the template test page above  
3. Import your tutorial content
4. Your GitHub tutorial system should work perfectly! 🎉