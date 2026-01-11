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

For detailed technical specifications including display, keyboard, power, and interface details, see the [Hardware Specifications](specifications.md) page.

**Quick Overview:**
- Pocket-sized handheld computer form factor
- 320×320 pixel LCD display with ILI9488 controller
- Full physical keyboard with compact layout
- Two USB-C ports (PicoCalc port and Lyra port with different functions)
- Internal rechargeable battery
- Modular SBC design

!!! warning "Hardware Modification Required"
    Installing a Luckfox Lyra or similar SBC requires opening the PicoCalc case and replacing the original board. This process involves careful handling of the internal connector and components. See [Hardware Modifications](modifications.md) for detailed instructions.

!!! warning "Screen Damage Risk"
    Some people have broken their screens while disassembling and reassembling the PicoCalc. Taping the screen in place from behind when placing it in the front bezel is recommended!

## Technical Details

For complete technical specifications including:
- Display system (ILI9488 controller, SPI interface, refresh rates)
- Keyboard system (STM32 MCU, I2C communication)
- USB-C ports (two ports with different functions)
- Power system (battery specs, consumption data)
- Storage options (internal and expansion SD cards)

See the [Hardware Specifications](specifications.md) page.

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

- Review [Hardware Specifications](specifications.md) for complete technical details
- Learn about the [Luckfox Lyra](luckfox-lyra.md) SBC
- Check [Hardware Modifications](modifications.md) installation guide
- See [Display & Input](display-input.md) for driver implementation details
- Review [Hardware Compatibility](compatibility.md) for supported hardware
