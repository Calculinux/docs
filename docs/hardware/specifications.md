# Hardware Specifications

This page provides comprehensive technical specifications for all hardware components supported by Calculinux.

## PicoCalc Hardware

### Physical Specifications

| Specification | Details |
|--------------|---------|
| **Form Factor** | Pocket-sized handheld computer |
| **Display** | Built-in 320×320 LCD screen |
| **Input** | Full physical keyboard with compact layout |
| **Power** | USB-C port for charging, internal rechargeable battery |
| **Module Interface** | Custom connector for SBC modules |

### Display System

| Specification | Details |
|--------------|---------|
| **Interface** | SPI (Serial Peripheral Interface) |
| **Controller** | ILI9488 |
| **Resolution** | 320×320 pixels |
| **Text Mode** | 53 columns × 40 rows (6×8 font) |
| **Color Depth** | 16-bit RGB565 |
| **Refresh Rate** | ~30 FPS target (60Hz capable) |
| **SPI Speed** | 80 MHz (overclocked from 40 MHz standard) |
| **Backlight** | Controlled by STM32 MCU |

### Keyboard System

| Specification | Details |
|--------------|---------|
| **Type** | Physical matrix keyboard |
| **MCU** | STM32F103R8T6 (keyboard controller/southbridge) |
| **Interface** | I2C to main SBC |
| **I2C Address** | 0x1F |
| **I2C Bus** | i2c2 at 400kHz |
| **Layout** | Compact layout with function keys |
| **Features** | Mouse mode (dual shift), MCU-based matrix scanning |

### USB-C Ports

The PicoCalc has **TWO USB-C ports** with different functions:

| Port | Function | Notes |
|------|----------|-------|
| **PicoCalc USB-C Port** | Battery charging + Serial console | Console at 1500000 baud, connects to Lyra UART |
| **Lyra USB-C Port** | USB-OTG data only | Does NOT charge PicoCalc, requires 3.3V devices |

!!! info "Two Distinct USB-C Ports"
    - **PicoCalc port**: Accessible externally, charges battery, provides serial console access for debugging
    - **Lyra port**: Internal (requires case opening), USB host/device functionality, 3.3V only

### Power System

| Specification | Details |
|--------------|---------|
| **Battery** | Internal rechargeable lithium-ion |
| **Charging** | Via PicoCalc USB-C port |
| **Input Voltage** | 5V |
| **Power Consumption (Idle)** | ~0.5-0.52W |
| **Power Consumption (Active)** | ~0.59-0.60W |
| **Power Consumption (WiFi)** | ~0.63-1.1W |
| **Battery Life** | 2-4 hours typical (varies by usage) |

### Storage

| Type | Location | Notes |
|------|----------|-------|
| **Primary Storage** | MicroSD in Luckfox Lyra | Main system storage |
| **Expansion Storage** | MicroSD in PicoCalc slot | Additional storage via SPI (slower) |

## Luckfox Lyra Specifications

### Processor

| Component | Specification |
|-----------|--------------|
| **SoC** | Rockchip RK3506G2 |
| **CPU** | Triple-core ARM Cortex-A7 @ 1.2GHz + ARM Cortex-M0 |
| **Architecture** | ARMv7-A (32-bit) |
| **NPU** | 0.5 TOPS AI accelerator |

### Memory & Storage

| Component | Supported Configurations |
|-----------|-------------------------|
| **RAM** | 128MB DDR2 (only tested configuration) |
| **Flash Storage** | Optional SPI NAND (128MB-1GB, must be erased for SD boot) |
| **External Storage** | MicroSD card slot (primary boot device) |

!!! note "RAM Configuration"
    Only the 128MB RAM configuration has been tested with Calculinux. Other RAM variants (64MB, 256MB) exist but have different pinouts and would require custom adapter boards.

### Network Interfaces

| Interface | Availability | Notes |
|-----------|--------------|-------|
| **WiFi** | External USB adapter required | See supported chipsets below |
| **Ethernet** | Lyra Plus model only | 10/100 Mbps, untested with Calculinux |
| **Bluetooth** | Not supported | No Bluetooth hardware |

### Expansion Interfaces

All interfaces operate at **3.3V logic levels**:

