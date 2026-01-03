# Applications

!!! warning "Under Construction"
    This page is currently being developed. Check back soon for application guides.

## Pre-installed applications
All calculinux images will come with at least these basic 57 pre-installed applications (but they are less of applications, and more of a system package):
| Package | Basic description |
|-------|-------------------|
| acpid | Handles ACPI events such as power button presses and lid switches. |
| alsa-lib | Core user-space library for the ALSA sound system. |
| alsa-plugins | Additional ALSA audio plugins (mixing, routing, etc.). |
| alsa-tools | Low-level tools for configuring and debugging ALSA audio hardware. |
| alsa-utils | Common ALSA utilities like `alsamixer` and `aplay`. |
| android-tools | Utilities for interacting with Android devices (adb, fastboot). |
| autoconf | Tool for generating portable `configure` scripts for building software. |
| bash | Primary interactive shell for command-line use and scripting. |
| bash-completion | Tab-completion support for many shell commands. |
| btrfs-tools | Utilities for managing and maintaining Btrfs filesystems. |
| busybox | Lightweight collection of essential Unix command-line utilities. |
| calculinux-update | Calculinux-specific system update tooling. |
| cloud-utils-growpart | Tool to automatically expand disk partitions in cloud images. |
| curl | Command-line tool for transferring data over network protocols. |
| dosfstools | Utilities for creating and checking FAT filesystems. |
| e2fsprogs | Tools for creating, checking, and repairing ext2/3/4 filesystems. |
| e2fsprogs-resize2fs | Utility for resizing ext filesystems. |
| file | Detects file types by inspecting their contents. |
| gdb | GNU debugger for debugging applications and binaries. |
| git | Distributed version control system for managing source code and files. |
| grep | Tool for searching text using regular expressions. |
| groff | Document formatting system used for man pages and text output. |
| hoard-of-bitfonts-commodore | Retro-style bitmap console fonts inspired by Commodore systems. |
| htop | Interactive process viewer and system monitor. |
| i2c-tools | Utilities for interacting with I²C devices and buses. |
| iw | Command-line tool for configuring wireless network devices. |
| iwd | Modern wireless daemon for managing Wi-Fi connections. |
| kbd-consolefonts | Bitmap fonts for Linux virtual consoles. |
| kbd-keymaps | Keyboard layout definitions for console input. |
| kernel-modules | Hardware drivers and kernel extensions needed for device support. |
| libdrm-tests | Test programs for Direct Rendering Manager graphics support. |
| libsdl | SDL 1.x library for multimedia and graphics applications. |
| libsdl2 | SDL 2.x library for multimedia, input, and graphics applications. |
| freetype | Font rendering library used by many graphical applications. |
| links | Text-based web browser for terminal use. |
| man-db | System for viewing and managing manual (man) pages. |
| mtd-utils | Tools for managing raw flash memory devices (MTD). |
| musl-locales | Locale data for systems using the musl C library. |
| notcurses | Library for building rich text-based user interfaces in terminals. |
| notcurses-tools | Demo and utility programs for notcurses. |
| ntp | Synchronizes system time with network time servers. |
| oldschool-console-fonts | Collection of classic-style console fonts. |
| openssh | Secure remote login, command execution, and file transfer tools. |
| opkg | Lightweight package manager for installing and updating software. |
| overlayfs-tools | Utilities for managing OverlayFS-based filesystems. |
| packagegroup-core-buildessential | Meta-package providing essential build tools (compiler, make, etc.). |
| rauc | Robust update framework for embedded Linux systems. |
| sdl2-test | Test and example programs for SDL2. |
| shadow | User and password management utilities. |
| sudo | Allows users to run commands with elevated privileges. |
| systemd-analyze | Tools for analyzing system boot performance and state. |
| terminus-font | Popular, readable fixed-width console font. |
| u-boot-fw-config | Firmware configuration support for U-Boot bootloader. |
| u-boot-rockchip-bootscript | Boot scripts for Rockchip-based systems using U-Boot. |
| usbutils | Utilities for inspecting USB devices (e.g., `lsusb`). |
| util-linux | Core system utilities for disk, mount, login, and system management. |
| wget | Command-line utility for downloading files over HTTP/HTTPS/FTP. |

## Installing new applications
### THIS SECTION IS EXPLAINED BETTER: [here](package-management.md)

Calculinux uses **opkg** (Open Package Management) as the package manager. Below, you will find a basic guide on how to install applications using opkg:

```    
    opkg update
    opkg install package_name
```
    
This, first checks the main package list by using *opkg update* to see if any new packages have been added or if any existing packages have been updated. Then, the *opkg install package_name* command will make opkg look for *package_name* in the list of available packages, and attempt to install it, if all dependancies are available.

When you try to install a package using opkg without all the required dependencies, you may see an error message like *pkg_hash_check_unresolved: cannot find dependency <dependency_name> for <package_name>.* This indicates that the installation cannot proceed because the necessary dependencies are missing.

##### A dependency for a package in linux, is another package required for it to function properly or install successfully.

### Common opkg Package Installation Options
| Option                | Description                                                                                                                                               |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| **-k**                | This option is used to skip the integrity check of the packages during installation. It's helpful when dealing with local packages where you trust the source. |
| **-l**                | This option lists all available packages. It can be used to view a summary of packages that can be installed, updated, or removed.                       |
| **--force-reinstall** | Forces the reinstallation of a package even if it's already installed. Useful for ensuring that you have the latest version of a package.                  |
| **--no-cache**        | Disables caching during the installation process. This is useful when you want to ensure that the installation process always retrieves packages directly from the repository, rather than a local cache. |
| **-d**                | This option allows for installing a package without dependencies. Use this with caution, as it might lead to an unstable configuration.                      |
| **--dest**            | Specifies an alternate installation destination. This can be handy if you want to install a package in a specific location on your filesystem.            |

### Example Usage of opkg Package Installation Options/Arguements
```opkg
opkg install -k package-name
opkg list-installed
opkg list-installed | grep <package-name> # Searches Filter
opkg install --force-reinstall package-name
opkg install --no-cache package-name
opkg install -d package-name
opkg install --dest /desired/path package-name
```
If you want to refer to the list of all available packages please refer to: [Available Packages](https://opkg.calculinux.org/ipk/walnascar/continuous/cortexa7t2hf-neon-vfpv4/)

## Coming Soon

This section will cover:
- Popular application recommendations
- Application configuration
- Troubleshooting applications

---
