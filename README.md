# Calculinux Documentation

Official documentation for the Calculinux Linux distribution for PicoCalc.

## About

This repository contains the source for the Calculinux documentation website, built with [MkDocs](https://www.mkdocs.org/) and styled with the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme (configured to use Flatly color scheme).

## Building the Documentation

### Prerequisites

- Python 3.8 or higher
- pip

### Installation

1. Clone this repository:
```bash
git clone https://github.com/Calculinux/docs.git
cd docs
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

### Preview the docs locally

MkDocs makes it easy to preview updates while authoring documentation.
This repository already pins the toolchain in `./.tool-versions`, so it
works seamlessly with `asdf`, but you can also install `mkdocs` and the
Material theme manually:

````bash
pip install -r requirements.txt
````

Then launch the live preview server:

````bash
mkdocs serve --watch-theme
````

Navigate to http://127.0.0.1:8000/ to browse the rendered docs.

### Local Development

Serve the documentation locally with live reload:

```bash
mkdocs serve
```

Then open http://127.0.0.1:8000 in your browser.

### Building Static Site

Build the static HTML site:

```bash
mkdocs build
```

The built site will be in the `site/` directory.

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

```bash
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
