# Maintaining Feed Packages Across Updates

Calculinux devices run a read-only system image with a writable overlay on
top. Packages that users install with `opkg` live in the overlay; everything
else comes with the image. When a device installs a new image with `cup`, the
packages in the overlay have to keep working on top of it. This page explains
what the update does with them, and what package maintainers must do so that
it works.

## What an image update does with installed packages

During `cup install`, calculinux-update compares the overlay's package list
(`/var/lib/opkg/status`) with the new image's (`status.image` in the bundle)
and sorts every overlay entry into one of these groups:

| Group | What it is | What happens |
| --- | --- | --- |
| Duplicate | The new image now ships the package too | The overlay copy is removed after the reboot and the image's copy shows through |
| Leaked entry | An image package opkg recorded in the overlay's list, with no files of its own | The entry is dropped |
| Overlay package | Something the user installed | Kept; reinstalled only when the ABI changes (below) |

Overlay packages are reinstalled from the new image's package feed only when
the new image could break them:

| The new image has... | Reinstalled |
| --- | --- |
| The same release and kernel | Nothing |
| A different kernel | The overlay's `kernel-module-*` packages |
| A different release (codename or Yocto series) | Every overlay package |

For those reinstalls `cup install` downloads the packages and their
dependencies *before* the reboot, while the device is still online. After the
reboot they are installed from that cache, so the update does not need the
network. Anything that could not be downloaded waits: the login message and
`cup status` list it, and `cup reconcile` installs it once the device is online
(`cup-reconcile.timer` also retries every 15 minutes).

```shell
cup status          # packages waiting, and packages that could not be reinstalled
sudo cup reconcile  # after connecting to the network (uwific)
```

## The version-string rule

Within a release, overlay packages are *not* reinstalled. They are updated the
normal way, with `opkg upgrade`, which only replaces a package when the feed
has a **higher version string**. Calculinux builds do not use a PR service, so
rebuilding a recipe from the same sources produces the same version string,
and devices keep the old binary.

That is only a problem when the old binary no longer works with the new
image. So:

!!! warning "Bump the version when an image-wide change breaks the ABI"
    If a change to the image within a release changes the ABI that feed
    packages are built against, bump `PR` (or add a version suffix) in every
    feed recipe the change affects, so `opkg upgrade` replaces the old
    binaries.

Changes that need a bump include:

- toolchain changes (a new GCC or musl version with ABI changes)
- global build flags: `TUNE_*`, `DEFAULTTUNE`, distro-wide `CFLAGS`, time64
- a library in the image changing its soname (every feed package linking it)
- a Python minor version change (every Python module in the feed)

For example:

```bitbake
# Rebuilt against libfoo.so.3 in the image
PR = "r1"
```

A new release (a new codename) does not need this: devices reinstall every
overlay package when they move to it.

## Kernel modules

Out-of-tree kernel module packages are named after the kernel they were built
for (`kernel-module-rtw89-core-6.1.99-rockchip-standard`). When the image's
kernel changes, `cup` reinstalls the overlay's kernel-module packages from the
new feed, which must therefore carry builds for the new kernel under the new
names. A kernel change needs no manual version bump.

## Moving to a new release

A new release can require devices to install a particular release of the old
series first (a "stepping stone"), for example one whose update tooling knows
how to move packages across. Set it in `calculinux-distro.conf` on the new
release's branch:

```bitbake
CALCULINUX_MIN_VERSION = "v1.0.0-alpha8"
```

It is enforced twice:

- `cup install` refuses the update when the running version is older or
  unknown.
- The bundle's `install-check` hook refuses it even for a plain `rauc install`,
  before any slot is written. It also checks that the running system has the
  overlayfs ioctls and a calculinux-update that uses them. RAUC skips its own
  `compatible` check when a bundle has an install-check hook, so the hook
  checks that too.

`cup install --force` overrides the version and capability checks (it creates
`/run/calculinux-update/allow-install-check-override` for the hook). The
`compatible` check cannot be overridden.

## Where this is implemented

- Planning, prefetch and post-reboot reinstalls:
  [calculinux-update](https://github.com/Calculinux/calculinux-update)
  (`opkg/reconcile.py`, `prefetch.py`, `hooks.py`)
- Upper-layer detection and whiteout restore: the overlayfs module
  [Calculinux/overlayfs](https://github.com/Calculinux/overlayfs), built for
  every machine by the `overlayfs-calculinux` recipe
- The install-check hook: `recipes-core/bundles/files/hook.sh` in
  meta-calculinux
