# Example: Adding a CMake Application

This guide walks through adding a CMake-based application to Calculinux. We use [notcurses](https://github.com/dankamongmen/notcurses), a library and toolkit for building TUIs with modern terminal features (24-bit color, Unicode, etc.), as the concrete example.

## Reference recipe

The working recipe lives at:

`meta-calculinux-apps/recipes-support/notcurses/notcurses_3.0.17.bb`

## 1. Create the recipe

Create `meta-calculinux-apps/recipes-support/notcurses/notcurses_3.0.17.bb`:

```bitbake
SUMMARY = "Notcurses: blingful TUIs and character graphics"
DESCRIPTION = "Notcurses facilitates the creation of modern TUI programs, \
making it easy to use features of modern terminals: 24-bit color, italics, \
transparency, UTF-8, and high-resolution bitmap graphics."
HOMEPAGE = "https://github.com/dankamongmen/notcurses"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://COPYRIGHT;md5=9d4fc1f864192e96250fc5464c06737e"

DEPENDS = "ncurses zlib libdeflate libunistring"

SRC_URI = "git://github.com/dankamongmen/notcurses.git;protocol=https;branch=master;tag=v3.0.17"

S = "${WORKDIR}/git"

inherit cmake pkgconfig

EXTRA_OECMAKE = " \
    -DUSE_MULTIMEDIA=none \
    -DUSE_DEFLATE=ON \
    -DBUILD_TESTING=OFF \
    -DUSE_DOCTEST=OFF \
    -DUSE_PANDOC=OFF \
"

# Split packages for demos and tools
PACKAGES =+ "${PN}-demos ${PN}-tools"

FILES:${PN} = "${libdir}/libnotcurses*.so.* ${libdir}/libnotcurses-core*.so.*"
FILES:${PN}-dev = "${includedir} ${libdir}/pkgconfig ${libdir}/*.so ${libdir}/cmake"
FILES:${PN}-demos = "${bindir}/notcurses-demo ${bindir}/notcurses-input ${datadir}/notcurses"
FILES:${PN}-tools = "${bindir}/ncls ${bindir}/ncneofetch ${bindir}/ncplayer ${bindir}/nctetris ${bindir}/notcurses-info ${bindir}/tfman"

RDEPENDS:${PN}-demos = "${PN}"
RDEPENDS:${PN}-tools = "${PN}"
RDEPENDS:${PN} = "ncurses libdeflate libunistring"
```

### Key points

- **inherit cmake pkgconfig** — CMake handles configure, build, and install; `pkgconfig` helps with library detection.
- **EXTRA_OECMAKE** — Pass CMake options (disable features you don't need, e.g. multimedia for embedded).
- **PACKAGES =+** — Split optional components (demos, tools) into separate packages so images can install only what they need.
- **SRC_URI with tag** — Use `tag=vX.Y.Z` for a specific release; omit for `SRCREV`-based Git builds.

### Licensing

--8<-- "developer/adding-packages/_snippets/licensing-workflow.md"

## 2. Add to the package group

--8<-- "developer/adding-packages/_snippets/add-to-package-group.md"

## 3. Build and test

--8<-- "developer/adding-packages/_snippets/build-and-test.md"
