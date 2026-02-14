# Add the package to your image

To include the package in a built image, add it via `IMAGE_INSTALL` in your distribution or image configuration, or in a bundle:

```bitbake
IMAGE_INSTALL:append = " <packagename>"
```

If you use a bundle (e.g. `calculinux-bundle.bb`), include the package there.
