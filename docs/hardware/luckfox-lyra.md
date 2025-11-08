# Luckfox Lyra

The **Luckfox Lyra** is a compact single-board computer based on the Rockchip RK3506G2 SoC, making it an ideal replacement for the PicoCalc's stock module.

## Overview

The Luckfox Lyra provides significant computing power in a small form factor, perfect for pocket-sized Linux applications.

!!! info "Complete Technical Specifications"
    For detailed processor, memory, interface, and power specifications, see the [Hardware Specifications](specifications.md) page.

## Luckfox Lyra Versions

| Model | RAM | Flash | Ethernet | Status |
|-------|-----|-------|----------|--------|
| **Luckfox Lyra** | 128MB | None | No | ✅ **Recommended** |
| **Luckfox Lyra B (SPI NAND)** | 128MB | 256MB SPI NAND| No | ✅ Supported ([NAND must be erased](../troubleshooting/erase-nand.md)) |
| **Luckfox Lyra Plus** | 128MB | 256 MB SPI NAND | Yes (10/100) | ❓ Untested (Requires a custom printed backplate) |

!!! tip "Recommended Version"
    The standard 128MB model with SPI NAND is recommended for better compatibility with future features.

!!! warning "SPI NAND Must Be Erased"
    If your board has SPI NAND, you **must erase it** before Calculinux will boot from SD card. The boot ROM always tries NAND first. See the comprehensive [SPI NAND Erase Guide](../troubleshooting/erase-nand.md) for detailed step-by-step instructions.

!!! note "Other Lyra Models"
    Other Luckfox Lyra models exist (64MB, 256MB RAM) but have different pinouts and would require custom adapter boards for PicoCalc compatibility.

## Why Luckfox Lyra for PicoCalc?

The Luckfox Lyra is particularly well-suited for PicoCalc:

1. **Size**: Compact form factor fits inside PicoCalc
2. **Power**: Efficient enough for battery operation
3. **Performance**: Sufficient for Linux console applications and development
4. **Interfaces**: SPI and GPIO interfaces match PicoCalc requirements
5. **Community**: Active development and support
6. **Cost**: Affordable pricing

## Driver Support in Calculinux

Calculinux includes custom kernel drivers developed specifically for the Luckfox Lyra + PicoCalc combination. For technical details about the drivers and device tree configuration, see [Display & Input Technical Details](display-input.md).

### Included Drivers

- **LCD Driver**: ILI9488 framebuffer driver for 320×320 display
- **Keyboard Driver**: I2C-based keyboard with STM32 MCU integration  
- **WiFi Drivers**: Support for multiple Realtek and other chipsets (see [WiFi Chipsets](specifications.md#supported-wifi-chipsets))
- **Device Tree**: Custom configuration for PicoCalc hardware connections

## Luckfox SDK vs Calculinux

### Official Luckfox SDK

The Luckfox Lyra uses the Luckfox Lyra SDK:

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
    While most community images are built with the Luckfox SDK and Buildroot, Calculinux is developed independently using upstream Yocto and only borrows the kernel and bootloader sources. Our goal is to foster innovation and promote sharing and pooling our resources to the benefit of all picocalc based Linux distros

### Other Major Community Images

For completeness, other distributions available for Luckfox Lyra include:

- **hisptoot's Buildroot images** - Original community port using Luckfox SDK
- **markbirss's Ubuntu images** - Ubuntu 22.04/24.04 based distributions
- **Community Buildroot variants** - Various SDK-based images with different features

See the [ClockworkPi forum thread](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280) for links to these alternative distributions.

## Hardware Considerations

### Boot Media Priority

The RK3506G2 boot ROM follows this priority:

1. **SPI NAND** (if present and programmed)
2. **SD Card** (if SPI NAND is erased or absent)
3. **USB Boot** (for recovery/programming)

!!! danger "NAND Boot Priority"
    If your Luckfox Lyra has SPI NAND, the boot ROM will **always try NAND first**. You must erase the NAND or it will ignore the SD card completely. See the [SPI NAND Erase Guide](../troubleshooting/erase-nand.md) for complete instructions.

### Power Supply & Thermal Management

For power requirements and thermal considerations, see [Hardware Specifications](specifications.md#power-system).

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
- **SDK**: [Luckfox Pico SDK](https://github.com/LuckfoxTECH/luckfox-pico)
- **Wiki**: [Luckfox Wiki](https://wiki.luckfox.com/)

### Community Resources

- **Forum Thread**: [Luckfox Lyra on PicoCalc](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280)
- **Original Port**: hisptoot's Google Drive with initial images and drivers

## Next Steps

- Learn about the [PicoCalc hardware](picocalc.md)
- Review [Hardware Specifications](specifications.md) for complete technical details
- Check [Display & Input](display-input.md) for driver implementation details
- See [Hardware Compatibility](compatibility.md) for compatibility matrices
- Follow [Hardware Modifications](modifications.md) for installation guide
