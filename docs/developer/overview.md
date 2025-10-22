# Developer Overview

Welcome to the Calculinux developer documentation! This section covers everything you need to know to build, customize, and contribute to Calculinux.

## What You'll Learn

This developer guide covers:

- Setting up the Yocto build environment
- Building Calculinux from source
- Customizing images and configurations
- Adding packages and applications
- Kernel and driver development
- Contributing to the project
- Release processes

## Who This Guide Is For

This guide is for:

- **Developers** wanting to build Calculinux from source
- **Contributors** interested in improving Calculinux
- **Customizers** needing specific configurations
- **Maintainers** managing their own distributions
- **Learners** exploring embedded Linux development

## Prerequisites

### Knowledge Requirements

You should be familiar with:

- **Linux command line** - Basic shell operations
- **Git** - Version control basics
- **Make/build systems** - Compilation processes
- **C/C++** (for kernel/driver work)
- **Python** (helpful for Yocto recipes)

### System Requirements

For building Calculinux, you need:

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| **OS** | Linux (Ubuntu 20.04+) | Linux (Ubuntu 22.04 LTS) |
| **CPU** | 4 cores | 8+ cores |
| **RAM** | 8 GB | 16+ GB |
| **Disk Space** | 50 GB | 100+ GB (SSD preferred) |
| **Internet** | Required | Fast connection |

!!! info "Why Linux?"
    While Yocto can run in VMs or containers on other OSes, native Linux is strongly recommended for performance and compatibility.

## Calculinux Architecture

### Overview

Calculinux is built using the **Yocto Project**, a powerful framework for creating custom Linux distributions.

```
Calculinux Architecture:

┌─────────────────────────────────────┐
│        Applications                 │
├─────────────────────────────────────┤
│     Desktop Environment (Optional)  │
├─────────────────────────────────────┤
│      Package Management (opkg)      │
├─────────────────────────────────────┤
│         System Libraries            │
├─────────────────────────────────────┤
│        Linux Kernel 5.10.x          │
├─────────────────────────────────────┤
│         U-Boot Bootloader           │
├─────────────────────────────────────┤
│    Hardware (Luckfox Lyra/RV1106)   │
└─────────────────────────────────────┘
```

### Key Components

**meta-calculinux**
- Main Yocto layer for Calculinux
- Machine configurations
- Custom recipes and patches
- Image definitions

**Linux Kernel**
- Based on Rockchip 5.10 kernel
- Custom drivers (display, keyboard)
- Device tree configurations
- Hardware support

**Bootloader**
- U-Boot for RV1106
- Boot scripts
- Device tree selection

**Userspace**
- Based on OpenEmbedded core
- Package management (opkg)
- System services (systemd)
- Optional desktop environments

## Repository Structure

### Main Repository

The meta-calculinux repository uses a multi-layer Yocto structure:

```
meta-calculinux/
├── meta-calculinux-distro/      # Distribution layer
│   ├── conf/distro/
│   │   └── calculinux-distro.conf
│   ├── recipes-bsp/
│   ├── recipes-connectivity/
│   ├── recipes-core/
│   │   ├── image/calculinux-image.bb
│   │   └── bundles/calculinux-bundle.bb
│   ├── recipes-extended/
│   └── recipes-support/
├── meta-picocalc-bsp-rockchip/  # Hardware BSP layer
│   ├── conf/machine/
│   │   └── luckfox-lyra.conf
│   ├── recipes-bsp/
│   │   └── u-boot/
│   └── recipes-kernel/
│       └── linux/linux-rockchip_6.1.bbappend
├── meta-calculinux-apps/        # Applications layer
│   ├── recipes-connectivity/
│   │   └── zerotier-one/
│   └── recipes-core/
│       └── packagegroups/
├── kas-luckfox-lyra-bundle.yaml # KAS build configuration
└── README.md
```

### External Dependencies

Calculinux uses external repositories for kernel and bootloader sources:

- **Kernel**: `github.com/0xd61/luckfox-linux-6.1-rk3506.git` (via linux-rockchip recipe)
- **Bootloader**: Provided by meta-rockchip layer
- **Documentation**: This repository (github.com/Calculinux/docs)

## Development Workflow

### Typical Development Process

1. **Set up environment** - Install dependencies, clone repos
2. **Configure build** - Select machine, distro, image
3. **Build image** - Run bitbake to compile everything
4. **Test on device** - Flash to SD card, boot, verify
5. **Iterate** - Make changes, rebuild, test again
6. **Submit changes** - Create pull request

### Build Types

**Full Build** (Clean)
- First build or major changes
- Builds everything from scratch
- Takes 2-8 hours depending on hardware
- Uses significant disk space

**Incremental Build**
- Rebuilds only changed components
- Much faster (minutes to hour)
- Used for development iterations

**Package Build**
- Builds specific packages
- Quick testing of changes
- Useful for recipe development

## Getting Started

### Quick Start for Developers

If you're ready to start developing:

1. [**Yocto Setup**](yocto-setup.md) - Install dependencies and configure environment
2. [**Building Calculinux**](building.md) - Compile your first image
3. [**Customization**](customization.md) - Tailor Calculinux to your needs
4. [**Adding Packages**](adding-packages.md) - Include new software

### Learning Path

**Beginner** (New to Yocto):
1. Read Yocto Project documentation
2. Follow our [Yocto Setup](yocto-setup.md) guide
3. Build a stock image
4. Make small customizations

**Intermediate** (Some Yocto experience):
1. Clone meta-calculinux
2. Customize image configurations
3. Add new packages/recipes
4. Modify existing recipes

**Advanced** (Experienced with Yocto):
1. Kernel development
2. Driver development
3. BSP modifications
4. Architecture contributions

