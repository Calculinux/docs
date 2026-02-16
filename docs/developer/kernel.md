# Kernel Development

This section covers kernel-related development for Calculinux, including kernel configuration, device tree overlays, and driver support.

## Quick Links

- [**Hardware Driver Config Fragments**](kernel-driver-config-fragments.md) — Add driver support via kernel configuration
- [**Device Tree Overlays**](device-tree-overlays.md) — Create runtime-loadable hardware configurations
- [**Building Calculinux**](building.md) — Build process and options
- [**Developer Overview**](overview.md) — Development environment setup

## Overview

Calculinux uses a customized Linux kernel 6.1.x based on Rockchip's kernel for the RK3506 SoC. Hardware support is managed through:

1. **Kernel Config Fragments** — Enable drivers and features
2. **Device Tree Files** — Define hardware configuration
3. **Device Tree Overlays** — Runtime hardware reconfiguration
4. **Kernel Patches** — Custom fixes and features

## Adding Hardware Support

To add support for new hardware:

### Step 1: Enable the Driver

Use the Makefile helper to generate a kernel config fragment:

```bash
cd meta-calculinux
make kernel-config FRAGMENT=mydevice
```

This opens `menuconfig` for interactive configuration, then automatically generates and saves the fragment.

Alternatively, manually create a `.cfg` file in:
```
meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/
```

See [Hardware Driver Config Fragments](kernel-driver-config-fragments.md) for full details.

### Step 2: Define Hardware in Device Tree

Create a device tree overlay describing your specific hardware:

```dts
&i2c2 {
    status = "okay";
    mydevice@50 {
        compatible = "vendor,device";
        reg = <0x50>;
    };
};
```

See [Creating Device Tree Overlays](device-tree-overlays.md) for complete guide.

### Step 3: Build and Test

```bash
cd calculinux-build
./meta-calculinux/kas-container build \
    ./meta-calculinux/kas-luckfox-lyra-bundle.yaml
```

Flash to device and verify configuration is applied.

## Kernel Architecture

### Build Recipe

- **Source**: `luckfox-linux-6.1-rk3506.git` (external repository)
- **Recipe**: `meta-picocalc-bsp-rockchip/recipes-kernel/linux/linux-rockchip_6.1.bbappend`
- **Config Fragments**: `meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/*.cfg`

### Board Support Package

The `meta-picocalc-bsp-rockchip` layer contains:

- Machine configuration: `conf/machine/luckfox-lyra.conf`
- Kernel build recipe: `recipes-kernel/linux/`
- U-Boot configuration: `recipes-bsp/u-boot/`
- Kernel patches: `recipes-kernel/linux/files/`

### Configuration Hierarchy

Calculinux uses a layered configuration approach:

1. Base kernel config from `rk3506_luckfox_defconfig`
2. Config fragments (all `.cfg` files, merged in alphabetical order)
3. Final merged configuration used for build

## Common Tasks

### Check Active Kernel Configuration

```bash
# On target device
zcat /usr/share/kernel/config.gz | grep CONFIG_OPTION_NAME

# During build
grep CONFIG_OPTION_NAME <bitbake-build-dir>/linux-rockchip/.config
```

### Add Driver Support

```bash
cd meta-calculinux
make kernel-config FRAGMENT=mydriver
```

Or manually create `.cfg` file, then rebuild:

```bash
bitbake linux-rockchip -c compile -f
```

### Modify Kernel Source

```bash
# Extract kernel sources
bitbake linux-rockchip -c unpack

# Edit in work directory
cd tmp/work/<path>/linux-rockchip/*/git

# Rebuild
bitbake linux-rockchip -c compile -f
```

### Apply Custom Patches

Create patch file in `recipes-kernel/linux/files/`, then reference in `linux-rockchip_6.1.bbappend`:

```bitbake
SRC_URI += "file://my-patch.patch"
```

## Device Tree Symbol Support

Calculinux uses a two-pass device tree compilation process to support runtime overlays while keeping the DTB compact. This is handled automatically in the build system.

Key symbols are whitelisted in `linux-rockchip_6.1.bbappend` to enable common peripherals like I2C, GPIO, UART, etc. for overlay use.

## Resources

### Kernel Configuration

- [Hardware Driver Config Fragments](kernel-driver-config-fragments.md) — Add drivers via `.cfg` files
- [Device Tree Overlays](device-tree-overlays.md) — Runtime hardware configuration
- [Linux Kernel Configuration Docs](https://www.kernel.org/doc/html/latest/kbuild/kconfig-language.html)

### Calculinux Documentation

- [Building Calculinux](building.md) — Build process
- [Developer Overview](overview.md) — Development setup
- [Contributing Guide](contributing.md) — Contribution guidelines

### External References

- [RK3506 Kernel Repository](https://github.com/rockchip-linux/kernel)
- [Luckfox Lyra Documentation](https://github.com/luckfox-official/luckfox-lyra)
- [Device Tree Specifications](https://devicetree-specification.readthedocs.io/)
- [Linux Device Tree Documentation](https://www.kernel.org/doc/html/latest/devicetree/)

## Next Steps

- **Add Hardware Support**: See [Hardware Driver Config Fragments](kernel-driver-config-fragments.md)
- **Runtime Configuration**: See [Device Tree Overlays](device-tree-overlays.md)
- **Build System**: See [Building Calculinux](building.md)
