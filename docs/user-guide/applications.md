# Applications

!!! warning "Under Construction"
    This page is currently being developed. Check back soon for application guides.

## Pre-installed applications
All Calculinux images come with at least these basic pre-installed packages. Some include directly usable applications, but most are the basic building blocks of a functional system:
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
### For a more thourough explinations go [here](package-management.md)

Calculinux uses **opkg** (Open Package Management) as the package manager. Below, you will find a basic guide on how to install applications using opkg:

```    
    opkg update
    opkg install package_name
```
    
This, first checks the main package list by using *opkg update* to see if any new packages have been added or if any existing packages have been updated. Then, the *opkg install package_name* command will make opkg look for *package_name* in the list of available packages, and attempt to install it, if all dependancies are available.

##### A dependency for a package in linux, is another package required for it to function properly or install successfully.

### Common opkg Package Installation Options
| Option                | Description                                                                                                                                               |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| **-l**                | This option lists all available packages. It can be used to view a summary of packages that can be installed, updated, or removed.                       |
| **--force-reinstall** | Forces the reinstallation of a package even if it's already installed. Useful for ensuring that you have the latest version of a package.                  |
| **--no-cache**        | Disables caching during the installation process. This is useful when you want to ensure that the installation process always retrieves packages directly from the repository, rather than a local cache. |
| **-d**                | This option allows for installing a package without dependencies. Use this with caution, as it might lead to an unstable configuration.                      |

### Example Usage of opkg Package Installation Options/Arguements
```opkg
opkg list-installed
opkg list-installed | grep <package-name> # Searches Filter
opkg install --force-reinstall package-name
opkg install --no-cache package-name
opkg install -d package-name
opkg search package-name # Searches for that package
```
If you want to refer to the list of all available packages please refer to: [Available Packages](https://opkg.calculinux.org/ipk/walnascar/continuous/cortexa7t2hf-neon-vfpv4/)

## Popular Application Recommendations
The following table with a selected list of 15 popular linux applications is based on the author's opinion:
| Name       | Basic description | Where to find documentation |
|-----------|--------------------|-----------------------------|
| vim       | Modal text editor widely used for code and config editing on Unix-like systems. | Project site (vim.org) and `:help` inside Vim. |
| nano      | Simple, beginner-friendly terminal text editor. | `man nano` and nano-editor.org. |
| wget      | Non-interactive command-line downloader supporting HTTP, HTTPS, and FTP. | `man wget` and GNU Wget manual (gnu.org). |
| curl      | Versatile tool to transfer data with URLs over many protocols (HTTP, HTTPS, FTP, etc.). | `man curl` and curl.se/docs. |
| git       | Distributed version control system for tracking changes in source code. | `git help <command>` and git-scm.com/docs. |
| bash      | Widely used Unix shell and command language. | `man bash` and GNU Bash Reference Manual. |
| mc        | Text-mode file manager (Midnight Commander) with panels and built-in viewers/editors. | `man mc` and midnight-commander.org documentation. |
| htop      | Interactive process viewer and system monitor for the terminal. | `man htop` and htop.dev documentation. |
| tmux      | Terminal multiplexer to manage multiple terminal sessions in one window. | `man tmux` and tmux.github.io. |
| openssh   | Tools for secure remote login and file transfer (ssh, scp, sftp, sshd). | `man ssh`, `man sshd`, and openssh.com/manual.html. |
| rsync     | Fast incremental file transfer and synchronization utility. | `man rsync` and rsync.samba.org documentation. |
| tar       | Standard archiving tool to create and extract tar archives. | `man tar` and GNU Tar manual. |
| grep      | Searches text using regular expressions, often used in pipelines. | `man grep` and GNU Grep manual. |
| sed       | Stream editor for filtering and transforming text. | `man sed` and GNU Sed manual. |
| python3   | Popular high-level programming language interpreter. | `python3 -m pydoc` and docs.python.org. |


## Coming Soon

This section will cover:
- Application configuration
- Troubleshooting applications

---
