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

## Concrete Examples

Step-by-step guides with full recipe content:

- [Go (amfora)](adding-packages/go-example.md) — Terminal app using `go-mod`
- [Rust (glkcli)](adding-packages/rust-example.md) — CLI tool using `cargo` and crate checksums
- [Rust (Newsboat)](adding-packages/newsboat.md) — Packaging an existing Rust CLI
- [CMake (notcurses)](adding-packages/cmake-example.md) — Library and tools using `cmake`
- [Python (wik)](adding-packages/python-example.md) — CLI tool using `python_flit_core`
- [Meson (kiwix-tools)](adding-packages/meson-example.md) — CLI tools using `meson`

## Recipe Types and Classes

- **Go applications** — `inherit go-mod`, set `GO_IMPORT`, and use a Git `SRC_URI`; put the clone in a path that matches the module path in `go.mod`. See [Go example](adding-packages/go-example.md).
- **Rust applications** — `inherit cargo` and usually `cargo-update-recipe-crates`; use a `*-crates.inc` include for crate checksums. See [Rust examples](adding-packages/rust-example.md) and [Newsboat](adding-packages/newsboat.md).
- **CMake projects** — `inherit cmake` and set `SRC_URI`; use `EXTRA_OECMAKE` for options. See [CMake example](adding-packages/cmake-example.md).
- **Python applications** — `inherit python_flit_core` for Flit/pyproject.toml, or `setuptools3` for setup.py. See [Python example](adding-packages/python-example.md).
- **Meson projects** — `inherit meson` and set `SRC_URI`; use `EXTRA_OEMESON` for options. See [Meson example](adding-packages/meson-example.md).
- **Autotools (configure/make)** — `inherit autotools` and set `SRC_URI`.
- **Simple Makefile** — `inherit pkgconfig` or a custom recipe with `do_compile`/`do_install` steps.

The Yocto Project documentation and existing recipes in `meta-calculinux-apps` and `meta-calculinux-distro` are good references for your specific build system.

## Version and SRCREV

- For **released tarballs**: use `packagename_X.Y.Z.bb` and a `SRC_URI` pointing at the release archive. Set **PV** if the version string in the filename differs from the default.
- For **Git**: use `packagename_git.bb`, set **SRCREV** to the desired commit hash (or a branch name for development), and use a `git://` **SRC_URI**.
- Updating **SRCREV** (and **PV** for tarballs) and refreshing **LIC_FILES_CHKSUM** when upgrading is part of package maintenance.

## Testing Your Recipe

--8<-- "developer/adding-packages/_snippets/build-and-test.md"

## Submitting Packages

- Follow the project's [Contributing](contributing.md) guidelines.
- New recipes and changes to the package group should go through the usual review process (e.g. pull requests against the meta-calculinux repository).
- Keep **LIC_FILES_CHKSUM** correct and document any non-obvious build or runtime dependencies.

## Further Reading

- [Development Overview](overview.md) — Environment and architecture
- [Building Calculinux](building.md) — Build process and feeds
- [Yocto Project — Writing a New Recipe](https://docs.yoctoproject.org/dev-manual/common-tasks.html#writing-a-new-recipe)
- Existing recipes in `meta-calculinux-apps/recipes-apps/` and `recipes-support/` for more examples

For advanced workflows (creating and modifying recipes interactively), the Yocto **devtool** is useful; see the Yocto Project documentation for devtool recipe creation and modification.
