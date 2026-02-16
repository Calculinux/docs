# Kernel Development

This section covers kernel-related development for Calculinux, including kernel configuration, device tree overlays, and driver support.

## Quick Links

- [**Kernel Config Fragments**](kernel-driver-config-fragments.md) - Add hardware driver support via kernel configuration
- [**Device Tree Overlays**](device-tree-overlays.md) - Create custom device tree overlays
- [**Building Calculinux**](building.md) - Build the kernel and full system
- [**Developer Overview**](overview.md) - General development environment

## Kernel Basics

Calculinux uses a customized Linux kernel (6.1.x) based on Rockchip's kernel for the RK3506 SoC used in Luckfox Lyra.

### Kernel Organization

The kernel configuration and customization is managed through:

1. **Kernel Config Fragments** (`.cfg` files) - Enable drivers and features
2. **Device Tree Files** (`.dts`/`.dtsi`) - Define hardware configuration
3. **Device Tree Overlays** (`.dtbo` files) - Runtime hardware reconfiguration
4. **Kernel Patches** - Custom fixes and features

## Adding Hardware Support

### Step 1: Enable the Driver

First, enable kernel support for your hardware via a config fragment:

```bash
# meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/mydevice.cfg
CONFIG_MY_DEVICE_DRIVER=m
CONFIG_MY_DEVICE_I2C=y
```

See [Kernel Driver Config Fragments](kernel-driver-config-fragments.md) for detailed instructions.

### Step 2: Define Hardware in Device Tree

Create a device tree overlay to describe your specific hardware:

```dts
&i2c2 {
    status = "okay";
    mydevice@50 {
        compatible = "vendor,device";
        reg = <0x50>;
    };
};
```

See [Creating Device Tree Overlays](device-tree-overlays.md) for full guide.

### Step 3: Build and Test

```bash
./meta-calculinux/kas-container build ./meta-calculinux/kas-luckfox-lyra-bundle.yaml
```

## Architecture

### Kernel Files

- **Source**: `luckfox-linux-6.1-rk3506.git` (external repository)
- **Build Recipe**: `meta-picocalc-bsp-rockchip/recipes-kernel/linux/linux-rockchip_6.1.bbappend`
- **Config Fragments**: `meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/*.cfg`
- **Device Trees**: `luckfox-linux-6.1-rk3506` repository

### Board Support Package

The `meta-picocalc-bsp-rockchip` layer contains:

- **Machine Configuration**: `conf/machine/luckfox-lyra.conf`
- **Kernel Recipe**: `recipes-kernel/linux/`
- **U-Boot Configuration**: `recipes-bsp/u-boot/`
- **Kernel Patches**: `recipes-kernel/linux/files/`

## Kernel Configuration Hierarchy

Calculinux uses a layered configuration approach:

1. **Base Kernel Config** - `rk3506_luckfox_defconfig` (from Rockchip)
2. **Config Fragments** - Layer-specific options (automatically merged)
3. **Kernel Config Merge** - BitBake merges all fragments during build

Fragments are processed in alphabetical order, so use appropriate naming:

- `base-configs.cfg` - Core required options
- `audio-i2s.cfg` - Audio subsystem
- `wifi.cfg` - Wireless drivers
- etc.

## Common Tasks

### Check Active Kernel Configuration

View which options are enabled in the compiled kernel:

```bash
# On target device
zcat /usr/share/kernel/config.gz | grep CONFIG_OPTION_NAME

# In build environment
grep CONFIG_OPTION_NAME <bitbake-build-dir>/linux-rockchip/.config
```

### Add Driver Support

There are two approaches:

**Option 1: Interactive Configuration (Recommended for New Drivers)**

Use the Makefile helper to interactively configure the kernel:

```bash
cd meta-calculinux
make kernel-config FRAGMENT=mydevice
```

This opens menuconfig, lets you select your options, and automatically generates the fragment.

**Option 2: Manual Fragment Creation**

1. Create or modify a `.cfg` file in `meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/`
2. Add kernel config options for your driver
3. Rebuild: `bitbake linux-rockchip -c compile -f`

See [Kernel Driver Config Fragments](kernel-driver-config-fragments.md).

### Modify Kernel Source

```bash
# Extract kernel sources
bitbake linux-rockchip -c unpack

# Make changes in:
cd tmp/work/<build-path>/linux-rockchip/*/git

# Rebuild
bitbake linux-rockchip -c compile -f
```

### Create Device Tree Overlay

See [Creating Device Tree Overlays](device-tree-overlays.md) for complete guide.

### Apply Kernel Patch

```bash
# Create a patch file
cp my-changes.patch meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/

# Reference in linux-rockchip_6.1.bbappend
# SRC_URI = " \
#     ... \
#     file://my-changes.patch \
# "
```

## Resources

### Kernel Configuration

- [Kernel Driver Config Fragments Guide](kernel-driver-config-fragments.md) - Add hardware drivers
- [Linux Kernel Configuration](https://www.kernel.org/doc/html/latest/kbuild/kconfig-language.html)
- [Device Tree Overlay Guide](device-tree-overlays.md) - Create runtime-loadable overlays

### Documentation

- [Building Calculinux](building.md) - Build process and options
- [Developer Overview](overview.md) - Development environment setup
- [Contributing Guide](contributing.md) - Submission guidelines

### External Resources

- [Linux Kernel Documentation](https://www.kernel.org/doc/html/latest/devicetree/)
- [Rockchip Kernel Repository](https://github.com/rockchip-linux/kernel)
- [RK3506 Datasheet](https://github.com/rockchip-linux/rkbin)
- [Device Tree Specifications](https://devicetree-specification.readthedocs.io/)

## Coming Soon

The following sections are planned for future release:

- Kernel debugging techniques
- Kernel performance tuning
- Submitting kernel patches upstream
- Advanced device tree topics
- Custom kernel module development

---

Start with [Kernel Driver Config Fragments](kernel-driver-config-fragments.md) to add support for new hardware!
