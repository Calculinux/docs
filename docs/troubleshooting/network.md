# Network Issues

Troubleshooting network connectivity problems on your PicoCalc.

## Quick Diagnostics

Start with these basic checks:

```shell
# Check network interfaces
ip addr show

# Check if interfaces are up
ip link show

# Test basic connectivity (if you know a working IP)
ping 8.8.8.8

# Test DNS resolution
ping google.com

# Check routing
ip route show
```

## USB Networking Issues

For detailed USB networking troubleshooting, see the [USB Networking Guide](../user-guide/usb-networking.md#troubleshooting).

### Quick USB Network Checks

```shell
# Check if USB gadget service is running
systemctl status usb-gadget-network

# Check usb0 interface
ip addr show usb0

# Restart USB gadget
sudo systemctl restart usb-gadget-network
```

Common USB networking issues:

- **Device not appearing on host**: Check USB cable (must be data cable), verify service is running
- **Cannot ping device**: Verify IP configuration on both host and device
- **No DHCP**: Check that host has internet sharing enabled
- **Module errors**: Verify kernel modules are loaded with `lsmod | grep -E 'libcomposite|rndis|ecm'`

See [USB Networking Troubleshooting](../user-guide/usb-networking.md#troubleshooting) for detailed solutions.

## WiFi Not Working

### WiFi Interface Not Found

Check if the WiFi interface exists:

```shell
# List network interfaces
ip link show

# Look for WiFi adapter
iw dev
```

If no WiFi interface is found:

1. Check if the module is loaded:

   ```shell
   lsmod | grep -E 'rtl|aic'
   ```

2. Load the WiFi driver module:

   ```shell
   sudo modprobe <driver_name>
   ```

3. Check system logs:

   ```shell
   dmesg | grep -i wifi
   journalctl -u systemd-networkd -b
   ```

### Cannot Connect to Network

Using `iwctl`:

```shell
# Enter iwctl interactive mode
iwctl

# Scan for networks
station wlan0 scan

# List available networks
station wlan0 get-networks

# Connect to network
station wlan0 connect "NetworkName"
```

If connection fails:

1. **Check signal strength**: Move closer to the access point
2. **Verify password**: Ensure correct passphrase
3. **Check network mode**: Some routers may need 2.4GHz mode enabled
4. **Check logs**:

   ```shell
   journalctl -u iwd -f
   ```

### WiFi Disconnects Frequently

Common causes:

1. **Power management**: Disable WiFi power saving:

   ```shell
   sudo iw dev wlan0 set power_save off
   ```

2. **Weak signal**: Move closer to access point or add external antenna

3. **Channel interference**: Try changing router channel (especially on 2.4GHz)

4. **Driver issues**: Check for kernel messages:

   ```shell
   dmesg | grep wlan0
   ```

### WiFi Adapter in Invalid State

**Symptoms**:

- Access points don't appear in WiFi scan results
- `iwctl station wlan0 scan` returns empty list
- WiFi USB adapter doesn't appear in `lsusb` output
- Network interface exists but doesn't respond to commands

**Cause**: The WiFi adapter or module enters an invalid state, preventing normal operation. This can happen after power cycling, resets, or other transient hardware issues.

**Solutions**:

**Option 1: Complete power cycle** (most reliable)

A simple reboot (`reboot`) or `sudo systemctl restart iwd` often does **not** work for invalid adapter states. A complete power off is required:

1. Power off the Picocalc:

   ```shell
   sudo poweroff
   ```

2. Press the power button and boot normally
3. The adapter hardware will fully reinitialize

**Option 2: Remove and re-insert USB adapter** (for external adapters)

If you have an external USB WiFi adapter, physical disconnection can help reset the hardware:

1. Unplug the USB WiFi adapter
2. Wait 10-15 seconds
3. Re-insert the adapter

!!! warning "Adapter May Get a New Name"

    In rare cases, a corrupted adapter may be assigned a new interface name upon re-insertion. Instead of `wlan0`, it may appear as `wlan1` in `ip addr`, `dmesg`, or other tools. iwd will still connect correctly since its configuration is adapter-independent. To restore the original device naming, reboot or perform a complete power cycle.

**Option 3: Software module reload** (unreliable for stuck adapters)

Software-only solutions may not work when the adapter itself is in an invalid state, but you can try:

```shell
# This may not work if the adapter hardware is truly stuck
# Identify the WiFi driver module (e.g., rtl8188fu, aic8800)
lsmod | grep -E 'rtl|aic'

# Attempt to reload the module (replace with your driver name)
sudo modprobe -r rtl8xxxu
sudo modprobe rtl8xxxu

# Or try restarting the iwd service
sudo systemctl restart iwd
```

If software reload doesn't resolve the issue within a few minutes, proceed to Option 1 (complete power cycle).

## DNS Problems

### Cannot Resolve Hostnames

Test DNS resolution:

```shell
# Check DNS servers
cat /etc/resolv.conf

# Test DNS lookup
nslookup google.com

# Or use dig
dig google.com
```

Fix DNS issues:

1. **Manually set DNS servers** in `/etc/resolv.conf`:

   ```shell
   nameserver 1.1.1.1
   nameserver 8.8.8.8
   ```

2. **For WiFi with iwd**: DNS should be set automatically via DHCP

3. **For USB networking**:
   - With internet sharing, DNS should come from DHCP
   - For static config, manually set DNS as above

### DNS Lookup Slow

1. Try alternative DNS servers (Cloudflare, Google, Quad9)
2. Check if DNS server is accessible:

   ```shell
   ping 1.1.1.1
   ```

## Connection Timeouts

### SSH Connection Times Out

If SSH to your PicoCalc times out:

1. **Verify connectivity**:

   ```shell
   ping <picocalc-ip>
   ```

2. **Check if SSH is running**:

   ```shell
   # On PicoCalc
   systemctl status sshd
   ```

3. **Check firewall** (if enabled):

   ```shell
   # On PicoCalc
   sudo iptables -L -v
   ```

4. **Try verbose SSH** to see where it fails:

   ```shell
   ssh -vvv pico@<ip-address>
   ```

### Internet Access Times Out

If you can't reach external sites:

1. **Check default route**:

   ```shell
   ip route show default
   ```

2. **Test local gateway**:

   ```shell
   ping <gateway-ip>
   ```

3. **Test external IP**:

   ```shell
   ping 8.8.8.8
   ```

4. **Test DNS**:

   ```shell
   ping google.com
   ```

This helps identify if the issue is:

- Local network (can't reach gateway)
- Internet routing (can reach gateway but not internet)
- DNS (can reach IPs but not resolve names)

## Advanced Diagnostics

### Network Interface Details

```shell
# Detailed interface info
ethtool usb0  # or wlan0

# Interface statistics
ip -s link show usb0

# Routing table
ip route show table all
```

### Network Traffic Analysis

```shell
# Monitor traffic on interface
sudo tcpdump -i usb0

# Show active connections
ss -tunap

# Network statistics
netstat -s
```

### Service Status

```shell
# Check network-related services
systemctl status systemd-networkd
systemctl status iwd
systemctl status usb-gadget-network
systemctl status sshd

# View service logs
journalctl -u systemd-networkd -b
journalctl -u iwd -b
```

## Getting Help

If you're still experiencing issues:

1. **Gather diagnostic information**:

   ```shell
   # Save to a file
   {
     echo "=== Network Interfaces ==="
     ip addr show
     echo "=== Routes ==="
     ip route show
     echo "=== DNS ==="
     cat /etc/resolv.conf
     echo "=== Service Status ==="
     systemctl status usb-gadget-network systemd-networkd iwd
   } > network-diag.txt
   ```

2. **Check the documentation**:
   - [USB Networking Guide](../user-guide/usb-networking.md)
   - [First Boot](../getting-started/first-boot.md) - WiFi setup
   - [FAQ](faq.md)

3. **Ask the community**:
   - [Discord](https://discord.gg/7quBbSPxcP)
   - [Forum](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280)
   - [GitHub Issues](https://github.com/Calculinux/meta-calculinux/issues)

## See Also

- [USB Networking Guide](../user-guide/usb-networking.md) - Complete USB networking documentation
- [Basic Usage](../user-guide/basic-usage.md) - General usage information
- [Common Issues](common-issues.md) - Other troubleshooting topics
