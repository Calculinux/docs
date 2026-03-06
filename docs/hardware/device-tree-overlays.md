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

Calculinux includes several pre-built overlays in `/boot/devicetree/`:

### DS3231 Real-Time Clock

**File**: `ds3231-rtc.dtbo`

Enables the Maxim DS3231 I2C Real-Time Clock module on I2C bus 2. See the [DS3231 RTC Guide](ds3231-rtc.md) for complete setup instructions.

### 100 kHz I2C Bus

**File**: `100khz-i2c.dtbo`

Reduces the I2C2 bus clock from 400 kHz to 100 kHz. Required when using the [custom PicoCalc keyboard firmware](https://forum.clockworkpi.com/t/custom-picocalc-bios-keyboard-firmware/17292). See the [100 kHz I2C Overlay](100khz-i2c.md) guide for setup.

### u-blox NEO-M8N GPS

**File**: `neo-m8n-gps.dtbo`

Enables UART5 for the u-blox NEO-M8N GPS module on the RMII1 test pads. See the [NEO-M8N GPS](neo-m8n-gps.md) guide for wiring and usage.

### PCM5102A I2S DAC

**File**: `pcm5102a-i2s.dtbo`

Adds support for the TI PCM5102A I2S stereo DAC on SAI2 (RMII1 test pads). See the [PCM5102A I2S DAC](pcm5102a-i2s.md) guide for connections and audio setup.

### SX1262 LoRa (Waveshare)

**File**: `sx1262-lora.dtbo`

Configures GPIO bitbang SPI for the Waveshare SX1262 LoRa module (e.g. for Meshtastic). See the [SX1262 LoRa](sx1262-lora.md) guide for pinout and usage.

## Loading an Overlay

To load a device tree overlay at runtime:

```shell
# Create the overlay directory
mkdir -p /sys/kernel/config/device-tree/overlays/<overlay-name>

# Load the compiled overlay file
cat /boot/devicetree/<overlay-name>.dtbo > /sys/kernel/config/device-tree/overlays/<overlay-name>/dtbo

# Activate the overlay
echo 1 > /sys/kernel/config/device-tree/overlays/<overlay-name>/status
```

!!! example "Loading the DS3231 RTC Overlay"
    ```shell
    mkdir -p /sys/kernel/config/device-tree/overlays/ds3231
    cat /boot/devicetree/ds3231-rtc.dtbo > /sys/kernel/config/device-tree/overlays/ds3231/dtbo
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

Overlays loaded via ConfigFS don't persist across reboots. Calculinux includes a built-in systemd service (`load-dt-overlays.service`) that automatically loads overlays listed in a configuration file at boot.

### Enabling an Overlay at Boot

Add the overlay name to `/etc/device-tree-overlays.conf` (one overlay per line):

```shell
echo "ds3231-rtc" >> /etc/device-tree-overlays.conf
```

The overlay loads on the next boot. To load it immediately without rebooting:

```shell
systemctl restart load-dt-overlays.service
```

### Configuration File Format

The configuration file `/etc/device-tree-overlays.conf` supports:

- **Overlay names** — resolved first in `/etc/devicetree/`, then `/boot/devicetree/`
- **Absolute paths** — for custom overlay files stored elsewhere
- **Comments** — lines starting with `#` are ignored
- The `.dtbo` extension is optional

!!! example "Example `/etc/device-tree-overlays.conf`"
    ```ini
    # Load the DS3231 RTC overlay
    ds3231-rtc

    # Load the 100 kHz I2C overlay
    100khz-i2c

    # Load a custom overlay from an absolute path
    /home/pico/custom-sensor.dtbo
    ```

### How It Works

The `load-dt-overlays.service` runs early in the boot process (after filesystems are mounted, before `multi-user.target`). For each entry in the config file, it:

1. Resolves the overlay file path
2. Creates the ConfigFS overlay directory
3. Loads the `.dtbo` blob
4. Activates the overlay

The service logs its progress to the journal:

```shell
journalctl -u load-dt-overlays.service
```

### User Overlay Overrides

If you place a `.dtbo` file in `/etc/devicetree/`, it takes priority over the system-provided version in `/boot/devicetree/`. This lets you test modified overlays without replacing the originals.

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

- **Missing file**: Verify the `.dtbo` file exists in `/boot/devicetree/` or `/etc/devicetree/`
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
