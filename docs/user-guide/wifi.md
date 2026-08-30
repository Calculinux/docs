# WiFi

Connect a USB WiFi adapter and join a wireless network with `uwific`, the terminal WiFi manager included with Calculinux.

!!! info "WiFi hardware required"
    Neither the PicoCalc nor Luckfox Lyra include built-in WiFi. You need a **USB WiFi adapter operating at 3.3V** connected to the Lyra USB header.

    For supported chipsets and tested adapters, see [Networking & WiFi](../hardware/compatibility/networking-wifi.md).

Calculinux uses **iwd** as the wireless daemon and **systemd-networkd** for IP configuration. `uwific` talks to iwd over D-Bus. Known networks reconnect on later boots without running `uwific` again.

## Connecting with uwific

On the device console (default `root` login):

```shell
uwific
```

As the `pico` user (for example over SSH), use `sudo`:

```shell
sudo uwific
```

`uwific` needs access to the system D-Bus, so it must run as root.

The TUI lists visible networks with signal strength. Select a network and press **Enter**. For a PSK network, enter the passphrase when prompted.

### Controls

| Key | Action |
|-----|--------|
| Up / `k` | Move cursor up |
| Down / `j` | Move cursor down |
| Enter | Connect to the selected network |
| `D` | Disconnect from the current network |
| `F` | Forget the selected network (asks `Y`/`N`) |
| `R` | Scan again |
| `O` | Adapter options |
| `P` | Toggle adapter power (in the options menu) |
| `Q` | Quit |

### Network list indicators

| Indicator | Meaning |
|-----------|---------|
| `####` | Strong signal |
| `###+` | Good signal |
| `##++` | Fair signal |
| `#+++` | Weak signal |
| `++++` | Weakest / no signal |
| `[*]` | Currently connected |
| `[k]` | Known network (credentials stored) |

## Verify the connection

```shell
ip addr show wlan0
ping -c 3 8.8.8.8
```

Interface names can differ (`wlan1` after a re-plug). Check with `ip link` or `iw dev`.

## Disconnect or forget

In `uwific`:

- **D** disconnects the current network
- **F** forgets the selected network and removes stored credentials from iwd

## CLI alternative (iwctl)

`iwctl` is still available if you prefer a command line:

```shell
iwctl

# Inside iwctl:
[iwd]# device list
[iwd]# station wlan0 scan
[iwd]# station wlan0 get-networks
[iwd]# station wlan0 connect "SSID"
[iwd]# exit
```

Or non-interactively:

```shell
iwctl station wlan0 scan
iwctl station wlan0 get-networks
iwctl station wlan0 connect "YourSSID"
iwctl station wlan0 show
iwctl station wlan0 disconnect
```

## Troubleshooting

If no networks appear, the adapter is missing, or the connection drops, see [Network Issues](../troubleshooting/network.md).

Useful checks:

```shell
ip link show
iw dev
systemctl status iwd
journalctl -u iwd -b
```

---

## See also

- [Networking](networking.md) - Connectivity overview
- [USB Networking](usb-networking.md) - USB gadget Ethernet
- [Networking & WiFi](../hardware/compatibility/networking-wifi.md) - Adapter compatibility
- [Network Issues](../troubleshooting/network.md) - Troubleshooting
