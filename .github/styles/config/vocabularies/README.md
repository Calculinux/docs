# Vale Vocabulary Files

This directory contains vocabulary files for Vale linting. These files define accepted and rejected terms for the Calculinux documentation.

## Structure

```
vocabularies/
├── Calculinux/
│   ├── accept.txt    # Accepted terms (won't be flagged as errors)
│   └── reject.txt    # Rejected terms (will always be flagged)
├── Yocto/
│   ├── accept.txt    # Yocto-specific accepted terms
│   └── reject.txt
└── OpenSource/
    ├── accept.txt    # Open source project terms
    └── reject.txt
```

## accept.txt Format

- **One term per line**
- **Case-sensitive** by default
- **Regex patterns supported** for advanced matching:
  - `(?i)MongoDB` - Case-insensitive match
  - `[Oo]bservability` - Character class alternative
  - `(?i)(react|vue|angular)js` - Multiple alternatives, case-insensitive

## Adding Terms

### Via PR Comment (Recommended)

When Vale flags a term in a PR review comment:

1. Reply to the Vale error comment with: `vale-accept-term`
2. The GitHub Actions bot will automatically:
   - Extract the term from the Vale error
   - Add it to `Calculinux/accept.txt`
   - Commit the change to your PR
   - Post a confirmation comment

### Manual Addition

1. Edit the appropriate `accept.txt` file
2. Add the term (one per line)
3. Commit and push
4. Vale will recognize the term on the next run

## What to Add

✅ **Should be added:**
- Hardware names: `PicoCalc`, `Luckfox`, `Rockchip`, `RK3506`
- Software/tools: `bitbake`, `mkdocs`, `opkg`
- Technical acronyms: `GPIO`, `UART`, `SoC`, `SPI`
- Brand names: `ClockworkPi`, `Yocto`
- Project-specific terms: `Calculinux`, `calculinux-image`
- File extensions: `wic.gz`, `bb`, `bbappend`

❌ **Should NOT be added:**
- Common misspellings
- Words that exist in standard dictionaries
- Temporary project names
- Typos

## Testing

After adding terms, test locally:

```bash
# Install Vale (if not already installed)
make install-vale

# Run Vale on documentation
vale docs/

# Or run full linting
make lint
```

## Vocabulary Scope

The vocabularies are configured in `.vale.ini`:

```ini
Vocab = Calculinux, Yocto, OpenSource
```

All vocabulary files are checked for markdown files (`*.md`).

## More Information

- [Vale Vocabularies Documentation](https://vale.sh/docs/topics/vocab/)
- [Vale Regex Guide](https://vale.sh/docs/topics/scoping/#regex)
- [Project Contributing Guide](../../../CONTRIBUTING.md)
