# Erasing SPI NAND Flash

This guide explains how to erase the SPI NAND flash memory on Luckfox Lyra boards that include onboard flash storage.

!!! danger "Critical Warning: Data Loss"
    **Erasing SPI NAND will permanently delete ALL data stored on the NAND flash.** This action cannot be undone. Ensure you have backups of any important data before proceeding.

## Why Erase SPI NAND?

The Luckfox Lyra boot process prioritizes SPI NAND flash over SD cards. If your board has SPI NAND with existing firmware:

- The board will boot from NAND instead of your Calculinux SD card
- Your SD card will be ignored even if properly flashed
- You must erase the NAND to enable SD card booting

## Which Boards Have SPI NAND?

| Board Model | SPI NAND | Notes |
|-------------|----------|-------|
| **Luckfox Lyra (Base)** | ❌ No | SD card only |
| **Luckfox Lyra B** | ✅ Yes | 256MB SPI NAND |
| **Luckfox Lyra Plus** | ✅ Yes | 256MB SPI NAND |
| **Luckfox Lyra Ultra/Ultra W** | N/A | Uses eMMC, not NAND |
| **Luckfox Lyra Zero W** | Varies | Check your specific model |
| **Luckfox Lyra Pi** | Varies | Check your specific model |

## Checking If You Have SPI NAND

**Visual Inspection:**
- Look for an additional chip on the board labeled "SPI NAND" or similar
- Check your purchase order/product specifications

