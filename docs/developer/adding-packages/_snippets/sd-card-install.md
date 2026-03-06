# Install via SD card (IPK package)

You can test the package without rebuilding an image by copying the
generated IPK to an SD card and installing it on the device.

1. Build the package and locate the IPK on your build host:

   ```shell
   # Build the package (replace <packagename> with your recipe name)
   bitbake <packagename>

   # Find the generated IPK (architecture folder varies)
   find "$BUILDDIR/tmp/deploy/ipk" -type f -name '<packagename>_*.ipk'
   ```

   The IPK is typically under a path such as:
   `$BUILDDIR/tmp/deploy/ipk/<arch>/<packagename>_<version>-r<rev>_<arch>.ipk`.

2. Copy the IPK to an SD card on your host (PicoCalc slot SD works fine):

   ```shell
   # Replace <CARD_MOUNT> with your SD card mount point
   cp /path/to/<packagename>_*.ipk /media/$USER/<CARD_MOUNT>/
   sync
   ```

3. On the device, mount the SD card and install the package:

   ```shell
   # Example mount point; adjust device node and path as needed
   sudo mkdir -p /mnt/sd
   sudo mount /dev/mmcblk1p1 /mnt/sd

   # Install from the SD card
   sudo opkg install /mnt/sd/<packagename>_*.ipk
   ```

4. Run the utility to verify it works.

Notes:

- Ensure the IPK architecture matches the target (ARMv7 for Luckfox Lyra).
- Using the PicoCalc SD slot is slower (SPI) but fine for small packages.
- If `opkg` reports dependency issues, install missing runtime deps first.
