# Rust packages with OpenSSL

If your Rust crate depends on `openssl` or `openssl-sys` (common for HTTPS), the build will fail with "Could not find directory of OpenSSL installation" unless you configure it for cross-compilation.

Add to your recipe:

```bitbake
DEPENDS = "openssl"

# Set up OpenSSL for Rust's openssl-sys crate (cross-compilation)
export OPENSSL_DIR = "${STAGING_DIR_HOST}${prefix}"
export OPENSSL_LIB_DIR = "${STAGING_DIR_HOST}${libdir}"
export OPENSSL_INCLUDE_DIR = "${STAGING_DIR_HOST}${includedir}"
```

This tells the `openssl-sys` build script where to find OpenSSL in the Yocto staging sysroot. See `glkcli` or `wiki-tui` in meta-calculinux-apps for working examples.
