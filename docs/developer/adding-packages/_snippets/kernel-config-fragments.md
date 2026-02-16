## Quick Reference

This snippet provides a quick reference for common hardware driver config fragment patterns in Calculinux.

### Basic Template

```bash
# File: meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/DEVICENAME.cfg

# Brief description of what this enables
# Example: Support for XYZ hardware peripheral

CONFIG_OPTION_NAME=y
CONFIG_ANOTHER_OPTION=m
# CONFIG_DISABLED_OPTION is not set
```

### Common Patterns

**I2C Sensor Driver**
```bash
CONFIG_I2C=y
CONFIG_HWMON=y
CONFIG_SENSORS_DEVICENAME=m
```

**SPI Device Driver**
```bash
CONFIG_SPI=y
CONFIG_SPI_BITBANG=m
CONFIG_DEVICE_DRIVER=m
```

**USB Gadget Function**
```bash
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_CONFIGFS=y
CONFIG_USB_CONFIGFS_FUNCTIONNAME=y
```

**RTC Module**
```bash
CONFIG_RTC_CLASS=y
CONFIG_RTC_DRV_DEVICENAME=m
```

**Wireless Driver**
```bash
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
CONFIG_WLAN_VENDOR_MANUFACTURER=y
CONFIG_DRIVER_NAME=m
```

**Filesystem Support**
```bash
CONFIG_FILESYSTEM_TYPE=m
CONFIG_FILESYSTEM_TYPE_XATTR=y
```

### Key Rules

- **Module** (`=m`) - For optional drivers
- **Built-in** (`=y`) - For required drivers only  
- **Disabled** (`is not set`) - Explicitly turn off options
- **One feature per file** - Keep fragments focused
- **Alphabetical naming** - Use consistent naming pattern
- **Add comments** - Explain the purpose of each option

### File Organization

```
meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/
├── base-configs.cfg              # Core
├── audio-i2s.cfg                # Audio
├── display.cfg                  # Graphics
├── dto.cfg                      # Device tree overlays
├── filesystems.cfg              # FS support
├── fonts.cfg                    # Console fonts
├── led.cfg                      # LEDs
├── removed.cfg                  # Disabled options
├── rtc.cfg                      # RTC drivers
├── utf8.cfg                     # UTF-8 support
├── wifi.cfg                     # Wireless
├── rauc.cfg                     # Updates
└── [your-feature].cfg           # Your additions
```

### Testing

```bash
# Add your fragment to the files/ directory
cp myfeature.cfg meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/

# Build kernel
bitbake linux-rockchip -c compile -f

# Verify config was applied
grep CONFIG_MY_OPTION tmp/work/.../linux-rockchip/.config

# Build full image
./meta-calculinux/kas-container build ./meta-calculinux/kas-luckfox-lyra-bundle.yaml

# On device, verify
zcat /usr/share/kernel/config.gz | grep CONFIG_MY_OPTION
```

### Common Kernel Config Options

| Option | Purpose |
|--------|---------|
| `CONFIG_I2C` | I2C controller support |
| `CONFIG_SPI` | SPI controller support |
| `CONFIG_UART_8250` | Serial port support |
| `CONFIG_GPIO` | GPIO support |
| `CONFIG_PWM` | PWM support |
| `CONFIG_HWMON` | Hardware monitoring drivers |
| `CONFIG_RTC_CLASS` | Real-time clock support |
| `CONFIG_USB_GADGET` | USB device mode |
| `CONFIG_WIRELESS` | Wireless networking |
| `CONFIG_BT` | Bluetooth support |
| `CONFIG_CONFIGFS_FS` | ConfigFS filesystem |
| `CONFIG_OF_OVERLAY` | Device tree overlay support |

### Related Documentation

- [Kernel Driver Config Fragments](../developer/kernel-driver-config-fragments.md) - Full guide
- [Device Tree Overlays](../developer/device-tree-overlays.md) - Define hardware in device tree
- [Building Calculinux](../developer/building.md) - Build instructions
