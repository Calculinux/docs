# USB Networking

Connect your PicoCalc directly to your computer via USB for fast, convenient network access without requiring WiFi or additional network infrastructure.

## Overview

Calculinux includes built-in USB gadget networking support that makes your PicoCalc appear as a USB Ethernet adapter when connected to a host computer. This provides:

- 🔌 **Direct connection** - No WiFi or router needed
- 🚀 **Fast transfer speeds** - USB 2.0 High-Speed (480 Mbps)
- 🔒 **Secure** - Direct connection without wireless exposure
- 🌐 **Internet sharing** - Host can share its internet connection
- 💻 **Cross-platform** - Works with Linux, macOS, and Windows

The USB gadget uses a **single configuration** mode where you can select the network protocol:

- **RNDIS** — Default. Works on Windows and Linux with a single host interface
- **ECM (CDC-Ether)** — Prefer for macOS (Apple has no inbox RNDIS host driver)
- **both** — ECM + RNDIS together; available but not recommended as a default (Linux often binds both functions and ends up with two interfaces on the same subnet)

By default the device uses RNDIS so Windows and Linux hosts work without switching. For macOS, switch to ECM (see [Switching protocols](#switching-protocols)).

## Quick Start

1. **Connect** your PicoCalc to your computer via USB cable
2. **Configure** the network interface on your host (see platform-specific sections below)
3. **Connect** to your PicoCalc:

   ```shell
   ssh pico@192.168.7.2
   # Password: calc
   ```

## Network Configuration

The PicoCalc USB network interface is configured to support both static IP and DHCP:

- **Static IP**: 192.168.7.2/24 (fallback)
- **DHCP**: Automatically configured if host provides DHCP server
- **Interface**: `usb0`

Your host computer should be configured with:

- **IP Address**: 192.168.7.1/24 (for static configuration)
- **DHCP Server**: Optional, for automatic configuration

## Host Configuration

### Linux Desktop

#### GNOME (NetworkManager)

GNOME's default NetworkManager makes USB networking simple:

##### Automatic Setup (Recommended)

1. Connect your PicoCalc via USB
2. Click the **network icon** in the top bar
3. Look for a new wired connection (may show as "USB Ethernet" or "Wired connection 2")
4. Click the connection to view settings
5. Click the **gear icon** ⚙️ next to the connection

- **Option A: With Internet Sharing (DHCP)**

   1. Go to the **IPv4** tab
   2. Set Method to: **Shared to other computers**
   3. Click **Apply**

   This automatically:

   - Assigns an IP to the host (typically 10.42.0.1)
   - Runs a DHCP server for the PicoCalc
   - Shares your internet connection via NAT

   Your PicoCalc will automatically get an IP address via DHCP!

- **Option B: Direct Connection (Static)**

   1. Go to the **IPv4** tab
   2. Set Method to: **Manual**
   3. Click **Add** under Addresses:
      - Address: `192.168.7.1`
      - Netmask: `24`
      - Gateway: (leave empty)
   4. Click **Apply**

##### Command Line Setup

Create a NetworkManager connection:

```shell
# For internet sharing (DHCP)
nmcli connection add type ethernet ifname usb0 \
    con-name "PicoCalc USB" \
    ipv4.method shared

# For direct connection (static)
nmcli connection add type ethernet ifname usb0 \
    con-name "PicoCalc USB" \
    ipv4.method manual \
    ipv4.addresses 192.168.7.1/24

# Activate the connection
nmcli connection up "PicoCalc USB"
```

To switch between shared and static:

```shell
# Switch to shared (with internet)
nmcli connection modify "PicoCalc USB" ipv4.method shared
nmcli connection up "PicoCalc USB"

# Switch to static (direct only)
nmcli connection modify "PicoCalc USB" \
    ipv4.method manual \
    ipv4.addresses 192.168.7.1/24
nmcli connection up "PicoCalc USB"
```

#### KDE Plasma (NetworkManager)

KDE also uses NetworkManager with a different interface:

1. Connect your PicoCalc via USB
2. Click the **network icon** in the system tray
3. Click **Configure Network Connections...**
4. Find the new USB Ethernet connection (or click **+** to add a new connection)
5. Select **Ethernet** as the connection type

- **Option A: With Internet Sharing (DHCP)**

   1. In the **IPv4** tab, set Method to: **Shared**
   2. Click **OK** then **Apply**

- **Option B: Direct Connection (Static)**

   1. In the **IPv4** tab, set Method to: **Manual**
   2. Click **Add** next to Addresses:
      - Address: `192.168.7.1`
      - Netmask: `24` or `255.255.255.0`
   3. Click **OK** then **Apply**

   The command-line approach (using `nmcli`) also works in KDE since it uses NetworkManager.

#### systemd-networkd

If your system uses systemd-networkd instead of NetworkManager:

**For internet sharing (with DHCP):**

1. Create `/etc/systemd/network/50-usb-picocalc.network`:

   ```ini
   [Match]
   Name=usb0

   [Network]
   Address=10.42.0.1/24
   DHCPServer=yes
   IPMasquerade=yes

   [DHCPServer]
   PoolOffset=100
   PoolSize=50
   EmitDNS=yes
   DNS=1.1.1.1 8.8.8.8
   ```

2. Enable IP forwarding:

   ```shell
   echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/50-ip-forward.conf
   sudo sysctl -p /etc/sysctl.d/50-ip-forward.conf
   ```

3. Restart networking:

   ```shell
   sudo systemctl restart systemd-networkd
   ```

**For direct connection (static):**

1. Create `/etc/systemd/network/50-usb-picocalc.network`:

   ```ini
   [Match]
   Name=usb0

   [Network]
   Address=192.168.7.1/24
   ```

2. Restart networking:

   ```shell
   sudo systemctl restart systemd-networkd
   ```

### macOS

!!! warning "ECM Required on macOS"
    macOS has no inbox RNDIS host driver. Switch the PicoCalc to ECM before connecting:

    ```shell
    sudo usb-modeswitch --protocol ecm
    ```

    Or set `USB_PROTOCOL=ecm` in `/etc/default/usb-gadget-network` and restart `usb-gadget-network`.

1. Connect your PicoCalc via USB
2. Open **System Settings** (or System Preferences on older versions)
3. Go to **Network**
4. The USB device should appear (may show as "CDC Composite Gadget" or "USB 10/100 LAN")
5. Select the USB device

- **Option A: Automatic (Internet Sharing)**

   1. Go back to **System Settings** → **General** → **Sharing**
   2. Select **Internet Sharing** in the sidebar
   3. Set "Share your connection from:" to your active connection (Wi-Fi or Ethernet)
   4. Check the box next to the USB Ethernet device
   5. Enable Internet Sharing

   macOS will automatically configure DHCP for the PicoCalc!

- **Option B: Manual Configuration**

   1. Click **Details**
   2. Go to the **TCP/IP** tab
   3. Set Configure IPv4: **Manually**
   4. Enter:
      - IP Address: `192.168.7.1`
      - Subnet Mask: `255.255.255.0`
   5. Click **OK**

### Windows

!!! note
    The default gadget protocol is **RNDIS**. Windows 10/11 include the RNDIS driver; no protocol switch is needed for basic SSH access.

1. Connect your PicoCalc via USB
2. Windows should detect it as "RNDIS/Ethernet Gadget"
3. If driver installation is needed, Windows should install it automatically

**Configure the network:**

1. Open **Settings** → **Network & Internet** → **Ethernet**
2. Click the RNDIS/Ethernet Gadget adapter
3. Click **Edit** next to IP assignment

- **Option A: For Internet Sharing**

   1. Use Windows' **Internet Connection Sharing (ICS)**:
      - Open **Control Panel** → **Network and Sharing Center**
      - Click your internet-connected adapter
      - Click **Properties**
      - Go to the **Sharing** tab
      - Check "Allow other network users to connect through this computer's Internet connection"
      - Select the RNDIS adapter from the dropdown
      - Click **OK**

   Windows will automatically configure DHCP (typically 192.168.137.x range).

- **Option B: Manual Configuration**

   1. Set to **Manual**
   2. Enter:
      - IP address: `192.168.7.1`
      - Subnet prefix length: `24`
      - Gateway: (leave empty)
   3. Click **Save**

## Connecting to Your PicoCalc

Once the network is configured, you can access your PicoCalc:

### SSH Access

```shell
ssh pico@192.168.7.2
# Password: calc
```

Or if using DHCP/internet sharing, check the assigned IP:

```shell
# On PicoCalc (via serial console or other connection)
ip addr show usb0
```

### File Transfer

Using SCP:

```shell
# Copy file to PicoCalc
scp myfile.txt pico@192.168.7.2:/home/pico/

# Copy file from PicoCalc
scp pico@192.168.7.2:/home/pico/myfile.txt ./
```

Using SFTP:

```shell
sftp pico@192.168.7.2
```

### Package Management

With internet sharing enabled, you can install packages on your PicoCalc:

```shell
ssh pico@192.168.7.2
sudo opkg update
sudo opkg install <package-name>
```

## Verifying Connection

### On Host Computer

**Check if interface is up:**

```shell
# Linux/macOS
ip link show usb0        # or the actual interface name
# Should show state UP

# Windows
ipconfig
# Look for the RNDIS/Ethernet Gadget adapter
```

**Test connectivity:**

```shell
ping 192.168.7.2
# Should receive replies
```

### On PicoCalc

Via serial console or existing network connection:

```shell
# Check if usb0 is configured
ip addr show usb0

# Check if service is running
systemctl status usb-gadget-network

# Test connectivity to host
ping 192.168.7.1  # or your DHCP-assigned gateway
```

## Troubleshooting

### Device Not Appearing

**Check Protocol Configuration:**

First, verify you're using the correct protocol for your host OS:

```shell
# On PicoCalc - check current protocol
grep USB_PROTOCOL /etc/default/usb-gadget-network

# Default:
# USB_PROTOCOL=rndis  # Windows + Linux
# USB_PROTOCOL=ecm    # macOS
```

**On PicoCalc:**

1. Check if the USB gadget service is running:

   ```shell
   systemctl status usb-gadget-network
   ```

2. Restart the service if needed:

   ```shell
   sudo systemctl restart usb-gadget-network
   ```

3. Check kernel modules:

   ```shell
   lsmod | grep -E 'libcomposite|rndis|ecm|dwc2'
   ```

4. Check USB gadget configuration:

   ```shell
   ls /sys/kernel/config/usb_gadget/g1/UDC
   # Check which function is active:
   ls /sys/kernel/config/usb_gadget/g1/functions/
   # Should show either ecm.usb0 or rndis.usb0 (not both)
   ```

**On Host:**

- Try a different USB cable (must support data, not just charging)
- Try a different USB port
- Check system logs for USB device detection

### Cannot Ping PicoCalc

1. **Verify IP configuration** on both host and device:

   ```shell
   # Host (Linux/macOS)
   ip addr show usb0

   # PicoCalc
   ip addr show usb0
   ```

2. **Check firewall rules** on host computer

3. **Verify cable connection** - must be a data cable, not power-only

### No Internet on PicoCalc (with Sharing Enabled)

**On PicoCalc:**

1. Check if you got an IP via DHCP:

   ```shell
   ip addr show usb0
   ```

2. Check default route:

   ```shell
   ip route show default
   ```

3. Check DNS:

   ```shell
   cat /etc/resolv.conf
   ```

4. Test connectivity:

   ```shell
   ping 1.1.1.1      # Test IP connectivity
   ping google.com   # Test DNS resolution
   ```

**On Host (Linux):**

1. Verify IP forwarding is enabled:

   ```shell
   sysctl net.ipv4.ip_forward
   # Should return 1
   ```

2. Check NAT rules (if using manual configuration):

   ```shell
   sudo iptables -t nat -L -v
   ```

### DHCP Not Working

If PicoCalc doesn't get an IP via DHCP:

1. **Verify host DHCP server** is running (automatic with "Shared" mode in NetworkManager)

2. **On PicoCalc**, check systemd-networkd logs:

   ```shell
   journalctl -u systemd-networkd -f
   ```

3. **Restart network** on PicoCalc:

   ```shell
   sudo systemctl restart systemd-networkd
   ```

4. **Fallback to static IP** - PicoCalc will use 192.168.7.2 if DHCP fails

## Configuration

### Switching protocols

The USB network protocol is set in `/etc/default/usb-gadget-network` on the PicoCalc (`USB_PROTOCOL`).

**RNDIS (default — Windows and Linux):**

```shell
sudo nano /etc/default/usb-gadget-network
# USB_PROTOCOL=rndis
sudo systemctl restart usb-gadget-network
```

**ECM (macOS, or Linux preference):**

```shell
sudo nano /etc/default/usb-gadget-network
# USB_PROTOCOL=ecm
sudo systemctl restart usb-gadget-network
```

**both (ECM + RNDIS in one config):**

```shell
# USB_PROTOCOL=both
sudo systemctl restart usb-gadget-network
```

!!! warning "Avoid both on Linux hosts"
    With `USB_PROTOCOL=both`, Linux often binds ECM and RNDIS at once, producing two interfaces on the same subnet and confusing routing/NetworkManager. Prefer `rndis` (default) or `ecm` alone.

!!! note "Reconnection Required"
    After changing the protocol and restarting the service, **unplug and replug** the USB cable so the host re-enumerates the gadget.

!!! tip "Protocol Selection"
    - **RNDIS** (default) — Windows and Linux, one host interface
    - **ECM** — macOS (required); also fine on Linux
    - **both** — only if you need it and can ignore the extra Linux interface

Temporary switches without editing the file: `sudo usb-modeswitch --protocol rndis|ecm|both` (see [usb-modeswitch](#using-usb-modeswitch)).

### Advanced Topics

### Network Configuration Details

The PicoCalc uses **dual IP addressing** for maximum compatibility:

- **Static IP**: `192.168.7.2/24` - Always available as a fallback
- **DHCP**: Automatically acquires an IP when the host provides DHCP (via internet sharing)

This configuration is handled by systemd-networkd and is defined in `/lib/systemd/network/usb0.network`:

```ini
[Match]
Name=usb*

[Network]
Address=192.168.7.2/24
DHCP=yes
```

When internet sharing is enabled on the host:

- The PicoCalc will acquire a second IP via DHCP (e.g., `10.42.0.247/24` on Linux)
- The static IP `192.168.7.2` remains active
- Internet traffic uses the DHCP-assigned gateway
- You can SSH to either IP address

### Custom IP Ranges

To use a different static IP range:

1. Edit `/lib/systemd/network/usb0.network`:

   ```ini
   [Match]
   Name=usb*

   [Network]
   Address=10.0.0.2/24
   DHCP=yes
   ```

2. Restart systemd-networkd:

   ```shell
   sudo systemctl restart systemd-networkd
   ```

!!! note
    The DHCP-assigned IP is controlled by your host computer's network sharing configuration and cannot be changed on the PicoCalc.

### Multiple Simultaneous Connections

You can use USB networking alongside WiFi:

- **WiFi** for internet access
- **USB** for fast file transfers and SSH access

Both interfaces can be active simultaneously. The PicoCalc will route traffic appropriately based on the default route.

### Security Considerations

!!! warning "Security Note"
    When enabling internet sharing, your PicoCalc becomes accessible to anyone who can access your host computer's network (if the host is on a shared network).

Best practices:

- Only join networks that you trust
- Use strong passwords for the `pico` and `root` accounts
- Keep your system updated
- Disable SSH password authentication and use SSH keys

## USB Serial Console

The USB gadget also exposes a **USB serial console** using the ACM (Abstract Control Model) function. This provides an additional login prompt over USB, accessible at **1500000 baud**.

### Accessing the Console

**On Linux/macOS:**

The device appears as `/dev/ttyACM0` (Linux) or `/dev/tty.usbmodem*` (macOS):

```shell
# Linux - using screen
screen /dev/ttyACM0 1500000

# Linux - using miniterm
python3 -m serial.tools.miniterm /dev/ttyACM0 1500000

# macOS - using screen
screen /dev/tty.usbmodem* 1500000
```

**On Windows:**

The device appears as a COM port in Device Manager:

1. Open Device Manager and note the COM port number (e.g., COM3)
2. Use PuTTY or another serial terminal:
   - Connection type: Serial
   - Serial line: COM3 (or your port)
   - Speed: 1500000

### Login

Once connected, you'll see a login prompt:

```shell
Calculinux 1.0.0-dev+abc1234 luckfox-lyra ttyGS0

luckfox-lyra login:
```

Login with:

- Username: `pico`
- Password: `calc`

!!! tip "USB Serial vs Hardware Serial"
    Both serial console options use **1500000 baud**:

    - **USB Serial** (`/dev/ttyACM0` on host, `/dev/ttyGS0` on device): Provided by USB gadget ACM function
    - **Hardware Serial** (`/dev/ttyUSB0` on host): Physical UART bridge (CH340) on PicoCalc USB-C port

    See [Serial Console Access](../hardware/serial/console-access.md) for the hardware serial connection.

## USB Host/Gadget Mode Switching

The PicoCalc's main USB-C port (usb20_otg0) supports **USB OTG** (On-The-Go), allowing it to switch between two roles:

- **Gadget Mode** (default) - Device acts as a USB peripheral (network adapter, serial console)
- **Host Mode** - Device acts as a USB host to connect peripherals (flash drives, keyboards, mice)

!!! warning "Network Access Required"
    Switching to host mode disables USB gadget networking. Before switching, ensure you have **alternate access** via WiFi or serial console to switch back.

### Using usb-modeswitch

The `usb-modeswitch` command provides temporary USB configuration changes without editing files. Changes are stored in `/run/usb-gadget-network.env` and persist until cleared or rebooted.

#### Switch to Host Mode

```shell
sudo usb-modeswitch --mode host
```

After this command:

- USB gadget networking stops
- PicoCalc can now connect to USB peripherals
- Use WiFi or serial console to access the device

#### Switch Back to Gadget Mode

Via WiFi or serial console:

```shell
sudo usb-modeswitch --mode gadget
```

#### Change USB Protocol

```shell
# RNDIS (default — Windows + Linux)
sudo usb-modeswitch --protocol rndis

# ECM (macOS)
sudo usb-modeswitch --protocol ecm

# Both ECM and RNDIS (usually avoid on Linux hosts)
sudo usb-modeswitch --protocol both
```

#### Toggle Additional Functions

```shell
# Enable USB serial console
sudo usb-modeswitch --serial on

# Disable USB networking (serial only)
sudo usb-modeswitch --network off --serial on
```

#### Clear Temporary Overrides

```shell
# Remove all temporary settings and return to defaults
sudo usb-modeswitch --clear
```

#### Check Current Settings

```shell
usb-modeswitch --status
```

Output shows current configuration:

```shell
USB_MODE=gadget
USB_PROTOCOL=rndis
ENABLE_SERIAL_CONSOLE=0
ENABLE_NETWORK=1
```

### Persistent Configuration

To make USB mode changes permanent, edit `/etc/default/usb-gadget-network`:

```shell
sudo nano /etc/default/usb-gadget-network
```

Available settings:

```shell
# USB port mode
USB_MODE=gadget  # or "host"

# Network protocol (gadget mode only)
USB_PROTOCOL=rndis  # or "ecm" / "both"

# Optional features
ENABLE_SERIAL_CONSOLE=0  # 1=enable, 0=disable
ENABLE_NETWORK=1         # 1=enable, 0=disable
```

After editing, restart the service:

```shell
sudo systemctl restart usb-gadget-network
```

### Using USB Storage in Host Mode

When in host mode, connected USB storage devices appear as block devices:

```shell
# List USB devices
lsusb

# Check for storage devices
ls /dev/sd*

# Mount USB drive
sudo mkdir -p /mnt/usb
sudo mount /dev/sda1 /mnt/usb

# Access files
ls /mnt/usb

# Unmount when done
sudo umount /mnt/usb
```

### Troubleshooting Mode Switching

**USB device not detected in host mode:**

Check current mode:

```shell
cat /etc/default/usb-gadget-network | grep USB_MODE
# Or check runtime override:
cat /run/usb-gadget-network.env 2>/dev/null
```

Verify no gadget is bound:

```shell
ls /sys/kernel/config/usb_gadget/
# Should be empty or g1 should not exist when in host mode
```

Check for connected USB devices:

```shell
lsusb
dmesg | grep -i usb | tail -20
```

**Can't switch back to gadget mode:**

If you lose all network access and can't switch back:

1. Connect via hardware serial console (see [Serial Console documentation](../hardware/serial/console-access.md))
2. Or remove the SD card, mount on another computer
3. Edit `/etc/default/usb-gadget-network` on the overlay partition
4. Set `USB_MODE=gadget`
5. Reinsert SD card and boot

## See Also

- [Basic Usage](basic-usage.md) - General PicoCalc usage
- [WiFi Configuration](../getting-started/first-boot.md#wifi-setup-usb-adapter-required) - Alternative connectivity
- [Network Troubleshooting](../troubleshooting/network.md) - More troubleshooting tips
- [Serial Console Access](../hardware/serial/console-access.md) - Alternative access method
- [USB Host Mode Details](https://github.com/Calculinux/meta-calculinux/blob/main/meta-calculinux-distro/recipes-connectivity/usb-gadget-network/USB_HOST_MODE.md) - Implementation details
