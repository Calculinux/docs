# Cargo.lock out of sync ("lock file needs to be updated but --frozen was passed")

When using `cargo-update-recipe-crates` with a patched `Cargo.lock` (e.g. to pin a dependency for Rust version compatibility), the build may fail with:

```
error: the lock file .../Cargo.lock needs to be updated but --frozen was passed to prevent this
```

The cargo class uses `--frozen` by default, which forbids any changes to `Cargo.lock`. If your patch modifies the lock file (e.g. pinning tui-logger to an older version), Cargo may need to reconcile the lock file with `Cargo.toml`, which `--frozen` blocks.

**Fix:** Override the build flags to use `--offline` instead of `--frozen`. This allows Cargo to update the lock file locally using the vendored crates from BitBake, without network access:

```bitbake
# Use --offline instead of --frozen when Cargo.lock is patched
CARGO_BUILD_FLAGS:remove = "--frozen"
CARGO_BUILD_FLAGS += "--offline"
```

See `wiki-tui` in meta-calculinux-apps for a working example (tui-logger pin patch + this override).
