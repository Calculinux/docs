# 100 kHz I2C Overlay

The 100 kHz I2C overlay reduces the **I2C2** bus clock from the default 400 kHz to **100 kHz**. Use this overlay when you need slower I2C communication, for example to support the [custom PicoCalc keyboard firmware](https://forum.clockworkpi.com/t/custom-picocalc-bios-keyboard-firmware/17292) by JackCarterSmith, which uses 100 kHz for lower power consumption.

## When to Use This Overlay

- **Custom keyboard firmware**: The custom PicoCalc BIOS/keyboard firmware limits the I2C bus to 100 kHz. Without this overlay, Calculinux runs I2C2 at 400 kHz and the keyboard will not respond. Loading the 100 kHz overlay makes the host match the keyboard firmware.
- **Other 100 kHz devices**: Any I2C device on bus 2 that requires standard (100 kHz) rather than fast (400 kHz) mode.

!!! warning "Load order with keyboard"
    If you use the custom keyboard firmware, load the **100khz-i2c** overlay **before** or **at the same time as** any other overlay that uses I2C2 (for example DS3231 RTC). The 100 kHz overlay only affects I2C2.

## Loading the Overlay

### One-time load

```shell
# Create overlay directory
mkdir -p /sys/kernel/config/device-tree/overlays/100khz-i2c

# Load the overlay
cat /boot/devicetree/100khz-i2c.dtbo > /sys/kernel/config/device-tree/overlays/100khz-i2c/dtbo

# Activate it
echo 1 > /sys/kernel/config/device-tree/overlays/100khz-i2c/status
```

### Load at boot (recommended for custom keyboard)

To enable the overlay automatically at boot, add it to the overlay configuration file:

```shell
echo "100khz-i2c" >> /etc/device-tree-overlays.conf
```

If you use the custom keyboard firmware, list **100khz-i2c** before other I2C2 overlays (e.g. `ds3231-rtc`) in `/etc/device-tree-overlays.conf`.

Apply immediately without rebooting:

```shell
systemctl restart load-dt-overlays.service
```

!!! tip
    See [Device Tree Overlays — Making Overlays Persistent](device-tree-overlays.md#making-overlays-persistent) for configuration file format and overlay resolution.

## Verifying

Check that the overlay is active:

```shell
cat /sys/kernel/config/device-tree/overlays/100khz-i2c/status
```

A status of `1` means the overlay is active. I2C2 will now run at 100 kHz. With the custom keyboard firmware, the keyboard should respond after loading this overlay.

## Unloading

To remove the overlay:

```shell
echo 0 > /sys/kernel/config/device-tree/overlays/100khz-i2c/status
rmdir /sys/kernel/config/device-tree/overlays/100khz-i2c
```

I2C2 will return to the default 400 kHz after the next boot (overlays do not persist without the config file).

## Related Topics

- [Device Tree Overlays](device-tree-overlays.md) — General overlay usage
- [Custom Keyboard Firmware Not Working](../troubleshooting/common-issues.md#custom-keyboard-firmware-not-working) — Troubleshooting when the keyboard does not respond
- [DS3231 RTC Module](ds3231-rtc.md) — Using I2C2 for the RTC with 100 kHz

## References

- [Device tree overlay source](https://github.com/Calculinux/picocalc-drivers/blob/main/devicetree-overlays/100khz-i2c-overlay.dts)
