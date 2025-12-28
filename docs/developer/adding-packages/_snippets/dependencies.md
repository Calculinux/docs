# Dependencies

## Build or runtime dependencies?

Put build-time deps in **DEPENDS**, runtime deps in **RDEPENDS:${PN}**.

This ensures we only include what is needed. Sometimes build-time packages
are not necessary at runtime. For example, **valac** (the Vala compiler)
transpiles Vala code into C which then gets compiled, so it is not needed
on the destination system. Other tools such as autotools fall into this
category as well.

### Finding dependencies

Check the project's README or build DOCUMENTATION for required libraries.
Common dependencies include:

- `sqlite3`, `curl`, `libxml2`, `ncurses`, `openssl`

Most common libraries are available in layers included in `kas-base.yaml`
or `kas-luckfox-lyra-bundle.yaml`. If missing:

1. Search your kas-container checkout (after a full build) for the
   package name
2. Check the [Layer Index][layerindex]
3. If still not found, create a new recipe or add a layer that provides it

[layerindex]: https://layers.openembedded.org/layerindex/branch/master/recipes/
