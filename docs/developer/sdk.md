# Using the Yocto SDK

The Calculinux CI builds a cross-compilation SDK for application development. SDKs are produced by the meta-calculinux build and publish workflows whenever the `develop` branch or a tagged release is built. Each SDK installer contains the target sysroot, cross-toolchain, pkg-config data, and CMake/Meson toolchain files for the Luckfox Lyra.

## Download locations

SDKs are published to the Calculinux download server. Pick the feed/subfolder based on the build type you need:

| Build type | Feed name | Subfolder | Example x86_64 URL |
| --- | --- | --- | --- |
| Development builds (branch `develop`) | `develop` | `continuous` | `https://opkg.calculinux.org/sdk/develop/continuous/x86_64/` |
| Tagged releases (e.g., `v1.0.0`) | `walnascar` (current distro codename) | `release` | `https://opkg.calculinux.org/sdk/walnascar/release/x86_64/` |

Notes:
- SDKs are built for x86_64 and aarch64 hosts; both target the Luckfox Lyra (ARMv7).
- `main` branch builds do not produce SDKs.
- Each directory includes a `.sh` installer and a matching `.manifest` for reference.

## Install the SDK

1) Download the installer that matches your host architecture:

```bash
SDK_BASE=https://opkg.calculinux.org/sdk/develop/continuous
curl -O ${SDK_BASE}/x86_64/calculinux-sdk-luckfox-lyra-x86_64.sh
curl -O ${SDK_BASE}/x86_64/calculinux-sdk-luckfox-lyra-x86_64.manifest
```

2) Choose an install location (no sudo needed):

```bash
INSTALL_DIR="$HOME/opt/calculinux-sdk"
chmod +x calculinux-sdk-luckfox-lyra-x86_64.sh
./calculinux-sdk-luckfox-lyra-x86_64.sh -d "$INSTALL_DIR" -- -y
```

3) Optional: skim the manifest to see included headers and libraries:

```bash
less calculinux-sdk-luckfox-lyra-x86_64.manifest
```

## Activate the cross environment

Source the environment script from the install directory (exact filename may vary slightly with the tune):

```bash
source "$INSTALL_DIR"/environment-setup-*
```

After sourcing you should see the cross toolchain in your path:

```bash
echo $CC
$CC --version
pkg-config --modversion sdl2
```

To make this persistent for a shell session, add the `source` line to your shell RC file or a project-specific script.

## Build applications with the SDK

### Plain Make or Autotools

```bash
$CC hello.c -o hello
```

### CMake

```bash
cmake -B build -S . \
  -DCMAKE_TOOLCHAIN_FILE=$OECORE_NATIVE_SYSROOT/usr/share/cmake/OEToolchainConfig.cmake
cmake --build build
```

### Meson

```bash
meson setup build . --cross-file $OECORE_NATIVE_SYSROOT/usr/share/meson/oe-cross-file.txt
meson compile -C build
```

The `$PKG_CONFIG_SYSROOT_DIR` and `$OECORE_TARGET_SYSROOT` variables from the SDK environment ensure headers and libraries resolve correctly.

## Build out-of-tree kernel modules

The SDK includes the target sysroot and matching kernel headers for the Luckfox Lyra image. Use the SDK cross toolchain to build modules that match the kernel shipped in the corresponding image.

1) Create a simple module (example):

```c
// hello.c
#include <linux/module.h>
#include <linux/init.h>

static int __init hello_init(void)
{
  pr_info("hello module loaded\n");
  return 0;
}

static void __exit hello_exit(void)
{
  pr_info("hello module unloaded\n");
}

module_init(hello_init);
module_exit(hello_exit);
MODULE_LICENSE("GPL");
```

2) Add a minimal `Makefile` that uses the kernel build system:

```make
obj-m += hello.o
```

3) Build the module with the SDK environment:

```bash
source "$INSTALL_DIR"/environment-setup-*
KERNEL_SRC=$OECORE_TARGET_SYSROOT/usr/src/kernel

# ARCH and CROSS_COMPILE come from the SDK environment, but set ARCH explicitly for clarity
ARCH=arm make -C "$KERNEL_SRC" M="$PWD" modules
```

4) The resulting `hello.ko` can be copied to the device and loaded:

```bash
scp hello.ko root@<device>:/tmp/
ssh root@<device> "insmod /tmp/hello.ko && dmesg | tail"
```

Notes:
- Always use an SDK that matches the image running on the device (same release/feed) so the module ABI aligns with the kernel.
- If you see missing headers, confirm the SDK contains `usr/src/kernel`; install the matching `linux-*-dev` package into the SDK sysroot if needed, then rebuild.
- For repeated builds, keep the `KERNEL_SRC` path cached; the kernel tree in the SDK already has the correct config and Module.symvers.

## Updating the SDK

- Grab the latest installer from the same feed/subfolder when CI publishes a new build (develop) or a new tag (release).
- Reinstall to a fresh directory to avoid mixing toolchain revisions; update your `source` path accordingly.
- If builds fail after an update, re-run the installer and re-source the environment to refresh all paths.
