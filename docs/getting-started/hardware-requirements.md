# Hardware Requirements

This page outlines what hardware you need to purchase and prepare to run Calculinux.

!!! info "Technical Specifications"
    For detailed technical specifications of all hardware components, see the [Hardware Specifications](../hardware/specifications.md) page.

## Required Hardware

### Essential Components

| Component | Requirement | Where to Get |
|-----------|-------------|--------------|
| **PicoCalc Device** | Base model | [ClockworkPi Store](https://www.clockworkpi.com/) |
| **Luckfox Lyra SBC** | 128MB RAM, RK3506G2-based | [Luckfox Store](https://www.luckfox.com/Luckfox-Lyra) |
| **MicroSD Card** | 8GB minimum (16GB+ recommended) | Any retailer - Class 10 or better |
| **USB-C Cable** | Data-capable | Any retailer |

!!! warning "Luckfox Lyra Configuration"
    - **RAM**: Get the **128MB** model - this is the only tested and supported configuration
    - **Storage**: Models with or without SPI NAND both work (NAND must be [erased first](../troubleshooting/erase-nand.md))
    - **Other variants**: 64MB and 256MB RAM models have different footprints and pinouts and would require custom adapter boards

## Recommended Configurations

### Budget Configuration
- Luckfox Lyra 128MB (basic model, no SPI NAND)
- 16GB Class 10 SD card
- **Best for**: Console use, scripting, learning Linux

### Standard Configuration
- Luckfox Lyra 128MB
- 32GB UHS-I SD card
- **Best for**: General use with more storage for applications

### Advanced Configuration
- Luckfox Lyra 128MB
- 64GB UHS-I SD card
- Powered USB hub (for 5V peripherals)
- Second USB-C cable (for serial console)
- **Best for**: Development, experimentation, debugging

!!! tip "Serial Console for Development"
    A second USB-C cable connected to the **PicoCalc's USB-C port** (not the Lyra's port) provides serial console access at **1500000 baud**. This is invaluable for:
    
    - Watching boot messages and kernel output
    - Debugging firmware and kernel driver modifications
    - Troubleshooting hardware issues
    - Development work requiring low-level system access
    
    See [Hardware Specifications](../hardware/specifications.md#usb-c-ports) for details on the two different USB-C ports.

## What's Included vs What to Buy

### Comes with PicoCalc
- Display and keyboard
- Internal battery
- PicoCalc USB-C port (for charging and serial console)
- PicoCalc SD card slot (for expansion storage)
- Original RP2040 board (you'll replace this)

### You Need to Purchase
- Luckfox Lyra SBC (replaces RP2040)
- MicroSD card for Lyra (system boot disk)
- USB-C cable

### Optional Purchases
- WiFi adapter (3.3V or via powered hub)
- Additional SD card for PicoCalc slot
- Powered USB hub (for 5V devices)
- Second USB-C cable (for serial console)

## Before You Order

### Important Considerations

!!! info "Graphical Desktop Experimentation"
    Calculinux is console-only by default. While you can experiment with lightweight graphical environments, the 128MB RAM is a significant limiting factor for desktop use. Set expectations accordingly!

!!! caution "SPI NAND Models"
    If you purchase a Luckfox Lyra with SPI NAND storage, you **must erase the NAND flash** before Calculinux will boot from SD card. See the [SPI NAND Erase Guide](../troubleshooting/erase-nand.md) for instructions.

!!! note "PicoCalc Availability"
    Check [ClockworkPi's website](https://www.clockworkpi.com/) for current PicoCalc availability and shipping information.

## Next Steps

Once you have your hardware:

1. **Check compatibility**: Review the [Hardware Compatibility Matrix](../hardware/compatibility.md)
2. **Learn about the hardware**: See [Hardware Specifications](../hardware/specifications.md) for technical details
3. **Prepare for installation**: Continue to the [Installation Guide](installation.md)

## Additional Resources

- [PicoCalc Overview](../hardware/picocalc.md) - Learn about the PicoCalc device
- [Luckfox Lyra Details](../hardware/luckfox-lyra.md) - SDK, purchasing, and software info
- [Hardware Specifications](../hardware/specifications.md) - Complete technical specs
- [Hardware Compatibility](../hardware/compatibility.md) - Detailed compatibility information

## Optional Hardware

### Network Connectivity

!!! warning "No Built-in WiFi"
    Neither the PicoCalc nor Luckfox Lyra include built-in WiFi. You will need a USB WiFi adapter.

!!! danger "Critical: 3.3V Requirement"
    The Lyra's USB port provides only **3.3V power**. Standard 5V USB adapters will NOT work and may damage the board.
    
    **Options**:
    - Use a 3.3V-compatible USB WiFi adapter
    - Use an **externally powered** USB hub for 5V devices

**Tested**: USB WiFi adapters with RTL8192CU, R8712U, R8188EU chipsets at 3.3V

**Untested but supported**: Additional chipsets listed in [Hardware Specifications - WiFi](../hardware/specifications.md#supported-wifi-chipsets)

### Storage Expansion

| Option | Status | Notes |
|--------|--------|-------|
| **PicoCalc SD Card Slot** | ✅ Tested | External SD card via PicoCalc's built-in slot (SPI, slower but great for storage) |
| **USB Storage** | ❓ Untested | Via Lyra USB-OTG port (requires 3.3V or powered hub) |

### Other Peripherals

**The following have NOT been tested with Calculinux** and likely require an externally powered USB hub:

- USB keyboard
- USB ethernet adapter  
- USB storage devices
- Other USB peripherals

!!! note "Luckfox Lyra Plus (Ethernet Model)"
    The [Luckfox Lyra Plus](https://www.luckfox.com/Mini-PC/Luckfox-Lyra-Plus) includes built-in Ethernet, but it has not been tested with Calculinux and would require a custom backplate to access the port within the PicoCalc enclosure.

## Compatibility

See [Compatibility Matrix](../hardware/compatibility.md) for detailed hardware compatibility information.

## Next Steps

- Review [Luckfox Lyra details](../hardware/luckfox-lyra.md)
- Check [Installation Guide](installation.md)
- Learn about [Hardware Modifications](../hardware/modifications.md)
