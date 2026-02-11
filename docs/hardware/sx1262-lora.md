# SX1262 LoRa Module (Waveshare)

The SX1262 overlay configures **GPIO bitbang SPI** and control pins for the **Waveshare SX1262HF LoRa** module on the RMII1 test pads. It is intended for use with the **Meshtastic** stack (e.g. `meshtasticd`), which drives the SX1262 via software SPI at 2 MHz.

## Hardware Requirements

- **Waveshare SX1262HF LoRa** module (or compatible SX1262)
- **Wiring** to the RMII1 test pads on the Luckfox Lyra

## Hardware Connection

Pin assignment on the RMII1 test pads:

| SX1262 / function | RMII1 test pad | Notes |
|-------------------|----------------|--------|
| **CLK** | GPIO3_B2 (Pin 30) | SPI clock |
| **MOSI** | GPIO3_B5 (Pin 27) | SPI data to module |
| **MISO** | GPIO3_A6 (Pin 34) | SPI data from module |
| **DIO1** | GPIO3_B6 (Pin 26) | Interrupt |
| **BUSY** | GPIO1_D0 (Pin 115) | Module status |
| **CS** | GND | Chip select tied low |
| **RESET** | 3.3V via 10 kΩ | Held high |
| **3.3V** | 3.3V | Power |
| **GND** | GND | Ground |

!!! note "UART5 pins"
    UART5_TX (GPIO3_B4) and UART5_RX (GPIO3_B3) are not used by this overlay and remain available for e.g. a GPS module.

## Software Setup

### Step 1: Load the overlay

```shell
# Create overlay directory
mkdir -p /sys/kernel/config/device-tree/overlays/sx1262-lora

# Load the overlay
cat /boot/devicetree/sx1262-lora.dtbo > /sys/kernel/config/device-tree/overlays/sx1262-lora/dtbo

# Activate it
echo 1 > /sys/kernel/config/device-tree/overlays/sx1262-lora/status
```

### Step 2: Use with Meshtastic

The overlay exposes the SX1262 and pin configuration for the Meshtastic daemon. Install and run Meshtastic (e.g. `meshtasticd`) according to the [Meshtastic documentation](https://meshtastic.org/docs/); the daemon uses the overlay’s device node and GPIO layout for bitbang SPI and DIO1/BUSY.

## Automatic Overlay Loading

To load the overlay at boot:

```shell
echo "sx1262-lora" >> /etc/device-tree-overlays.conf
systemctl restart load-dt-overlays.service   # optional: apply now
```

See [Device Tree Overlays — Making Overlays Persistent](device-tree-overlays.md#making-overlays-persistent) for details.

## Troubleshooting

- **Overlay fails to load**: Run `dmesg | tail -20` and ensure `/boot/devicetree/sx1262-lora.dtbo` exists.
- **Meshtastic doesn’t see the radio**: Confirm wiring (especially CLK/MOSI/MISO, DIO1, BUSY, power, and RESET). Check that the overlay is active and that Meshtastic is configured for the correct GPIO/bitbang layout.

## Related Topics

- [Device Tree Overlays](device-tree-overlays.md) — General overlay usage
- [Hardware Modifications](modifications.md) — Physical connections

## References

- [Device tree overlay source](https://github.com/Calculinux/picocalc-drivers/blob/main/devicetree-overlays/sx1262-lora-overlay.dts)
- [Meshtastic](https://meshtastic.org/)
- [Waveshare SX1262 module](https://www.waveshare.com/wiki/SX1262_LoRa_HAT)
