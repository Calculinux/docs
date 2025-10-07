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

### By Memory Configuration

| RAM | Recommended Use | Status |
|-----|-----------------|--------|
| **64 MB** | Console/Terminal | ✅ Supported, minimal desktop possible |
| **128 MB** | Light Desktop | ✅ **Recommended** for general use |
| **256 MB** | Full Desktop | ✅ Best performance, more apps |

### By Storage Type

| Storage | Boot Priority | Calculinux Support |
|---------|---------------|-------------------|
| **SD Card Only** | Primary | ✅ **Recommended** - simplest setup |
| **SPI NAND + SD** | NAND first | ✅ Supported after NAND erase |
| **eMMC** | N/A | ❌ Not available on Lyra |

### By Network Capability

| Model | Ethernet | WiFi | Notes |
|-------|----------|------|-------|
| **Basic** | ❌ | ❌ | No network hardware |
| **Ethernet** | ✅ | ❌ | 10/100 Mbps via USB adapter |
| **WiFi** | ❌ | 🚧 | Future USB WiFi dongle support |

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
| **USB Mouse** | USB-OTG | ✅ Supported | For GUI use |
| **Bluetooth Keyboard** | BT Dongle | 🚧 Untested | Requires USB BT adapter |
| **Touchscreen** | N/A | ❌ Not Available | PicoCalc has no touch |

## Network Hardware

### USB Network Adapters

| Type | Chipset | Status | Notes |
|------|---------|--------|-------|
| **USB Ethernet** | RTL8152 | ✅ Recommended | Well supported |
| **USB Ethernet** | AX88179 | ✅ Supported | USB 3.0 adapter |
| **USB WiFi** | RT5370 | 🚧 Should Work | Requires testing |
| **USB WiFi** | MT7601U | 🚧 Should Work | Requires testing |

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

### Desktop Environments

| Desktop | RAM Requirement | Status | Notes |
|---------|----------------|--------|-------|
| **Console Only** | ~32 MB | ✅ Fully Supported | Best for 64MB RAM |
| **Lightweight (LXDE)** | ~64 MB | ✅ Supported | Good for 128MB |
| **Standard (XFCE)** | ~128 MB | ✅ Supported | Recommended for 256MB |
| **Heavy (GNOME/KDE)** | >256 MB | ❌ Not Practical | Too resource intensive |

### Applications

| Application Type | 64 MB RAM | 128 MB RAM | 256 MB RAM |
|------------------|-----------|------------|------------|
| **Terminal Apps** | ✅ | ✅ | ✅ |
| **Text Editor** | ✅ | ✅ | ✅ |
| **Web Browser** | ❌ | ⚠️ Limited | ✅ |
| **Development Tools** | ⚠️ Basic | ✅ | ✅ |
| **Media Player** | ❌ | ⚠️ Audio | ✅ |

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
- **Extras**: USB Ethernet adapter
- **Use Case**: Desktop, networking, projects
- **Cost**: ~$45-60

### Premium Build

- **SBC**: Luckfox Lyra 256MB (ethernet)
- **Storage**: Samsung EVO Plus 64GB
- **Power**: 5V/3A PD adapter
- **Extras**: USB hub, peripherals
- **Use Case**: Full desktop, development
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
