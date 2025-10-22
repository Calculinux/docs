# Getting Started with Calculinux

Welcome to Calculinux! This guide will help you get started with your PicoCalc running Linux.

## Overview

Calculinux is a Linux distribution built specifically for the PicoCalc handheld computer with Luckfox Lyra SBC. This getting started guide will walk you through everything you need to know to set up and use Calculinux.

## What You'll Need

Before you begin, make sure you have:

- ✅ PicoCalc device
- ✅ Luckfox Lyra SBC (or compatible)
- ✅ MicroSD card (8GB minimum, 16GB+ recommended)
- ✅ SD card reader for your computer
- ✅ USB-C cable and power adapter (5V/2A minimum)
- ✅ Computer for flashing the SD card

Optional but helpful:
- USB-OTG adapter for peripherals
- USB keyboard (for easier initial setup)
- USB WiFi adapter (3.3V, see supported chipsets in [Hardware Compatibility](../hardware/compatibility.md))
- USB Ethernet adapter (for wired network connectivity)

## Quick Start Process

Here's the high-level process to get Calculinux running:

1. **[Check Hardware Requirements](hardware-requirements.md)** - Verify compatibility
2. **[Install Hardware](installation.md#hardware-installation)** (if needed) - Install Luckfox Lyra in PicoCalc
3. **[Flash SD Card](installation.md#flashing-the-image)** - Write Calculinux image to SD card
4. **[First Boot](first-boot.md)** - Power on and complete initial setup
5. **[Quick Start Guide](quick-start.md)** - Learn basic operations

## Time Requirements

- **Hardware Installation**: 30-60 minutes (if replacing SBC)
- **Image Flashing**: 5-15 minutes (depends on SD card)
- **First Boot**: 5-10 minutes
- **Initial Configuration**: 10-30 minutes

## Skill Level

This guide is written for users with basic to intermediate technical knowledge:

- **Basic**: You can follow written instructions and use a computer
- **Intermediate**: Comfortable with command-line interfaces
- **Advanced**: Hardware modifications and development

!!! tip "Don't worry!"
    Even if you're new to Linux or embedded systems, the guide provides detailed step-by-step instructions. Take your time and ask for help in the community if needed.

## Support Channels

If you need help:

- 📖 Check this documentation first
- 💬 [ClockworkPi Forum](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280) - Active community
- 🐛 [GitHub Issues](https://github.com/Calculinux/meta-calculinux/issues) - Bug reports
- 📧 Community Discord/Matrix (links in [Resources](../resources/community.md))

## What to Expect

### After Installation

Once Calculinux is running, you'll have:

- Full Linux operating system (console-based)
- Command-line terminal access via built-in display and keyboard
- Package manager (opkg) for installing software
- Development tools (gcc, g++, make, git, gdb, etc.)
- Network connectivity via WiFi or Ethernet (USB adapters required)
- Access to thousands of open-source command-line applications

### Limitations

Be aware of these limitations:

- **Console Only**: No graphical desktop environment (text-based interface)
- **Small Display**: 320×320 pixels (53×40 text), optimized for terminal use
- **RAM**: 64-256MB means careful resource management
- **Storage**: SD card speed affects performance
- **No Built-in Network**: Requires USB WiFi or Ethernet adapter (3.3V for WiFi)
- **Battery Life**: Running Linux uses more power than stock firmware

## Learning Path

### Beginners

1. Start with [Installation](installation.md)
2. Follow [First Boot](first-boot.md) guide
3. Learn [Quick Start Guide](quick-start.md)
4. Explore [Basic Usage](../user-guide/basic-usage.md)

### Intermediate Users

1. Review [Hardware Requirements](hardware-requirements.md)
2. Perform [Installation](installation.md)
3. Configure [Networking](../user-guide/networking.md)
4. Install [Applications](../user-guide/applications.md)

### Advanced Users/Developers

1. Check [Installation](installation.md) for base system
2. Review [Developer Guide](../developer/overview.md)
3. Set up [Yocto Build System](../developer/yocto-setup.md)
4. Start [Contributing](../developer/contributing.md)

## Documentation Structure

This documentation is organized into sections:

### Getting Started (You Are Here)
Everything needed to get Calculinux running

### Hardware
Physical device information, modifications, technical specs

### User Guide
Day-to-day usage, applications, configuration

### Developer Guide
Building, customizing, contributing to Calculinux

### Troubleshooting
Solutions to common problems and FAQ

### Resources
External links, tools, community information

## Before You Begin

### Important Warnings

!!! danger "Warranty"
    Installing Luckfox Lyra requires opening your PicoCalc and will void the warranty. Proceed at your own risk.

!!! warning "Data Loss"
    If you're replacing an existing system, back up any data first. The installation process will erase the SD card.

!!! caution "SPI NAND"
    If your Luckfox Lyra has SPI NAND flash, you **must** erase it first or the SD card will be ignored. See [Boot Problems](../troubleshooting/boot-problems.md#spi-nand-interference).

### Make a Backup Plan

If this is your first time:

- Keep the original PicoCalc board in case you want to revert
- Use a spare SD card for testing
- Join the community forum before starting
- Read through all documentation first

## Next Steps

Ready to proceed? Here's where to go next:

<div class="grid cards" markdown>

-   :material-check-decagram:{ .lg .middle } **Hardware Requirements**

    ---

    Verify you have compatible hardware

    [:octicons-arrow-right-24: Check Requirements](hardware-requirements.md)

-   :material-download:{ .lg .middle } **Installation Guide**

    ---

    Flash Calculinux to your SD card

    [:octicons-arrow-right-24: Install Now](installation.md)

-   :material-rocket-launch:{ .lg .middle } **First Boot**

    ---

    Power on and configure your system

    [:octicons-arrow-right-24: Boot Up](first-boot.md)

-   :material-book-open:{ .lg .middle } **Quick Start**

    ---

    Learn the basics quickly

    [:octicons-arrow-right-24: Quick Start](quick-start.md)

</div>

## Feedback

This documentation is continuously improving! If you find:

- Unclear instructions
- Missing information
- Errors or outdated content
- Suggestions for improvement

Please [open an issue](https://github.com/Calculinux/docs/issues) or submit a pull request!

---

Let's get started! Head to [Hardware Requirements](hardware-requirements.md) to begin.
