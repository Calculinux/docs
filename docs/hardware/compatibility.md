# Hardware Compatibility Matrix

This page provides a comprehensive compatibility matrix for different hardware combinations with Calculinux.

## SBC Compatibility

| SBC Model | Status | RAM Options | Notes |
|-----------|--------|-------------|-------|
| **Luckfox Lyra** | ✅ Fully Supported | 64/128/256 MB | Primary platform |
| **Luckfox Lyra (SPI NAND)** | ✅ Supported | 128/256 MB | Requires NAND erase |
| **Milk-V Duo** | 🚧 Planned | 64 MB | Future support |
| **Milk-V Duo256** | 🚧 Planned | 256 MB | Future support |
| **Raspberry Pi Zero** | ❌ Not Compatible | N/A | Form factor mismatch |
| **Custom Boards** | ❓ Unknown | Varies | Community experiments |

**Legend**:
- ✅ Fully Supported - Works out of box with official images
- 🚧 Planned - Under development or planned for future
- ❓ Unknown - Not tested, may work with modifications
- ❌ Not Compatible - Known not to work

## Luckfox Lyra Variants

### Supported Variants

Calculinux currently supports two variants of the Luckfox Lyra board:

| RAM | Storage | Status | Notes |
|-----|---------|--------|-------|
| **128 MB** | SD Card Only | ✅ **Recommended** | Simplest setup |
| **128 MB** | SPI NAND + SD | ✅ Supported | Requires NAND erase first |

### Future Variants (Not Yet Supported)

| Variant | Notes | Status |
|---------|-------|--------|
| **Luckfox Lyra Zero W** | Built-in WiFi/Bluetooth | 🚧 Potential future support |
| **Luckfox Lyra Pi** | Core3506-based | 🚧 Potential future support |
| **Luckfox Lyra Plus** | RK3576-based | 🚧 Potential future support |
| **64MB variants** | Lower memory | 🚧 May work but untested |
| **256MB variants** | Higher memory | 🚧 May work but untested |

### By Memory Configuration

| RAM | Recommended Use | Status |
|-----|-----------------|--------|
| **64 MB** | Console/Terminal | ❓ Untested - may work |
| **128 MB** | General Use | ✅ **Recommended** for most applications |
| **256 MB** | Development | ❓ Untested - may work |

### By Storage Type

| Storage | Boot Priority | Calculinux Support |
|---------|---------------|-------------------|
| **SD Card Only** | Primary | ✅ **Recommended** - simplest setup |
| **SPI NAND + SD** | NAND first | ✅ Supported after NAND erase |
| **eMMC** | N/A | ❌ Not available on Lyra |

### By Network Capability

!!! info "Limited Network Options"
    The basic Luckfox Lyra has no built-in networking. An Ethernet variant exists but would require a custom 3D-printed backplate to access the port and has not been tested with Calculinux.

| Connectivity | Hardware Required | Status | Notes |
|--------------|-------------------|--------|-------|
| **Ethernet (Lyra variant)** | Custom backplate | 🚧 Untested | Ethernet model exists but not tested |
| **WiFi** | Not currently available | ❌ Not Supported | No practical solution at present |

## Storage Compatibility

### MicroSD Cards

| Brand/Type | Speed Class | Size | Status | Notes |
|------------|-------------|------|--------|-------|
| **SanDisk Ultra** | Class 10 | 8-32 GB | ✅ Recommended | Good reliability |
| **Samsung EVO** | Class 10 | 8-32 GB | ✅ Recommended | Good value |
| **Generic/No-Name** | Varies | Any | ⚠️ Use Caution | May be unreliable |

**Recommendations**:
- **Minimum**: 8 GB Class 10
- **Recommended**: 16-32 GB from reputable brand

!!! note "SD Card Performance"
    Given the hardware speeds, different SD card classes are unlikely to have significant impact on performance.

### USB Storage

| Type | Status | Notes |
|------|--------|-------|
| **Internal Storage** | ✅ Fully Supported | SD card and optional SPI NAND |
| **External USB (OTG)** | 🧪 Experimental | Via USB-C port with 3.3V devices or powered hub |

!!! info "USB-C OTG Support"
    The USB-C port supports USB On-The-Go functionality, enabling connection of external USB devices. However, this requires 3.3V compatible devices or an externally powered USB hub. This feature is currently untested and may require additional configuration.

## Display Compatibility

### Integrated Display

| PicoCalc Model | Display Type | Status |
|----------------|--------------|--------|
| **PicoCalc (Original)** | ST7789 LCD | ✅ Fully Supported |
| **PicoCalc (Variant)** | Similar LCD | ✅ Should work |

### Replacement Display Options