| Interface | Status | Notes |
|-----------|--------|-------|
| **GPIO** | ✅ Available | External GPIO free (display/keyboard don't use) |
| **USB** | ✅ Available | Internal USB host/device, 3.3V only |
| **I2C** | ✅ Available | Multiple I2C buses |
| **I2S** | ❓ Untested | Audio interface available |
| **SPI** | ✅ Available | Shared with display |
| **UART** | ✅ Available | Serial communication |
| **MIPI DSI** | 🚧 Possible | For alternate displays (22-pin CM4 connector) |

!!! danger "Critical: 3.3V Logic Levels"
    **ALL interfaces operate at 3.3V ONLY.** Using 5V devices or signals will damage the hardware. Always verify voltage compatibility before connecting peripherals.

### Display Interface Details

| Parameter | Value |
|-----------|-------|
| **SPI Bus** | spi0 |
| **SPI Mode** | 0 (CPOL=0, CPHA=0) |
| **Max Speed** | 80 MHz |
| **Chip Select** | GPIO0 RK_PA4 |
| **Data/Command** | GPIO0 RK_PA3 |
| **Reset** | GPIO0 RK_PA2 |

### Keyboard Interface Details

| Parameter | Value |
|-----------|-------|
| **Interface** | I2C |
| **Bus** | i2c2 |
| **Address** | 0x1F |
| **Speed** | 400 kHz (Fast Mode) |
| **SCL Pin** | GPIO0 RK_PB2 |
| **SDA Pin** | GPIO0 RK_PB3 |

## Supported WiFi Chipsets

The following USB WiFi adapters are supported (must operate at **3.3V**):

### Enabled in Current Kernel

- **RTL8192CU** - Realtek single-band USB adapter
- **R8712U** - Realtek single-band USB adapter
- **R8188EU** - Realtek single-band USB adapter
- **RTL8723BS** - Realtek dual-band (SDIO/USB)

### Requiring Kernel Configuration

The following chipsets have drivers available but are not currently enabled:

- RTL8723DU
- RTL8812AU
- RTL8814AU
- RTL8821CU
- RTL88X2BU
- RTL8188FU
- RTL8188FTV
- RT2800 series
- MT7612U
- MT7610U
- RT5370

!!! warning "3.3V Requirement for WiFi"
    USB WiFi adapters **must operate at 3.3V** as the Lyra's USB provides only 3.3V power. Standard 5V USB adapters will not work and may damage the board. Use an externally powered USB hub for 5V devices.

## Boot Priority

The RK3506G2 boot ROM follows this priority:

1. **SPI NAND** (if present and programmed)
2. **SD Card** (if SPI NAND is erased or absent)
3. **USB Boot** (for recovery/programming)

!!! danger "SPI NAND Boot Priority"
    If your Luckfox Lyra has SPI NAND flash, you **must erase it** or the boot ROM will ignore the SD card. See the [SPI NAND Erase Guide](../troubleshooting/erase-nand.md) for detailed instructions.

## Luckfox Lyra Variants

| Model | RAM | Storage | Ethernet | Status with Calculinux |
|-------|-----|---------|----------|----------------------|
| **Luckfox Lyra** | 128MB | SD only | No | ✅ Fully Supported |
| **Luckfox Lyra (SPI NAND)** | 128MB | SPI NAND + SD | No | ✅ Supported (NAND must be erased) |
| **Luckfox Lyra Plus** | 128MB | SPI NAND + SD | Yes (10/100) | ❓ Untested |

!!! note "Other Lyra Models"
    Other Luckfox Lyra variants exist (64MB, 256MB RAM, different SoC models) but have different pinouts and are not compatible without custom adapter boards.

## Thermal Considerations

| Condition | Details |
|-----------|---------|
| **Normal Operation** | No heatsink required for typical console use |
| **Heavy Load** | Monitor temperatures during intensive tasks |
| **Enclosed Design** | PicoCalc case limits airflow, consider heat dissipation |

## Power Supply Requirements

| Component | Requirement |
|-----------|------------|
| **Input Voltage** | 5V DC |
| **Minimum Current** | 2A |
| **Recommended** | 5V 2A or higher USB power supply |
| **Cable** | USB-C data-capable cable |

!!! tip "Power Supply Recommendations"
    - Use a quality USB-C cable (not just charging cables)
    - Ensure power supply can deliver stable 2A
    - Under-voltage can cause system instability and boot failures
    - Quality power supplies reduce risk of data corruption

## Console Display Specifications

| Parameter | Value |
|-----------|-------|
| **Physical Resolution** | 320×320 pixels |
| **Console Font** | 6×8 pixels per character |
| **Text Area** | 53 columns × 40 rows |
| **Color Support** | 16-bit color (RGB565) |
| **Frame Rate** | 30 FPS target |

!!! note "Small Text Console"
    The 53×40 text area is smaller than standard terminals (typically 80×24 or larger). Many applications may require:
    
    - Horizontal scrolling for wide output
    - Setting `COLUMNS=53 LINES=40` environment variables
    - Using compact display modes when available

## Related Documentation

- [PicoCalc Overview](picocalc.md) - Device overview and design
- [Luckfox Lyra](luckfox-lyra.md) - SDK, purchasing, software details
- [Display & Input](display-input.md) - Driver implementation details
- [Hardware Compatibility](compatibility.md) - Compatibility matrices
- [Hardware Modifications](modifications.md) - Installation and modification guides

---

**Note**: This page is the canonical reference for all hardware specifications. Other pages should link here rather than duplicating these details.
