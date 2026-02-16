# Adding Hardware Driver Config Fragments

This guide explains how to add kernel configuration fragments for new hardware drivers in Calculinux. Kernel config fragments allow you to enable or modify specific driver and feature configurations without changing the base kernel configuration.

## Overview

Kernel config fragments are small `.cfg` files that contain kernel configuration options. They are automatically merged during the kernel build process, allowing you to:

- Add support for new hardware devices and peripherals
- Enable optional kernel features
- Configure driver-specific options
- Override default kernel settings for specific peripherals

Calculinux automatically discovers and applies all `.cfg` files in the `meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/` directory during the kernel build.

## How It Works

When building the kernel, the Yocto build system:

1. Discovers all `.cfg` files in the kernel recipe's files directory
2. Generates the necessary kernel configuration based on these fragments
3. Merges fragments in alphabetical order (can be important for dependencies)
4. Compiles the kernel with the merged configuration

The build process is defined in `linux-rockchip_6.1.bbappend`, which automatically handles fragment discovery and merging.

## Existing Config Fragments

Calculinux currently includes the following config fragments:

| Fragment | Purpose |
|----------|---------|
| `base-configs.cfg` | Core kernel configuration |
| `audio-i2s.cfg` | I2S audio interface support |
| `display.cfg` | Display and graphics drivers |
| `dto.cfg` | Device Tree Overlay support |
| `filesystems.cfg` | Filesystem support |
| `fonts.cfg` | Console fonts |
| `led.cfg` | LED subsystem support |
| `removed.cfg` | Explicitly disabled options |
| `rtc.cfg` | Real-Time Clock (DS1307) |
| `utf8.cfg` | UTF-8 filesystem support |
| `wifi.cfg` | Wireless network drivers |
| `rauc.cfg` | RAUC software update support |

## Creating a Config Fragment

### Step 1: Identify Required Kernel Options

First, determine which kernel configuration options you need for your hardware:

1. **Check hardware documentation** - The device datasheet or manufacturer documentation
2. **Find the Linux driver** - Check the Linux kernel source for bindings documentation
3. **Identify config symbols** - Look for `CONFIG_*` options in Kconfig files
4. **Reference similar devices** - Check existing fragments for similar hardware

For example, if adding support for a new I2C temperature sensor, you'd look for:

```bash
# In kernel source: Documentation/devicetree/bindings/thermal/
# Or search the kernel menuconfig for sensor options
```

### Step 2: Create the Fragment File

Create a new `.cfg` file in `meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/`:

**Naming Convention:**

Use descriptive names matching the hardware or feature:

- `ds3231-rtc.cfg` - DS3231 Real-Time Clock support
- `sx1262-lora.cfg` - SX1262 LoRa module support
- `i2c-sensor.cfg` - I2C sensor support
- `usb-gadget.cfg` - USB gadget mode support

**Fragment Format:**

A config fragment is a simple text file with one configuration option per line:

```bash
# Temperature sensor I2C driver
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM75_REGMAP=y

# Optional: Add comments to explain the options
# CONFIG_UNUSED_DRIVER is not set
```

### Step 3: Understand Configuration Options

#### Module vs Built-in

- `CONFIG_OPTION=y` - Compile into the kernel
- `CONFIG_OPTION=m` - Compile as a loadable module
- `# CONFIG_OPTION is not set` - Disable the option

For most drivers, use `=m` to compile as a module (smaller kernel, more flexibility):

```bash
# Good: Load as module if device is not always present
CONFIG_SENSORS_BME280=m
CONFIG_SENSORS_BME280_I2C=m
```

Use `=y` only for essential hardware that must always be available:

```bash
# Essential: always needed for this board
CONFIG_OF_OVERLAY=y
CONFIG_CONFIGFS_FS=y
```

#### Dependencies

Some options depend on other kernel features. Check for required parent options:

```bash
# Example: I2C device drivers need I2C support
CONFIG_I2C=y                    # Parent requirement
CONFIG_SENSORS_LM75=m           # Depends on I2C
CONFIG_SENSORS_LM75_REGMAP=y    # Depends on SENSORS_LM75
```

Fragment files don't specify dependencies - they're already resolved in the kernel's Kconfig. However, ensure all required parent options are enabled.

### Step 4: Test Locally (Optional)

Before committing, you can test the configuration locally:

```bash
# In the Calculinux build environment
cd <calculinux-build-dir>

# Build just the kernel to test your config fragment
bitbake linux-rockchip -c compile -f
```

Check for any warnings or errors related to your config options.

### Step 5: Add to Git

Copy your config fragment to the correct location in the repository:

```bash
# From meta-calculinux directory
cp /path/to/your/feature.cfg \
    meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/

# Add and commit
git add meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/feature.cfg
git commit -m "Add kernel config for feature support"
```

## Common Config Fragment Examples

