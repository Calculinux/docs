# Example: Packaging a Simple Rust Utility

This guide walks through creating a small Rust command-line utility and
packaging it into a Yocto recipe so it ships in Calculinux images.

## Prerequisites

- Calculinux build environment ready (Yocto Walnascar 4.3)
- A working layer where you place custom recipes (e.g.,
  `meta-calculinux-extended` or in `meta-calculinux-apps` if you want
  to contribute back to us).

## 1) Create the Rust Utility

Make a minimal CLI called `hello-calculinux`:

```bash
cargo new hello-calculinux --bin
cd hello-calculinux
```

Edit `src/main.rs`:

```rust
fn main() {
    println!("hello, Calculinux!");
}
```

Add a `Cargo.lock` and set a version in `Cargo.toml`:

```toml
[package]
name = "hello-calculinux"
version = "0.1.0"
edition = "2026"
```

Commit the project to a Git repo (local or hosted):

```bash
git init && git add .
git commit -m "Initial Rust utility"
# If hosting, push to e.g., GitHub
```

## 2) Add Sources to Your Layer

Create a recipe folder in your custom layer (example paths):

```text
meta-hello-calculinux/
  recipes-utils/
    hello-calculinux/
      hello-calculinux_0.1.0.bb
```

You can fetch sources via `git` or bundle them as a tarball. Git is
simplest during development, but if you're packaging an upstream project,
you're limited to how they ship.

## 3) Write the Yocto Recipe

Create `hello-calculinux_0.1.0.bb` with this content (include the
license file path but omit the checksum initially; BitBake will prompt
you with the exact value to add):

```bitbake
SUMMARY = "Simple Rust CLI that prints a greeting"
HOMEPAGE = "https://github.com/Calculinux/hello-calculinux"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=<fill-after-bitbake>"

# Fetch from your repo; replace URL/branch/SRCREV with your details
SRC_URI = "git://github.com/Calculinux/hello-calculinux;branch=main;\
protocol=https"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

inherit cargo

# Build in release mode for smaller/faster binaries
CARGO_BUILD_FLAGS += "--release"

# Install the compiled binary into /usr/bin
# The Cargo class sets up the target directory; copy the release binary
do_install() {
    install -d ${D}${bindir}
    # Find the built binary from the cargo target dir and install it
    BIN_PATH=$(find ${B}/target -type f -name hello-calculinux -path "*/release/*" -print -quit)
    if [ -z "$BIN_PATH" ]; then
        bbfatal "hello-calculinux binary not found in target/release"
    fi
    install -m 0755 "$BIN_PATH" ${D}${bindir}/hello-calculinux
}

# Package contents
FILES:${PN} += "${bindir}/hello-calculinux"

# Optionally strip the binary if desired
INHIBIT_PACKAGE_STRIP = "0"
```

Notes:

- Use `SRC_URI` pointing to your Git repo. For local development, you
  can use `file://` sources and `externalsrc`.
- The `cargo` class handles Rust toolchain configuration for the target.
- The `do_install()` step copies the compiled binary to `${bindir}`.

### Licensing Workflow

--8<-- "developer/adding-packages/_snippets/licensing-workflow.md"

## 4) Add the Package to Your Image

Add the utility to your image via an `IMAGE_INSTALL` append. For example,
in your distribution or image configuration or a bundle:

```bitbake
IMAGE_INSTALL:append = " hello-calculinux"
```

If you use a bundle (e.g., `calculinux-bundle.bb`), include it there.

## 5) Build and Test

Build the package and the image:

```bash
# Build just the package (faster for iteration)
bitbake hello-calculinux

# Or build the image that includes it
bitbake calculinux-image
```

After flashing and booting, verify on the target:

```bash
hello-calculinux
# Output: hello, Calculinux!
```

--8<-- "developer/adding-packages/_snippets/sd-card-install.md"

## Troubleshooting

- If Rust is not available, add `meta-rust` and ensure the Rust toolchain
  is enabled for your target.
- If the binary isn't found during `do_install()`, check the
  `B/target/*/release/` path in the build logs and adjust the `find`
  command as needed.
- For crates with dependencies, ensure `Cargo.lock` is present to avoid
  network fetches during builds.

--8<-- "developer/adding-packages/_snippets/dependencies.md"

## Next Steps

- Add CLI options with `clap` or `argparse` for richer utilities.
- Package libraries and services (systemd units) with additional Yocto recipe sections.
- Create a `-dev` subpackage if you plan to expose headers or examples.