**Check Product Documentation:**
- Refer to the [Luckfox Lyra documentation](https://wiki.luckfox.com/Luckfox-Lyra/) for your specific model

## Erasure Methods

### Method 1: Windows - RKDevTool (Recommended)

This is the easiest and most reliable method for most users.

#### Prerequisites

- Windows PC
- USB Type-A to Type-C cable (data-capable)
- Luckfox Lyra board with SPI NAND

#### Step 1: Download Required Tools

1. **RK Driver Assistant**: [Download v5.13](https://files.luckfox.com/wiki/Omni3576/TOOLS/DriverAssitant_v5.13.zip)
2. **RKDevTool**: [Download v3.31](https://files.luckfox.com/wiki/Omni3576/TOOLS/RKDevTool_Release_v3.31.zip)
3. **Luckfox Firmware** (any official image): [Download from Luckfox](https://wiki.luckfox.com/Luckfox-Lyra/Image-flashing/#2--image-download)

#### Step 2: Install Drivers

1. Extract the RK Driver Assistant ZIP file
2. Run `DriverInstall.exe`
3. Click "Install Driver"
4. Restart your computer after installation completes

![RK Driver Installation](https://files.luckfox.com/wiki/Luckfox-Pico/Picture/Luckfox-Pico-RKDriver.png)

#### Step 3: Enter Loader Mode

1. Extract and open RKDevTool
2. **Method A - Using BOOT button:**
   - Disconnect the Luckfox Lyra from USB
   - Hold down the **BOOT** button on the board
   - While holding BOOT, connect the USB cable to your PC
   - Wait 2-3 seconds, then release the BOOT button
   
3. **Method B - Using RESET button:**
   - With the board connected via USB
   - Hold down **RESET** button
   - While holding RESET, press and hold **BOOT** button
   - Release RESET, wait 2 seconds
   - Release BOOT

4. RKDevTool should display: `Found One LOADER Device`

![Loader Mode Detected](https://wiki.luckfox.com/assets/images/RK3506-LOADER-1fbf388a871c4e6f6755532deb9324fa.png)

!!! tip "Troubleshooting Device Detection"
    If the device is not detected, check Windows Device Manager:
    
    - **Correct (Loader Mode)**: Should show "Rockusb Device" under "Universal Serial Bus controllers"
    - **Wrong**: Shows as "ADB Interface" or other device
    
    If not detected properly, try a different USB cable or USB port.

#### Step 4: Erase the NAND Flash

1. In RKDevTool, click the **"Advanced Function"** tab (高级功能)
2. Click **"Erase Flash"** button
3. Wait for the process to complete
4. Tool will display: "Erase Flash Success"

Alternatively, you can erase by flashing a minimal firmware:

1. Click the **"Firmware"** tab
2. Click the folder icon and select the downloaded firmware `update.img`
3. Click **"Upgrade"** button
4. Wait for completion: "Download Successful"

![Erase Flash](https://wiki.luckfox.com/assets/images/RK3576-Erase-6d3170ce107ad4c94c0cd61920662380.png)

#### Step 5: Verify Erasure

1. Disconnect the USB cable
2. Insert your Calculinux SD card
3. Power on the device
4. The device should now boot from the SD card

### Method 2: Linux (x86_64 Platform)

This method uses command-line tools on Linux.

#### Prerequisites

- Linux PC (tested on Ubuntu 22.04)
- Luckfox SDK or upgrade_tool
- USB Type-A to Type-C cable

#### Step 1: Download Tools

Download the Luckfox SDK which includes the flashing tools:
- [Luckfox SDK Setup Guide](https://wiki.luckfox.com/Luckfox-Lyra/SDK)

Or download standalone upgrade_tool:
- Available in the SDK under `tools/linux/Linux_Upgrade_Tool/`

#### Step 2: Enter Loader Mode

1. Hold the **BOOT** button while connecting the board to your PC
2. Verify detection with `lsusb`:

```bash
lsusb | grep Rockchip
```

You should see output indicating Loader mode:
```
Bus 001 Device 007: ID 2207:350f Fuzhou Rockchip Electronics Company
```

#### Step 3: Erase Using rkflash.sh

If you have the full SDK:

```bash
cd /path/to/luckfox-sdk
sudo ./rkflash.sh erase
```

#### Step 4: Verify

```bash
# Check the flash is erased
sudo ./rkflash.sh query
```

### Method 3: MaskRom Mode (Advanced/Recovery)

Use this method only if Loader Mode fails or the device is in an unrecoverable state.

!!! warning "Advanced Users Only"
    MaskRom mode requires physical hardware manipulation and should only be used when Loader mode fails.

#### Entering MaskRom Mode

1. **Locate the Flash Chip**: Find the SPI NAND flash chip on your board
2. **Identify GND Pin**: Locate a ground pin near the flash chip
3. **Short Circuit Method**:
   - Disconnect power from the board
   - Use tweezers or a wire to short `FSPI_CLK` pin to `GND`
   - While keeping the short, connect USB cable
   - RKDevTool should display: `Found One MASKROM Device`
   - Remove the short circuit once detected

![MaskRom Mode Pins](https://wiki.luckfox.com/assets/images/Lyra-eMMC-GND-5a8f923f48f967c8ca7ebc7bcc1b2c8f.png)

4. **Erase in MaskRom**:
   - Use RKDevTool "Erase Flash" function
   - Or flash a minimal firmware image

### Method 4: Linux on the Device (Not Yet Documented)

!!! warning "Method Not Available"
    Methods for erasing SPI NAND directly from Linux running on the Luckfox Lyra (without external flashing tools) are not yet documented or tested. 
    
    This would theoretically be possible using `mtd-utils` and `/dev/mtdX` devices, but specific procedures for Calculinux have not been established.

## After Erasing

Once the SPI NAND is erased:

1. **Insert SD Card**: Insert your Calculinux SD card
2. **Power On**: Connect power or USB
3. **Boot**: The device should now boot from the SD card
4. **Verify**: Check that Calculinux boots successfully

## Common Issues

### Issue: Board Still Boots from NAND

**Symptoms**: SD card is ignored, old firmware still runs

**Solutions**:
- Verify the erase completed successfully
- Try the erase process again
- Try MaskRom mode instead of Loader mode
- Check that your SD card is properly flashed

### Issue: Cannot Enter Loader Mode

**Symptoms**: RKDevTool doesn't detect device

**Solutions**:
- Try different USB cable (must be data-capable)
- Try different USB port
- Check Device Manager for driver issues
- Reinstall RK Driver Assistant
- Try MaskRom mode

### Issue: Erase Fails Midway

**Symptoms**: Erase process errors or hangs

**Solutions**:
- Disconnect and retry
- Try using MaskRom mode
- Ensure stable USB connection
- Check power supply is adequate

### Issue: Device Won't Boot After Erase

**Symptoms**: No boot after erasing NAND

**This is expected behavior!** With NAND erased and no SD card:
- Insert your Calculinux SD card
- Power on the device
- It should boot from SD card

## Recovery Options

If you need to restore the original Luckfox firmware to NAND:

1. Download the official Luckfox firmware for your board model
2. Follow the [official flashing guide](https://wiki.luckfox.com/Luckfox-Lyra/Image-flashing/)
3. Flash the firmware to SPI NAND using RKDevTool

## Additional Resources

- **Official Luckfox Flashing Guide**: [wiki.luckfox.com/Luckfox-Lyra/Image-flashing](https://wiki.luckfox.com/Luckfox-Lyra/Image-flashing/)
- **Luckfox Forum**: [forums.luckfox.com](https://forums.luckfox.com/)
- **RK Driver Downloads**: [Luckfox Tools](https://wiki.luckfox.com/Luckfox-Lyra/Image-flashing/#3-installing-drivers)

## Questions?

If you encounter issues not covered here:

1. Check the [Boot Problems](boot-problems.md) troubleshooting guide
2. Ask in the [Calculinux Forum](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280)
3. Refer to [Luckfox Official Documentation](https://wiki.luckfox.com/Luckfox-Lyra/)
4. Open a [GitHub Issue](https://github.com/Calculinux/meta-calculinux/issues)

---

**Remember**: Erasing SPI NAND is a one-way operation. Make sure you understand the implications before proceeding.
