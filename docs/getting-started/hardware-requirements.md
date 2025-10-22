# Hardware Requirements

This page outlines the hardware required to run Calculinux.

## Required Hardware

### Essential Components

| Component | Requirement | Notes |
|-----------|-------------|-------|
| **PicoCalc Device** | Any model | The calculator shell and display |
| **Luckfox Lyra SBC** | RV1106-based | Replaces stock RP2040 board |
| **MicroSD Card** | 8GB+ (16GB+ recommended) | For OS storage |
| **USB-C Cable** | Data-capable | For power and connectivity |
| **Power Supply** | 5V/2A minimum | 2A or higher recommended |

### Luckfox Lyra Specifications

Minimum supported Luckfox Lyra:
- **RAM**: 128MB (only tested configuration)
- **SoC**: Rockchip RK3506G2
- **Storage**: SD card (SPI NAND optional)

## Recommended Configurations

### Budget Configuration
- Luckfox Lyra 128MB (basic)
- 16GB Class 10 SD card
- Generic 5V/2A charger
- **Use Case**: Console, development
- **Cost**: ~$30-40

### Standard Configuration  
- Luckfox Lyra 128MB
- 32GB UHS-I SD card
- Quality USB-C adapter
- **Use Case**: Light desktop
- **Cost**: ~$45-60

### Premium Configuration
- Luckfox Lyra 256MB
- 64GB UHS-I SD card
- USB hub + peripherals
- **Use Case**: Full desktop, development
- **Cost**: ~$60-80

## Optional Hardware

- USB keyboard (easier initial setup)
- USB Ethernet adapter (network access)
- USB hub (for multiple peripherals)
- USB WiFi adapter (untested but should work)

## Compatibility

See [Compatibility Matrix](../hardware/compatibility.md) for detailed hardware compatibility information.

## Next Steps

- Review [Luckfox Lyra details](../hardware/luckfox-lyra.md)
- Check [Installation Guide](installation.md)
- Learn about [Hardware Modifications](../hardware/modifications.md)
