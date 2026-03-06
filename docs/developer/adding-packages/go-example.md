# Example: Adding a Go Application

This guide walks through adding a Go terminal application to Calculinux using the `go-mod` class. We use [circumflex](https://github.com/bensadeh/circumflex), a terminal client for Hacker News, as the concrete example.

## Reference recipe

The working recipe lives at:

`meta-calculinux-apps/recipes-apps/circumflex/circumflex_3.8.bb`

## 1. Create the recipe

Create `meta-calculinux-apps/recipes-apps/circumflex/circumflex_3.8.bb` (or `circumflex_git.bb` for a Git-based build):

```bitbake
HOMEPAGE = "https://github.com/bensadeh/circumflex"
SUMMARY = "It's Hacker News in your terminal"
DESCRIPTION = "circumflex is a command line tool for browsing \
Hacker News in your terminal \
"

LICENSE = "AGPL-3.0-only"
LIC_FILES_CHKSUM = "file://src/${GO_IMPORT}/LICENSE;md5=4ae09d45eac4aa08d013b5f2e01c67f6"

inherit go-mod

SRC_URI = "\
    git://${GO_IMPORT};destsuffix=git/src/${GO_IMPORT};nobranch=1;name=${BPN};protocol=https \
"

SRCREV = "d3718631d4dad87c239d2d7b0209773dfdb40ea6"

S = "${WORKDIR}/git"

GO_IMPORT = "github.com/bensadeh/circumflex"
```

### When repo path and Go module path differ

If the GitHub repo path and the Go module path in `go.mod` are the same (e.g. `github.com/bensadeh/circumflex`), you can use `destsuffix=git/src/${GO_IMPORT}` as above.

When they differ (e.g. repo `makew0rld/amfora`, module `makeworld-the-better-one/amfora`), set `destsuffix` explicitly to the module path so the build finds the code where Go expects it:

```bitbake
SRC_URI = "\
    git://github.com/makew0rld/amfora;destsuffix=git/src/github.com/makeworld-the-better-one/amfora;nobranch=1;name=${BPN};protocol=https \
"
```

### Licensing

--8<-- "developer/adding-packages/_snippets/licensing-workflow.md"

## 2. Add to the package group

--8<-- "developer/adding-packages/_snippets/add-to-package-group.md"

## 3. Build and test

--8<-- "developer/adding-packages/_snippets/build-and-test.md"
