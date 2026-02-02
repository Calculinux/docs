# Hardware Compatibility Matrix

This page provides a comprehensive compatibility matrix for different hardware combinations with Calculinux.

## SBC Compatibility

| SBC Model | Status | RAM Options | Notes |
|-----------|--------|-------------|-------|
| **Luckfox Lyra** | ✅ Fully Supported | 128 MB | Primary platform |
| **Luckfox Lyra (SPI NAND)** | ✅ Supported | 128 MB | Requires NAND erase |
| **Luckfox Lyra Plus** | ❓ Unknown | 128 MB | RK3506-based with Ethernet (untested) |
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

Calculinux currently supports the Luckfox Lyra board with 128 MB RAM. View compatibility details by category:

=== "Supported Variants"

    | RAM | Storage | Status | Notes |
    |-----|---------|--------|-------|
    | **128 MB** | SD Card Only | ✅ **Recommended** | Simplest setup |
    | **128 MB** | SPI NAND + SD | ✅ Supported | Requires NAND erase first |

    !!! note "Other Lyra Models"
        - **Luckfox Lyra Plus**: RK3506-based with Ethernet (untested with Calculinux)
        - **256 MB Lyra variants**: Would require custom adapter boards due to different pinouts; community members are experimenting with this

=== "By Storage Type"

    | Storage | Boot Priority | Calculinux Support |
    |---------|---------------|-------------------|
    | **SD Card Only** | Primary | ✅ **Recommended** - simplest setup |
    | **SPI NAND + SD** | NAND first | ✅ Supported after NAND erase |

=== "By Network Capability"

    !!! info "Limited Network Options"
        The basic Luckfox Lyra has no built-in networking. The Luckfox Lyra Plus with Ethernet would require a custom 3D-printed backplate to access the port and has not been tested with Calculinux. USB WiFi adapters are the only tested networking option.

    | Connectivity | Hardware Required | Status | Notes |
    |--------------|-------------------|--------|-------|
    | **Luckfox Lyra Plus (Ethernet)** | Custom backplate | ❓ Untested | Plus model has Ethernet but not tested |
    | **USB WiFi** | USB WiFi adapter (3.3V or powered hub) | ✅ Supported | Only tested networking option |

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

### PicoCalc External SD Card Slot

| Type | Status | Notes |
|------|--------|-------|
| **Internal Lyra Storage** | ✅ Fully Supported | Main SD card and optional SPI NAND |
| **PicoCalc SD Card Slot** | ✅ Supported | Accessible external SD card slot on PicoCalc for additional storage |
| **External USB Storage (OTG)** | 🧪 Experimental | Via Lyra's USB-C port with 3.3V devices or powered hub |

!!! info "USB-C OTG Support"
    The Lyra's USB-C port supports USB On-The-Go functionality, enabling connection of external USB storage devices. However, this requires 3.3V compatible devices or an externally powered USB hub. This feature is currently experimental and may require additional configuration.

## Display Compatibility

### Integrated Display

| PicoCalc Model | Display Type | Status |
|----------------|--------------|--------|
| **PicoCalc** | ILI9488 LCD | ✅ Fully Supported |

### Replacement Display Options

| Display Type | Connector | Size Requirement | Status |
|--------------|-----------|------------------|--------|
| **MIPI DSI (Higher Resolution)** | 22-pin (CM4 compatible) | 3.95" diagonal, square | 🚧 Possible |
| **Original ILI9488** | SPI | 320×320 | ✅ Standard |

!!! info "MIPI DSI Display Upgrade"
    Higher resolution MIPI DSI displays are possible if they use the same 22-pin connector found on Raspberry Pi Compute Module IO boards. The display must be square format and exactly 3.95" diagonal to fit within the PicoCalc enclosure. This would require hardware modification and custom driver configuration.

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

## Networking and WiFi

This section consolidates networking options, USB gadget networking, and WiFi compatibility.

=== "Networking Options"

    ### Built-in Network

    | Model | Interface | Speed | Status |
    |-------|-----------|-------|--------|
    | **Lyra Plus** | Ethernet (10/100) | 100 Mbps | ❓ Untested - Requires custom backplate |
    | **Lyra** | None | N/A | N/A - USB WiFi adapters supported |

    !!! info "Network Options"
        - **Luckfox Lyra**: No built-in networking. USB WiFi adapters (3.3V or via powered hub) are the only tested option.
        - **Luckfox Lyra Plus**: Has built-in Ethernet but has not been tested with Calculinux and would require a custom 3D-printed backplate to access the port.

