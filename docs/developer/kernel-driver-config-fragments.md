# Adding Hardware Driver Config Fragments

Kernel config fragments are `.cfg` files containing kernel configuration options. They're automatically discovered and merged during the build, allowing you to add driver support without modifying the base kernel configuration.

## Quick Start

The recommended way to create a kernel config fragment is using the Makefile helper:

```bash
cd meta-calculinux
make kernel-config FRAGMENT=mydevice
```

This will:
1. Open the kernel's interactive configuration (`menuconfig`)
2. Let you select your kernel options
3. Automatically generate the fragment using `diffconfig`
4. Save to: `meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/mydevice.cfg`

**Example:**

```bash
cd meta-calculinux
make kernel-config FRAGMENT=lm75-sensor

# In menuconfig, navigate and select your options:
# Device Drivers > Hardware Monitoring > LM75 temperature sensor
# Mark as [M] (module) and save/exit
# Fragment is automatically created!
```

## How It Works

When building the kernel, the Yocto build system:

1. Discovers all `.cfg` files in `meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/`
2. Merges them in alphabetical order
3. Compiles the kernel with merged configuration

The process is defined in `linux-rockchip_6.1.bbappend`.

## Existing Fragments

Calculinux includes:

| Fragment | Purpose |
|----------|---------|
| `base-configs.cfg` | Core kernel options |
| `audio-i2s.cfg` | I2S audio support |
| `display.cfg` | Display drivers |
| `dto.cfg` | Device Tree Overlay support |
| `filesystems.cfg` | Filesystem support |
| `led.cfg` | LED subsystem |
| `rtc.cfg` | Real-Time Clock drivers |
| `wifi.cfg` | Wireless drivers |
| `usb-gadget.cfg` | USB gadget mode |

## Manual Fragment Creation

If you prefer to manually create fragments instead of using the Makefile helper:

### 1. Create the Fragment File

Create a `.cfg` file in `meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/`:

```bash
# File: myfeature.cfg

# Brief description of what this enables
CONFIG_FEATURE_OPTION=y
CONFIG_DRIVER_MODULE=m
# CONFIG_UNUSED_OPTION is not set
```

### 2. Understand Configuration Options

- `CONFIG_OPTION=y` — Compile into kernel
- `CONFIG_OPTION=m` — Compile as loadable module (preferred for optional drivers)
- `# CONFIG_OPTION is not set` — Disable option

### 3. Add to Repository

```bash
git add meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/myfeature.cfg
git commit -m "Add kernel config for feature support"
```

## Best Practices

- **One feature per file** - Keep fragments focused (e.g., `lm75-sensor.cfg`, not `drivers.cfg`)
- **Use modules** - Use `=m` for optional drivers, `=y` only for essential hardware
- **Add comments** - Explain what each option enables
- **Document dependencies** - If your fragment requires other features, comment it
- **Check existing examples** - Reference similar fragments in the repository

## Common Patterns

### I2C Sensor Driver

```bash
CONFIG_I2C=y
CONFIG_HWMON=y
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM75_REGMAP=y
```

### SPI Device

```bash
CONFIG_SPI=y
CONFIG_SPI_BITBANG=m
CONFIG_DEVICE_DRIVER=m
```

### USB Gadget

```bash
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_CONFIGFS=y
CONFIG_USB_CONFIGFS_SERIAL=y
```

### Filesystem Support

```bash
CONFIG_F2FS_FS=m
CONFIG_EXFAT_FS=m
```

## Verify Configuration

After building, verify your config was applied:

```bash
# On build machine
grep CONFIG_MY_OPTION <build-dir>/linux-rockchip/.config

# On target device
zcat /usr/share/kernel/config.gz | grep CONFIG_MY_OPTION

# Check if modules loaded
modprobe -l | grep driver-name
lsmod | grep driver-name
```

## Integration with Device Tree Overlays

For maximum flexibility, pair kernel config fragments with device tree overlays:

- **Kernel fragment** enables the driver
- **Device tree overlay** enables the specific device instance

Example:

```bash
# Kernel fragment: enables driver
CONFIG_SENSORS_LM75=m
```

```dts
# Device tree overlay: enables specific device
&i2c2 {
    lm75: lm75@48 {
        compatible = "lm75";
        reg = <0x48>;
    };
};
```

See [Creating Device Tree Overlays](device-tree-overlays.md) for details.

## Building and Testing

### Build the Image

```bash
cd calculinux-build
./meta-calculinux/kas-container build \
    ./meta-calculinux/kas-luckfox-lyra-bundle.yaml
```

### Test on Device

```bash
# After flashing to device
ssh root@<device-ip>

# Verify your config
zcat /usr/share/kernel/config.gz | grep CONFIG_YOUR_OPTION
```

## Troubleshooting

### Option Not Found

If you get an "Unknown option" error:

1. Verify it exists in kernel 6.1.x (Calculinux uses `linux-rockchip_6.1`)
2. Check spelling and case (CONFIG options are case-sensitive)
3. Some options may be architecture-specific or require parent options

### Kernel Build Fails

If the build fails:

1. Check the build log: `bitbake -v linux-rockchip 2>&1 | tee build.log`
2. Verify parent options are enabled (e.g., enable `CONFIG_I2C` before I2C drivers)
3. Try building without your fragment to isolate the issue

### Module Won't Load

If a driver module won't load:

```bash
# Check kernel messages
dmesg | tail -20

# Check module dependencies
modinfo driver-name

# Try loading manually
modprobe -v driver-name
```

## Submitting Changes

When contributing a new kernel config fragment:

1. Create the fragment with appropriate comments
2. Test on hardware
3. Ensure it follows naming conventions
4. Submit pull request with clear description
5. If adding new functionality, create user documentation

## References

- [Device Tree Overlays Developer Guide](device-tree-overlays.md)
- [Building Calculinux](building.md)
- [Linux Kernel Configuration Documentation](https://www.kernel.org/doc/html/latest/kbuild/kconfig-language.html)
- [meta-calculinux Repository](https://github.com/Calculinux/meta-calculinux)

## Summary

1. **Recommended:** Use `make kernel-config FRAGMENT=<name>` to generate fragments interactively
2. **Alternative:** Manually create `.cfg` files with kernel options
3. Place in: `meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/`
4. Build and test with full image build
5. Verify configuration is applied on device

The modular fragment system keeps the build clean and maintainable while enabling flexible hardware support.
