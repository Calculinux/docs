# Rust version requirements

Some crates use features that require a specific Rust version. For example, `is_multiple_of` (used by tui-logger 0.17.4+) was stabilized in **Rust 1.87**.

**Options:**

1. **Upgrade Rust** — Add or update meta-rust / meta-rust-bin to provide Rust 1.87+. Check your Yocto layer for Rust version configuration.

2. **Pin an older crate version** — If a dependency requires a newer Rust feature, pin it to an older release in your `*-crates.inc` and add a patch to `Cargo.lock`. See `wiki-tui` in meta-calculinux-apps for an example: tui-logger is pinned to 0.17.3 (0.17.4 needs Rust 1.87+). When patching `Cargo.lock`, you may also need to use `--offline` instead of `--frozen`; see the "lock file needs to be updated" troubleshooting entry.
