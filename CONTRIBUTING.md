# Contributing to Calculinux Documentation

Thank you for your interest in contributing to Calculinux documentation! This guide will help you get started.

## How to Contribute

### Types of Contributions

We welcome various types of contributions:

- **Content improvements** - Fix errors, clarify instructions, add missing information
- **New pages** - Add documentation for undocumented features
- **Examples** - Add code examples, tutorials, how-tos
- **Screenshots** - Add visual guides and diagrams
- **Translations** - Translate documentation to other languages
- **Bug reports** - Report issues with documentation

### Getting Started

1. **Fork the repository**
   ```bash
   # On GitHub, click "Fork" button
   git clone https://github.com/YOUR_USERNAME/docs.git
   cd docs
   ```

2. **Set up development environment**
   ```bash
   pip install -r requirements.txt
   ```

3. **Create a branch**
   ```bash
   git checkout -b my-improvement
   ```

4. **Make your changes**
   - Edit markdown files in `docs/` directory
   - Test locally: `mkdocs serve`
   - View at http://127.0.0.1:8000

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Brief description of changes"
   ```

6. **Push and create PR**
   ```bash
   git push origin my-improvement
   # Then create Pull Request on GitHub
   ```

## Documentation Standards

### Writing Style

- **Clear and concise** - Use simple language
- **Active voice** - "Click the button" not "The button should be clicked"
- **Present tense** - "The system boots" not "The system will boot"
- **Second person** - "You can configure" not "One can configure"
- **Consistent terminology** - Use the same terms throughout

### Formatting

- Use **Markdown** for all documentation
- One sentence per line (makes diffs clearer)
- Use code blocks with language specification:
  ```bash
  # Like this
  command --option
  ```
- Use admonitions for important information:
  ```markdown
  !!! tip
      Helpful hint here
  
  !!! warning
      Important warning
  
  !!! danger
      Critical information
  ```

### Structure

- Start with overview/introduction
- Use hierarchical headings (##, ###, ####)
- Include "Next Steps" or "See Also" at end
- Link to related pages
- Use tables for structured data
- Use lists for steps or options

### Code Examples

- **Test all commands** - Verify they work
- **Include output** where helpful
- **Explain non-obvious steps**
- **Use realistic examples**
- **Keep examples simple** but useful

### Images

- Store in `docs/assets/` or `docs/images/`
- Use descriptive filenames: `luckfox-connection.jpg`
- Optimize file size (compress)
- Include alt text: `![Description](path/to/image.jpg)`
- Reference in text: "See Figure 1 below"

## Page Templates

### New Guide Page

```markdown
# Page Title

Brief introduction paragraph explaining what this page covers.

## Prerequisites

What you need before following this guide.

## Main Content

### Step 1: First Step

Explanation and commands.

### Step 2: Second Step

More explanation.

## Troubleshooting

Common issues and solutions.

## Next Steps

- Link to related guide
- Link to another resource
```

### New Reference Page

```markdown
# Feature Reference

Overview of the feature.

## Syntax

How to use it.

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--opt` | What it does | value |

## Examples

### Example 1: Basic Usage

Description and code.

## See Also

Links to related pages.
```

## Review Process

### What We Look For

- **Accuracy** - Information is correct
- **Clarity** - Easy to understand
- **Completeness** - Covers the topic adequately
- **Consistency** - Matches existing style
- **Links** - Internal links work, external links are valid
- **Grammar** - Proper spelling and grammar

### PR Checklist

Before submitting, verify:

- [ ] Content is accurate and tested
- [ ] Spelling and grammar checked
- [ ] Links work correctly
- [ ] Code examples tested
- [ ] Images optimized
- [ ] Builds without errors: `mkdocs build`
- [ ] Looks good locally: `mkdocs serve`
- [ ] Follows style guidelines
- [ ] Added to appropriate navigation section

## Stub Pages

Many pages exist as stubs (defined in navigation but minimal content). These are great opportunities to contribute! When filling in a stub:

1. Check if there's related content elsewhere to reference
2. Follow the structure of similar complete pages
3. Include all relevant sections
4. Add practical examples

## Questions?

- **Unclear guidelines?** Open an issue
- **Need help?** Ask in the forum
- **Technical questions?** Check main project docs

## Code of Conduct

- Be respectful and constructive
- Welcome newcomers
- Accept feedback gracefully
- Focus on improving documentation

## Recognition

Contributors are recognized in:
- Git commit history
- GitHub contributors page
- About/Contributors page (when created)

Thank you for contributing to Calculinux! 🎉
