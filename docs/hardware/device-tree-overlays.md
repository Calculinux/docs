# Device Tree Overlays

Device tree overlays allow you to enable hardware modules and customize your PicoCalc configuration at runtime without rebuilding the entire system image.

## What are Device Tree Overlays?

Device tree overlays are small fragments that modify the hardware configuration of your Linux system. They enable you to:

- Add support for I2C/SPI peripherals
- Configure GPIO pins
- Enable additional hardware features
- Test hardware configurations without rebuilding

Calculinux uses the kernel's built-in ConfigFS interface for loading overlays dynamically.

## Available Overlays

Calculinux includes several pre-built overlays in `/lib/firmware/overlays/`:

### DS3231 Real-Time Clock

**File**: `ds3231-rtc.dtbo`

Enables the Maxim DS3231 I2C Real-Time Clock module on I2C bus 2. See the [DS3231 RTC Guide](ds3231-rtc.md) for complete setup instructions.

### 100 kHz I2C Bus

**File**: `100khz-i2c.dtbo`

Reduces the I2C2 bus clock from 400 kHz to 100 kHz for devices that require slower communication speeds.

### Other Overlays

Additional overlays may be available depending on your Calculinux version. Check the contents of `/lib/firmware/overlays/` on your device.

## Loading an Overlay

To load a device tree overlay at runtime:

```shell
# Create the overlay directory
mkdir -p /sys/kernel/config/device-tree/overlays/<overlay-name>

# Load the compiled overlay file
cat /lib/firmware/overlays/<overlay-name>.dtbo > /sys/kernel/config/device-tree/overlays/<overlay-name>/dtbo

# Activate the overlay
echo 1 > /sys/kernel/config/device-tree/overlays/<overlay-name>/status
```

!!! example "Loading the DS3231 RTC Overlay"
    ```shell
    mkdir -p /sys/kernel/config/device-tree/overlays/ds3231
    cat /lib/firmware/overlays/ds3231-rtc.dtbo > /sys/kernel/config/device-tree/overlays/ds3231/dtbo
    echo 1 > /sys/kernel/config/device-tree/overlays/ds3231/status
    ```

## Unloading an Overlay

To remove a loaded overlay:

```shell
# Deactivate the overlay
echo 0 > /sys/kernel/config/device-tree/overlays/<overlay-name>/status

# Remove the overlay directory
rmdir /sys/kernel/config/device-tree/overlays/<overlay-name>
```

## Making Overlays Persistent

Overlays loaded via ConfigFS don't persist across reboots. To automatically load them at boot, create a systemd service.

!!! example "Persistent DS3231 RTC Overlay"
    Create `/etc/systemd/system/ds3231-rtc.service`:
    
    ```ini
    [Unit]
    Description=Load DS3231 RTC device tree overlay
    After=sys-kernel-config.mount
    Requires=sys-kernel-config.mount

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/bin/sh -c 'mkdir -p /sys/kernel/config/device-tree/overlays/ds3231 && \
      cat /lib/firmware/overlays/ds3231-rtc.dtbo > /sys/kernel/config/device-tree/overlays/ds3231/dtbo && \
      echo 1 > /sys/kernel/config/device-tree/overlays/ds3231/status'
    ExecStop=/bin/sh -c 'echo 0 > /sys/kernel/config/device-tree/overlays/ds3231/status; \
      rmdir /sys/kernel/config/device-tree/overlays/ds3231'

    [Install]
    WantedBy=multi-user.target
    ```
    
    Enable and start the service:
    
    ```shell
    systemctl enable ds3231-rtc.service
    systemctl start ds3231-rtc.service
    ```

## Verifying Loaded Overlays

To check which overlays are currently loaded:

```shell
ls /sys/kernel/config/device-tree/overlays/
```

To check the status of a specific overlay:

```shell
cat /sys/kernel/config/device-tree/overlays/<overlay-name>/status
```

A status of `1` means the overlay is active, `0` means it's inactive.

## Troubleshooting

### Overlay won't load

Check kernel messages for errors:

```shell
dmesg | tail -20
```

Common issues:

- **Missing file**: Verify the `.dtbo` file exists in `/lib/firmware/overlays/`
- **Permission denied**: Ensure you have root privileges
- **Overlay conflicts**: Another overlay or driver may be using the same hardware resources

### Hardware not appearing after loading

Some devices may require additional steps:

1. **Check device detection**: Use tools like `i2cdetect`, `lsusb`, or check `/dev/` for new device nodes
2. **Load kernel modules**: Some overlays require specific kernel modules to be loaded
3. **Verify connections**: Double-check your hardware wiring

## I2C Bus Reference

The RK3506 on Luckfox Lyra exposes the following I2C buses for expansion:

| Bus | Device | SCL Pin | SDA Pin | Common Uses |
|-----|--------|---------|---------|-------------|
| I2C2 | `/dev/i2c-2` | GPIO IO4 | GPIO IO5 | Expansion peripherals (RTC, sensors) |

!!! tip "Checking I2C Devices"
    Use `i2cdetect` to scan for devices on a bus:
    
    ```shell
    i2cdetect -y 2
    ```

## Developer Resources

For information on creating your own device tree overlays, see the [Developer Guide on Device Tree Overlays](../developer/device-tree-overlays.md).

## References

- [Linux Kernel ConfigFS Device Tree Documentation](https://www.kernel.org/doc/html/latest/devicetree/overlay-notes.html)
- [picocalc-drivers Repository](https://github.com/Calculinux/picocalc-drivers)
- [Hardware Modifications](modifications.md)
