# Common Issues

Comprehensive troubleshooting for common Calculinux problems and boot-related issues.

## Boot Problems

### System Won't Boot

#### SPI NAND Interference

Some Luckfox Lyra boards include SPI NAND flash memory. The RK3506G2 boot ROM **always tries NAND first**, so if your board has NAND with any firmware on it, the boot ROM will ignore your SD card.

**Quick Check:**

- Lyra models with "SPI NAND" or "Lyra B" or "Lyra Plus" have NAND
- Check your purchase specifications
- If unsure, try booting - if SD card is ignored, you likely have NAND
- **Watch the red LED on the Lyra** - it should blink in a heartbeat pattern when booted. If it's not blinking, the Lyra isn't booting at all.

**Solution:**
You must erase the SPI NAND flash. See the comprehensive **[SPI NAND Erase Guide](erase-nand.md)** for detailed step-by-step instructions covering:

- Windows method (RKDevTool)
- Linux method (upgrade_tool)
- MaskRom mode recovery
- Troubleshooting failed erases

!!! danger "Critical: Data Loss"
    Erasing SPI NAND will **permanently delete all data** on the NAND flash. This cannot be undone. Ensure you understand the implications before proceeding. On a new device there is nothing of value, only a test image placed there by Luckfox.

!!! info "More Information"
    - **Complete Erase Guide**: [SPI NAND Erase Guide](erase-nand.md)
    - **Boot Priority Details**: [Hardware Specifications - Boot Priority](../hardware/specifications.md#boot-priority)
    - **Luckfox Official Docs**: [wiki.luckfox.com/Luckfox-Lyra/Image-flashing](https://wiki.luckfox.com/Luckfox-Lyra/Image-flashing/)

### Boot Hangs or Takes Long Time

**First boot specific**: The system automatically expands the overlay partition on first boot, which can take 1-3 minutes. This is normal.

**Other causes**:

- **SPI NAND not erased**: Most common issue on NAND-equipped boards
- **Corrupt SD card**: Test with `sudo fsck /dev/mmcblk0p1` after booting
- **Insufficient power**: Ensure 5V/2A power supply or check battery charge
- **External SD card conflicts**: Remove external SD cards during first boot

### SD Card Issues

**Corrupted card**:

```shell
# Test filesystem integrity
sudo fsck /dev/mmcblk0p1
```

**Write protection**: Check physical write-protect switch on SD card

**Incompatible card**: Use Class 10 or UHS-I cards, avoid cheap/counterfeit cards

**Wrong slot**: Ensure SD card is in the **Lyra's** slot, not the PicoCalc's external slot

### Cannot Login

**Verify credentials**:

- Username: `root`
- Password: `root`

!!! danger "Change Default Password"
    After first login, immediately change the root password with `passwd`

**Other login issues**:

- Try different keyboard if available
- Check keyboard driver loaded: `dmesg | grep -i keyboard`
- Access via USB networking if display/keyboard not working
- Use serial console for debugging: 1500000 baud on PicoCalc USB-C port

## Display Issues

### Display Blank But System Accessible

If you can access the system via USB networking but the display remains blank:

**Cause**: Lyra was powered on directly (via its USB-C port) before the PicoCalc was turned on.

**Why this happens**: The display initializes only during boot when the PicoCalc hardware is powered on. If the Lyra boots before the PicoCalc is turned on, the display hardware isn't available and won't be initialized.

**Solution**:

1. Unplug the Lyra's USB-C cable (powers off the Lyra)
2. Press the PicoCalc power button to turn on the device
3. The PicoCalc will power and boot the Lyra with display properly initialized
4. **If no batteries**: Use the **PicoCalc's USB-C port** for power instead of the Lyra's

### Other Display Checks

- **Check the red LED**: The Lyra has a red LED that blinks in a heartbeat pattern when booted. If it's blinking, the system is running and the issue is display-specific. If it's not blinking, the system isn't booting.
- **Wait 2-3 minutes**: First boot takes longer as the overlay partition is automatically expanded
- **Check power supply**: If not running on batteries, ensure 5V/2A minimum
- **Verify SD card**: Check SD card is inserted correctly in Lyra slot
- **Test display hardware**: After login, run `sdl2-test` to verify display functionality
- **Review display compatibility**: See [Display & Input Compatibility](../hardware/compatibility/display-input.md)

## Input Issues

### Keyboard Not Responding

1. **Check input devices**:

    ```shell
    cat /proc/bus/input/devices
    ```

2. **Check kernel messages**:

    ```shell
    dmesg | grep -i keyboard
    ```

3. **Test events** (if `evtest` is installed):

    ```shell
    evtest /dev/input/event0
    ```

4. **Hardware checks**:
    - Power-cycle the PicoCalc and ensure it is on before the Lyra boots
    - Reseat internal connections if you recently modified hardware

### Key Mapping Issues

- Check your layout in [Basic Usage](../user-guide/basic-usage.md)
- If you customized mappings, revert changes and retest

### Custom Keyboard Firmware Not Working

**Symptoms**: Keyboard doesn't respond when using the [custom PicoCalc keyboard firmware](https://forum.clockworkpi.com/t/custom-picocalc-bios-keyboard-firmware/17292)

**Cause**: The custom firmware by JackCarterSmith reduces the I2C bus frequency for more efficient power consumption, limiting it to 100 kHz. Calculinux currently attempts to use the I2C bus at 400 kHz, which is incompatible with the custom firmware.

**Short-term Solution**:

Flash the keyboard back to the original firmware. The custom firmware is not yet officially supported.

**Future Support**:

Calculinux plans to support the custom firmware with proper I2C speed configuration. Check [GitHub Issues](https://github.com/Calculinux/meta-calculinux/issues) for updates on this compatibility improvement.

## System Read-Only / Overlayfs Failure

### Symptoms

- System boots but remains **read-only**
- Cannot create files or directories
- Cannot edit any settings in /etc
- Cannot change passwords
- Error messages mentioning overlayfs or mounting failures
- `/var`, `/etc`, or `/home` appear read-only

### Root Cause: External SD Card Partition Label Conflicts

**The most common cause** of overlayfs failure is **partition label conflicts** with external SD cards.

Calculinux uses **partition labels** (not UUIDs or device paths) to identify and mount its overlayfs partition for persistent storage. If an external SD card contains partitions with **conflicting labels**—especially `OVERLAY_DATA` — the system may mount the wrong partition, causing overlayfs to fail.

**How It Happens**:

1. User boots Calculinux with external SD card inserted
2. External SD card has another Calculinux installation (or partitions with conflicting labels)
3. During pre-init, the boot script queries for the `OVERLAY_DATA` partition by label using `lsblk`
4. When duplicate labels exist, `lsblk` returns **multiple partition names** instead of one
5. The script attempts to expand the filesystem using `growpart`, but receives multiple/invalid partition names and **fails**
6. The subsequent `mount` command also fails because the partition name variable contains multiple values or the wrong partition
7. Without a mounted overlay partition, the overlayfs setup for `/etc`, `/home`, `/var`, etc. cannot proceed
8. System falls back to read-only mode

### Diagnosing the Issue

**Check for read-only filesystem**:

```shell
# Try creating a test file
touch ~/test
# If you get "Read-only file system" error, overlayfs failed to load

# Check mount status
mount | grep overlay
# Should show overlayfs mounted on root
# If missing, overlayfs failed to mount

# Check available block devices
lsblk
# Look for multiple SD cards (mmcblk0, mmcblk1)
```

**Check partition labels**:

```shell
# List all partition labels
lsblk -o NAME,LABEL,FSTYPE,SIZE,MOUNTPOINT

# Look for duplicate labels - each should only appear ONCE:
# - OVERLAY_DATA (used for persistent storage overlay)
# - ROOT_A, ROOT_B (used for A/B system updates)
# - SWAP (used for swap space)
# - BOOT (used for boot partition)
```

**Check system logs**:

```shell
# Check for mount errors
dmesg | grep -i "overlay\|mount\|fail"
journalctl -b | grep -i "overlay\|mount"
```

### Solution 1: Remove External SD Card

**Immediate fix**:

1. Power off the device
2. Remove any external SD card
3. Reboot
4. System should mount overlayfs correctly

### Solution 2: Relabel External SD Card Partitions

If you need to keep the external SD card inserted:

**Option A: Change partition labels** (preserves data):

```shell
# Install sgdisk if not available (built in on 1.0.0 Alpha 8 ans later)
opkg update && opkg install gptfdisk

# List current partition labels
lsblk -o NAME,PARTLABEL,LABEL

# Change partition labels to unique names
# (adjust partition numbers as needed for your card)
sudo sgdisk --change-name=1:"external-storage" /dev/mmcblk1
sudo sgdisk --change-name=2:"external-backup" /dev/mmcblk1

# Verify changes
lsblk -o NAME,PARTLABEL,LABEL
```

**Option B: Reformat the external card** (destroys all data):

```shell
# Identify the external card (mmcblk1)
lsblk

# Unmount all partitions
sudo umount /dev/mmcblk1*

# Create new partition table with unique partition label
sudo sgdisk -o /dev/mmcblk1  # Create new GPT table
sudo sgdisk -n 1:0:0 -t 1:8300 -c 1:"external-data" /dev/mmcblk1

# Format the partition
sudo mkfs.ext4 -L "external-data" /dev/mmcblk1p1

# Verify
lsblk -o NAME,PARTLABEL,LABEL
```

### Solution 3: Recovery After Boot

If already booted into read-only mode, you can attempt a manual overlay mount:

```shell
# 1. Identify and mount the correct OVERLAY_DATA partition
lsblk -o NAME,PARTLABEL,MOUNTPOINT
# Find the partition with PARTLABEL "OVERLAY_DATA" on boot card (mmcblk0)

# 2. Mount the overlay data partition if not already mounted
sudo mkdir -p /data
sudo mount /dev/disk/by-partlabel/OVERLAY_DATA /data

# 3. Manually create overlay for /etc (example for one directory)
sudo mkdir -p /data/overlay/etc/upper
sudo mkdir -p /data/overlay/etc/work
sudo mount -t overlay overlay \
  -o lowerdir=/etc,upperdir=/data/overlay/etc/upper,workdir=/data/overlay/etc/work \
  /etc

# 4. Repeat for other directories as needed:
# /root, /home, /var, /usr, /opt

# 5. Test write access
touch ~/test && rm ~/test
```

**Note**: Manual overlay mounting is complex and error-prone. The better solution is to fix the partition label conflict and reboot cleanly.

### Prevention

**Best practices** to avoid this issue:

- ✅ **Remove external SD cards during first boot**
- ✅ **Use unique partition labels** on all external storage
- ✅ **Never clone** Calculinux SD cards for use as external storage
- ✅ **Check labels** before rebooting with an external SD card insterted, especially if you've previously used it as a boot device

**Safe external SD card labels** (won't conflict):

- `external-data`
- `backup`
- `media`
- `storage`
- Any name **not** used by Calculinux system partitions

**Calculinux reserved labels** (never use these on external cards):

- `OVERLAY_DATA` (most critical - causes immediate failure)
- `ROOT_A` and `ROOT_B` (system partition labels - may cause issues with updates)
- `SWAP` (swap partition)
- `BOOT` (boot partition)

Duplicating any of these labels will prevent proper system function.

### Advanced: External Overlay Storage

!!! info "For Advanced Users Only"
    It **is** possible to intentionally place the `OVERLAY_DATA` partition on an external SD card for expanded storage or to enable swapping boot SD cards while keeping persistent data separate.
    
    This is an **advanced configuration**  and is documented elsewhere:
    
    📖 **[Advanced Storage Configuration Guide](../user-guide/advanced-storage.md)**

If you're experiencing overlayfs failures, this advanced configuration is **not** your issue—you have accidental duplicate labels that need to be resolved using the solutions above.

### Related Issues

See also:

- [Installation Guide - External SD Card Warning](../getting-started/installation.md#step-3-hardware-installation)

## More Troubleshooting Guides

Use these specialized guides for deeper troubleshooting:

- [Basic Troubleshooting](basic-troubleshooting.md)
- [Network Issues](network.md)
- [Erasing SPI NAND](erase-nand.md)
- [Troubleshooting & FAQ](faq.md)
- [Advanced Storage Configuration](../user-guide/advanced-storage.md)