| Display Type | Connector | Size Requirement | Status |
|--------------|-----------|------------------|--------|
| **MIPI DSI (Higher Resolution)** | 22-pin (CM4 compatible) | 3.95" diagonal, square | 🚧 Possible |
| **Original ST7789** | SPI | 320×320 | ✅ Standard |

!!! info "MIPI DSI Display Upgrade"
    Higher resolution MIPI DSI displays are possible if they use the same 22-pin connector found on Raspberry Pi Compute Module IO boards. The display must be square format and exactly 3.95" diagonal to fit within the PicoCalc enclosure. This would require hardware modification and custom driver configuration.

### External Displays

| Connection Type | Status | Notes |
|-----------------|--------|-------|
| **HDMI** | ❌ Not Available | RV1106 has no HDMI |
| **USB Display** | 🧪 Experimental | May work with DisplayLink via USB-C OTG |
| **SPI Display** | ⚠️ Conflicts | Would conflict with internal display |

## Input Device Compatibility

### Integrated Keyboard

| PicoCalc Model | Keyboard | Status |
|----------------|----------|--------|
| **All Models** | Matrix Keyboard | ✅ Fully Supported |

### External Input

| Device Type | Connection | Status | Notes |
|-------------|------------|--------|-------|
| **USB Input Devices** | USB-C OTG | 🧪 Experimental | Requires 3.3V devices or powered hub |
| **Keyboard/Mouse** | USB-C OTG | 🧪 Experimental | May work with compatible devices |

!!! info "USB OTG Input Support"
    While the integrated matrix keyboard is the primary input method, external USB input devices may be possible via the USB-C OTG port. This requires 3.3V compatible devices or an externally powered USB hub and is currently untested.

## Network Hardware

### Built-in Network

| Model | Interface | Speed | Status |
|-------|-----------|-------|--------|
| **Lyra Ethernet** | 10/100 | 100 Mbps | 🚧 Untested - Requires custom backplate |
| **Lyra Basic** | None | N/A | ❌ No networking capability |

!!! warning "Ethernet Model Considerations"
    While a Luckfox Lyra variant with built-in Ethernet exists, it has not been tested with Calculinux and would require a custom 3D-printed backplate to access the Ethernet port within the PicoCalc enclosure.

## Power Supply Compatibility

### Internal Battery Power

| Power Source | Status | Notes |
|--------------|--------|-------|
| **PicoCalc Internal Battery** | ✅ Fully Supported | Rechargeable lithium-ion |
| **USB-C Charging/OTG** | ✅ Supported | Charging + OTG data (3.3V devices) |

!!! info "USB-C Dual Function"
    The USB-C port serves dual purposes: charging the internal battery and USB OTG functionality for external devices. External devices must be 3.3V compatible or use an externally powered hub.

## Peripheral Compatibility

### Internal Peripherals

| Device Type | Status | Notes |
|-------------|--------|-------|
| **Display** | ✅ Fully Supported | Integrated LCD |
| **Keyboard** | ✅ Fully Supported | Matrix keyboard |
| **Storage** | ✅ Fully Supported | SD card, optional NAND |

### Expansion Interfaces