=== "USB Gadget Networking"

    !!! info "USB Gadget Networking"
        Calculinux includes USB gadget networking over the Lyra USB-C port. Connect the PicoCalc to your host via USB-C, and the device appears as a USB Ethernet adapter.

    **Defaults:**

    - **Device IP**: 192.168.7.2/24
    - **Interface**: usb0
    - **Mode**: ECM (Linux/macOS), RNDIS (Windows)

    **Quick SSH:**

    - `ssh pico@192.168.7.2` (password: `calc`)

    For detailed setup steps and troubleshooting, see the USB gadget networking section in the [Hardware Specifications](specifications.md).

=== "WiFi Drivers"

    The following WiFi chipsets have drivers enabled in the Calculinux kernel:

    **Realtek:**

    - **RTL8192CU** - Single-band USB adapter
    - **R8712U** - Single-band USB adapter
    - **R8188EU** - Single-band USB adapter
    - **RTL8723BS** - Dual-band (SDIO/USB)

    **Ralink/MediaTek:**

    - **RT2500USB** - Legacy 802.11b/g
    - **RT73USB** - Legacy 802.11b/g
    - **RT2800USB** - 802.11n with variants: RT33XX, RT35XX, RT3572, RT5370, RT5372, RT55XX
    - **MT7601U** - Single-band 802.11n
    - **MT7663U** - Dual-band 802.11ac
    - **MT7921U** - Dual-band 802.11ax (WiFi 6)

    **Atheros:**

    - **AR5523** - Legacy 802.11a/b/g
    - **ATH9K_USB** - 802.11n
    - **AR9170_USB** - 802.11n

    **AIC:**

    - **AIC8800DC** - Single-band 802.11n (out-of-tree module)

    **Others:**

    - **ZD1211RW** - Zydas 802.11b/g
    - **LIBERTAS_USB** - Marvell 802.11b/g

