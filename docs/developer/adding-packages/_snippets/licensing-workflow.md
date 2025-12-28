# Licensing workflow

BitBake enforces license checksums. Use this workflow to add them correctly:

1. Start with the license and a placeholder checksum in your recipe:

   ```bitbake
   LICENSE = "MIT"  # or the project's license
   LIC_FILES_CHKSUM = "file://LICENSE;md5=<fill-after-bitbake>"
   ```

2. Trigger a build to get BitBake's suggested checksum:

   ```bash
   bitbake <recipe_name>
   ```

   BitBake will fail and print the exact `LIC_FILES_CHKSUM` value to use.

3. Update your recipe with the suggested md5 and rebuild.

4. Optional: compute manually if needed from the upstream repo:

   ```bash
   md5sum LICENSE
   ```
