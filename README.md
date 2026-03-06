# Calculinux Documentation

Official documentation for the Calculinux Linux distribution for PicoCalc.

## About

This repository contains the source for the Calculinux documentation website, built with [MkDocs](https://www.mkdocs.org/) and styled with the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme (configured to use Flatly color scheme).

## Building the Documentation

### Prerequisites

- Python 3.8 or higher
- pip
- Node.js and npm
- Vale (installed automatically via `make install`)

### Installation

1. Clone this repository:
```shell
git clone https://github.com/Calculinux/docs.git
cd docs
```

2. Install dependencies:
```shell
make install
```

### Quick Start

The repository includes a Makefile for common development tasks:

```shell
make          # Default: runs lint, then starts docs server
make lint     # Run all linters (markdownlint, link-check, vale)
make docs     # Start local MkDocs server
make site     # Build static HTML site to site/
make pdf      # Build static site and combined PDF (site/calculinux-docs.pdf)
make clean    # Remove build artifacts
make vale-sync           # Sync Vale styles and packages
make validate-workflows  # Validate GitHub Actions YAML files
make help     # Show all available commands
```

### Preview the docs locally

To preview documentation with live reload:

```shell
make docs
```

Navigate to http://127.0.0.1:8000/ to browse the rendered docs.

Or manually:
```shell
mkdocs serve --watch-theme
```

### Local Development

Serve the documentation locally with live reload:

```shell
mkdocs serve
```

Then open http://127.0.0.1:8000 in your browser.

### Building Static Site

Build the static HTML site:

```shell
make site
```

Or manually:

```shell
mkdocs build
```

The built site will be in the `site/` directory.

### Building a PDF

You can generate a single combined PDF of all documentation pages:

```shell
make pdf
```

The PDF is written to **`site/calculinux-docs.pdf`**.

**Requirements:** PDF generation uses [WeasyPrint](https://weasyprint.org/), which needs system libraries. Install them before running `make pdf`:

- **Fedora:** `sudo dnf install cairo pango gdk-pixbuf2 libffi-devel`
- **Debian/Ubuntu:** `sudo apt install libpango-1.0-0 libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info`

Then ensure the Python dependencies are installed (`make install` or `pip install -r requirements.txt`). If `make pdf` fails with a WeasyPrint error, check that the system packages above are installed.

## Project Structure

```
docs/
├── mkdocs.yml              # MkDocs configuration
├── requirements.txt        # Python dependencies
├── docs/                   # Documentation source
│   ├── index.md           # Homepage
│   ├── stylesheets/       # Custom CSS
│   ├── getting-started/   # Getting started guides
│   ├── hardware/          # Hardware documentation
│   ├── user-guide/        # User guides
│   ├── developer/         # Developer documentation
│   ├── troubleshooting/   # Troubleshooting guides
│   ├── resources/         # External resources
│   └── about/             # About pages
└── README.md              # This file
```

## Contributing

We welcome contributions to improve the documentation!

### How to Contribute

1. Fork this repository
2. Create a branch for your changes
3. Make your edits in the `docs/` directory
4. Test locally with `mkdocs serve`
5. Submit a pull request

### Writing Guidelines

- Use clear, concise language
- Include code examples where appropriate
- Add screenshots/diagrams for visual concepts
- Follow the existing structure and style
- Test all commands and instructions
- Keep line length reasonable for readability

### Automated Quality Checks

Pull requests automatically run:
- **markdownlint** - Markdown formatting and structure
- **markdown-link-check** - Validates all links
- **Vale** - Prose linting (grammar, style, technical terms)

#### Vale Term Management

If Vale flags a legitimate technical term on your PR:

1. Reply to the Vale error comment with `vale-accept-term`
2. The bot will automatically add the term to the accept list and commit it

See [Vale Vocabulary README](.github/styles/config/vocabularies/README.md) for more details.

### Markdown Features

This documentation supports:

- Standard Markdown
- [Admonitions](https://squidfunk.github.io/mkdocs-material/reference/admonitions/)
- [Code blocks](https://squidfunk.github.io/mkdocs-material/reference/code-blocks/) with syntax highlighting
- [Tables](https://squidfunk.github.io/mkdocs-material/reference/data-tables/)
- [Task lists](https://squidfunk.github.io/mkdocs-material/reference/lists/#using-task-lists)
- [Icons and emojis](https://squidfunk.github.io/mkdocs-material/reference/icons-emojis/)

## Deployment

The documentation is automatically deployed to GitHub Pages when changes are pushed to the `main` branch.

### Manual Deployment

To deploy manually:

```shell
mkdocs gh-deploy
```

## License

This documentation is licensed under the Creative Commons Attribution 4.0 International License (CC BY 4.0).

See the [LICENSE](LICENSE) file for details.

## Links

- **Documentation Site**: https://calculinux.github.io/docs/
- **Main Project**: https://github.com/Calculinux/meta-calculinux
- **Forum**: https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280
- **Issue Tracker**: https://github.com/Calculinux/docs/issues

## Support

- Open an [issue](https://github.com/Calculinux/docs/issues) for documentation bugs or improvements
- Visit the [forum](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280) for general discussion
- See the main project [README](https://github.com/Calculinux/meta-calculinux) for Calculinux itself
