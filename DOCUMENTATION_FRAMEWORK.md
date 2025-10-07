# Calculinux Documentation Framework - Setup Complete

This repository now contains a comprehensive documentation framework for the Calculinux project using MkDocs with the Material theme (styled with Flatly colors).

## What Has Been Created

### Core Configuration Files

1. **mkdocs.yml** - Main configuration with navigation structure
2. **requirements.txt** - Python dependencies for MkDocs
3. **README.md** - Documentation repository guide
4. **.github/workflows/deploy.yml** - Automatic deployment to GitHub Pages

### Documentation Structure

The documentation is organized into the following sections:

#### Getting Started
- Overview - Introduction and quick links
- Hardware Requirements - What you need
- Installation - How to flash and install
- First Boot - Initial setup
- Quick Start Guide - Basic commands and usage

#### Hardware
- PicoCalc Overview - Device information
- Luckfox Lyra - SBC specifications and details
- Hardware Modifications - Installation guide
- Display & Input - Technical details of drivers
- Power Management - Power considerations (stub)
- Milk-V Duo - Future platform support (stub)
- Compatibility Matrix - Hardware compatibility table

#### User Guide (Stubs created for future development)
- Basic Usage
- Desktop Environment
- Applications
- Package Management
- System Configuration
- Networking
- Storage & SD Cards
- Updates

#### Developer Guide
- Overview - Development introduction
- Yocto Setup (stub)
- Building Calculinux (stub)
- Customizing Images (stub)
- Adding Packages (stub)
- Kernel Development (stub)
- Driver Development (stub)
- Contributing (stub)
- Release Process (stub)

#### Troubleshooting
- Common Issues (stub)
- Boot Problems (stub)
- Display Issues (stub)
- Input Problems (stub)
- Network Issues (stub)
- FAQ - Comprehensive troubleshooting and questions

#### Resources
- Community Links - How to connect and get help
- External Documentation - Comprehensive link collection
- Useful Tools (stub)
- Related Projects (stub)
- Glossary (stub)

#### About (Stubs for future development)
- Project Goals
- Roadmap
- License
- Contributors

## Key Features

### Theme & Styling

- **Material for MkDocs** theme
- **Flatly color scheme** (via custom CSS)
- Responsive design
- Search functionality
- Navigation tabs
- Code syntax highlighting
- Admonitions (info, warning, tip, etc.)

### Content Features

- Comprehensive hardware documentation
- Step-by-step installation guide
- Troubleshooting resources
- Developer guides
- External resource links
- Community information

### Automation

- GitHub Actions workflow for automatic deployment
- Git revision date plugin for page updates
- Search indexing

## Getting Started with the Documentation

### Local Development

```bash
# Install dependencies
pip install -r requirements.txt

# Serve locally with live reload
mkdocs serve

# Visit http://127.0.0.1:8000
```

### Building

```bash
# Build static site
mkdocs build

# Output in site/ directory
```

### Deployment

```bash
# Deploy to GitHub Pages
mkdocs gh-deploy
```

Or push to main branch - GitHub Actions will auto-deploy.

## Next Steps for Development

### High Priority Content to Add

1. **User Guide Pages** - Flesh out stubs with actual usage guides
2. **Developer Guides** - Complete Yocto setup and building instructions
3. **Troubleshooting Details** - Expand specific troubleshooting pages
4. **Screenshots** - Add visual guides and examples
5. **About Section** - Project goals, roadmap, license details

### Resources Referenced

The documentation includes links to:
- Forum thread: https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280
- Luckfox SDK: https://github.com/LuckfoxTECH/luckfox-pico
- Yocto Project: https://www.yoctoproject.org
- Flatly theme: https://bootswatch.com/flatly/

### Contributing

The framework makes it easy for contributors to:
- Add new pages in appropriate sections
- Edit existing content
- Submit pull requests
- View changes locally before submitting

## File Structure

```
docs/
├── mkdocs.yml                          # Main configuration
├── requirements.txt                     # Python dependencies
├── README.md                           # Repo documentation
├── DOCUMENTATION_FRAMEWORK.md          # This file
├── .github/
│   └── workflows/
│       └── deploy.yml                  # Auto-deployment
└── docs/                               # Content directory
    ├── index.md                        # Homepage
    ├── stylesheets/
    │   └── flatly.css                  # Custom theme CSS
    ├── getting-started/                # 5 complete pages
    ├── hardware/                       # 4 complete + stubs
    ├── user-guide/                     # Stubs
    ├── developer/                      # 1 complete + stubs
    ├── troubleshooting/                # 1 complete + stubs
    ├── resources/                      # 2 complete + stubs
    └── about/                          # Stubs
```

## Pages Created

### Complete Pages (Ready to Publish)

1. index.md - Homepage with project overview
2. getting-started/overview.md
3. getting-started/hardware-requirements.md
4. getting-started/installation.md
5. getting-started/first-boot.md
6. getting-started/quick-start.md
7. hardware/picocalc.md
8. hardware/luckfox-lyra.md
9. hardware/modifications.md
10. hardware/display-input.md
11. hardware/compatibility.md
12. developer/overview.md
13. troubleshooting/faq.md
14. resources/community.md
15. resources/external-docs.md

### Stub Pages (Need Content)

These pages are defined in navigation but need content:
- User guide pages (8 pages)
- Developer guide pages (8 pages)
- Remaining troubleshooting pages (5 pages)
- Remaining resource pages (3 pages)
- About section pages (4 pages)

Total: 28 stub pages to be filled in

## Customization Notes

### Theme Colors (Flatly)

The custom CSS in `docs/stylesheets/flatly.css` implements:
- Primary color: #2C3E50 (dark blue-gray)
- Accent color: #18BC9C (teal/green)
- Clean, professional appearance
- Good contrast and readability

### Navigation Structure

The navigation is hierarchical and logical:
1. Home (landing page)
2. Getting Started (new user flow)
3. Hardware (physical device info)
4. User Guide (day-to-day usage)
5. Developer Guide (building/contributing)
6. Troubleshooting (problem solving)
7. Resources (external links)
8. About (project info)

## Documentation Philosophy

The documentation follows these principles:

1. **User-Focused** - Organized by user needs, not technical structure
2. **Progressive Disclosure** - Basic info first, details available deeper
3. **Practical** - Focus on actionable information
4. **Comprehensive** - Cover all aspects from beginner to advanced
5. **Maintainable** - Easy for contributors to add/update content
6. **Searchable** - Good structure and indexing for finding information

## Contributing to Documentation

To add or modify documentation:

1. Fork the repository
2. Create a new branch
3. Edit markdown files in `docs/` directory
4. Test locally with `mkdocs serve`
5. Submit pull request

See README.md for detailed contribution guidelines.

## Support and Questions

For questions about the documentation:
- Open an issue: https://github.com/Calculinux/docs/issues
- Discuss in forum: https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280

---

**Documentation framework created: October 6, 2025**
**Status: Ready for content development and community contributions**