### Example 1: Simple I2C Sensor

Add support for a common I2C temperature sensor (LM75):

```bash
# File: meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/lm75-sensor.cfg

# LM75 temperature sensor support
CONFIG_HWMON=y
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM75_REGMAP=y
CONFIG_THERMAL=y
CONFIG_THERMAL_OF=y
```

### Example 2: SPI Device

Add support for an SPI-based LoRa module:

```bash
# File: meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/lora.cfg

# LoRa module (bitbang SPI)
CONFIG_SPI_BITBANG=m
CONFIG_SPI_GPIO=m
CONFIG_SPI=y
```

### Example 3: USB Peripheral

Add USB gadget support with specific functions:

```bash
# File: meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/usb-peripheral.cfg

# USB gadget framework
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_CONFIGFS=y
CONFIG_USB_CONFIGFS=y
CONFIG_USB_CONFIGFS_SERIAL=y
CONFIG_USB_CONFIGFS_ACM=y
CONFIG_USB_CONFIGFS_OBEX=y
```

### Example 4: Filesystem Support

Add support for additional filesystems:

```bash
# File: meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/additional-fs.cfg

# Filesystem support
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_EXFAT_FS=m
CONFIG_VFAT_FS=y
```

## Best Practices

### 1. Keep Fragments Focused

Each fragment should handle a related set of features:

```bash
# Good: One feature per file
# File: lm75-sensor.cfg
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM75_REGMAP=y
```

Instead of:

```bash
# Poor: Mix of unrelated features
# File: drivers.cfg
CONFIG_SENSORS_LM75=m
CONFIG_RTL8188EU=m
CONFIG_USB_GADGET=y
```

### 2. Include Comments

Add comments explaining what the configuration enables:

```bash
# DS1307 Real-Time Clock via I2C
# This enables support for the DS1307/DS1338 RTC on I2C bus 2
CONFIG_RTC_CLASS=y
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1307_CENTURY=y
```

### 3. Document Dependencies

If your fragment requires other features, document this:

```bash
# GPS via UART5
# Requires: UART5 enabled, TTY support
# Optional device tree overlay: neo-m8n-gps.dtbo
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_CORE=y
CONFIG_HAVE_PATA_PLATFORM=y
```

### 4. Avoid Conflicting Options

Don't include conflicting options in the same fragment:

```bash
# Good: Choose one approach
# File: rtl-wifi.cfg
CONFIG_WLAN_VENDOR_REALTEK=y
CONFIG_RTL8192CU=m
```

Instead of:

```bash
# Poor: Conflicting drivers
CONFIG_WLAN_VENDOR_REALTEK=y
CONFIG_RTL8192CU=m
CONFIG_WLAN_VENDOR_ATHEROS=y
CONFIG_AR5523=m
```

### 5. Use Module Support for Optional Features

Use `=m` for optional drivers to keep the kernel small:

```bash
# Good: Optional driver as module
CONFIG_SENSORS_BME280=m

# Only use =y if absolutely required
CONFIG_I2C=y  # Required for I2C sensors to work
```

### 6. Order Fragments Alphabetically

While fragments are processed in alphabetical order automatically, group related configurations together in your file:

```bash
# File: i2c-sensors.cfg

# I2C subsystem (parent)
CONFIG_I2C=y
CONFIG_I2C_RK3X=y

# Sensor drivers
CONFIG_SENSORS_BME280=m
CONFIG_SENSORS_LM75=m
```

## Checking Your Configuration

### View Active Kernel Config

After building, check which options are enabled:

```bash
# On the target device
zcat /usr/share/kernel/config.gz | grep CONFIG_OPTION

# On build machine, in kernel sources
grep CONFIG_OPTION <build-dir>/linux-rockchip/.config
```

### Verify Module Loading

If you set options as modules (`=m`), verify they load correctly:

```bash
# On target device
modprobe -l | grep option-name
modprobe option-name
lsmod | grep option-name
```

### Check Kernel Messages

Look for any warnings or errors during boot:

```bash
dmesg | grep -E "(ERROR|WARN|module)"
```

## Integration with Device Tree Overlays

For maximum flexibility, pair kernel config fragments with device tree overlays:

```bash
# Kernel config enables the driver
# File: lm75-sensor.cfg
CONFIG_SENSORS_LM75=m
```

```dts
# Device tree overlay enables the specific device
# File: lm75-sensor-overlay.dts
&i2c2 {
    lm75: lm75@48 {
        compatible = "lm75";
        reg = <0x48>;
    };
};
```

This separation allows:

- Kernel supports the driver generically
- User selects specific devices via overlays
- Easy hardware customization without kernel rebuilds

## Troubleshooting

### Option Not Found

If you get an error about an unknown config option:

```
ERROR: linux-rockchip: Unknown option CONFIG_MY_OPTION
```

**Solution:**

