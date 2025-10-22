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

### 4. Expand Filesystem (Optional)

!!! warning "Script Location Needs Verification"
    The expand-filesystem.sh script location needs verification. The system includes `cloud-utils-growpart` package with the `growpart` utility.

If using SD card larger than image size, you can expand the root partition:

```bash
# Using growpart (installed by default)
growpart /dev/mmcblk1 2  # Expand partition 2
resize2fs /dev/mmcblk1p2  # Resize filesystem

# Alternative: check for expand-filesystem.sh
if [ -f /usr/sbin/expand-filesystem.sh ]; then
    /usr/sbin/expand-filesystem.sh
fi
```

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
```

### Check Logs

```bash
# Boot messages
dmesg | less

# System journal
journalctl -b
```

## Network Configuration

!!! warning "Network Commands Need Verification"
    The network configuration method should be verified. Calculinux uses systemd-networkd and may not use udhcpc as shown below.

### Via Ethernet

```bash
# Check interface status
ip addr show
networkctl status

# DHCP is typically configured automatically via systemd-networkd
# Manual DHCP request (if using busybox udhcpc):
# udhcpc -i eth0

# Static IP (temporary)
ip addr add 192.168.1.100/24 dev eth0
ip route add default via 192.168.1.1
echo "nameserver 8.8.8.8" > /etc/resolv.conf
```

For persistent network configuration, edit systemd-networkd files in `/etc/systemd/network/`.

See [Networking Guide](../user-guide/networking.md) for details (page in development).

## Next Steps

After initial setup:

- Follow [Quick Start Guide](quick-start.md)
- Learn [Basic Usage](../user-guide/basic-usage.md)
- Configure [Desktop Environment](../user-guide/desktop.md) (if using GUI image)
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
