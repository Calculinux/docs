# Networking

This section covers network connectivity options for your PicoCalc.

!!! info "PicoCalc Network Configuration"
    The PicoCalc uses **systemd-networkd** for network configuration and **iwd** for WiFi management. No graphical network managers (like NetworkManager) are included - configuration is done via configuration files or command-line tools like `iwctl`.
    
## Available Connectivity

<div class="grid cards" markdown>

-   :material-usb:{ .lg .middle } **USB Networking**

    ---

    Connect directly to your computer via USB for fast, convenient network access.

    [:octicons-arrow-right-24: USB Networking Guide](usb-networking.md)

-   :material-wifi:{ .lg .middle } **WiFi**

    ---

    Connect to wireless networks using a USB WiFi adapter (not built-in, must be installed separately).

    [:octicons-arrow-right-24: WiFi Setup](../getting-started/first-boot.md#wifi-setup-usb-adapter-required)

    [:octicons-arrow-right-24: Selecting a WiFi Adapter](../hardware/specifications.md#supported-wifi-chipsets)

</div>

## Quick Links

- **USB Networking**: Direct USB connection to your computer - [Setup Guide](usb-networking.md)
- **WiFi Setup**: Wireless connectivity with USB WiFi adapter (not built-in) - See [First Boot Guide](../getting-started/first-boot.md#wifi-setup-usb-adapter-required)
- **WiFi Adapter Selection**: Choosing a compatible adapter - See [Supported WiFi Chipsets](../hardware/specifications.md#supported-wifi-chipsets)
- **Troubleshooting**: Network issues - See [Network Troubleshooting](../troubleshooting/network.md)

## Common Tasks

### SSH Access

Access your PicoCalc remotely via SSH:

```bash
ssh pico@<ip-address>
# Default password: calc
```

For USB networking:
```bash
ssh pico@192.168.7.2
```

### File Transfer

Transfer files using SCP:

```bash
# Copy to PicoCalc
scp myfile.txt pico@<ip-address>:/home/pico/

# Copy from PicoCalc
scp pico@<ip-address>:/path/to/file ./
```

### Internet Access

Your PicoCalc can access the internet via (requires USB WiFi adapter):

- **WiFi connection** - Direct internet access
- **USB with internet sharing** - Host computer shares its connection
- **USB tethering from phone** - Android or iOS device sharing

## Additional Resources

- [Supported WiFi Chipsets](../hardware/specifications.md#supported-wifi-chipsets) - Choosing a compatible WiFi adapter
- [Hardware Compatibility](../hardware/compatibility.md) - USB and peripheral compatibility information
- [Network Troubleshooting](../troubleshooting/network.md) - Solving connectivity issues
- [Basic Usage](basic-usage.md) - General system usage

---

!!! tip "Recommended: USB Networking"
    For development and testing, USB networking provides the fastest and most reliable connection without requiring additional hardware.
