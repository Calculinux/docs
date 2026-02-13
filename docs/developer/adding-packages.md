# Adding Packages

This guide explains how to add new packages (applications and libraries) to Calculinux. Packages are built as IPKs and can be installed from the package feed or included in images.

## Prerequisites

Before adding packages, you should have:

- A working build environment — see [Development Overview](overview.md), [Setting Up Yocto](yocto-setup.md), and [Building Calculinux](building.md)
- Basic familiarity with BitBake and Yocto recipe syntax

## Where Recipes Live

Calculinux uses the **meta-calculinux-apps** layer for additional applications and tools. Recipe layout follows Yocto conventions:

| Directory | Purpose |
|-----------|---------|
| `meta-calculinux-apps/recipes-apps/` | End-user applications |
| `meta-calculinux-apps/recipes-support/` | Libraries and support packages |
| `meta-calculinux-apps/recipes-core/packagegroups/` | Package groups (what gets built and offered in the feed) |

Recipes are organized by package name. Each package has its own directory containing one or more `.bb` (BitBake) recipe files.

## Recipe Basics

A recipe file is named `packagename_version.bb` (e.g. `circumflex_3.8.bb`) or `packagename_git.bb` for Git-based builds. Typical contents:

- **HOMEPAGE** — Project URL  
- **SUMMARY** — Short one-line description  
- **DESCRIPTION** — Longer description (can span lines with `\`)  
- **LICENSE** / **LIC_FILES_CHKSUM** — License and checksum of the license file  
- **SRC_URI** — Where to fetch source (tarball, Git, etc.)  
- **S** — Source directory inside the build tree (e.g. `${WORKDIR}/git`)  
- **inherit** — Use a class such as `go-mod`, `cmake`, `autotools`, etc., for build/install behavior  

The build system uses these to fetch, patch, configure, build, and install the package.

## Example: Adding a Go Application

Many terminal apps in Calculinux are written in Go and use the `go-mod` class. Here we add [amfora](https://github.com/makew0rld/amfora), a terminal browser for the Gemini protocol.

**1. Create the recipe directory and file**

Create `meta-calculinux-apps/recipes-apps/amfora/amfora_git.bb`:

```bitbake
HOMEPAGE = "https://github.com/makew0rld/amfora"
SUMMARY = "A terminal browser for the Gemini protocol"
DESCRIPTION = "Amfora is a beautiful terminal browser for the Gemini protocol. \
It aims to be the best-looking Gemini client with the most features while \
remaining fully functional in the terminal. \
"

LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=1ebbd3e37fb99a8f4b95b7840adf9910"

inherit go-mod

# Clone into path matching go.mod module (github.com/makeworld-the-better-one/amfora)
SRC_URI = "\
    git://github.com/makew0rld/amfora;destsuffix=git/src/github.com/makeworld-the-better-one/amfora;nobranch=1;name=${BPN};protocol=https \
"

SRCREV = "4d9a5c56c88f7bec2938968182c88130b923fbba"

S = "${WORKDIR}/git"

# go.mod declares this module path (may differ from repo URL)
GO_IMPORT = "github.com/makeworld-the-better-one/amfora"
```

If the GitHub repo path and the Go module path in `go.mod` are the same (e.g. `github.com/bensadeh/circumflex`), you can use `destsuffix=git/src/${GO_IMPORT}` and `SRC_URI = "git://${GO_IMPORT};..."`. When they differ (like amfora: repo `makew0rld/amfora`, module `makeworld-the-better-one/amfora`), set `destsuffix` to the module path so the build finds the code where Go expects it.

**2. Make the package available in the feed**

Add the package name to the apps package group. Edit:

`meta-calculinux-apps/recipes-core/packagegroups/packagegroup-meta-calculinux-apps.bb`

In the `RDEPENDS:${PN}` list, add your package in alphabetical order (e.g. `amfora`):

```bitbake
RDEPENDS:${PN} = " \
    amfora \
    android-adbd \
    ...
"
```

After the next build, the package will be built as an IPK and available from the feed (e.g. `opkg install amfora`).

## Example: Adding a Rust Application

Rust applications use the `cargo` class and often a separate include file for crate checksums. Calculinux has [glkcli](https://github.com/benklop/glkcli) as an example: a CLI launcher for GLK-based interactive fiction.

**1. Create the recipe**

Create `meta-calculinux-apps/recipes-games/glkcli/glkcli_git.bb` (or under `recipes-apps/` as appropriate):

```bitbake
SUMMARY = "A memory-safe Rust CLI launcher for GLK-based interactive fiction interpreters"
DESCRIPTION = "Automatically detects game file formats and launches the appropriate interpreter..."
HOMEPAGE = "https://github.com/benklop/glkcli"
SECTION = "games"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=42c55472c018a92c8089e3971fb6f602"

SRC_URI = "git://github.com/benklop/glkcli.git;protocol=https;branch=main"
SRCREV = "${AUTOREV}"
PV = "1.1+git${SRCPV}"
S = "${WORKDIR}/git"

inherit cargo cargo-update-recipe-crates

DEPENDS = "glkterm openssl"
RDEPENDS:${PN} = "glkterm"

export OPENSSL_DIR = "${STAGING_DIR_HOST}${prefix}"
export OPENSSL_LIB_DIR = "${STAGING_DIR_HOST}${libdir}"
export OPENSSL_INCLUDE_DIR = "${STAGING_DIR_HOST}${includedir}"

require ${BPN}-crates.inc

FILES:${PN} = "${bindir}/glkcli"
```

**2. Generate crate checksums**

Rust crates are fetched from crates.io; the recipe must pin their checksums. Use the `cargo-update-recipe-crates` class and generate the include file:

- Build once with a recipe that has `inherit cargo` and the correct `SRC_URI` for your Rust project. The build will fail with instructions, or you can use **devtool** to add the recipe and then run the cargo recipe update helper (e.g. `cargo-update-recipe-crates.bbclass` usage in your layer).
- Alternatively, from a build that has fetched the Rust source, run the recipe’s cargo recipe update script (if provided by your layer) to generate `glkcli-crates.inc` with `SRC_URI` and `SRC_URI[cratename.sha256sum]` lines for each dependency.

The generated `*-crates.inc` is included with `require ${BPN}-crates.inc`. See existing Rust recipes in `meta-calculinux-apps` (e.g. `recipes-games/glkcli/`) for the exact pattern.

**3. Add to the package group**

As with the Go example, add your package name (e.g. `glkcli`) to `RDEPENDS:${PN}` in `packagegroup-meta-calculinux-apps.bb` in alphabetical order.

## Recipe Types and Classes

- **Go applications** — `inherit go-mod`, set `GO_IMPORT`, and use a Git `SRC_URI`; put the clone in a path that matches the module path in `go.mod` (see the [Go example](#example-adding-a-go-application) above).  
- **Rust applications** — `inherit cargo` and usually `cargo-update-recipe-crates`; use a `*-crates.inc` include for crate checksums (see the [Rust example](#example-adding-a-rust-application) above).  
- **CMake projects** — `inherit cmake` and set `SRC_URI` (and optionally `S`).  
- **Autotools (configure/make)** — `inherit autotools` and set `SRC_URI`.  
- **Simple Makefile** — `inherit pkgconfig` or a custom recipe with `do_compile`/`do_install` steps.  

The Yocto Project documentation and existing recipes in `meta-calculinux-apps` and `meta-calculinux-distro` are good references for your specific build system.

## Version and SRCREV

- For **released tarballs**: use `packagename_X.Y.Z.bb` and a `SRC_URI` pointing at the release archive. Set **PV** if the version string in the filename differs from the default.  
- For **Git**: use `packagename_git.bb`, set **SRCREV** to the desired commit hash (or a branch name for development), and use a `git://` **SRC_URI** as in the Go example.  
- Updating **SRCREV** (and **PV** for tarballs) and refreshing **LIC_FILES_CHKSUM** when upgrading is part of package maintenance.

## Testing Your Recipe

1. Build the package:  
   `bitbake <packagename>`  
   (e.g. `bitbake amfora` or `bitbake glkcli`)  
2. Check that the IPK is produced under `tmp/deploy/ipk/`.  
3. If the package is in `packagegroup-meta-calculinux-apps`, rebuild the package group or the image and verify the package appears in the feed and installs correctly on device.

## Submitting Packages

- Follow the project’s [Contributing](contributing.md) guidelines.  
- New recipes and changes to the package group should go through the usual review process (e.g. pull requests against the meta-calculinux repository).  
- Keep **LIC_FILES_CHKSUM** correct and document any non-obvious build or runtime dependencies.

## Further Reading

- [Development Overview](overview.md) — Environment and architecture  
- [Building Calculinux](building.md) — Build process and feeds  
- [Yocto Project — Writing a New Recipe](https://docs.yoctoproject.org/dev-manual/common-tasks.html#writing-a-new-recipe)  
- Existing recipes in `meta-calculinux-apps/recipes-apps/` and `recipes-support/` for more examples  

For advanced workflows (creating and modifying recipes interactively), the Yocto **devtool** is useful; see the Yocto Project documentation for devtool recipe creation and modification.
