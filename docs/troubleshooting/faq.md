# Troubleshooting & FAQ

Common issues and frequently asked questions about Calculinux.

## Quick Diagnostics

Before diving into specific issues, run these basic checks:

```bash
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

### Issue: System Won't Boot

**Symptoms**: No display activity, device appears dead

**Possible Causes**:

1. SPI NAND not erased (most common with NAND versions)
2. Corrupt SD card image
3. SD card not inserted properly
4. Insufficient power supply
5. Hardware connection issue

**Solutions**:

- See [Boot Problems](boot-problems.md#system-wont-boot) for detailed
  troubleshooting
- Verify SPI NAND was erased:
  [NAND Erasing Guide](../hardware/modifications.md#erasing-spi-nand)
- Try different power supply (5V/2A minimum)
- Reflash SD card
- Reseat hardware connections

### Issue: Display Not Working

**Symptoms**: System boots but display stays blank

**Quick Fixes**:

```bash
# Check if framebuffer exists
ls -l /dev/fb0

# Test display with color pattern
cat /dev/urandom > /dev/fb0

# Check display driver
dmesg | grep -i display
lsmod | grep fb
```

See [Display Issues](display.md) for more details.

### Issue: Keyboard Not Responding

**Symptoms**: Cannot type or keys don't register

**Quick Fixes**:

```bash
# Check input devices
cat /proc/bus/input/devices

# Test keyboard
evtest /dev/input/event0

# Check driver
dmesg | grep -i keyboard
```

See [Input Problems](input.md) for more details.

### Issue: Network Not Working

**Symptoms**: Cannot connect to network

**Quick Check**:

```bash
# Check interfaces
ip link

# Check connectivity
ping 8.8.8.8

# Check DNS
cat /etc/resolv.conf
```

See [Network Issues](network.md) for solutions.

### Issue: Out of Space

**Symptoms**: "No space left on device" errors

**Solution**:

```bash
# Check disk usage
df -h

# Find large files
du -h /home | sort -h | tail -20

# Clean package cache
opkg clean

# Note: Filesystem expansion is handled automatically by the pre-init script
# No manual intervention required for SD card expansion
```

### Issue: System Running Slow

**Possible Causes**:

- Insufficient RAM
- Slow SD card
- Too many services running
- Swap thrashing

**Solutions**:

```bash
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

## Frequently Asked Questions

### General Questions

**Q: What is Calculinux?**

A: Calculinux is a Linux distribution built specifically for the PicoCalc
handheld computer when equipped with a Luckfox Lyra or compatible SBC. It
provides a full Linux environment in a pocket-sized device.

**Q: Is this the same as the stock PicoCalc firmware?**

A: No. The stock PicoCalc uses a Raspberry Pi Pico running **PicoMite MMBasic**
firmware. Calculinux requires replacing this with a Luckfox Lyra SBC to run full
Linux.

**Q: Will this void my warranty?**

A: Yes. Opening the PicoCalc and replacing the internal board voids the
warranty. Proceed at your own risk.

**Q: Can I revert to the original firmware?**

A: Yes, if you kept the original RP2040 board. Simply reinstall it and reflash
the original firmware.

### Hardware Questions

**Q: Which Luckfox Lyra version should I buy?**

A: The 128MB version without SPI NAND is recommended for simplicity. The SPI
NAND versions work but require an extra NAND erasing step.

**Q: What size SD card do I need?**

A: Minimum 8GB, but 16GB or 32GB is recommended for comfortable use.

**Q: Does it work with other SBCs?**

A: Currently only Luckfox Lyra is officially supported. Milk-V Duo support is
planned. Other boards may work with community modifications.

**Q: Can I use WiFi?**

A: Not built-in, but USB WiFi adapters should work (requires testing). USB
Ethernet adapters are confirmed working.

**Q: How long does the battery last?**

A: Battery life is less than stock firmware due to running full Linux. Expect
4-6 hours depending on usage. External USB battery packs work well, and you can
always swap batteries.

### Software Questions

**Q: Can I install regular Linux software?**

A: Yes, using the opkg package manager. Many standard Linux packages are
available, though some may not work well on the small display or with limited
RAM. We are still building up the software library - if the application you're
looking for is not present please request it!

**Q: Can I run a graphical desktop?**

A: Yes, lightweight desktop environments like LXDE work on 128MB+ systems. Full
desktops like GNOME/KDE are too heavy.

