# Example: Adding a Meson Application

This guide walks through adding a Meson-based application to Calculinux. We use [kiwix-tools](https://github.com/kiwix/kiwix-tools), a collection of CLI tools for managing and serving ZIM files (offline Wikipedia, etc.), as the concrete example.

## Reference recipe

The working recipe lives at:

`meta-calculinux-apps/recipes-apps/kiwix-tools/kiwix-tools_git.bb`

## 1. Create the recipe

Create `meta-calculinux-apps/recipes-apps/kiwix-tools/kiwix-tools_git.bb`:

```bitbake
SUMMARY = "Collection of Kiwix command line tools"
DESCRIPTION = "Kiwix tools is a collection of Kiwix related command line tools: \
kiwix-manage (manage XML based library of ZIM files), kiwix-search (full text \
search in ZIM files), and kiwix-serve (HTTP daemon serving ZIM files)."
HOMEPAGE = "https://github.com/kiwix/kiwix-tools"
LICENSE = "GPL-3.0-or-later"
LIC_FILES_CHKSUM = "file://COPYING;md5=f27defe1e96c2e1ecd4e0c9be8967949"

SRC_URI = "git://github.com/kiwix/kiwix-tools;protocol=https;branch=main"
SRCREV = "acad8a85ab4706ff527cabdaac4635a930f3bdd4"

S = "${WORKDIR}/git"

DEPENDS = "\
    libzim \
    libkiwix \
    docopt.cpp \
"

inherit meson pkgconfig

EXTRA_OEMESON = "\
    -Dstatic-linkage=false \
    -Ddoc=false \
"

FILES:${PN} += "${bindir}/*"

RDEPENDS:${PN} = "libzim libkiwix"
```

### Key points

- **inherit meson pkgconfig** — Meson handles configure, build, and install; `pkgconfig` helps with library detection.
- **EXTRA_OEMESON** — Pass Meson options (e.g. `-Dstatic-linkage=false`, `-Ddoc=false` to disable documentation).
- **DEPENDS** — Build-time dependencies (libraries, tools). Meson projects often need `docopt.cpp` or similar for argument parsing.
- **RDEPENDS** — Runtime libraries the binaries need.

### Licensing

--8<-- "developer/adding-packages/_snippets/licensing-workflow.md"

## 2. Add to the package group

--8<-- "developer/adding-packages/_snippets/add-to-package-group.md"

## 3. Build and test

--8<-- "developer/adding-packages/_snippets/build-and-test.md"
