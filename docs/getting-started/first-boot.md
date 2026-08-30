# First Boot

Guide for the first boot and initial configuration of Calculinux.

## Booting for the First Time

After flashing your SD card and installing hardware:

1. **Insert SD card** into Luckfox Lyra
2. **Connect USB-C power** (5V/2A minimum)
3. **Wait for boot** (30-60 seconds first time)

!!! warning "Remove external SD card on first boot"
    Leave the PicoCalc external SD card slot **empty** during the first boot. External cards with duplicate partition labels (such as `OVERLAY_DATA`, `ROOT_A`, or `ROOT_B`) can cause overlayfs to fail and leave the system read-only.

    Once the first boot completes successfully, you’ll have a clean baseline so any read-only behavior after inserting an external card is easier to attribute to partition label conflicts.

    See:
    - [Common Issues - System Read-Only / Overlayfs Failure](../troubleshooting/common-issues.md#system-read-only--overlayfs-failure)
    - [Basic Troubleshooting](../troubleshooting/basic-troubleshooting.md)
    - [Advanced Storage Configuration](../user-guide/advanced-storage.md)

### What to Expect

**Boot Process**:

- Power LED lights up
- Boot messages appear on display
- System initialization
- Login prompt appears

**First Boot Timing**:

- First boot: 30-60 seconds
- Subsequent boots: 15-30 seconds

## Initial Login

### Default Credentials

```shell
Username: root
Password: root
```

!!! danger "Change Password Immediately"
    The first thing you should do after logging in is change the root password:
    ```shell
    passwd
    ```

## Initial Configuration

### 1. Change Root Password

```shell
passwd
# Enter new password twice
```

### 2. Set System Time

The system clock can be set manually or will sync automatically via NTP when network is available:

```shell
# Set manually if no network connection
date -s "2025-10-06 14:30:00"

# Verify current time
date
```

!!! info "Automatic Time Sync"
    If you have an active network connection (USB networking or WiFi), `ntpd` runs automatically in the background and will sync the system time. No manual intervention is needed.

### 3. Check System Status

```shell
# Check system info
uname -a

# Check memory
free -h

# Check disk space
df -h

# Check running services
systemctl status
```

### 4. Filesystem Expansion (Automatic)

!!! success "Automatic Expansion"
    The overlayfs partition is **automatically expanded** during the pre-init process on first boot. The system uses `growpart` to expand the overlay partition to fill available disk space, leaving 10% free. No manual intervention is required.

### 5. Update Package Database

```shell
opkg update
```

## Basic System Check

### Verify Hardware

```shell
# Check display device exists
ls -l /dev/fb0

# Test display with SDL2 test utility
sdl2-test
# Press SPACE or ENTER to cycle through test patterns
# Press ESC to exit

# Check keyboard
cat /proc/bus/input/devices

# Check CPU
cat /proc/cpuinfo

# Check USB WiFi adapter (if connected)
lsusb
ip link show
```

### Supported Peripherals

!!! info "Hardware Expansion"
    The PicoCalc and Luckfox Lyra do not include WiFi or many peripherals by default. Hardware can be added via USB, I2C, SPI, and GPIO headers.

**Currently Tested:**

- Display (built-in LCD drivers)
- Keyboard (built-in keyboard drivers)
- USB WiFi adapters (see **[Networking & WiFi Compatibility](../hardware/compatibility/networking-wifi.md)**)

**Planned/Future Support:**

- I2C RTC modules (e.g., Adafruit DS3231)
- LoRa radio modules (e.g., Waveshare Core1262-868M for Meshtastic)
- Additional I2C/SPI peripherals

!!! note "Peripheral Testing"
    Most peripheral support beyond WiFi, display, and keyboard has not been thoroughly tested yet. Community contributions for additional hardware support are welcome!

### Check Logs

```shell
# Boot messages
dmesg | less

# System journal
journalctl -b
```

## Network Configuration

You have two primary options for network connectivity:

1. **USB Networking** - Direct connection to your computer (recommended for initial setup)
2. **WiFi** - Requires USB WiFi adapter

### USB Networking

USB networking is the easiest way to get started with Calculinux. Simply connect the Lyra's USB-C port to your computer, and the device will appear as a USB Ethernet adapter.

!!! tip "Quick USB Setup"
    1. Connect Lyra's USB-C port to your computer
    2. Wait 10-15 seconds for the USB gadget to enumerate
    3. SSH to the PicoCalc:

    ```shell
    ssh pico@192.168.7.2
    # Password: calc
    ```

    See the [USB Networking Guide](../user-guide/usb-networking.md) for complete setup instructions including:

    - Internet sharing configuration
    - USB serial console access
    - Advanced configuration options

!!! warning "macOS Users"
    The default USB gadget protocol is **RNDIS**, which works on Windows and Linux. macOS needs **ECM** instead — see [USB Networking](../user-guide/usb-networking.md#switching-protocols).

**What you get with USB networking:**

- ✅ Fast, reliable connection
- ✅ No additional hardware required
- ✅ Works on Windows and Linux out-of-the-box (RNDIS)
- ✅ macOS via ECM (`usb-modeswitch --protocol ecm`)
- ✅ Static IP (`192.168.7.2`) always available
- ✅ DHCP support for internet sharing
- ✅ USB serial console at 1500000 baud
- ✅ SSH over USB (no ADB required)

### WiFi Setup (USB Adapter Required)

!!! info "WiFi Hardware Required"
    Neither the PicoCalc nor Luckfox Lyra include built-in WiFi. You need a **USB WiFi adapter operating at 3.3V** connected to the Lyra's USB header.

    For a complete list of supported WiFi chipsets and tested adapters, see **[Networking & WiFi Compatibility](../hardware/compatibility/networking-wifi.md)**.

#### Connecting to WiFi with uwific

Calculinux uses `iwd` for WiFi management. The included TUI is `uwific`:

```shell
uwific
```

Scan results appear in the TUI. Highlight a network, press **Enter**, and type the passphrase if asked. **D** disconnects, **Q** quits.

Known networks reconnect on later boots. For keys, multiple adapters, and the `iwctl` command-line alternative, see the [WiFi guide](../user-guide/wifi.md).

**Verify Connection:**

```shell
ip addr show wlan0
ping -c 3 8.8.8.8
```

## Next Steps

After initial setup:

- Follow [Quick Start Guide](quick-start.md)
- Learn [Basic Usage](../user-guide/basic-usage.md)
- Install [Applications](../user-guide/applications.md)

## Troubleshooting First Boot

### No Display or Boot Hangs

**Most common first-boot issue**: Wait 2-3 minutes. The first boot takes longer as the overlay partition is automatically expanded to use available disk space.

If problems persist after waiting, see [Troubleshooting - Common Issues](../troubleshooting/common-issues.md) for:

- Display initialization problems
- SPI NAND interference
- SD card issues
- Login problems
- Other boot issues

## Getting Help

- Check [Troubleshooting](../troubleshooting/faq.md)
- Visit [Community Forum](../resources/community.md)
- Open [GitHub Issue](https://github.com/Calculinux/meta-calculinux/issues)
