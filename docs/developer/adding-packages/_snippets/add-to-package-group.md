# Add to the package group

To make the package available in the feed (e.g. `opkg install <package>`), add it to the apps package group. Edit:

`meta-calculinux-apps/recipes-core/packagegroups/packagegroup-meta-calculinux-apps.bb`

Add your package name to the `RDEPENDS:${PN}` list in alphabetical order:

```bitbake
RDEPENDS:${PN} = " \
    amfora \
    android-adbd \
    ...
"
```

After the next build, the package will be built as an IPK and available from the feed.
