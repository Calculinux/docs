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
    The "PicoCalc" name suggests its intended purpose for calculation and computation work, though it's primarily a clever branding choice rather than a literal description. The device is roughly the size of a large calculator but is designed as a general-purpose pocket computing platform.

## Original Hardware

The PicoCalc originally ships with a **Raspberry Pi Pico** or **RP2040-based** microcontroller running **PicoMite MMBasic**. While functional for programming tasks and computation, replacing this with a more powerful SBC unlocks the device's full potential as a pocket Linux computer.

## Why Replace the SBC?

Upgrading from the stock microcontroller to an SBC like the Luckfox Lyra provides:

- **Full Linux OS** instead of PicoMite MMBasic
- **Significantly more processing power**
- **More RAM** (128MB vs. 264KB)
- **Network connectivity** options
- **Storage expansion** via multiple SD cards
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
- Resolution: 320x320
- Requires custom kernel drivers for Linux support

## Keyboard

The keyboard provides:

- Compact key layout suitable for programming and computation
- Matrix keyboard interface with a custom MCU connected over I2C
- Requires custom kernel drivers for Linux support
- Includes function keys and most keys on a standard keyboard.

!!! note "Keyboard Layout"
    The custom kernel drivers support a mouse mode if you press both shift keys at the same time, which converts the arrow keys to function as a mouse cursor. Using shift with the arrow keys outside of mouse mode sends pgup/pgdown/home/end keys.

## Module Connector

The internal connector provides:

- Power delivery to the SBC
- Display interface (SPI)
- Keyboard interface
- GPIO access
- USB connectivity

!!! warning "Hardware Modification Required"
    Installing a Luckfox Lyra or similar SBC requires opening the PicoCalc case and replacing the original board. This process involves careful handling of the internal connector and components. See [Hardware Modifications](modifications.md) for detailed instructions.

!!! warning "Screen Damage
    Some people have broken their screens while disassembling and reassembling the PicoCalc. Taping the screen in place from behind when placing it in the front bezel is recommended!

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
