### Alternative: Install via SD Card (IPK Package)

You can test the package without rebuilding an image by copying the generated IPK to an SD card and installing it on the device.

1. Build the package and locate the IPK on your build host:

   ```bash
   # Build the package
   bitbake hello-calculinux

   # Find the generated IPK (architecture folder varies)
   find "$BUILDDIR/tmp/deploy/ipk" -type f -name 'hello-calculinux_*.ipk'
   ```

   The IPK is typically under a path like:
   `$BUILDDIR/tmp/deploy/ipk/<arch>/hello-calculinux_<version>-r<rev>_<arch>.ipk`.

2. Copy the IPK to an SD card on your host (PicoCalc slot SD works fine):

   ```bash
   # Replace <CARD_MOUNT> with your SD card mount point
   cp /path/to/hello-calculinux_*.ipk /media/$USER/<CARD_MOUNT>/
   sync
   ```

3. On the device, mount the SD card and install the package:

   ```bash
   # Example mount point; adjust device node and path as needed
   sudo mkdir -p /mnt/sd
   sudo mount /dev/mmcblk1p1 /mnt/sd

   # Install from the SD card
   sudo opkg install /mnt/sd/hello-calculinux_*.ipk
   ```

4. Run the utility to verify:

   ```bash
   hello-calculinux
   ```

Notes:
- Ensure the IPK architecture matches the target (ARMv7 for Luckfox Lyra).
- Using the PicoCalc SD slot is slower (SPI) but fine for small packages.
- If `opkg` reports dependency issues, install missing runtime deps first.
