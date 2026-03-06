# PCM5102A I2S DAC

The PCM5102A overlay adds support for the **TI PCM5102A** I2S stereo DAC on **SAI2** (I2S2) on the RK3506. It uses the RMII1 test pads on the Luckfox Lyra for the I2S signals.

## Hardware Requirements

- **PCM5102A I2S DAC module** (common breakout board)
- **Wiring** to the RMII1 test pads

## Hardware Connection

Connect the PCM5102A to the RMII1 test pads as follows:

| PCM5102A pin | Connection | RMII1 test pad |
|--------------|------------|-----------------|
| **VCC** | 3.3V | 3.3V |
| **GND** | Ground | GND |
| **BCK** | Bit clock | GPIO3_A7 (Pin 33) — SAI2_SCLK_M0 |
| **DIN** | Data in | GPIO3_B0 (Pin 32) — SAI2_SDO_M0 |
| **LCK** | Word select (LRCK) | GPIO3_B1 (Pin 31) — SAI2_LRCK_M0 |
| **FLT** | Filter | GND (normal latency) |
| **DEMP** | De-emphasis | GND (off) |
| **XSMT** | Soft mute | 3.3V (mute off) |

**Optional**: **SCK** (master clock) can go to GPIO3_B6 (Pin 26) — SAI2_MCLK_M0 if your module uses it.

!!! info "Module jumpers"
    If the breakout has jumpers (e.g. H1L–H4L), set them for 3.3V and I2S standard format as per the module’s instructions.

## Software Setup

### Step 1: Load the overlay

```shell
# Create overlay directory
mkdir -p /sys/kernel/config/device-tree/overlays/pcm5102a-i2s

# Load the overlay
cat /boot/devicetree/pcm5102a-i2s.dtbo > /sys/kernel/config/device-tree/overlays/pcm5102a-i2s/dtbo

# Activate it
echo 1 > /sys/kernel/config/device-tree/overlays/pcm5102a-i2s/status
```

### Step 2: Verify and play audio

List playback devices:

```shell
aplay -l
```

You should see a card such as `picocalc-i2s-audio`. Test playback:

```shell
speaker-test -D hw:0,0 -c 2
```

Use the same device with any ALSA-compatible application.

## Automatic Overlay Loading

To load the overlay at boot:

```shell
echo "pcm5102a-i2s" >> /etc/device-tree-overlays.conf
systemctl restart load-dt-overlays.service   # optional: apply now
```

See [Device Tree Overlays — Making Overlays Persistent](device-tree-overlays.md#making-overlays-persistent) for details.

## Troubleshooting

- **No sound card**: Confirm the overlay is applied (`cat /sys/kernel/config/device-tree/overlays/pcm5102a-i2s/status`) and check wiring, especially BCK/DIN/LCK and power.
- **No sound**: Check volume/mute in ALSA and that the application uses the correct device (e.g. `hw:0,0`).

## Related Topics

- [Device Tree Overlays](device-tree-overlays.md) — General overlay usage
- [Hardware Modifications](modifications.md) — Physical connections

## References

- [Device tree overlay source](https://github.com/Calculinux/picocalc-drivers/blob/main/devicetree-overlays/pcm5102a-i2s-overlay.dts)
- [TI PCM5102A datasheet](https://www.ti.com/product/PCM5102A)
