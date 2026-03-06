# Build and test

1. Build the package:

   ```shell
   bitbake <packagename>
   ```

2. Check that the IPK is produced under `tmp/deploy/ipk/`.

3. If the package is in `packagegroup-meta-calculinux-apps`, rebuild the package group or the image and verify the package appears in the feed and installs correctly on device.
