# Material for MkDocs Icon Validation

This directory contains custom markdownlint rules for validating icon usage in the Calculinux documentation.

## Complete Icon Validation

The `material-icons-complete.js` rule validates icon references against **complete** icon lists extracted directly from the Material for MkDocs theme installation.

### Supported Icon Sets

- **Material Design Icons**: 7,447 icons from [Pictogrammers](https://pictogrammers.com/library/mdi/)
- **Octicons**: 665 icons from [GitHub Primer](https://primer.style/foundations/icons)
- **FontAwesome**: 2,806 icons (solid, regular, brands)
- **Simple Icons**: 3,364 brand icons from [Simple Icons](https://simpleicons.org/)

### Icon Lists

The complete icon lists are stored in `../.github/icon-lists.json` and are generated from the installed Material for MkDocs theme.

### Regenerating Icon Lists

If you update the Material for MkDocs theme to a newer version, regenerate the icon lists:

```shell
python3 .github/scripts/generate-icon-lists.py
```

This will scan the Material theme's `.icons` directory and update `icon-lists.json` with all available icons.

### Usage in Documentation

Icons are referenced using the syntax `:icon-set-icon-name:`, for example:

- Material: `:material-rocket-launch:` → 🚀
- Octicons: `:octicons-arrow-right-24:` → →
- FontAwesome: `:fontawesome-brands-github:` → 
- Simple: `:simple-python:` → 

### Why a Custom Rule?

The default `mkdocs-material-linter` package includes icon validation, but it only validates against a small subset (~30-40 icons per set). This causes false positives for perfectly valid icons like:

- `:material-rocket-launch:` ✅ (exists, but not in default list)
- `:material-chip:` ✅ (exists, but not in default list)
- `:octicons-arrow-right-24:` ✅ (exists, but not in default list)

Our custom rule validates against the **complete** icon sets bundled with Material for MkDocs (10,000+ icons total), eliminating false positives.

## Configuration

The custom rule is enabled in `.markdownlint-cli2.jsonc`:

```jsonc
{
  "customRules": [
    "mkdocs-material-linter",
    ".github/markdownlint-rules/material-icons-complete.js"
  ],
  "config": {
    // Disable incomplete validation from mkdocs-material-linter
    "material-icons-valid": false,
    // Enable our complete validation
    "material-icons-complete": true
  }
}
```

## Finding Icons

To find available icons:

1. **Interactive Search**: Visit https://squidfunk.github.io/mkdocs-material/reference/icons-emojis/#search
2. **Material Icons**: https://pictogrammers.com/library/mdi/
3. **Octicons**: https://primer.style/foundations/icons
4. **FontAwesome**: https://fontawesome.com/search?m=free
5. **Simple Icons**: https://simpleicons.org/

## Troubleshooting

### Icon shows as text in preview

If an icon displays as text (e.g., `:material-rocket-launch:`) instead of rendering:

1. Check the icon name is correct (no typos)
2. Verify the icon exists in the icon set
3. Ensure `pymdownx.emoji` is configured in `mkdocs.yml`:

```yaml
markdown_extensions:
  - pymdownx.emoji:
      emoji_index: !!python/name:material.extensions.emoji.twemoji
      emoji_generator: !!python/name:material.extensions.emoji.to_svg
```

### Validation error for valid icon

If you get a validation error for an icon that exists:

1. Regenerate icon lists: `python3 .github/scripts/generate-icon-lists.py`
2. Check if Material for MkDocs needs updating: `pip install --upgrade mkdocs-material`
3. Verify the icon exists in the theme: `ls /path/to/material/templates/.icons/material/ | grep icon-name`
