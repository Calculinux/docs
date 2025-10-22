# Hardware Requirements

This page outlines the hardware required to run Calculinux.

## Required Hardware

### Essential Components

| Component | Requirement | Notes |
|-----------|-------------|-------|
| **PicoCalc Device** | Base model | The handheld computer shell and display |
| **Luckfox Lyra SBC** | RK3506G2-based | Replaces stock RP2040 board |
| **MicroSD Card** | 8GB+ (16GB+ recommended) | For OS storage |
| **USB-C Cable** | Data-capable | For power and connectivity |
| **Power Supply** | 5V/2A minimum | 2A or higher recommended |

### Luckfox Lyra Specifications

Supported Luckfox Lyra configuration:
- **RAM**: 128MB (only available and tested configuration)
- **SoC**: Rockchip RK3506G2
- **Storage**: SD card (some models include SPI NAND that must be erased)

## Recommended Configurations

### Budget Configuration
- Luckfox Lyra 128MB (basic)
- 16GB Class 10 SD card
- Generic 5V/2A charger
- **Use Case**: Console, scripting, development
- **Cost**: ~$30-40

### Standard Configuration  
- Luckfox Lyra 128MB
- 32GB UHS-I SD card
- Quality USB-C adapter
- **Use Case**: Console with more storage for applications
- **Cost**: ~$45-60

### Advanced Configuration
- Luckfox Lyra 128MB
- 64GB UHS-I SD card
- Powered USB hub + peripherals
- **Use Case**: Console development, experimentation
- **Cost**: ~$60-80

!!! info "Graphical Desktop Experimentation"
    While Calculinux is console-only by default, users may experiment with lightweight graphical environments. However, the 128MB RAM is a significant limiting factor for desktop use. Community experimentation is encouraged but not officially supported.

## Optional Hardware

!!! warning "USB Peripheral Limitations"
    The Lyra USB-C port supports USB OTG, but has important limitations:
    
    - **Voltage Requirement**: USB devices must operate at 3.3V or use an externally powered hub
    - **Tested Hardware**: Only internal USB WiFi adapter (3.3V) has been confirmed working
    - **Untested Peripherals**: External USB devices (keyboards, ethernet adapters, storage) have not been tested
    - **Recommendation**: Use an externally powered USB hub for any external USB peripherals

### Tested Hardware

- **WiFi Adapter** (3.3V, internal USB header) - ✅ Confirmed working
- **External SD Card** (PicoCalc's built-in SD slot) - ✅ Confirmed working

!!! info "External SD Card Expansion"
    The PicoCalc includes a built-in SD card slot that can be used for additional storage. This slot is accessed over SPI and is therefore slower than the main internal SD card, but it's excellent for mass storage of files, media, or backups.

### Untested Hardware

The following peripherals may work but have not been tested and likely require a powered USB hub:

- USB keyboard
- USB Ethernet adapter
- USB storage devices
- Other USB peripherals

!!! note "Luckfox Lyra Plus Ethernet"
    The [Luckfox Lyra Plus](https://www.luckfox.com/Mini-PC/Luckfox-Lyra-Plus) includes a built-in Ethernet port, but this model has not been tested with Calculinux and would require a custom backplate to access the port within the PicoCalc enclosure.

!!! note "Other Luckfox Lyra Models"
    Other Luckfox Lyra models exist with different RAM configurations (64MB, 256MB), but these have different pinouts from the 128MB model and would require a custom adapter board to be compatible with the PicoCalc. Only the 128MB model with the standard pinout is currently supported.

## Compatibility

See [Compatibility Matrix](../hardware/compatibility.md) for detailed hardware compatibility information.

## Next Steps

- Review [Luckfox Lyra details](../hardware/luckfox-lyra.md)
- Check [Installation Guide](installation.md)
- Learn about [Hardware Modifications](../hardware/modifications.md)