!!! info "Internal Expansion Options"
    While the Luckfox Lyra is enclosed within the PicoCalc, it provides several expansion interfaces accessible for hardware modifications and custom projects. For detailed pinout information, see the [official Luckfox Lyra pinout documentation](https://wiki.luckfox.com/Luckfox-Lyra/Pinout).

| Interface | Voltage | Status | Notes |
|-----------|---------|--------|-------|
| **GPIO** | 3.3V | ✅ Available | Multiple GPIO pins accessible |
| **USB** | 3.3V | ✅ Available | Internal USB host/device |
| **I2C** | 3.3V | ✅ Available | I2C bus for sensors/peripherals |
| **SPI** | 3.3V | ✅ Available | SPI interface (shared with display) |
| **UART** | 3.3V | ✅ Available | Serial communication |

!!! warning "Advanced Users Only"
    Accessing these interfaces requires hardware modification skills and may void warranties. All interfaces operate at 3.3V logic levels.

### Expansion Peripheral Compatibility

| Peripheral Type | Interface | Status | Notes |
|----------------|-----------|--------|-------|
| **Sensors** | I2C/SPI | ✅ Compatible | Temperature, accelerometer, etc. |
| **External Storage** | USB 3.3V | ✅ Compatible | Flash drives, custom storage |
| **Network Modules** | USB/SPI | 🚧 Possible | WiFi/cellular modules (3.3V) |
| **Audio Devices** | I2C/SPI | 🚧 Possible | External audio codecs |
| **Replacement Displays** | MIPI DSI | 🚧 Possible | 22-pin connector, 3.95" square |
| **Additional SPI Displays** | SPI | ⚠️ Conflicts | Would conflict with main display |
| **Input Devices** | GPIO/I2C | 🚧 Possible | Additional buttons, encoders |
| **Communication** | UART/USB | ✅ Compatible | Serial devices, modems |

!!! note "Custom Hardware Projects"
    These expansion options enable custom hardware projects and modifications for advanced users comfortable with electronics work.

### GPIO Peripherals

!!! warning "GPIO Access Limited"
    Most GPIO pins are used by display and keyboard. External GPIO expansion is limited.

## Software Compatibility

!!! info "Console-Only System"
    Calculinux is currently a **console-only** system with no graphical desktop environment. All interaction is via text terminal. This is by design to maximize performance on limited hardware.

### User Interface

| Interface Type | RAM Requirement | Status | Notes |
|---------|----------------|--------|-------|
| **Console (Text)** | ~32 MB | ✅ Fully Supported | Current implementation |
| **Framebuffer Graphics** | Variable | 🚧 Future | Planned for future releases |
| **X11/Wayland Desktop** | >128 MB | 🚧 Future | Not currently available |

### Console Applications

| Application Type | 64 MB RAM | 128 MB RAM | 256 MB RAM |
|------------------|-----------|------------|------------|
| **Terminal Apps** | ✅ | ✅ | ✅ |
| **Text Editor (vim/nano)** | ✅ | ✅ | ✅ |
| **Scripting (Python/Bash)** | ⚠️ Basic | ✅ | ✅ |
| **Development Tools** | ⚠️ Basic | ✅ | ✅ |
| **Command-line Tools** | ✅ | ✅ | ✅ |

### Gaming and Entertainment (Community Tested)

!!! info "Community Testing Results"
    These applications have been tested by community members but may not be included in official Calculinux images.

| Application | Status | Notes |
|-------------|--------|-------|
| **Pico-8** | ✅ Working | Runs smoothly, audio requires hardware mod |
| **Doom (prboom)** | ✅ Working | Good performance, tested extensively |
| **RetroArch** | ⚠️ Issues | Has configuration problems |
| **tmux** | ✅ Working | Terminal multiplexer works well |
| **Framebuffer apps** | ✅ Working | FBV image viewer confirmed working |

!!! note "Gaming Performance"
    Gaming applications work but are limited by SPI display bandwidth. Not all emulators perform well due to hardware constraints.

## Testing Status

### Tested Configurations

| Configuration | Test Date | Status |
|--------------|-----------|--------|
| Lyra 128MB + 64GB SD | Mar 2025 | ✅ Working |



### Known Issues

| Issue | Affected Hardware | Status | Workaround |
|-------|------------------|--------|------------|
| SPI NAND Boot | Lyra with NAND | ✅ Documented | Erase NAND first |
| Slow SD Cards | External SD card | ⚠️ Known | Use internal storage for demanding tasks |

## Community Testing

We need community help testing various hardware combinations!

### Untested Configurations

Help us test these combinations:

- [ ] Different SD card brands (though performance differences are likely minimal)
- [ ] Various applications (request inclusion!)
- [ ] Luckfox Lyra Ethernet model with custom backplate

### How to Report

If you test a configuration:

1. Open an issue on [GitHub](https://github.com/Calculinux/meta-calculinux/issues)
2. Include:
   - Hardware model and version
   - SD card brand and size
   - Any peripherals connected
   - What works / doesn't work
3. Use the "Hardware Compatibility Report" template

## Recommended Configurations

### Budget Build

- **SBC**: Luckfox Lyra 128MB (basic)
- **Storage**: SanDisk Ultra 16GB
- **Use Case**: Console, development, learning
- **Cost**: ~$30-40

### Standard Build

- **SBC**: Luckfox Lyra 128MB 
- **Storage**: Samsung EVO 32GB
- **Use Case**: General use, projects
- **Cost**: ~$35-45

### Ethernet Build (Experimental)

- **SBC**: Luckfox Lyra 128MB (ethernet variant)
- **Storage**: Samsung EVO 32GB
- **Extras**: Custom 3D-printed backplate for Ethernet access
- **Use Case**: Network-connected projects (untested)
- **Cost**: ~$40-50 + custom backplate

## Future Hardware Support

### Planned

- **Milk-V Duo**: Similar form factor, RISC-V processor
- **Custom Carrier Boards**: Community-designed alternatives

### Under Consideration

- **Pine64 Ox64**: RISC-V option
- **ESP32-based boards**: Lower cost alternative
- **Raspberry Pi alternatives**: If form factor matches

## Next Steps

- Review [Hardware Requirements](../getting-started/hardware-requirements.md)
- Check [Luckfox Lyra details](luckfox-lyra.md)
- See [Hardware Modifications](modifications.md) guide
