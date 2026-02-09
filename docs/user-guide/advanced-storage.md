# Advanced Storage Configuration

This guide covers advanced storage configurations for experienced Calculinux users.

!!! warning "Advanced Users Only"
    These configurations require careful setup and understanding of Linux storage systems. Incorrect configuration can result in data loss or unbootable systems. Only proceed if you're comfortable with partition management and system recovery.

## External Overlay Storage

For users who need expanded persistent storage or want to enable swapping boot SD cards while keeping user data separate, it's possible to place the `OVERLAY_DATA` partition on an external SD card.

### How It Works

Calculinux's pre-init script queries for storage partitions **by label**, not by device path. This allows flexibility in where partitions are located, but also requires careful management to avoid conflicts.

The system searches for a partition labeled `OVERLAY_DATA` and mounts it as the upper layer for the overlayfs that provides persistent storage for `/etc`, `/home`, `/var`, `/usr`, and `/opt`.

### Use Cases

**Valid reasons to use external overlay storage**:

- ✅ **Expanded storage**: Boot card is small, external card provides more space
- ✅ **Hot-swappable boot cards**: Multiple boot cards for different configurations, single data partition
- ✅ **Faster storage**: External card is higher quality/speed than boot card
- ✅ **Testing/development**: Separate system and data for easier recovery

**Not suitable for**:

- ❌ Removable storage that will be frequently inserted/removed
- ❌ Cards shared between multiple devices
- ❌ General file storage (use the sd card as a separate storage medium instead)

### Prerequisites

Before attempting this configuration:

- [ ] Comfortable with Linux command line and partition management
- [ ] Understand partition labels and filesystem types
- [ ] Have backup of any existing data
- [ ] Have serial console access for troubleshooting
- [ ] External SD card of appropriate size (16GB+ recommended)

!!! danger "Critical: Do Not Remove External Card While Running"
    Once configured with external overlay storage, the external SD card becomes **essential** to system operation. **Never remove the external SD card while the PicoCalc is powered on or running.**

    Removing the card will:
    
    - ⚠️ Cause immediate system instability
    - ⚠️ Result in data loss and corruption
    - ⚠️ Potentially require complete system reinstall
    - ⚠️ Make the system unbootable until the card is reinserted
    
    **Always shut down completely** before removing or inserting the external SD card.

### Configuration Steps

#### Option A: Fresh Installation with External Overlay

**Best for**: New installations

1. **Flash the boot SD card** with Calculinux as normal
2. **Before first boot**, mount the boot card on your computer
3. **Relabel the OVERLAY_DATA partition** on the boot card:

   ```shell
   # Find the partition (should be partition 6)
   lsblk -o NAME,PARTLABEL,LABEL,FSTYPE
   # Note: On your computer it will show as /dev/sdX (not mmcblk)
   
   # Change the partition label (not filesystem label) - adjust device name
   # Using sgdisk (for GPT partition tables):
   sudo sgdisk --change-name=6:"OVERLAY_UNUSED" /dev/sdX
   
   # Or using parted:
   sudo parted /dev/sdX name 6 "OVERLAY_UNUSED"
   ```

4. **Prepare the external SD card**:

   ```shell
   # Create partition with GPT partition table
   sudo sgdisk -o /dev/sdY  # Create new GPT table
   sudo sgdisk -n 1:0:0 -t 1:8300 -c 1:"OVERLAY_DATA" /dev/sdY
   
   # Format the partition (filesystem label can match for clarity)
   sudo mkfs.ext4 -L "OVERLAY_DATA" /dev/sdY1
   
   # Alternative: Using fdisk (creates MBR, then set partition label separately)
   # sudo fdisk /dev/sdY  # Create partition table and partition
   # sudo sgdisk --change-name=1:"OVERLAY_DATA" /dev/sdY
   # sudo mkfs.ext4 -L "OVERLAY_DATA" /dev/sdY1
   ```

   !!! warning "Important: Only OVERLAY_DATA on External Card"
       Do **not** attempt to move `BOOT`, `ROOT_A`, or `ROOT_B` partitions to the external SD card. U-Boot (the bootloader) cannot access the external SD card slot, so the system will not boot. Only the `OVERLAY_DATA` partition can be placed externally.

5. **Insert both cards** into the PicoCalc:
   - Boot card in internal slot
   - External card in external slot

6. **Boot the system** - it will automatically use the external overlay partition

#### Option B: Migrate Existing System

**Best for**: Moving an existing installation to external storage

!!! danger "Data Loss Risk"
    This process involves moving your entire persistent data. Make backups first!

!!! info "Required Tools"
    This procedure requires `sgdisk` to change GPT partition labels, which is only installed by default on 1.0.0-alpha8 and newer. Install it first if needed:
    ```shell
    opkg update && opkg install gptfdisk
    ```

1. **Boot the system normally** with current configuration

2. **Prepare external SD card** while system is running:

   ```shell
   # Install sgdisk if not already available
   opkg update && opkg install gptfdisk
   
   # Insert external card and identify it
   lsblk -o NAME,PARTLABEL,LABEL
   
   # Create partition with proper partition label (using sgdisk)
   sudo sgdisk -o /dev/mmcblk1  # Create new GPT table
   sudo sgdisk -n 1:0:0 -t 1:8300 -c 1:"OVERLAY_DATA_NEW" /dev/mmcblk1
   
   # Format with matching filesystem label
   sudo mkfs.ext4 -L "OVERLAY_DATA_NEW" /dev/mmcblk1p1
   
   # Mount it by partition label
   sudo mkdir -p /mnt/new-overlay
   sudo mount /dev/disk/by-partlabel/OVERLAY_DATA_NEW /mnt/new-overlay
   ```

