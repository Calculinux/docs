# DS3231 Real-Time Clock Module

The DS3231 is a highly accurate I2C-based Real-Time Clock (RTC) module that can keep time even when your PicoCalc is powered off. This guide covers hardware connection and software setup.

## Hardware Requirements

- **DS3231 RTC Module** (commonly available breakout boards)
- **Wiring** to connect to PicoCalc I2C pins
- **CR2032 Battery** (usually included with module) for timekeeping when powered off

## Hardware Connection

The DS3231 connects to **I2C bus 2** on the PicoCalc:

| DS3231 Pin | Connection | Description |
|------------|------------|-------------|
| **VCC** | 3.3V power | Power supply |
| **GND** | Ground | Ground reference |
| **SDA** | GPIO IO5 (I2C2 SDA) | Data line |
| **SCL** | GPIO IO4 (I2C2 SCL) | Clock line |
| **SQW/INT** | (Optional) GPIO | Interrupt for alarms |

!!! warning "Voltage Level"
    Use **3.3V**, not 5V. The PicoCalc GPIO pins are 3.3V logic.

!!! info "I2C Address"
    The DS3231 uses I2C address **0x68** by default.

### GPIO Wiring Reference

![DS3231 RTC wiring on PicoCalc GPIO pins](../../assets/images/ds3231-gpio-wiring.jpg)

The image above shows how to connect the DS3231 module to the I2C header on the PicoCalc. Connect:

- **VCC** to 3.3V (pin 5 on the right header)
- **GND** to ground (pin 18 on the left header)
- **SDA** to I2C SDA (pin 9 on the left header)
- **SCL** to I2C SCL (pin 10 on the left header)

## Software Setup

### Step 1: Enable the Device Tree Overlay

Load the DS3231 overlay to register the device with the kernel:

```shell
# Create overlay directory
mkdir -p /sys/kernel/config/device-tree/overlays/ds3231

# Load the overlay
cat /boot/devicetree/ds3231-rtc.dtbo > /sys/kernel/config/device-tree/overlays/ds3231/dtbo

# Activate it
echo 1 > /sys/kernel/config/device-tree/overlays/ds3231/status
```

### Step 2: Verify Detection

Check that the DS3231 is detected on the I2C bus:

```shell
# Scan I2C bus 2 for devices
i2cdetect -y 2
```

You should see a device at address `0x68`:

```text
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- -- -- -- -- -- -- -- 68 -- -- -- -- -- -- -- 
70: -- -- -- -- -- -- -- --
```

Check for the RTC device node:

```shell
ls -l /dev/rtc*
```

The DS3231 should appear as `/dev/rtc1` (the SoC's built-in RTC is typically `/dev/rtc0`).

Verify in kernel messages:

```shell
dmesg | grep -i rtc
```

## Using the RTC

### Read Current Time

```shell
hwclock -r -f /dev/rtc1
```

### Set RTC from System Time

After setting the system time (via NTP or manually), write it to the RTC:

```shell
hwclock -w -f /dev/rtc1
```

### Set System Time from RTC

On boot or when the system time is incorrect, read from the RTC:

```shell
hwclock -s -f /dev/rtc1
```

### Manual Time Setting

If you need to set the RTC manually:

```shell
# Set system time first (format: MMDDhhmmYYYY)
date 020815302026  # Feb 8, 15:30, 2026

# Write to RTC
hwclock -w -f /dev/rtc1
```

## Making the DS3231 the Default RTC

To make the DS3231 the system default RTC device:

Create `/etc/udev/rules.d/50-rtc.rules`:

```udev
# Make DS3231 the default RTC
KERNEL=="rtc1", SUBSYSTEM=="rtc", SYMLINK+="rtc", OPTIONS+="link_priority=10"
```

Reload udev rules:

```shell
udevadm control --reload-rules
```

Now `/dev/rtc` will point to the DS3231.

## Automatic Overlay Loading

Calculinux includes a built-in systemd service for loading device tree overlays at boot. To enable the DS3231 overlay automatically, add it to the overlay configuration file:

```shell
echo "ds3231-rtc" >> /etc/device-tree-overlays.conf
```

The overlay loads on the next boot. To load it immediately without rebooting:

```shell
systemctl restart load-dt-overlays.service
```

Verify the service loaded the overlay successfully:

```shell
journalctl -u load-dt-overlays.service
```

!!! tip
    See [Device Tree Overlays — Making Overlays Persistent](device-tree-overlays.md#making-overlays-persistent) for more details on the configuration file format and overlay resolution.

## Troubleshooting

### I2C Device Not Found

If `i2cdetect` doesn't show the device at 0x68:

1. **Check wiring**: Verify all connections, especially VCC (3.3V) and GND
2. **Check voltage**: Ensure you're using 3.3V, not 5V
3. **Test connections**: Use a multimeter to verify continuity
4. **Try another I2C device**: Rule out I2C bus issues

### RTC Driver Not Loading

If the overlay loads but `/dev/rtc1` doesn't appear:

```shell
# Check overlay status
cat /sys/kernel/config/device-tree/overlays/ds3231/status

# Check kernel messages for errors
dmesg | grep -i "ds3231\|rtc"
```

Common causes:
- I2C device not responding (check connections)
- Kernel driver not compiled (shouldn't happen with standard Calculinux)

### Incorrect Time After Reboot

If the time is wrong after rebooting:

1. **Check battery**: The CR2032 battery may be dead
2. **Set time**: Use `hwclock -w` to write system time to RTC
3. **Verify overlay service**: Check `journalctl -u load-dt-overlays.service` for errors

## Using Alarms (Advanced)

The DS3231 supports two programmable alarms with interrupt output. To use them:

1. **Wire the SQW/INT pin** to a free GPIO
2. **Modify the overlay** to include interrupt configuration
3. **Use RTC alarm tools** like `rtcwake`

!!! tip "RTC Wake from Sleep"
    With proper configuration, the DS3231 can wake your PicoCalc from sleep mode at a scheduled time.

## Related Topics

- [Device Tree Overlays](device-tree-overlays.md) - General overlay usage
- [Hardware Modifications](modifications.md) - Physical connections
- [Networking](../user-guide/networking.md) - Time synchronization via NTP

## References

- [DS3231 Datasheet](https://datasheets.maximintegrated.com/en/ds/DS3231.pdf)
- [Linux RTC Documentation](https://www.kernel.org/doc/html/latest/admin-guide/rtc.html)
- [Device tree overlay source](https://github.com/Calculinux/picocalc-drivers/blob/main/devicetree-overlays/ds3231-rtc-overlay.dts)
