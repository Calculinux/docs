### Dependencies

Put build-time deps in **DEPENDS**, runtime deps in **RDEPENDS:${PN}**.

This is used by the build system to ensure that we only include what we really need. Sometimes packages used for build aren't necessary while running the application. **valac** (the Vala compiler) for example transpiles Vala code into C code which then gets compiled, so it's not needed on the destination system. There are lots of other tools used at build time (like autotools) that fall into this category as well.

#### Finding Dependencies

Check the project's README or build documentation for required libraries. Common dependencies include:
- `sqlite3`, `curl`, `libxml2`, `ncurses`, `openssl`

Most common libraries are available in layers included via `kas-base.yaml` or `kas-luckfox-lyra-bundle.yaml`. If missing:

1. Search your kas-container checkout (after a full build) for the package name
2. Check the Layer Index: https://layers.openembedded.org/layerindex/branch/master/recipes/
3. If still not found, create a new recipe or add a layer that provides it
