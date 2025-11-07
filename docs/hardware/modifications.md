# Hardware Modifications

This guide covers the physical modifications required to install a Luckfox Lyra (or similar SBC) into your PicoCalc.

!!! danger "Warranty Warning"
    Opening your PicoCalc and replacing the SBC will void your warranty. Proceed at your own risk. This modification requires careful handling of small components and connectors.

## Prerequisites

### Tools Required

- The allen wrench that came with the picocalc
- Good lighting and magnification (optional)
- A soft cloth to work or pad on

### Parts Needed

- Luckfox Lyra SBC (see [compatible versions](luckfox-lyra.md#luckfox-lyra-versions))
- MicroSD card (8GB minimum, 64GB+ recommended)

## Disassembly

### Step 1: Power Off and Disconnect

1. Power off the PicoCalc completely
2. remove the batteries

### Step 2: Open the Case

1. Remove all screws, open the case.
2. disconnect the LCD

### Step 3: Remove Original Board

1. Locate the existing RP2040/Pico board
2. Unplug the RP2040 from its socket.

## Installation

### Step 4: Prepare Luckfox Lyra

Before installation:

1. **Erase SPI NAND** (if your board has it) - see [SPI NAND Erasing](#erasing-spi-nand)
2. Flash Calculinux to your microSD card - see [Installation Guide](../getting-started/installation.md)
3. Insert the prepared microSD card into the Luckfox Lyra

### Step 5: Install Luckfox Lyra

1. Position the Luckfox Lyra in the same orientation as the original RP2030
2. Gently but firmly press the Lyra in to the socket

### Step 6: Reassembly

1. Take care to ensure the board is properly aligned with all screw holes
2. Ensure the kayboard rubber is in place
3. Ensure the display is properly aligned with the case
3. Align the case halves
4. Replace all screws
5. Verify nothing is binding or misaligned

!!! warn "Risk to your Display!"
    If the display is misaligned when installed, it can crack when you tighten the screws. make sure it is perfectly aligned with the front case!

!!! tip "Keeping the screen aligned"
    You may want to tape the screen in place using kapton tape or similar. this will prevent it from moving around as you open and close the picocalc in the future.

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
TODO: insert information about pin mapping

!!! warning "GPIO Voltage Levels"
    - **RMIO pins**: 3.3V operation
    - **GPIO4_B3/GPIO4_B2**: 1.8V operation (not RMIO-capable)
    - Always verify voltage levels before hardware modifications

!!! info "Hardware PWM Limitation"
    Some GPIO pins (like GPIO4_B3 and GPIO4_B2) cannot output hardware PWM as they are not RMIO-capable. For audio modifications, use RMIO pins that support hardware PWM. 
    A future page needs to be written detailing this.

### Power

- **5V In**: From USB-C connector via PicoCalc board (to charge the batteries)
- **3.3V Regulation**: On Luckfox Lyra board
- **Current Draw**: TODO

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
- **Power insufficient**: Try different USB cable/adapter or replace the batteries

### Display Not Working

- **Driver not loaded**: Check kernel logs via the serial terminal on the picocalc USB-C connector
- **Connection issue**: Reseat display cable
- **Wrong device tree**: Verify correct DTB is loaded

### Keyboard Not Responsive

- **Driver not loaded**: Check kernel logs
- **GPIO mapping wrong**: Verify device tree configuration

## Safety Considerations

### Electrical Safety

- Work on ESD-safe surface
- Avoid static discharge to components
- Never work on powered device
- Check for shorts before powering on

### Mechanical Safety

- Don't force connectors
- Handle PCBs by edges
- Watch for sharp edges

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

(TODO: add articles detailing these modifications)

- **Hardware PWM Mod**
- **Add a WiFi Module**
- **Flash customized firmware to the STM32 southbridge chip**

### Future Compatibility

The modification process should be similar for other SBCs:

- Milk-V Duo (future support)
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