=== "Tested WiFi Adapters"

    The following USB WiFi adapters have been tested with Calculinux:

    | Model | Type | Notes | Link |
    |-------|------|-------|------|
    | **RTL8188FTV/FU** | USB module | Requires soldering; 3.3V native | [AliExpress](https://www.aliexpress.us/item/3256807590709883.html) |
    | **AIC8800DC** | USB adapter | Requires cable; 3.3V tolerant | [AliExpress](https://www.aliexpress.us/item/3256805850412278.html) |
    | **RTL8188EU** | USB adapter | Requires cable; 3.3V tolerant | [Amazon](https://a.co/d/gRErxAn) |

    !!! note "USB Adapter Connection"
        USB WiFi adapters require a USB-C cable (similar to [this Waveshare cable](https://a.co/d/hQKiBRK)) to connect to the Lyra's USB-C port. The cable is a very tight fit inside the PicoCalc enclosure and may require rear casing modifications or a 3D-printed case.

    !!! note "USB Modules vs. Adapters"
        - **USB Modules** (like RTL8188FTV) are compact circuit boards with castellated edges that require soldering. Most modules support 3.3V natively, providing better stability at low battery levels.
        - **USB Adapters** are standard USB devices that plug directly into a cable but require an external USB cable.

    !!! warning "3.3V Requirement"
        USB WiFi adapters **must operate at 3.3V** as the Lyra's USB provides only 3.3V power. Use an externally powered USB hub for 5V devices. Many USB adapters are 5V rated but tolerate 3.3V due to voltage regulator design, but may malfunction at low battery levels.

=== "Future WiFi Support"

    The following chipsets have drivers available in the kernel but are not currently enabled. They may be enabled in future releases:

    - MT7612U, MT7610U (MediaTek)

## Power Supply Compatibility

### Internal Battery Power

| Power Source | Status | Notes |
|--------------|--------|-------|
| **PicoCalc Internal Battery** | ✅ Fully Supported | Rechargeable lithium-ion |
| **PicoCalc USB-C Port** | ✅ Supported | Battery charging + serial console to Lyra |
| **Lyra USB-C Port** | ✅ Supported | USB-OTG data only (does NOT charge PicoCalc) |

!!! info "Two USB-C Ports"
    The PicoCalc has TWO USB-C ports with different functions:

    - **PicoCalc USB-C Port**: Used for charging the internal battery and provides a USB serial console connection to the Lyra (at 1500000 baud)
    - **Lyra USB-C Port**: Provides USB On-The-Go (OTG) functionality for external devices or connection to a host PC, but does NOT charge the PicoCalc batteries. External devices must use an externally powered hub.

## Peripheral Compatibility

### Internal Peripherals

| Device Type | Status | Notes |
|-------------|--------|-------|
| **Display** | ✅ Fully Supported | Integrated LCD |
| **Keyboard** | ✅ Fully Supported | Matrix keyboard |
| **Lyra Storage** | ✅ Fully Supported | Lyra's SD card, optional NAND |
| **PicoCalc SD Card Slot** | ✅ Fully Supported | External SD card accessible on PicoCalc |

### Expansion Interfaces

!!! info "Internal Expansion Options"
    While the Luckfox Lyra is enclosed within the PicoCalc, it provides multiple expansion interfaces accessible for hardware modifications and custom projects. For detailed pinout information, see the [official Luckfox Lyra pinout documentation](https://wiki.luckfox.com/Luckfox-Lyra/Pinout).

| Interface | Voltage | Status | Notes |
|-----------|---------|--------|-------|
| **GPIO** | 3.3V | ✅ Available | External GPIO pins are free (display/keyboard do not use them) |
| **USB** | 3.3V | ✅ Available | Internal USB host/device |
| **I2C** | 3.3V | ✅ Available | I2C bus for sensors/peripherals |
| **I2S** | 3.3V | ❓ Untested | Audio interface available but untested |
| **SPI** | 3.3V | ✅ Available | SPI interface (shared with display) |
| **UART** | 3.3V | ✅ Available | Serial communication |

!!! warning "3.3V Logic Level Requirement"
    **CRITICAL**: All interfaces operate at **3.3V logic levels only**. Using 5V devices or signals will damage the hardware. The PicoCalc is designed for tinkering and experimentation, but proper voltage levels must be maintained.

### Expansion Peripheral Compatibility

| Peripheral Type | Interface | Status | Notes |
|----------------|-----------|--------|-------|
| **Sensors** | I2C/SPI | ✅ Compatible | Temperature, accelerometer, etc. |
| **External Storage** | USB 3.3V | ✅ Compatible | Flash drives, custom storage |
| **Network Modules** | USB/SPI | 🚧 Possible | WiFi/cellular modules (3.3V) |
| **Audio Devices (I2S)** | I2S | ❓ Untested | External audio codecs via I2S interface |
| **Audio Devices (PWM)** | GPIO (PWM) | ⚠️ Limited | See PWM audio note below |
| **Replacement Displays** | MIPI DSI | 🚧 Possible | 22-pin connector, 3.95" square |
| **Additional SPI Displays** | SPI | ⚠️ Conflicts | Would conflict with main display |
| **Input Devices** | GPIO/I2C | 🚧 Possible | Additional buttons, encoders |
| **Communication** | UART/USB | ✅ Compatible | Serial devices, modems |

!!! info "PWM Audio Details"
    The PicoCalc has built-in audio support using PWM (Pulse Width Modulation) on GPIO pins. However, there are significant limitations:

    - The Lyra's PWM is not available on the correct pins without hardware modification
    - Software PWM must be used instead on pins with only 1.2V tolerance
    - This results in **low volume** audio and **high CPU usage**
    
    For proper audio, hardware modifications are needed to access the correct PWM pins or use the I2S interface. See the [Hardware Modifications guide](modifications.md) for details on enabling full-volume audio (documentation stub - refer to the [ClockworkPi forum](https://forum.clockworkpi.com/) for community solutions).

!!! note "Custom Hardware Projects"
    These expansion options enable custom hardware projects and modifications for advanced users comfortable with electronics work.

## Software Compatibility

!!! info "Console-Only System"
    Calculinux is currently a **console-only** system with no graphical desktop environment. All interaction is via text terminal. This is by design to maximize performance on limited hardware (128 MB RAM).

### Console Applications

All console applications work well with the 128 MB RAM configuration:

| Application Type | Status | Notes |
|------------------|--------|-------|
| **Terminal Apps** | ✅ Fully Supported | All work well |
| **Text Editor (vim/nano)** | ✅ Fully Supported | All work well |
| **Scripting (Python/Bash)** | ✅ Fully Supported | All work well |
| **Development Tools** | ✅ Fully Supported | All work well |
| **Command-line Tools** | ✅ Fully Supported | All work well |

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

We need community help testing different hardware combinations!

### Untested Configurations

Help us test these combinations:

- [ ] Different SD card brands (though performance differences are likely minimal)
- [ ] Additional applications (request inclusion!)
- [ ] Luckfox Lyra Plus (Ethernet model) with custom backplate

### How to Report

If you test a configuration:

1. Open an issue on [GitHub](https://github.com/Calculinux/meta-calculinux/issues)
2. Include:
   - Hardware model and version
   - SD card brand and size
   - Any peripherals connected
   - What works / doesn't work
3. Use the "Hardware Compatibility Report" template

## Future Hardware Support

### Planned

- **Milk-V Duo**: Similar form factor, RISC-V processor
- **Custom Carrier Boards**: Community-designed alternatives

### Under Consideration

- **Pine64 Ox64**: RISC-V option
- **Raspberry Pi alternatives**: If form factor matches

## Next Steps

- Review [Hardware Requirements](../getting-started/hardware-requirements.md)
- Check [Luckfox Lyra details](luckfox-lyra.md)
- See [Hardware Modifications](modifications.md) guide
