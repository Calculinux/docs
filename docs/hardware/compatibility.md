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

!!! info "No Built-in Network Hardware"
    Neither the PicoCalc nor Luckfox Lyra include built-in WiFi or Ethernet. Network connectivity requires external USB adapters (3.3V compatible) connected to the USB header.

| Connectivity | Hardware Required | Status | Notes |
|--------------|-------------------|--------|-------|
| **Ethernet** | USB Ethernet adapter | ✅ Supported | See supported chipsets below |
| **WiFi** | USB WiFi adapter (3.3V) | ✅ Supported | See supported chipsets below |

## Storage Compatibility

### MicroSD Cards

| Brand/Type | Speed Class | Size | Status | Notes |
|------------|-------------|------|--------|-------|
| **SanDisk Ultra** | Class 10 | 8-32 GB | ✅ Recommended | Good reliability |
| **SanDisk Extreme** | UHS-I | 16-64 GB | ✅ Excellent | Fastest option |
| **Samsung EVO** | Class 10 | 8-32 GB | ✅ Recommended | Good value |
| **Generic/No-Name** | Varies | Any | ⚠️ Use Caution | May be slow or unreliable |

**Recommendations**:
- **Minimum**: 8 GB Class 10
- **Recommended**: 16 GB UHS-I
- **Optimal**: 32 GB SanDisk/Samsung branded

### USB Storage

| Type | Status | Notes |
|------|--------|-------|
| **USB Flash** | ✅ Supported | Via USB-OTG adapter |
| **USB HDD/SSD** | ✅ Supported | Requires powered hub |
| **USB Card Reader** | ✅ Supported | Additional storage expansion |

## Display Compatibility

### Integrated Display

| PicoCalc Model | Display Type | Status |
|----------------|--------------|--------|
| **PicoCalc (Original)** | ST7789 LCD | ✅ Fully Supported |
| **PicoCalc (Variant)** | Similar LCD | ✅ Should work |

### External Displays

| Connection Type | Status | Notes |
|-----------------|--------|-------|
| **HDMI** | ❌ Not Available | RV1106 has no HDMI |
| **USB Display** | 🚧 Untested | May work with DisplayLink |
| **SPI Display** | ⚠️ Conflicts | Would conflict with internal display |

## Input Device Compatibility

### Integrated Keyboard

| PicoCalc Model | Keyboard | Status |
|----------------|----------|--------|
| **All Models** | Matrix Keyboard | ✅ Fully Supported |

### External Input

| Device Type | Connection | Status | Notes |
|-------------|------------|--------|-------|
| **USB Keyboard** | USB-OTG | ✅ Supported | Full size keyboard |
| **USB Mouse** | USB-OTG | ✅ Supported | Basic cursor support |
| **Bluetooth Keyboard** | BT Dongle | 🚧 Untested | Requires USB BT adapter |
| **Touchscreen** | N/A | ❌ Not Available | PicoCalc has no touch |

## Network Hardware

### USB Network Adapters

#### USB WiFi Adapters (3.3V Required)

**Supported Realtek Chipsets:**

| Chipset | Type | Status | Notes |
|---------|------|--------|-------|
| **RTL8723DU** | Dual-band | ✅ Supported | Included in image |
| **RTL8812AU** | AC1200 dual-band | ✅ Supported | Included in image |
| **RTL8814AU** | AC1900 quad-antenna | ✅ Supported | Included in image |
| **RTL8821CU** | AC600 compact | ✅ Supported | Included in image |
| **RTL88X2BU** | AC1200 | ✅ Supported | Included in image |

**Additional Chipsets (Pending Support):**

| Chipset | Type | Status | Notes |
|---------|------|--------|-------|
| **RTL8188FU** | Single-band | 🚧 Planned | Community tested, driver available |
| **RTL8188FTV** | Single-band | 🚧 Planned | Successfully tested by community |
| **RT2800 series** | Various | 🚧 Planned | Ralink/MediaTek drivers exist |
| **MT7612U** | AC dual-band | 🚧 Planned | MediaTek, community confirmed |
| **MT7610U** | AC single-band | 🚧 Planned | MediaTek chipset |
| **RT5370** | Single-band | 🚧 Planned | Ralink Technology |

!!! danger "Critical 3.3V Requirement"
    **ALL USB WiFi adapters MUST operate at 3.3V** as they connect to the Lyra's USB header, not standard 5V USB. Using 5V adapters will damage the board. Verify voltage compatibility before purchase.

### Alternative WiFi Solutions (Pending Support)

