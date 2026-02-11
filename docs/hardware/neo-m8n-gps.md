# u-blox NEO-M8N GPS Module

The NEO-M8N overlay enables **UART5** for the u-blox NEO-M8N GPS module on the PicoCalc. The module outputs NMEA sentences at 9600 baud by default and is compatible with standard tools such as `gpsd`, `gpsmon`, and `cgps`.

## Hardware Requirements

- **u-blox NEO-M8N GPS module** (or compatible)
- **Wiring** to the RMII1 test pads on the Luckfox Lyra

## Hardware Connection

The overlay uses UART5 on the RMII1 test pads:

| NEO-M8N | Connection | RMII1 test pad |
|---------|------------|-----------------|
| **VCC** | 3.3V | 3.3V |
| **GND** | Ground | GND |
| **TX** (module) | RX (SoC) | GPIO3_B3 (Pin 29) — UART5_RX |
| **RX** (module) | TX (SoC) | GPIO3_B4 (Pin 28) — UART5_TX |

!!! info "Baud rate"
    The NEO-M8N defaults to 9600 baud. The overlay configures UART5 for 9600 baud. You can change the module’s baud rate with u-blox tools if needed.

## Software Setup

### Step 1: Load the overlay

```shell
# Create overlay directory
mkdir -p /sys/kernel/config/device-tree/overlays/neo-m8n-gps

# Load the overlay
cat /boot/devicetree/neo-m8n-gps.dtbo > /sys/kernel/config/device-tree/overlays/neo-m8n-gps/dtbo

# Activate it
echo 1 > /sys/kernel/config/device-tree/overlays/neo-m8n-gps/status
```

### Step 2: Use the GPS

The GPS serial port is `/dev/ttyS5`.

Read raw NMEA sentences:

```shell
cat /dev/ttyS5
```

Use with **gpsd** (install with `opkg install gpsd` if needed):

```shell
gpsd /dev/ttyS5
gpsmon /dev/ttyS5
# or
cgps -s
```

## Automatic Overlay Loading

To load the overlay at boot:

```shell
echo "neo-m8n-gps" >> /etc/device-tree-overlays.conf
systemctl restart load-dt-overlays.service   # optional: apply now
```

See [Device Tree Overlays — Making Overlays Persistent](device-tree-overlays.md#making-overlays-persistent) for details.

## Troubleshooting

- **No data on `/dev/ttyS5`**: Check wiring (TX↔RX crossed), power (3.3V), and antenna. Ensure the module has a clear view of the sky for a fix.
- **Overlay won’t load**: Run `dmesg | tail -20` and confirm the overlay file exists under `/boot/devicetree/neo-m8n-gps.dtbo`.

## Related Topics

- [Device Tree Overlays](device-tree-overlays.md) — General overlay usage
- [Hardware Modifications](modifications.md) — Physical connections

## References

- [Device tree overlay source](https://github.com/Calculinux/picocalc-drivers/blob/main/devicetree-overlays/neo-m8n-gps-overlay.dts)
- [u-blox NEO-M8N product page](https://www.u-blox.com/en/product/neo-m8-series)