1. Verify the option exists in your kernel version (6.1.x for Calculinux)
2. Check the spelling and case (options are case-sensitive)
3. Look for the option in `kernel/Kconfig` files
4. Some options may be conditionally available (architecture-specific, etc.)

### Kernel Build Fails

If the kernel build fails after adding a config fragment:

1. Check the build log: `bitbake -v linux-rockchip 2>&1 | tee build.log`
2. Look for "Makefile" or config-related errors
3. Verify dependencies are met (parent options enabled)
4. Try disabling the fragment temporarily to isolate the issue

### Module Won't Load

If a driver module won't load on the device:

```bash
# Check dmesg for errors
dmesg | tail -20

# Try loading with verbose output
modprobe -v sensor-driver

# Check if dependencies are met
modinfo sensor-driver
```

## Building and Testing

After adding your config fragment:

### Build the Image

```bash
# From calculinux-build directory
./meta-calculinux/kas-container build \
    ./meta-calculinux/kas-luckfox-lyra-bundle.yaml
```

### Test the Configuration

```bash
# After flashing to device
ssh root@<device-ip>

# Verify kernel includes your config
zcat /usr/share/kernel/config.gz | grep CONFIG_YOUR_OPTION

# Check if driver/module is available
modprobe -l | grep driver-name
```

## File Organization

The `files/` directory contains several types of configuration files:

```
meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/
├── base-configs.cfg          # Core required options
├── display.cfg               # Display driver options
├── dto.cfg                   # Device tree overlay support
├── filesystems.cfg           # Filesystem drivers
├── audio-i2s.cfg            # Audio subsystem
├── wifi.cfg                 # Wireless drivers
├── rtc.cfg                  # RTC device drivers
├── usb-gadget.cfg           # USB gadget support
├── led.cfg                  # LED drivers
└── [your-new-feature].cfg   # Your additions
```

New fragments should follow similar naming patterns.

## Submitting Your Changes

When contributing a new kernel config fragment:

1. **Create the fragment file** with appropriate options
2. **Test on hardware** - Build and verify on actual PicoCalc
3. **Document in code** - Add comments explaining the options
4. **Create corresponding driver/overlay** if needed
5. **Submit pull request** with clear description
6. **Include user documentation** - If adding new functionality

## References

### Kernel Configuration

- [Linux Kernel Configuration](https://www.kernel.org/doc/html/latest/kbuild/kconfig-language.html)
- [Kernel Kconfig Files](https://github.com/torvalds/linux/tree/master/arch/arm/Kconfig)
- [RK3506 Kernel Configuration](https://github.com/rockchip-linux/kernel/blob/develop-4.19/arch/arm/Kconfig)

### Calculinux Resources

- [Device Tree Overlays Developer Guide](device-tree-overlays.md)
- [Building Calculinux](building.md)
- [Contributing Guide](contributing.md)
- [meta-calculinux Repository](https://github.com/Calculinux/meta-calculinux)

### Device Documentation

- [RK3506 Datasheet](https://github.com/rockchip-linux/rkbin)
- [Luckfox Lyra Documentation](https://github.com/luckfox-official/luckfox-lyra)
- [Linux Kernel Device Tree Bindings](https://www.kernel.org/doc/html/latest/devicetree/bindings/)

## Example Workflow: Adding RTL8188EU WiFi Support

Here's a complete example of adding support for a common USB WiFi adapter:

### Step 1: Create Config Fragment

```bash
# File: rtl8188-wifi.cfg
# Realtek RTL8188EU USB WiFi Adapter

# Wireless stack (if not already present in wifi.cfg)
CONFIG_WIRELESS=y
CONFIG_CFG80211=m

# RTL8xxxu staging driver
CONFIG_STAGING=y
CONFIG_RTL8XXXU=m
CONFIG_RTL8188EU=y
```

### Step 2: Add to Repository

```bash
cp rtl8188-wifi.cfg meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/
git add meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/rtl8188-wifi.cfg
git commit -m "Add RTL8188EU USB WiFi driver config"
```

### Step 3: Build and Test

```bash
# Build
./meta-calculinux/kas-container build ./meta-calculinux/kas-luckfox-lyra-bundle.yaml

# On device after boot
lsusb  # Should show the WiFi adapter

# Load the module
modprobe rtl8xxxu

# Check for new wireless interfaces
iwconfig
```

### Step 4: Document (Optional)

Create user documentation in `docs/hardware/rtl8188-wifi.md` explaining setup and usage.

---

## Summary

Adding hardware driver config fragments is straightforward:

1. Create a `.cfg` file with kernel configuration options
2. Place it in `meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/`
3. The build system automatically discovers and applies it
4. Test your changes on hardware
5. Submit your contribution

The modular fragment system makes it easy to enable hardware support without modifying the base kernel configuration, keeping the build system clean and maintainable.
