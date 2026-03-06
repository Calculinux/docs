# Example: Adding a Python Application

This guide walks through adding a Python application to Calculinux. We use [wik](https://github.com/yashsinghcodes/wik), a command-line tool to view Wikipedia from the terminal, as the concrete example. It uses `pyproject.toml` and the Flit build backend, which is common for modern Python packages.

## Reference recipe

The working recipe lives at:

`meta-calculinux-apps/recipes-apps/wik/python3-wik.bb`

## 1. Create the recipe

Create `meta-calculinux-apps/recipes-apps/wik/python3-wik.bb`:

```bitbake
SUMMARY = "Command-line tool to view Wikipedia pages from the terminal"
DESCRIPTION = "WIK is a command-line tool to view Wikipedia pages from your \
terminal. It lets you search Wikipedia articles with a single query. Supports \
caching for offline access, multiple languages, and quick summaries."
HOMEPAGE = "https://github.com/yashsinghcodes/wik"
SECTION = "console/utils"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=0a421caab6054dca789a07a50d1a162f"

SRC_URI = "git://github.com/yashsinghcodes/wik.git;protocol=https;nobranch=1"
SRCREV = "900079af2a29332c2c965d7c50f59dec201d7cbc"

S = "${WORKDIR}/git"

PV = "2.0.1+git${SRCPV}"

inherit python_flit_core

RDEPENDS:${PN} += " \
    python3-beautifulsoup4 \
    python3-requests \
"
```

### Key points

- **inherit python_flit_core** — For packages that use `pyproject.toml` with the Flit build backend. The class handles setup, install, and packaging.
- **RDEPENDS** — List Python dependencies (pip package names map to `python3-<name>` in Yocto). Check the project's `pyproject.toml` or `requirements.txt`.
- **PV** — Set explicitly when the package doesn't have a versioned release; Git-based builds often use `X.Y.Z+git${SRCPV}`.

### Other Python build backends

- **setuptools** — `inherit setuptools3` or `pip_install` for packages with `setup.py` or `pyproject.toml` using setuptools.
- **Custom layout** — `inherit python3-dir python3native` and use a custom `do_install` (see `calculinux-update` in meta-calculinux-distro).

### Licensing

--8<-- "developer/adding-packages/_snippets/licensing-workflow.md"

## 2. Add to the package group

--8<-- "developer/adding-packages/_snippets/add-to-package-group.md"

## 3. Build and test

--8<-- "developer/adding-packages/_snippets/build-and-test.md"
