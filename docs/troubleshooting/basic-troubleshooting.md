# Basic Troubleshooting

Start here for quick checks and common fixes before diving into specialized guides.

## Quick Diagnostics

Run these basic checks to capture system state:

```shell
# Check system info
uname -a
cat /proc/cpuinfo | grep -i "model name"
free -h

# Check disk space
df -h

# Check boot messages
dmesg | less

# Check system logs
journalctl -b
```

## Most Common Issues

### System Won't Boot

**Symptoms**: No display activity, device appears dead

**Possible causes**:

1. SPI NAND not erased (most common with NAND versions)
2. Corrupt SD card image
3. SD card not inserted properly
4. Insufficient power supply
5. Hardware connection issue

**Next steps**:

- See [Common Issues](common-issues.md#boot-problems) for detailed troubleshooting
- Verify SPI NAND was erased: [Erasing SPI NAND](erase-nand.md)
- Try a different power supply (5V/2A minimum)
- Reflash the SD card
- Reseat hardware connections

### Display Not Working

**Symptoms**: System boots but display stays blank

**Quick checks**:

!!! info When the keyboard or display isn't working, you can still run commands and see output through the serial console!

    The Picocalc includes a USB to serial converter, and Calculinux runs a login shell on the connected serial port. See [Console Access](hardware/serial/console-access.md) for details on accessing it. You can use this for running commands when your keyboard is not working, seeing output when the display is not working, or troubleshooting early boot issues.

```shell
# Check if framebuffer exists
ls -l /dev/fb0

# Test display with color pattern
cat /dev/urandom > /dev/fb0

# Check display driver
dmesg | grep -i display
lsmod | grep fb
```

See [Common Issues](common-issues.md#display-issues) for additional fixes.

### Keyboard Not Responding

**Symptoms**: Cannot type or keys don't register

**Quick checks**:

!!! info When the keyboard or display isn't working, you can still run commands and see output through the serial console!

    The Picocalc includes a USB to serial converter, and Calculinux runs a login shell on the connected serial port. See [Console Access](hardware/serial/console-access.md) for details on accessing it. You can use this for running commands when your keyboard is not working, seeing output when the display is not working, or troubleshooting early boot issues.

```shell
# Check input devices
cat /proc/bus/input/devices

# Test keyboard
evtest /dev/input/event0

# Check driver
dmesg | grep -i keyboard
```

See [Common Issues](common-issues.md#input-issues) for additional fixes.

### Network Not Working

**Symptoms**: Cannot connect to a network

**Quick checks**:

```shell
# Check interfaces
ip link

# Check connectivity
ping 8.8.8.8

# Check DNS
cat /etc/resolv.conf
```

See [Network Issues](network.md) for solutions.

### Out of Space

**Symptoms**: "No space left on device" errors

**Quick checks**:

```shell
# Check disk usage
df -h

# Find large files
du -h /home | sort -h | tail -20

# Clean package cache
opkg clean
```

Note: Filesystem expansion is handled automatically by the pre-init script. No manual intervention is required for SD card expansion.

### System Running Slow

**Possible causes**:

- Insufficient RAM
- Slow SD card
- Too many services running
- Swap thrashing

**Quick checks**:

```shell
# Check memory
free -h

# Check swap
swapon --show

# Check running processes
htop  # or top

# Disable unnecessary services
systemctl list-unit-files --state=enabled
systemctl disable <service-name>
```

## Error Messages

### Common Error Messages and Solutions

| Error Message | Cause | Solution |
|---------------|-------|----------|
| "Kernel panic - not syncing" | Corrupt kernel or bad device tree | Reflash SD card, verify image |
| "No space left on device" | Disk full | Clean cache, remove large files |
| "Out of memory" | RAM exhausted | Close apps, disable services, reduce memory use |
| "Cannot allocate memory" | Memory fragmentation | Reboot, reduce memory usage |
| "Unable to mount root fs" | Bad SD card or partition | Check SD card, reflash |
| "Timeout waiting for device" | Hardware not detected | Check connections, verify device tree |

## Getting More Help

If you can’t find a solution here:

### Information to Include

When asking for help, provide:

1. **Hardware**: Luckfox Lyra version (RAM, NAND), SD card brand/size
2. **Software**: Calculinux version/image variant
3. **Error messages**: Exact text of errors
4. **What you tried**: Steps you’ve already taken
5. **Logs**: Relevant portions of `dmesg` or `journalctl`

### Where to Ask

- **Documentation**: Check specific troubleshooting pages
- **Discord Community**: [Join our Discord](https://discord.gg/7quBbSPxcP)
- **Forum**: [ClockworkPi Forum Thread](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280)
- **GitHub**: [Issue Tracker](https://github.com/Calculinux/meta-calculinux/issues)
- **Community**: Links in [Resources](../resources/community.md)

## Still Stuck?

### Debug Mode Boot

Boot with more verbose output:

```shell
# Edit boot command in U-Boot
# Add to kernel command line:
loglevel=7 debug
```

### Serial Console

Connect via serial for full boot output:

```shell
# From another computer
screen /dev/ttyUSB0 1500000
```

### Safe Mode

Boot to minimal system:

```shell
# Connect with a serial cable, then reboot.
# In U-Boot, add to kernel command line:
single
```

This boots to single-user mode for recovery.

## Next Steps

- [Common Issues](common-issues.md)
- [Network Issues](network.md)
- [Erasing SPI NAND](erase-nand.md)
- [Troubleshooting & FAQ](faq.md)
