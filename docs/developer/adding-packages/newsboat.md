# Packaging Newsboat (Rust CLI)

This guide covers packaging the existing Rust-based CLI application **Newsboat**
using Yocto, following patterns that work well in practice.

## Reference example

Check **glkcli** in your layers for a working Rust recipe:

- `meta-calculinux-apps/recipes-games/glkcli/glkcli_git.bb`

## Key recipe fields

Use these fields; omit the license checksum initially:

- **SECTION**: Category such as `"console/network"`, `"games"`, and so on.
- **SRC_URI**: `"git://github.com/owner/repo;protocol=https;branch=master"`
- **SRCREV**: Git commit hash, or `${AUTOREV}` for latest
- **S**: `${WORKDIR}/git` (where the source gets checked out)

### Add license checksum later

BitBake will fail the first build and print the exact `LIC_FILES_CHKSUM` to use.
Include the license filename up front, then copy the suggested checksum into
your recipe:

```bitbake
LICENSE = "MIT"  # or the license used by the project
LIC_FILES_CHKSUM = "file://LICENSE;md5=<value from bitbake error>"
```

--8<-- "developer/adding-packages/\_snippets/licensing-workflow.md"

## Rust-specific lines

Include these in the recipe:

```bitbake
inherit cargo cargo-update-recipe-crates
require ${BPN}-crates.inc
```

Then generate crate dependencies from Cargo.lock:

```bash
bitbake -c update_crates newsboat
```

This auto-generates `newsboat-crates.inc` listing all Rust dependencies.

--8<-- "developer/adding-packages/\_snippets/dependencies.md"

## Tips

- Keep `SRCREV` pinned to a commit for reproducibility; use `${AUTOREV}` only
  during development.
- Ensure `Cargo.lock` is present to avoid network fetches during builds.
- Test the package standalone before adding it to images:

```bash
bitbake newsboat
```