## Development Tools

### Required Tools

Installed via package manager:

```bash
# Ubuntu/Debian
sudo apt install gawk wget git diffstat unzip texinfo \
    gcc build-essential chrpath socat cpio python3 \
    python3-pip python3-pexpect xz-utils debianutils \
    iputils-ping python3-git python3-jinja2 libegl1-mesa \
    libsdl1.2-dev pylint3 xterm python3-subunit mesa-common-dev \
    zstd liblz4-tool
```

### Helpful Tools

Development aids:

- **devtool** - Yocto development tool for recipes
- **bitbake** - Build engine
- **runqemu** - QEMU emulation (limited use for ARM)
- **oe-pkgdata-util** - Package data queries
- **bitbake-layers** - Layer management

### Editor Setup

Recommended editors with Yocto support:

- **VS Code** - With Yocto/BitBake extensions
- **Vim/Neovim** - With syntax highlighting
- **Emacs** - With bitbake-mode

## Build System Overview

### Yocto/OpenEmbedded

Calculinux uses Yocto for several reasons:

**Advantages**:
- ✅ Reproducible builds
- ✅ Extensive package ecosystem
- ✅ Professional tooling
- ✅ Active community
- ✅ Long-term support
- ✅ Customization flexibility

**Challenges**:
- ⚠️ Steep learning curve
- ⚠️ Long initial build times
- ⚠️ Large disk space requirements
- ⚠️ Complex dependency management

### BitBake

BitBake is the build engine:

- Task execution
- Dependency resolution
- Parallel builds
- Caching/reuse

### Recipes

Recipes define how to build packages:

```python
# Example recipe structure
SUMMARY = "Example package"
LICENSE = "MIT"
SRC_URI = "https://example.com/package.tar.gz"

do_compile() {
    # Compilation steps
}

do_install() {
    # Installation steps
}
```

## Common Development Tasks

### Adding a Package

```bash
# Create new recipe
devtool add <package-name> <source-url>

# Test build
devtool build <package-name>

# Create recipe
devtool finish <package-name> meta-calculinux
```

### Modifying Kernel

```bash
# Extract kernel source
bitbake linux-rockchip -c unpack

# Make changes
cd tmp/work/.../linux-rockchip/.../git

# Rebuild
bitbake linux-rockchip -c compile -f
```

### Creating Custom Image

```python
# recipes-core/images/calculinux-custom.bb
require calculinux-image.bb

IMAGE_INSTALL += "mypackage another-package"
```

## Testing & Validation

### Build Testing

```bash
# Build main image
bitbake calculinux-image

# Build update bundle
bitbake calculinux-bundle

# Verify package contents
oe-pkgdata-util list-pkgs
```

### Runtime Testing

1. Flash image to SD card
2. Boot on PicoCalc
3. Verify functionality
4. Check logs: `journalctl -b`
5. Test applications

### Automated Testing

Coming soon: CI/CD pipeline for automated builds and tests.

## Performance Optimization

### Build Speed

**Parallel Builds**:
```python
# local.conf
BB_NUMBER_THREADS = "8"
PARALLEL_MAKE = "-j 8"
```

**Shared State Cache**:
```python
SSTATE_DIR = "/path/to/shared/sstate-cache"
```

**Build History**:
```python
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT = "1"
```

### Image Size

Optimize for small SD cards:

```python
# Remove documentation
IMAGE_FEATURES_remove = "doc-pkgs"

# Remove development files
IMAGE_FEATURES_remove = "dev-pkgs"

# Minimize locales
IMAGE_LINGUAS = "en-us"
```

## Debugging

### Build Failures

```bash
# Verbose output
bitbake -v calculinux-image

# Debug specific task
bitbake -c devshell <package>

# Clean and rebuild
bitbake -c cleansstate <package>
bitbake <package>
```

### Runtime Debugging

```bash
# Serial console
screen /dev/ttyUSB0 115200

# SSH access
ssh root@<ip-address>

# System logs
journalctl -f
```

## Contributing

We welcome contributions! See [Contributing Guide](contributing.md) for:

- Code style guidelines
- Submission process
- Review process
- Community standards

## Resources

### Official Documentation

- **Yocto Project**: [https://www.yoctoproject.org/docs/](https://www.yoctoproject.org/docs/)
- **OpenEmbedded**: [https://www.openembedded.org/](https://www.openembedded.org/)
- **BitBake Manual**: [https://docs.yoctoproject.org/bitbake/](https://docs.yoctoproject.org/bitbake/)

### Calculinux Specific

- **Repository**: [https://github.com/Calculinux/meta-calculinux](https://github.com/Calculinux/meta-calculinux)
- **Issues**: [GitHub Issues](https://github.com/Calculinux/meta-calculinux/issues)
- **Discussions**: [Forum Thread](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280)

### Learning Resources

- Yocto Project Quick Start
- Yocto Project Mega-Manual
- OpenEmbedded User Manual
- Linux From Scratch (background)

## Next Steps

Choose your path:

<div class="grid cards" markdown>

-   :material-cog:{ .lg .middle } **Set Up Environment**

    ---

    Install tools and configure Yocto

    [:octicons-arrow-right-24: Yocto Setup](yocto-setup.md)

-   :material-hammer-wrench:{ .lg .middle } **Build Calculinux**

    ---

    Compile your first image

    [:octicons-arrow-right-24: Building Guide](building.md)

-   :material-palette:{ .lg .middle } **Customize**

    ---

    Make Calculinux your own

    [:octicons-arrow-right-24: Customization](customization.md)

-   :material-code-braces:{ .lg .middle } **Contribute**

    ---

    Join the development effort

    [:octicons-arrow-right-24: Contributing](contributing.md)

</div>
