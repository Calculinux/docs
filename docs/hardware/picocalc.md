# PicoCalc Overview

The **PicoCalc** is a pocket-sized handheld computing device created by ClockworkPi that features a modular design allowing for different computing modules.

## What is PicoCalc?

PicoCalc is a unique handheld device that combines:

- A physical keyboard layout
- A built-in display
- A modular SBC (Single Board Computer) slot
- USB-C connectivity
- Battery power capability

!!! info "About the Name"
    The "PicoCalc" name suggests its intended purpose for calculation and computation work, though it's primarily a clever branding choice rather than a literal description. The device is roughly the size of a large calculator but is designed as a general-purpose computing platform.

## Original Hardware

The PicoCalc originally ships with a **Raspberry Pi Pico** or **RP2040-based** microcontroller running **PicoMite MMBasic**. While functional for programming tasks and computation, replacing this with a more powerful SBC unlocks the device's full potential as a pocket Linux computer.

## Why Replace the SBC?

Upgrading from the stock microcontroller to an SBC like the Luckfox Lyra provides:

- **Full Linux OS** instead of firmware
- **Significantly more processing power**
- **More RAM** (typically 64MB-256MB vs. 264KB)
- **Network connectivity** options
- **Storage expansion** via SD card
- **Rich software ecosystem**

## Physical Specifications

| Specification | Details |
|--------------|---------|
| **Dimensions** | Pocket-sized handheld form factor |
| **Display** | Built-in LCD screen |
| **Input** | Physical keyboard with compact layout |
| **Power** | USB-C port, battery operation |
| **Module Interface** | Custom connector for SBC modules |

## Display

The PicoCalc features an integrated LCD display that requires proper driver support in the Linux kernel. Key characteristics:

- LCD panel with SPI interface
- Resolution: (specifications to be documented)
- Requires custom kernel drivers for Linux support

## Keyboard

The keyboard provides:

- Compact key layout suitable for programming and computation
- Matrix keyboard interface
- Requires custom kernel drivers for Linux support
- Includes numeric keypad and function keys

!!! note "Keyboard Layout"
    While the PicoCalc includes a numeric keypad among other keys, it's designed as a general-purpose input device rather than a traditional calculator keypad. The layout is optimized for programming and computational work.

## Module Connector

The internal connector provides:

- Power delivery to the SBC
- Display interface (SPI)
- Keyboard interface
- GPIO access
- USB connectivity

!!! warning "Hardware Modification Required"
    Installing a Luckfox Lyra or similar SBC requires opening the PicoCalc case and replacing the original board. This process involves careful handling of the internal connector and components. See [Hardware Modifications](modifications.md) for detailed instructions.

## Compatibility

The PicoCalc's modular design potentially supports various SBCs with the right adapters and modifications:

- ✅ **Luckfox Lyra** - Fully supported by Calculinux
- 🚧 **Milk-V Duo** - Future support planned
- ❓ **Other SBCs** - Community experimentation ongoing

See the [Compatibility Matrix](compatibility.md) for detailed information.

## Resources

- **Official Product Page**: [ClockworkPi PicoCalc](https://www.clockworkpi.com/)
- **Community Forum**: [PicoCalc Category](https://forum.clockworkpi.com/c/picocalc/31)
- **Hardware Discussion**: [Forum Thread](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280)

## Next Steps

- Learn about the [Luckfox Lyra](luckfox-lyra.md) SBC
- Review [Hardware Modifications](modifications.md) guide
- Check [Display & Input](display-input.md) technical details