**Q: Can I run Python/C/other languages?**

A: Yes, development tools including Python, GCC, and other compilers are
available.

**Q: Can I browse the web?**

A: Text-mode browsers (lynx, w3m) work well. Graphical browsers require 256MB+
RAM and are slow on the small display.

**Q: How do I install more software?**

A: Use the opkg package manager:

```bash
opkg update
opkg install <package-name>
```

See [Package Management](../user-guide/package-management.md) for details.

### Build & Development Questions

**Q: How do I build Calculinux from source?**

A: Follow the [Developer Guide](../developer/overview.md), starting with
[Yocto Setup](../developer/yocto-setup.md).

**Q: How long does a build take?**

A: First build: ~2 hours depending on your computer. Subsequent builds: much
faster (minutes to an hour).

**Q: Can I contribute to Calculinux?**

A: Absolutely! See [Contributing Guide](../developer/contributing.md) for how to
get involved.

**Q: Where is the source code?**

A: GitHub: [github.com/Calculinux](https://github.com/Calculinux)

### Troubleshooting Questions

**Q: Why won't my system boot from SD card?**

A: Most likely SPI NAND interference. If your Luckfox Lyra has SPI NAND, you
must erase it first. See
[Boot Problems](boot-problems.md#spi-nand-interference).

**Q: Why is my system so slow?**

A: Check RAM usage (`free -h`). With only 128MB, many applications will
struggle. If you are trying to use a GUI, you may want to explore other lighter
options.

**Q: Where can I get help?**

A:

1. Check this documentation
2. Join our [Discord Community](https://discord.gg/7quBbSPxcP)
3. Search the
   [Forum](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280)
4. Open a [GitHub issue](https://github.com/Calculinux/meta-calculinux/issues)

**Q: The display shows garbage/corruption**

A: Try:

- Reducing SPI clock speed in device tree. The default should be stable,
  however.
- Reflashing SD card
- Testing with different SD card

## Error Messages

### Common Error Messages and Solutions

| Error Message                | Cause                             | Solution                                  |
| ---------------------------- | --------------------------------- | ----------------------------------------- |
| "Kernel panic - not syncing" | Corrupt kernel or bad device tree | Reflash SD card, verify image             |
| "No space left on device"    | Disk full                         | Clean cache, expand filesystem            |
| "Out of memory"              | RAM exhausted                     | Close apps, disable services, upgrade RAM |
| "Cannot allocate memory"     | Memory fragmentation              | Reboot, reduce memory usage               |
| "Unable to mount root fs"    | Bad SD card or partition          | Check SD card, reflash                    |
| "Timeout waiting for device" | Hardware not detected             | Check connections, verify device tree     |

## Getting More Help

If you can't find a solution here:

### Information to Include

When asking for help, provide:

1. **Hardware**: Luckfox Lyra version (RAM, NAND), SD card brand/size
2. **Software**: Calculinux version/image variant
3. **Error messages**: Exact text of errors
4. **What you tried**: Steps you've already taken
5. **Logs**: Relevant portions of `dmesg` or `journalctl`

### Where to Ask

- **Documentation**: Check specific troubleshooting pages
- **Discord Community**: [Join our Discord](https://discord.gg/7quBbSPxcP)
- **Forum**:
  [ClockworkPi Forum Thread](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280)
- **GitHub**:
  [Issue Tracker](https://github.com/Calculinux/meta-calculinux/issues)
- **Community**: Links in [Resources](../resources/community.md)

## Still Stuck?

### Debug Mode Boot

Boot with more verbose output:

```bash
# Edit boot command in U-Boot
# Add to kernel command line:
loglevel=7 debug
```

### Serial Console

Connect via serial for full boot output:

```bash
# From another computer
screen /dev/ttyUSB0 1500000
```

### Safe Mode

Boot to minimal system:

```bash
# Connect with a serial cable, then reboot.
# In U-Boot, add to kernel command line:
single
```

This boots to single-user mode for recovery.

## Related Pages

- [Boot Problems](boot-problems.md) - Detailed boot troubleshooting
- [Display Issues](display.md) - Display-specific problems
- [Input Problems](input.md) - Keyboard/input issues
- [Network Issues](network.md) - Networking problems
- [Common Issues](common-issues.md) - General issues and solutions

---

_Can't find your issue?
[Open a documentation issue](https://github.com/Calculinux/docs/issues) to
request it be added!_
