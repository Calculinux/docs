# Installation Guide

This guide covers how to install Calculinux on your PicoCalc with Luckfox Lyra
SBC.

## Overview

The installation process involves:

1. Obtaining the Calculinux image
2. Flashing it to a microSD card
3. Installing the Luckfox Lyra in your PicoCalc (if not already done)
4. Booting the system

## Prerequisites

Before starting, ensure you have:

- ✅ Luckfox Lyra SBC (installed in PicoCalc)
- ✅ MicroSD card (8GB minimum, 16GB+ recommended)
- ✅ SD card reader
- ✅ Computer (Linux, macOS, or Windows)
- ✅ Stable internet connection
- ✅ 1-2 GB free disk space for image download

## Step 1: Download Calculinux Image

### Official Releases

Download the latest Calculinux image from:

**GitHub Releases**:
[https://github.com/Calculinux/meta-calculinux/releases](https://github.com/Calculinux/meta-calculinux/releases)

Download the Calculinux image file:

| Image Name                                    | Description                      |
| --------------------------------------------- | -------------------------------- |
| `calculinux-image-luckfox-lyra.rootfs.wic.gz` | Complete Calculinux system image |

Additional files you may find:

| File Name                              | Description                                              |
| -------------------------------------- | -------------------------------------------------------- |
| `calculinux-bundle-luckfox-lyra.raucb` | RAUC update bundle (for updating existing installations) |
| `*.manifest`                           | Build manifest with package list                         |

!!! info "Single Image Design" Calculinux provides a single console-based image
suitable for all RAM configurations (64MB, 128MB, 256MB). Additional software
can be installed via the package manager as needed.

### Verify Download

After downloading, verify the image integrity:

```bash
# On Linux/macOS
sha256sum calculinux-*.wic.gz

# On Windows (PowerShell)
Get-FileHash calculinux-*.wic.gz -Algorithm SHA256
```

Compare with the SHA256 hash on the release page.

### Extract Image

If the image is compressed (`.xz`, `.gz`, `.zip`):

```bash
# Linux/macOS with xz
unxz calculinux-*.wic.gz

# Or using 7-Zip on any platform
7z x calculinux-*.wic.gz
```

## Step 2: Flash SD Card

!!! danger "Data Loss Warning" Flashing will **erase all data** on the SD card.
Make sure you've selected the correct device!

### Option A: Using Balena Etcher (Recommended for Beginners)

1. **Download Balena Etcher**:
   [https://www.balena.io/etcher/](https://www.balena.io/etcher/)
2. **Install and launch** Etcher
3. **Insert SD card** into card reader
4. In Etcher:
   - Click "Flash from file" and select Calculinux image
   - Click "Select target" and choose your SD card
   - Click "Flash!"
5. **Wait for completion** and verification

### Option B: Using dd (Linux/macOS)

!!! warning "Dangerous Command" Double-check the device name! Using the wrong
device will destroy your data.

```bash
# 1. Insert SD card and identify device
lsblk
# Look for your SD card (usually /dev/sdX or /dev/mmcblkN)

# 2. Unmount the device if mounted
sudo umount /dev/sdX*

# 3. Flash the image
sudo dd if=calculinux-*.wic of=/dev/sdX bs=4M status=progress conv=fsync

# 4. Sync to ensure all data is written
sync
```

### Option C: Using Rufus (Windows)

1. **Download Rufus**: [https://rufus.ie/](https://rufus.ie/)
2. **Launch Rufus** (may require admin rights)
3. **Insert SD card**
4. In Rufus:
   - Device: Select your SD card
   - Boot selection: Click "SELECT" and choose image
   - Partition scheme: MBR
   - File system: FAT32 (will be overwritten)
5. Click "START" and confirm

### Option D: Using Win32DiskImager (Windows)

1. **Download**:
   [Win32 Disk Imager](https://sourceforge.net/projects/win32diskimager/)
2. **Install and launch** as administrator
3. **Insert SD card**
4. In Win32DiskImager:
   - Select image file
   - Choose correct device
   - Click "Write"
5. **Wait for completion**

### Verify Flashing

After flashing:

```bash
# Linux/macOS - verify partition table
sudo fdisk -l /dev/sdX

# Should show multiple partitions:
# - Boot partition (FAT32)
# - Root filesystem (ext4)
```

## Step 3: Hardware Installation {#hardware-installation}

If you haven't already installed the Luckfox Lyra in your PicoCalc, follow the
[Hardware Modifications](../hardware/modifications.md) guide.

If your Luckfox Lyra has SPI NAND, you **must** erase it:

```bash
# See Hardware Modifications guide for detailed instructions
# Or Boot Problems troubleshooting page
```

Quick checklist:

- [ ] Luckfox Lyra installed in PicoCalc
- [ ] Connector properly seated
- [ ] SPI NAND erased (if present)
- [ ] Case reassembled
- [ ] SD card inserted in Luckfox Lyra

## Step 4: First Boot

1. **Insert the flashed SD card** into the Luckfox Lyra
2. **Connect USB-C power** (5V/2A minimum)
3. **Power on** the device

### What to Expect

**Initial boot timing**:

- First boot: 30-60 seconds
- Subsequent boots: 15-30 seconds

**Visual indicators**:

- Power LED should light up
- Display may show boot messages
- Initial splash screen
- Login prompt (console-only, no GUI)

### Boot Messages

You should see:

```
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 5.10.x-calculinux
...
[    5.234567] PicoCalc display initialized
[    5.345678] PicoCalc keyboard initialized
...

Calculinux GNU/Linux 1.0 picocalc ttyS0

picocalc login: _
```

!!! success "Success!" If you see a login prompt, congratulations! Calculinux is
running.

### Troubleshooting Boot Issues

If the system doesn't boot:

**No display activity**:

- Check power supply (try different cable/adapter)
- Verify SD card is inserted correctly
- See [Boot Problems](../troubleshooting/boot-problems.md)

**Boots but hangs**:

- Wait 2-3 minutes (first boot may take longer)
- Check SD card integrity
- Try reflashing the image

**Display shows errors**:

- Note the error messages
- Check [Troubleshooting](../troubleshooting/common-issues.md)
- Search forum for similar issues

## Step 5: Initial Login

After successful boot, you'll see a login prompt.

!!! info "Login Credentials" For default usernames and passwords, see the
[First Boot guide](first-boot.md#initial-login).

!!! danger "Change Passwords" Immediately change all default passwords after
first login. See
[First Boot - Initial Configuration](first-boot.md#initial-configuration).

## Post-Installation

After successful login, follow the [First Boot guide](first-boot.md) for:

1. Changing default passwords
2. Setting system time
3. Checking system status
4. Configuring network (if needed)
5. Updating package database

## Filesystem Expansion (Automatic)

!!! success "No Action Required" The overlayfs partition is **automatically
expanded** during first boot to use all available space on your SD card (leaving
10% free). No manual intervention is needed.

## Multiple SD Cards

You can create multiple SD cards for different purposes:

- **Development**: Full tools, larger packages
- **Production**: Minimal, stable release
- **Testing**: Experimental features
- **Backup**: Stable known-good configuration

Just flash different images or clone a working card:

```bash
# Clone a working SD card
sudo dd if=/dev/sdX of=backup.img bs=4M status=progress

# Later, restore it
sudo dd if=backup.img of=/dev/sdX bs=4M status=progress
```

## Pre-Installed Software

Calculinux comes with a console-based environment including:

### System Utilities

- **Shell**: bash, busybox
- **Editors**: vi, nano (via opkg)
- **Development**: gcc, g++, make, autoconf, git, gdb
- **Package Management**: opkg with online repositories

### Network Tools

- **WiFi**: iwd (iwctl command)
- **Utilities**: curl, wget, links (text browser), openssh
- **Debugging**: iw, htop, systemd-analyze

### System Management

- **Update System**: RAUC (A/B partition updates)
- **Storage**: e2fsprogs, mtd-utils, cloud-utils-growpart
- **Hardware**: i2c-tools, usbutils, android-tools

### Additional Features

- **Filesystem**: Overlayfs for read-only root with persistent overlay
- **Console Font**: Terminus font for better readability
- **Keyboard**: Full keyboard mapping support

!!! info "No GUI/Desktop" Calculinux is currently **console-only** with no
graphical desktop environment. All interaction is via text terminal. GUI support
may be added in future releases.

- File manager
- Basic applications

## Customization

After installation, you can customize your system:

- Install additional packages: See
  [Package Management](../user-guide/package-management.md)
- Set up development: See [Developer Guide](../developer/overview.md)
- Add applications: See [Applications](../user-guide/applications.md)

## Building Your Own Image

Instead of using pre-built images, you can build your own:

1. Follow [Yocto Setup](../developer/yocto-setup.md)
2. Customize configuration
3. Build image: [Building Calculinux](../developer/building.md)
4. Flash your custom image

## Updating Calculinux

To update an existing installation:

```bash
# Update package database
opkg update

# Upgrade all packages
opkg upgrade

# Or see Updates guide
```

See [Updates](../user-guide/updates.md) for detailed information.

## Backup Strategies

Protect your work:

### Full SD Card Backup

```bash
# Backup entire SD card
sudo dd if=/dev/sdX of=calculinux-backup.img bs=4M status=progress

# Compress to save space
gzip calculinux-backup.wic
```

### Filesystem Backup

```bash
# Backup home directory
tar czf home-backup.tar.gz /home

# Backup configuration
tar czf etc-backup.tar.gz /etc
```

## Common Installation Issues

### SD Card Not Recognized

- Try different card reader
- Test SD card on another device
- Format card first: `sudo mkfs.fat -F 32 /dev/sdX`

### Image Won't Flash

- Verify image integrity (checksum)
- Try different flashing tool
- Check SD card isn't write-protected

### Boot Loops

- SPI NAND not erased (most common)
- Corrupted image
- Faulty SD card
- Insufficient power

See [Troubleshooting](../troubleshooting/common-issues.md) for solutions.

## Next Steps

Now that Calculinux is installed:

- Continue to [First Boot](first-boot.md) guide
- Learn [Quick Start](quick-start.md) basics
- Explore [User Guide](../user-guide/basic-usage.md)

## Getting Help

If you encounter problems:

1. Check [Troubleshooting](../troubleshooting/common-issues.md)
2. Search
   [Forum](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280)
3. Ask in community chat
4. Open [GitHub issue](https://github.com/Calculinux/meta-calculinux/issues)

Include in your help request:

- Image variant and version
- SD card brand/size
- Luckfox Lyra version (RAM, NAND)
- Exact error messages
- What you've already tried
