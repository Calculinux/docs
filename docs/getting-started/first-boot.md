# First Boot

Guide for the first boot and initial configuration of Calculinux.

## Booting for the First Time

After flashing your SD card and installing hardware:

1. **Insert SD card** into Luckfox Lyra
2. **Connect USB-C power** (5V/2A minimum)
3. **Wait for boot** (30-60 seconds first time)

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

```
Username: root
Password: root
```

!!! danger "Change Password Immediately"
    The first thing you should do after logging in is change the root password:
    ```bash
    passwd
    ```

## Initial Configuration

### 1. Change Root Password

```bash
passwd
# Enter new password twice
```

### 2. Set System Time

```bash
# Set current date/time
date -s "2025-10-06 14:30:00"

# Or use NTP if network connected
ntpd -q -p pool.ntp.org
```

### 3. Check System Status

```bash
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

```bash
opkg update
```

## Basic System Check

### Verify Hardware

```bash
# Check display
ls -l /dev/fb0
cat /dev/urandom > /dev/fb0  # Should show random colors

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
- USB WiFi adapters (see WiFi chipsets above)

**Planned/Future Support:**
- I2C RTC modules (e.g., Adafruit DS3231)
- LoRa radio modules (e.g., Waveshare Core1262-868M for Meshtastic)
- Additional I2C/SPI peripherals

!!! note "Peripheral Testing"
    Most peripheral support beyond WiFi, display, and keyboard has not been thoroughly tested yet. Community contributions for additional hardware support are welcome!

### Check Logs

```bash
# Boot messages
dmesg | less

# System journal
journalctl -b
```

## Network Configuration

### WiFi Setup (USB Adapter Required)

!!! info "WiFi Hardware Required"
    Neither the PicoCalc nor Luckfox Lyra include built-in WiFi. You need a **USB WiFi adapter operating at 3.3V** connected to the USB header on the Lyra.

**Supported WiFi Chipsets:**

Calculinux includes drivers for the following Realtek chipsets:

- RTL8723DU
- RTL8812AU
- RTL8814AU
- RTL8821CU
- RTL88X2BU

#### Connecting to WiFi with iwctl

Calculinux uses `iwd` (iNet Wireless Daemon) for WiFi management. Use `iwctl` to configure wireless connections:

```bash
# Start iwctl interactive mode
iwctl

# Inside iwctl:
[iwd]# device list                          # List wireless devices
[iwd]# station wlan0 scan                   # Scan for networks
[iwd]# station wlan0 get-networks           # Show available networks
[iwd]# station wlan0 connect "SSID"         # Connect to network
# Enter passphrase when prompted
[iwd]# exit

# Or use iwctl non-interactively:
iwctl station wlan0 scan
iwctl station wlan0 get-networks
iwctl station wlan0 connect "YourSSID"
```

**Verify Connection:**

```bash
# Check connection status
iwctl station wlan0 show

# Check IP address
ip addr show wlan0

# Test connectivity
ping -c 3 8.8.8.8
```

**Disconnect:**

```bash
iwctl station wlan0 disconnect
```

## Next Steps

After initial setup:

- Follow [Quick Start Guide](quick-start.md)
- Learn [Basic Usage](../user-guide/basic-usage.md)
- Install [Applications](../user-guide/applications.md)

## Troubleshooting First Boot

### No Display

- Wait 2-3 minutes
- Check power supply
- Verify SD card inserted correctly
- See [Boot Problems](../troubleshooting/boot-problems.md)

### Boot Hangs

- SPI NAND not erased (most common)
- Corrupt SD card
- Insufficient power
- See [Troubleshooting](../troubleshooting/common-issues.md)

### Cannot Login

- Verify correct username: `root`
- Verify correct password: `calculinux`
- Try different keyboard
- Check keyboard driver in logs

## Getting Help

- Check [Troubleshooting](../troubleshooting/faq.md)
- Visit [Community Forum](../resources/community.md)
- Open [GitHub Issue](https://github.com/Calculinux/meta-calculinux/issues)