3. **Copy existing overlay data**:

   ```shell
   # The current overlay data is already mounted at /data/
   # The overlay structure is at /data/overlay
   
   # Copy all overlay data to new partition
   sudo rsync -aAXv /data/ /mnt/new-overlay/
   
   # Verify copy
   sudo diff -r /data /mnt/new-overlay
   ```

4. **Relabel partitions**:

   ```shell
   # Note: Requires sgdisk - install first if needed:
   # opkg update && opkg install gptfdisk
   
   # Find the actual device names
   lsblk -o NAME,PARTLABEL,MOUNTPOINT
   
   # Relabel old partition (adjust partition number as needed)
   sudo sgdisk --change-name=6:"OVERLAY_OLD" /dev/mmcblk0
   
   # Relabel new partition
   sudo sgdisk --change-name=1:"OVERLAY_DATA" /dev/mmcblk1
   ```

5. **Reboot** - system will now use external overlay

6. **Verify and cleanup** (after confirming system works):

   ```shell
   # Check what's mounted
   lsblk -o NAME,LABEL,MOUNTPOINT
   mount | grep overlay
   
   # If working correctly, you can reformat old overlay partition
   # for use as regular storage (wait at least a week!)
   ```

### Critical Requirements

- ✅ **Exactly ONE** `OVERLAY_DATA` partition across all storage devices
- ✅ External SD card must be **permanently installed** (system requires it to boot)
- ✅ Must remove or relabel the `OVERLAY_DATA` partition on boot card
- ✅ External partition must be **ext4 filesystem**
- ✅ Label must **exactly match** `OVERLAY_DATA` (case-sensitive)
- ✅ External card must be inserted **before boot**
- ⚠️ **Only `OVERLAY_DATA` can be on external card** - `BOOT`, `ROOT_A`, and `ROOT_B` must remain on boot SD card (U-Boot cannot access external card)

### Verification

After configuration, verify it's working:

```shell
# Check which partition is mounted (check PARTLABEL, not LABEL)
lsblk -o NAME,PARTLABEL,LABEL,FSTYPE,SIZE,MOUNTPOINT | grep OVERLAY_DATA

# Check overlay mounts
mount | grep overlay

# Verify you can write to key directories
touch /etc/test-file && rm /etc/test-file
touch ~/test-file && rm ~/test-file

# Check available space
df -h | grep overlay
```

### Troubleshooting

**System boots read-only after configuration**:

- Multiple `OVERLAY_DATA` partition labels still exist - check with `lsblk -o NAME,PARTLABEL,LABEL`
- External card not inserted during boot
- External partition not formatted correctly (must be ext4)
- Label typo (must be exactly `OVERLAY_DATA`)

**Lost data after migration**:

- If you kept the `OVERLAY_OLD` partition, you can reverse the labels and reboot
- Use serial console to diagnose boot issues
- See [Common Issues - Overlayfs Failure](../troubleshooting/common-issues.md#system-read-only-overlayfs-failure)

**System won't boot at all**:

- Remove external card and relabel boot card's partition back to `OVERLAY_DATA`
- Boot with only boot card to recover
- If you need to relabel from the PicoCalc: `opkg update && opkg install gptfdisk`
- **Critical partitions on external card**: U-Boot cannot access the external SD card slot. If `BOOT`, `ROOT_A`, or `ROOT_B` partitions were moved to external card, system won't boot. Only `OVERLAY_DATA` can be external.
- Check serial console for actual errors

### Reverting to Standard Configuration

To move back to standard (overlay on boot card):

!!! info "Note"
    Requires `sgdisk` installed: `opkg update && opkg install gptfdisk`

1. Boot the system with external overlay
2. Copy data from external to boot card's partition (reverse of migration steps)
3. Relabel boot card partition to `OVERLAY_DATA`: `sudo sgdisk --change-name=6:"OVERLAY_DATA" /dev/mmcblk0`
4. Relabel external partition to something else: `sudo sgdisk --change-name=1:"OVERLAY_OLD" /dev/mmcblk1`
5. Reboot

### Performance Considerations

!!! warning "SPI Interface Limitation"
    The external SD card slot uses a **slower SPI-only interface**, not the faster SDIO/MMC interface used by the internal boot card slot. This limits performance regardless of card quality.

    **Maximum theoretical SPI throughput is much lower** than SDIO, so external overlay storage will generally be slower than internal overlay for I/O-heavy workloads.

**External overlay may be slower due to**:

- **SPI interface limitation** (most significant factor - affects all external cards)
- External card is lower quality than boot card
- Heavy I/O operations to `/var` or `/home`

**External overlay may still be beneficial for**:

- **Expanded capacity** when boot card is too small (primary use case)
- **Hot-swappable boot cards** for different system configurations
- Read-heavy workloads where capacity matters more than speed
- More physical space reduces write amplification on smaller cards
- Calculinux development

**Not recommended if**:

- Primary goal is performance improvement (internal is faster due to SDIO)
- Heavy write operations to `/var` (logs, databases, etc.)
- Applications with frequent small file I/O

### Related Documentation

- [Common Issues - Overlayfs Failure](../troubleshooting/common-issues.md#system-read-only-overlayfs-failure) - What to do when labels conflict
- [Installation Guide](../getting-started/installation.md) - Initial setup
- [Package Management](package-management.md) - Installing additional software
- [Updates](updates.md) - System update process with overlayfs
