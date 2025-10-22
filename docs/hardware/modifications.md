# Hardware Modifications

This guide covers the physical modifications required to install a Luckfox Lyra (or similar SBC) into your PicoCalc.

!!! danger "Warranty Warning"
    Opening your PicoCalc and replacing the SBC will void your warranty. Proceed at your own risk. This modification requires careful handling of small components and connectors.

## Prerequisites

### Tools Required

- Small Phillips screwdriver
- Plastic spudger or opening tool
- ESD-safe work surface (or ESD wrist strap)
- Tweezers (optional but helpful)
- Good lighting and magnification (optional)

### Parts Needed

- Luckfox Lyra SBC (see [compatible versions](luckfox-lyra.md#luckfox-lyra-versions))
- MicroSD card (8GB minimum, 16GB+ recommended)
- (Optional) Thermal pad or paste if concerned about heat

## Disassembly

### Step 1: Power Off and Disconnect

1. Power off the PicoCalc completely
2. Disconnect any USB cables
3. Remove any attached peripherals

### Step 2: Open the Case

!!! warning "Take Photos"
    Before disassembly, take photos of the original configuration. This helps during reassembly.

1. Locate the screws holding the case together (typically on the back)
2. Remove all screws and keep them organized
3. Carefully separate the case halves using a plastic spudger
4. Be mindful of any ribbon cables connecting the halves

### Step 3: Remove Original Board

1. Locate the existing RP2040/Pico board
2. Carefully disconnect the main connector
3. Note the orientation of the board and connector
4. Remove any screws holding the board in place
5. Gently lift the board out

!!! tip "Connector Orientation"
    The connector orientation is critical. The Luckfox Lyra must be installed with the same orientation as the original board. Mark or photograph the correct orientation. For reference pinout diagrams, consult the [official Luckfox Lyra pinout documentation](https://wiki.luckfox.com/Luckfox-Lyra/Pinout).

## Installation

### Step 4: Prepare Luckfox Lyra

Before installation:

1. **Erase SPI NAND** (if your board has it) - see [SPI NAND Erasing](#erasing-spi-nand)
2. Flash Calculinux to your microSD card - see [Installation Guide](../getting-started/installation.md)
3. Insert the prepared microSD card into the Luckfox Lyra

### Step 5: Install Luckfox Lyra

1. Position the Luckfox Lyra in the same orientation as the original board
2. Carefully align the connector with the PicoCalc socket
3. Gently but firmly press the connector into place
4. Secure the board with screws if mounting holes align
5. Verify the connection is seated properly

!!! caution "Connector Care"
    The connector is delicate. Apply even pressure and ensure proper alignment before pushing it in. Do not force it.

### Step 6: Reassembly

1. Route any cables carefully (avoid pinching)
2. Align the case halves
3. Gently press together until they click
4. Replace all screws
5. Verify nothing is binding or misaligned

## Erasing SPI NAND

If your Luckfox Lyra has SPI NAND flash, you **must** erase it for the board to boot from SD card.

### Method 1: Using Luckfox Tools

1. Download Luckfox SDK and tools from [GitHub](https://github.com/LuckfoxTECH/luckfox-pico)
2. Connect Luckfox Lyra via USB while holding boot button
3. Use `upgrade_tool` to erase NAND:
   ```bash
   upgrade_tool ef
   ```
4. Wait for confirmation message
5. Disconnect and reconnect power

### Method 2: Using U-Boot

If you can boot to U-Boot prompt:

```bash
# Erase entire NAND
nand erase.chip

# Or erase specific partition
sf probe 0
sf erase 0 0x1000000
```

### Method 3: From Running System

If you have a working Linux system on the board:

```bash
# Identify NAND device
cat /proc/mtd

# Erase NAND (assuming mtd0)
flash_erase /dev/mtd0 0 0
```

!!! tip "One-Time Operation"
    You only need to erase the NAND once. After erasing, the board will always boot from SD card (unless you reprogram the NAND).

## Pin Mapping

Understanding the pin connections helps with troubleshooting:

### Display Connection

| Luckfox Pin | Function | PicoCalc Connection |
|-------------|----------|---------------------|
| SPI MOSI | Data Out | LCD Data In |
| SPI SCK | Clock | LCD Clock |
| GPIO | CS (Chip Select) | LCD CS |
| GPIO | DC (Data/Command) | LCD DC |
| GPIO | Reset | LCD Reset |
| 3.3V | Power | LCD VCC |
| GND | Ground | LCD GND |

### GPIO and RMIO Pin Mapping

The Luckfox Lyra uses both standard GPIO and RMIO (Reconfigurable Multi-function IO) pins:

| PicoCalc Pin | Luckfox Equivalent | Type | Voltage | Notes |
|--------------|-------------------|------|---------|-------|
| GP2 | RMIO12 | RMIO | 3.3V | Reconfigurable |
| GP3 | RMIO13 | RMIO | 3.3V | Reconfigurable |
| GP4 | RMIO0 | RMIO | 3.3V | Used for audio (PWM) |
| GP5 | RMIO1 | RMIO | 3.3V | Reconfigurable |
| GP21 | RMIO26 | RMIO | 3.3V | Reconfigurable |
| GP28 | RMIO24 | RMIO | 3.3V | Reconfigurable |

!!! warning "GPIO Voltage Levels"
    - **RMIO pins**: 3.3V operation
    - **GPIO4_B3/GPIO4_B2**: 1.8V operation (not RMIO-capable)
    - Always verify voltage levels before hardware modifications

!!! info "Hardware PWM Limitation"
    Some GPIO pins (like GPIO4_B3 and GPIO4_B2) cannot output hardware PWM as they are not RMIO-capable. For audio modifications, use RMIO pins that support hardware PWM.

### Keyboard Matrix

The keyboard matrix connects via GPIO pins. Exact mapping is defined in the device tree. See [Display & Input](display-input.md) for details.

### Power

- **5V In**: From USB-C connector via PicoCalc board
- **3.3V Regulation**: On Luckfox Lyra board
- **Current Draw**: ~500mA typical, up to 1A peak

## Verification

After installation:

1. **Visual Check**: Ensure board is seated properly
2. **Power On**: Connect USB-C power
3. **Boot Check**: Look for display activity
4. **LED Indicators**: Observe any status LEDs on Luckfox board

If the system doesn't boot, see [Boot Problems](../troubleshooting/boot-problems.md).

## Common Issues

### Board Won't Boot

- **SPI NAND not erased**: Most common issue with NAND versions
- **SD card not flashed correctly**: Verify image integrity
- **Connector not seated**: Reseat the board carefully
- **Power insufficient**: Try different USB cable/adapter

### Display Not Working

- **Driver not loaded**: Check kernel logs
- **Connection issue**: Reseat display cable
- **Wrong device tree**: Verify correct DTB is loaded

### Keyboard Not Responsive

- **Driver not loaded**: Check kernel logs
- **GPIO mapping wrong**: Verify device tree configuration
- **Connection issue**: Reseat board connector

## Safety Considerations

### Electrical Safety

- Work on ESD-safe surface
- Avoid static discharge to components
- Never work on powered device
- Check for shorts before powering on

### Mechanical Safety

- Don't force connectors
- Handle PCBs by edges
- Watch for sharp edges on case
- Keep screws organized

### Thermal Considerations

- Luckfox can get warm under load
- Ensure adequate ventilation
- Consider thermal pad if needed
- Monitor temperatures initially

## Reverting to Original

To restore the original RP2040 board:

1. Follow disassembly steps above
2. Remove Luckfox Lyra
3. Reinstall original board in reverse order
4. Reflash original firmware if needed

!!! note "Keep Original Board"
    Store the original RP2040 board safely in case you want to revert or use it elsewhere.

## Advanced Modifications

### Optional Enhancements

- **Heat sink**: Add small heat sink to RV1106 SoC
- **Thermal pad**: Use thermal interface material
- **Mounting**: Create custom mounting bracket
- **Cables**: Add internal USB extension for easier access

### Future Compatibility

The modification process should be similar for other SBCs:

- Milk-V Duo (future support)
- Other Rockchip-based boards
- Custom carrier boards

## Resources

- **Video Guide**: [YouTube - Luckfox Lyra on PicoCalc](https://www.youtube.com/watch?v=DaVv7h8cKAE)
- **Forum Discussion**: [ClockworkPi Forum Thread](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280)
- **Image Files**: Check forum thread for community-shared modifications

## Next Steps

After successful installation:

- Follow [First Boot](../getting-started/first-boot.md) guide
- Configure system per [Configuration Guide](../user-guide/configuration.md)
- Explore [User Guide](../user-guide/basic-usage.md)
