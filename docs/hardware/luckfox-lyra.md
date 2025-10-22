# Luckfox Lyra

The **Luckfox Lyra** is a compact single-board computer based on the Rockchip RK3506G2 SoC, making it an ideal replacement for the PicoCalc's stock module.

## Overview

The Luckfox Lyra provides significant computing power in a small form factor, making it perfect for pocket-sized Linux applications.

## Specifications

### Processor

| Component | Specification |
|-----------|--------------|
| **SoC** | Rockchip RK3506G2 |
| **CPU** | Triple-core ARM Cortex-A7 @ 1.2GHz + ARM Cortex-M0 |
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

!!! info "Complete Interface Documentation"
    For detailed pinout diagrams and interface specifications, refer to the [official Luckfox Lyra documentation](https://wiki.luckfox.com/Luckfox-Lyra/) and [pinout reference](https://wiki.luckfox.com/Luckfox-Lyra/Pinout).

!!! info "WiFi Not Included"
    The Luckfox Lyra does not have built-in WiFi. Wireless connectivity requires an external USB WiFi adapter (must operate at 3.3V) connected to the USB header.

### Audio

- **Default**: Software PWM audio output (poor quality)
- **Hardware Interface**: I2S audio interface available
- **PWM Output**: Requires hardware modification for good quality

!!! warning "Audio Quality Limitations"
    The default software PWM audio driver has very poor performance and is not suitable for general use. For good audio quality, hardware modifications are required. Current alpha images do not support audio driver selection, but this could be implemented through module blacklisting in the future.

### Power

- **Input Voltage**: 5V
- **Power Consumption**: 
  - Idle: ~0.5-0.52W
  - Light use (gaming): ~0.59-0.60W  
  - With WiFi connected: ~0.63-1.1W
- **USB-C Power Delivery**: Supported
- **Battery Operation**: Supported but significantly reduced life vs stock firmware

!!! info "Real-World Power Data"
    Community testing shows actual power consumption ranging from 0.5W idle to over 1W with WiFi active. Battery life is typically 2-4 hours depending on usage.

## Luckfox Lyra Versions

Calculinux currently supports two variants of the Luckfox Lyra board available from [https://www.luckfox.com/Luckfox-Lyra](https://www.luckfox.com/Luckfox-Lyra):

| Model | RAM | Flash | Notes |
|-------|-----|-------|-------|
| **Standard** | 128MB | None | SD card only - **Recommended** |
| **SPI NAND** | 128MB | 128MB-1GB | Requires NAND erase before use |

!!! tip "Recommended Version"
    The standard 128MB version without SPI NAND is recommended for simplicity. Both variants have identical performance for Calculinux.

!!! info "Other Variants Not Yet Supported" 
    Other Luckfox variants mentioned in community discussions (Lyra Zero W, Lyra Pi, Lyra Plus) could potentially be supported in the future but have not been attempted. Current images are only tested on the two variants listed above.

!!! warning "SPI NAND Versions"
    If your board has SPI NAND, you **must erase it first** or the board will boot from NAND instead of the SD card. See the [troubleshooting guide](../troubleshooting/boot-problems.md) for instructions.

## Why Luckfox Lyra for PicoCalc?

The Luckfox Lyra is particularly well-suited for PicoCalc:

1. **Size**: Compact form factor fits inside PicoCalc
2. **Power**: Efficient enough for battery operation
3. **Performance**: Sufficient for Linux console applications and development
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

Calculinux includes drivers for external USB WiFi adapters with the following chipsets currently enabled in the kernel:

- **RTL8192CU** - Single-band USB WiFi adapter
- **R8712U** - Single-band USB WiFi adapter  
- **R8188EU** - Single-band USB WiFi adapter
- **RTL8723BS** - Dual-band SDIO WiFi (not typically used via USB)

**Additional chipsets that need kernel configuration**: RTL8723DU, RTL8812AU, RTL8814AU, RTL8821CU, RTL88X2BU.

**Additional chipsets with pending support include**: RTL8188FU, RTL8188FTV, RT2800 series, MT7612U, MT7610U, and RT5370. Community testing has confirmed these work but drivers are not yet included in official images.

!!! danger "Critical 3.3V Requirement"
    When selecting a USB WiFi adapter:
    
    - **MUST operate at 3.3V** (Lyra USB header voltage) - 5V adapters will damage the board
    - Verify chipset compatibility with the supported list above
    - Compact form factor recommended for PicoCalc integration
    - Consider power consumption for battery operation

### Device Tree

Calculinux includes a custom device tree configuration that:

- Defines PicoCalc hardware connections
- Configures SPI bus for display
- Maps GPIO pins for keyboard matrix
- Sets up USB and power management

## Luckfox SDK vs Calculinux

### Official Luckfox SDK

The Luckfox Lyra uses the Luckfox Pico SDK:

- **Repository**: [https://github.com/LuckfoxTECH/luckfox-pico](https://github.com/LuckfoxTECH/luckfox-pico)
- **Documentation**: Available in SDK repository
- **Build System**: Buildroot-based
- **Community Usage**: Most community images use this SDK

### Calculinux Architecture

Calculinux is independently developed with a different approach:

- **Build System**: Upstream Yocto (not Buildroot)
- **Developer**: 0xd61 (personal repository continuation)
- **Relationship to SDK**: Limited - only uses kernel and u-boot sources
- **Kernel**: Hosted externally to the SDK
- **U-Boot**: Hosted externally with custom patches
- **Everything Else**: Independent implementation with upstream compilers

!!! info "Independent Development"
    While most community images are built with the Luckfox SDK and Buildroot, Calculinux is developed independently using upstream Yocto and only borrows the kernel and bootloader sources.

### Other Major Community Images

For completeness, other distributions available for Luckfox Lyra include:

- **hisptoot's Buildroot images** - Original community port using Luckfox SDK
- **markbirss's Ubuntu images** - Ubuntu 22.04/24.04 based distributions
- **Community Buildroot variants** - Various SDK-based images with different features

See the [ClockworkPi forum thread](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280) for links to these alternative distributions.

## Hardware Considerations

### Boot Media Priority

The RK3506G2 boot process follows this priority:

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

- **Luckfox Official Store**: [https://www.luckfox.com/Luckfox-Lyra](https://www.luckfox.com/Luckfox-Lyra)
- **AliExpress**: Search for "Luckfox Lyra"
- **Other Distributors**: Check Luckfox website for authorized sellers

!!! tip "Official Source"
    The official Luckfox website is the authoritative source for current specifications and available variants.

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
