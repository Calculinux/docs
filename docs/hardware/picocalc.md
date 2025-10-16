# PicoCalc Overview

The **PicoCalc** is a pocket-sized calculator device created by ClockworkPi that features a modular design allowing for different computing modules.

## What is PicoCalc?

PicoCalc is a unique handheld device that combines:

- A physical calculator-style keyboard
- A built-in display
- A modular SBC (Single Board Computer) slot
- USB-C connectivity
- Battery power capability

## Original Hardware

The PicoCalc originally ships with a **Raspberry Pi Pico** or **RP2040-based** microcontroller running PicoMite MMBasic. While functional for small and light programming tasks, replacing this with a more powerful SBC unlocks the device's full potential as a pocket Linux computer.

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
| **Dimensions** | Pocket-sized calculator form factor |
| **Display** | Built-in LCD screen |
| **Input** | Physical keyboard with calculator layout |
| **Power** | USB-C port, battery operation |
| **Module Interface** | Custom connector for SBC modules |

## Display

The PicoCalc features an integrated LCD display that requires proper driver support in the Linux kernel. Key characteristics:

- LCD panel with SPI interface
- Resolution: (specifications to be documented)
- Requires custom kernel drivers for Linux support

## Keyboard

The keyboard provides:

- Calculator-style key layout
- Matrix keyboard interface
- Requires custom kernel drivers for Linux support
- Includes number pad and function keys

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