| Solution | Connection | Status | Notes |
|----------|------------|--------|-------|
| **ESP32-C3 SPI WiFi** | SPI (SD card socket) | 🚧 Community tested | Works but not yet in official image |
| **Custom SPI modules** | SPI interface | 🚧 Experimental | Community development ongoing |
| **External antenna mods** | USB header + antenna | 🚧 Advanced users | Hardware modification required |

!!! info "Alternative Connectivity"
    These solutions are possible but not yet officially supported. Community members have successfully implemented some of these approaches.

#### USB Ethernet Adapters

!!! warning "3.3V Requirement"
    USB WiFi adapters must operate at 3.3V as they connect to the Lyra's USB header, not standard 5V USB.

#### USB Ethernet Adapters

| Chipset | Status | Notes |
|---------|--------|-------|
| **RTL8152** | ✅ Recommended | Common, well-supported |
| **AX88179** | ✅ Supported | USB 3.0 adapter |

### Built-in Network

| Model | Interface | Speed | Status |
|-------|-----------|-------|--------|
| **Lyra Ethernet** | 10/100 | 100 Mbps | ✅ Supported |
| **Lyra Basic** | None | N/A | ➖ Use USB adapter |

## Power Supply Compatibility

### USB-C Power

| Specification | Status | Notes |
|--------------|--------|-------|
| **5V/1A** | ⚠️ Minimum | May be unstable under load |
| **5V/2A** | ✅ **Recommended** | Reliable for all uses |
| **5V/3A** | ✅ Excellent | Best for USB peripherals |
| **USB-PD** | ✅ Compatible | Will negotiate 5V |

### Battery Power

| Battery Type | Capacity | Status | Notes |
|--------------|----------|--------|-------|
| **PicoCalc Internal** | ~2000mAh | ✅ Supported | Original battery |
| **USB Power Bank** | Varies | ✅ Supported | Any 5V bank |
| **LiPo (Custom)** | >2000mAh | ⚠️ Advanced | Requires modification |

## Peripheral Compatibility

### USB Peripherals

| Device Type | Status | Notes |
|-------------|--------|-------|
| **USB Hub** | ✅ Supported | Powered hub recommended |
| **USB Storage** | ✅ Supported | Flash drives, HDDs |
| **USB Audio** | 🚧 Should Work | May need drivers |
| **USB Serial** | ✅ Supported | FTDI, CH340, etc. |
| **USB Camera** | 🚧 Untested | V4L2 support needed |

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

## Testing Status

### Tested Configurations

| Configuration | Test Date | Status | Tester |
|--------------|-----------|--------|--------|
| Lyra 128MB + 16GB SD | Mar 2025 | ✅ Working | hisptoot |
| Lyra 256MB + 32GB SD | TBD | 🚧 Testing | Community |
| Lyra 64MB + 8GB SD | TBD | 🚧 Testing | Community |

### Known Issues

| Issue | Affected Hardware | Status | Workaround |
|-------|------------------|--------|------------|
| SPI NAND Boot | Lyra with NAND | ✅ Documented | Erase NAND first |
| Slow SD Cards | Generic cards | ⚠️ Known | Use branded cards |
| USB Power Issues | Weak chargers | ⚠️ Known | Use 2A+ charger |

## Community Testing

We need community help testing various hardware combinations!

### Untested Configurations

Help us test these combinations:

- [ ] Different SD card brands and speeds
- [ ] Various USB Ethernet adapters
- [ ] USB WiFi dongles
- [ ] USB audio devices
- [ ] Different power supplies

### How to Report

If you test a configuration:

1. Open an issue on [GitHub](https://github.com/Calculinux/meta-calculinux/issues)
2. Include:
   - Hardware model and version
   - SD card brand and size
   - Power supply specs
   - Any peripherals connected
   - What works / doesn't work
3. Use the "Hardware Compatibility Report" template

## Recommended Configurations

### Budget Build

- **SBC**: Luckfox Lyra 128MB (basic)
- **Storage**: SanDisk Ultra 16GB
- **Power**: Generic 5V/2A USB charger
- **Use Case**: Console, development, learning
- **Cost**: ~$30-40

### Standard Build

- **SBC**: Luckfox Lyra 128MB (standard)
- **Storage**: SanDisk Extreme 32GB
- **Power**: Quality 5V/2A adapter
- **Extras**: USB WiFi or Ethernet adapter (3.3V)
- **Use Case**: General use, networking, projects
- **Cost**: ~$45-60

### Premium Build

- **SBC**: Luckfox Lyra 256MB (ethernet)
- **Storage**: Samsung EVO Plus 64GB
- **Power**: 5V/3A PD adapter
- **Extras**: USB hub, peripherals, network adapters
- **Use Case**: Development, heavy workloads
- **Cost**: ~$60-80

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
