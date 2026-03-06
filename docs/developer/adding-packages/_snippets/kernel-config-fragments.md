## Quick Reference

This snippet provides common patterns for kernel config fragments in Calculinux.

### Basic Template

```bash
# File: meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/myfeature.cfg

# Brief description of what this enables
CONFIG_FEATURE_MAIN=y
CONFIG_FEATURE_DRIVER=m
```

### Common Patterns

**I2C Sensor**
```bash
CONFIG_I2C=y
CONFIG_HWMON=y
CONFIG_SENSORS_LM75=m
```

**SPI Device**
```bash
CONFIG_SPI=y
CONFIG_SPI_BITBANG=m
CONFIG_DEVICE_SPI=m
```

**USB Gadget**
```bash
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_CONFIGFS=y
CONFIG_USB_CONFIGFS_SERIAL=y
```

**RTC Module**
```bash
CONFIG_RTC_CLASS=y
CONFIG_RTC_DRV_DS1307=m
```

**Wireless Driver**
```bash
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
CONFIG_WLAN_VENDOR_NAME=y
CONFIG_DRIVER_NAME=m
```

**Filesystem**
```bash
CONFIG_F2FS_FS=m
CONFIG_EXFAT_FS=m
```

### Key Rules

- Use `=m` for optional drivers (smaller kernel, loads on demand)
- Use `=y` for essential hardware only
- Use `is not set` to explicitly disable options
- One feature per file (keep focused)
- Add comments explaining each option
- Check existing fragments for examples

### Creating a Fragment

**Using Makefile (Recommended):**
```bash
cd meta-calculinux
make kernel-config FRAGMENT=mydevice
# Responds to menuconfig prompts
# Fragment auto-generated
```

**Manual Creation:**
```bash
# Create file in meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/myfeature.cfg
# Add CONFIG_ options
# Commit to git
```

### Testing

```bash
# Build kernel
bitbake linux-rockchip -c compile -f

# Build full image
./meta-calculinux/kas-container build \
    ./meta-calculinux/kas-luckfox-lyra-bundle.yaml

# On device, verify
zcat /usr/share/kernel/config.gz | grep CONFIG_MY_OPTION
modprobe -l | grep driver-name
```

### File Organization

```
meta-picocalc-bsp-rockchip/recipes-kernel/linux/files/
├── base-configs.cfg      # Core options
├── display.cfg          # Graphics drivers
├── wifi.cfg             # Wireless drivers
├── rtc.cfg              # RTC drivers
├── usb-gadget.cfg       # USB support
└── [your-feature].cfg   # Your additions
```

### Common Kernel Config Options

| Option | Purpose |
|--------|---------|
| `CONFIG_I2C` | I2C controller |
| `CONFIG_SPI` | SPI controller |
| `CONFIG_GPIO` | GPIO support |
| `CONFIG_PWM` | PWM support |
| `CONFIG_RTC_CLASS` | Real-time clock |
| `CONFIG_HWMON` | Hardware monitoring |
| `CONFIG_USB_GADGET` | USB device mode |
| `CONFIG_WIRELESS` | Wireless networking |
| `CONFIG_CONFIGFS_FS` | ConfigFS filesystem |
| `CONFIG_OF_OVERLAY` | Device tree overlays |

### Related Documentation

- [Hardware Driver Config Fragments](../developer/kernel-driver-config-fragments.md) — Full guide
- [Device Tree Overlays](../developer/device-tree-overlays.md) — Runtime hardware config
- [Building Calculinux](../developer/building.md) — Build instructions
