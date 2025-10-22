# Luckfox Lyra

The **Luckfox Lyra** is a compact single-board computer based on the Rockchip RV1106 SoC, making it an ideal replacement for the PicoCalc's stock module.

## Overview

The Luckfox Lyra provides significant computing power in a small form factor, making it perfect for pocket-sized Linux applications.

## Specifications

### Processor

| Component | Specification |
|-----------|--------------|
| **SoC** | Rockchip RV1106 |
| **CPU** | ARM Cortex-A7, up to 1.2GHz |
| **Architecture** | ARMv7-A (32-bit) |
| **NPU** | 0.5 TOPS AI accelerator |

### Memory & Storage

| Component | Options |
|-----------|---------|
| **RAM** | 64MB / 128MB / 256MB DDR2/DDR3 |
| **Flash Storage** | Optional SPI NAND (different versions available) |
| **External Storage** | MicroSD card slot |

!!! warning "SPI NAND Versions"
    Some Luckfox Lyra boards come with SPI NAND flash memory. If your board has SPI NAND, you **must erase it first** or the board will boot from NAND instead of the SD card. See the [troubleshooting guide](../troubleshooting/boot-problems.md) for instructions.

### Interfaces

- **Display**: SPI interface for LCD
- **Camera**: MIPI CSI interface (not used in PicoCalc)
- **USB**: USB 2.0 OTG (headers only - requires USB adapter)
- **GPIO**: Multiple GPIO pins
- **Audio**: I2S audio interface
- **Network**: Ethernet MAC (PHY depends on version)

!!! info "WiFi Not Included"
    The Luckfox Lyra does not have built-in WiFi. Wireless connectivity requires an external USB WiFi adapter (must operate at 3.3V) connected to the USB header.

### Power

- **Input Voltage**: 5V
- **Power Consumption**: Low power (ideal for battery operation)
- **USB-C Power Delivery**: Supported

## Luckfox Lyra Versions

Luckfox produces several variants of the Lyra board:

| Model | RAM | Flash | Notes |
|-------|-----|-------|-------|
| **Basic** | 64MB | None | SD card only |
| **Standard** | 128MB | None | SD card only |
| **SPI NAND** | 128MB/256MB | 128MB-1GB | Requires NAND erase |
| **Ethernet** | 128MB | Optional | Includes Ethernet PHY |

!!! tip "Recommended Version"
    For PicoCalc use, the standard 128MB version without SPI NAND is recommended for simplicity. If you have a SPI NAND version, the extra storage isn't utilized in typical Calculinux configurations.

## Why Luckfox Lyra for PicoCalc?

The Luckfox Lyra is particularly well-suited for PicoCalc:

1. **Size**: Compact form factor fits inside PicoCalc
2. **Power**: Efficient enough for battery operation
3. **Performance**: Sufficient for Linux desktop and development
4. **Interfaces**: SPI and GPIO interfaces match PicoCalc requirements
5. **Community**: Active development and support
6. **Cost**: Affordable pricing

## Driver Support in Calculinux

Calculinux includes custom kernel drivers developed specifically for the Luckfox Lyra + PicoCalc combination:

### LCD Driver

- SPI-based display interface
- Custom framebuffer driver
- Optimized for PicoCalc's display panel
- Resolution and refresh rate tuning

### Keyboard Driver

- Matrix keyboard scanning
- Key mapping for PicoCalc layout
- Input event handling
- Debouncing and repeat rate configuration

### WiFi Drivers

Calculinux includes drivers for external USB WiFi adapters with the following Realtek chipsets:

- **RTL8723DU** - Dual-band WiFi adapter
- **RTL8812AU** - AC1200 dual-band adapter
- **RTL8814AU** - AC1900 quad-antenna adapter
- **RTL8821CU** - AC600 compact adapter
- **RTL88X2BU** - AC1200 adapter

!!! tip "Choosing a WiFi Adapter"
    When selecting a USB WiFi adapter:
    
    - Ensure it operates at **3.3V** (Lyra USB header voltage)
    - Verify chipset compatibility with the list above
    - Compact form factor recommended for PicoCalc integration
    - Consider power consumption for battery operation

### Device Tree

Calculinux includes a custom device tree configuration that:

- Defines PicoCalc hardware connections
- Configures SPI bus for display
- Maps GPIO pins for keyboard matrix
- Sets up USB and power management

## Luckfox SDK

The Luckfox Lyra uses the Luckfox Pico SDK:

- **Repository**: [https://github.com/LuckfoxTECH/luckfox-pico](https://github.com/LuckfoxTECH/luckfox-pico)
- **Documentation**: Available in SDK repository
- **Buildroot-based**: Original SDK uses Buildroot
- **Calculinux Integration**: Calculinux ports drivers to Yocto

!!! info "Yocto vs. Buildroot"
    While the official Luckfox SDK uses Buildroot, Calculinux uses **Yocto** for better package management, reproducibility, and long-term maintenance. The kernel drivers are compatible with both systems.

## Hardware Considerations

### Boot Media Priority

The RV1106 boot process follows this priority:

1. **SPI NAND** (if present and programmed)
2. **SD Card** (if SPI NAND is erased or absent)
3. **USB Boot** (for recovery/programming)

!!! danger "Important for SPI NAND Versions"
    If your Luckfox Lyra has SPI NAND, the boot ROM will **always try NAND first**. You must erase the NAND or it will ignore the SD card completely. See [Boot Problems](../troubleshooting/boot-problems.md#spi-nand-interference) for instructions.

### Thermal Management

The RV1106 can generate heat under load:

- Generally safe without heatsink for typical use
- Consider heat dissipation in enclosed PicoCalc case
- Monitor temperatures during intensive tasks

### Power Supply

Proper power delivery is critical:

- Use quality USB-C cable
- Ensure 5V/2A minimum supply
- Battery operation is supported but monitor voltage
- Under-voltage can cause instability

## Purchasing

Luckfox Lyra boards are available from:

- **Luckfox Official Store**: [https://www.luckfox.com/](https://www.luckfox.com/)
- **AliExpress**: Search for "Luckfox Lyra"
- **Other Distributors**: Check Luckfox website for authorized sellers

## Resources

### Official Documentation

- **Luckfox Website**: [https://www.luckfox.com/](https://www.luckfox.com/)
- **GitHub SDK**: [Luckfox Pico SDK](https://github.com/LuckfoxTECH/luckfox-pico)
- **Wiki**: [Luckfox Wiki](https://wiki.luckfox.com/)

### Community Resources

- **Forum Thread**: [Luckfox Lyra on PicoCalc](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280)
- **Original Port**: hisptoot's Google Drive with initial images and drivers

## Next Steps

- Review [Hardware Modifications](modifications.md) for installation guide
- Check [Display & Input](display-input.md) for driver details
- See [Compatibility Matrix](compatibility.md) for version compatibility
- Learn about [power management](power.md) considerations
