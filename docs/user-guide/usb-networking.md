# USB Networking

Connect your PicoCalc directly to your computer via USB for fast, convenient network access without requiring WiFi or additional network infrastructure.

## Overview

Calculinux includes built-in USB gadget networking support that makes your PicoCalc appear as a USB Ethernet adapter when connected to a host computer. This provides:

- 🔌 **Direct connection** - No WiFi or router needed
- 🚀 **Fast transfer speeds** - USB 2.0 High-Speed (480 Mbps)
- 🔒 **Secure** - Direct connection without wireless exposure
- 🌐 **Internet sharing** - Host can share its internet connection
- 💻 **Cross-platform** - Works with Linux, macOS, and Windows

The USB gadget provides two configurations:

- **RNDIS** - For Windows compatibility
- **CDC-Ether/ECM** - Standard USB Ethernet for Linux and macOS

## Quick Start

1. **Connect** your PicoCalc to your computer via USB cable
2. **Configure** the network interface on your host (see platform-specific sections below)
3. **Connect** to your PicoCalc:
   ```bash
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

**Option A: With Internet Sharing (DHCP)**

6. Go to the **IPv4** tab
7. Set Method to: **Shared to other computers**
8. Click **Apply**

This automatically:
- Assigns an IP to the host (typically 10.42.0.1)
- Runs a DHCP server for the PicoCalc
- Shares your internet connection via NAT

Your PicoCalc will automatically get an IP address via DHCP!

**Option B: Direct Connection (Static)**

6. Go to the **IPv4** tab
7. Set Method to: **Manual**
8. Click **Add** under Addresses:
   - Address: `192.168.7.1`
   - Netmask: `24`
   - Gateway: (leave empty)
9. Click **Apply**

##### Command Line Setup

Create a NetworkManager connection:

```bash
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

```bash
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

**Option A: With Internet Sharing (DHCP)**

6. In the **IPv4** tab, set Method to: **Shared**
7. Click **OK** then **Apply**

**Option B: Direct Connection (Static)**

6. In the **IPv4** tab, set Method to: **Manual**
7. Click **Add** next to Addresses:
   - Address: `192.168.7.1`
   - Netmask: `24` or `255.255.255.0`
8. Click **OK** then **Apply**

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
   ```bash
   echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/50-ip-forward.conf
   sudo sysctl -p /etc/sysctl.d/50-ip-forward.conf
   ```

3. Restart networking:
   ```bash
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
   ```bash
   sudo systemctl restart systemd-networkd
   ```

### macOS

1. Connect your PicoCalc via USB
2. Open **System Settings** (or System Preferences on older versions)
3. Go to **Network**
4. The USB device should appear (may show as "CDC Composite Gadget" or "USB 10/100 LAN")
5. Select the USB device

**Option A: Automatic (Internet Sharing)**

6. Go back to **System Settings** → **General** → **Sharing**
7. Select **Internet Sharing** in the sidebar
8. Set "Share your connection from:" to your active connection (Wi-Fi or Ethernet)
9. Check the box next to the USB Ethernet device
10. Enable Internet Sharing

macOS will automatically configure DHCP for the PicoCalc!

**Option B: Manual Configuration**

6. Click **Details**
7. Go to the **TCP/IP** tab
8. Set Configure IPv4: **Manually**
9. Enter:
   - IP Address: `192.168.7.1`
   - Subnet Mask: `255.255.255.0`
10. Click **OK**

### Windows

!!! note
    Windows requires RNDIS drivers, which are usually built-in for Windows 10/11.

1. Connect your PicoCalc via USB
2. Windows should detect it as "RNDIS/Ethernet Gadget"
3. If driver installation is needed, Windows should install it automatically

**Configure the network:**

4. Open **Settings** → **Network & Internet** → **Ethernet**
5. Click the RNDIS/Ethernet Gadget adapter
6. Click **Edit** next to IP assignment

**Option A: For Internet Sharing**

7. Use Windows' **Internet Connection Sharing (ICS)**:
   - Open **Control Panel** → **Network and Sharing Center**
   - Click your internet-connected adapter
   - Click **Properties**
   - Go to the **Sharing** tab
   - Check "Allow other network users to connect through this computer's Internet connection"
   - Select the RNDIS adapter from the dropdown
   - Click **OK**

Windows will automatically configure DHCP (typically 192.168.137.x range).

**Option B: Manual Configuration**

7. Set to **Manual**
8. Enter:
   - IP address: `192.168.7.1`
   - Subnet prefix length: `24`
   - Gateway: (leave empty)
9. Click **Save**

## Connecting to Your PicoCalc

Once the network is configured, you can access your PicoCalc:

### SSH Access

```bash
ssh pico@192.168.7.2
# Password: calc
```

Or if using DHCP/internet sharing, check the assigned IP:

```bash
# On PicoCalc (via serial console or other connection)
ip addr show usb0
```

### File Transfer

Using SCP:

```bash
# Copy file to PicoCalc
scp myfile.txt pico@192.168.7.2:/home/pico/

# Copy file from PicoCalc
scp pico@192.168.7.2:/home/pico/myfile.txt ./
```

Using SFTP:

```bash
sftp pico@192.168.7.2
```

### Package Management

With internet sharing enabled, you can install packages on your PicoCalc:

```bash
ssh pico@192.168.7.2
sudo opkg update
sudo opkg install <package-name>
```

## Verifying Connection

### On Host Computer

**Check if interface is up:**

```bash
# Linux/macOS
ip link show usb0        # or the actual interface name
# Should show state UP

# Windows
ipconfig
# Look for the RNDIS/Ethernet Gadget adapter
```

**Test connectivity:**

```bash
ping 192.168.7.2
# Should receive replies
```

### On PicoCalc

Via serial console or existing network connection:

```bash
# Check if usb0 is configured
ip addr show usb0

# Check if service is running
systemctl status usb-gadget-network

# Test connectivity to host
ping 192.168.7.1  # or your DHCP-assigned gateway
```

## Troubleshooting

### Device Not Appearing

**On PicoCalc:**

1. Check if the USB gadget service is running:
   ```bash
   systemctl status usb-gadget-network
   ```

2. Restart the service if needed:
   ```bash
   sudo systemctl restart usb-gadget-network
   ```

3. Check kernel modules:
   ```bash
   lsmod | grep -E 'libcomposite|rndis|ecm|dwc2'
   ```

4. Check USB gadget configuration:
   ```bash
   ls /sys/kernel/config/usb_gadget/g1/UDC
   ```

**On Host:**

- Try a different USB cable (must support data, not just charging)
- Try a different USB port
- Check system logs for USB device detection

### Cannot Ping PicoCalc

1. **Verify IP configuration** on both host and device:
   ```bash
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
   ```bash
   ip addr show usb0
   ```

2. Check default route:
   ```bash
   ip route show default
   ```

3. Check DNS:
   ```bash
   cat /etc/resolv.conf
   ```

4. Test connectivity:
   ```bash
   ping 1.1.1.1      # Test IP connectivity
   ping google.com   # Test DNS resolution
   ```

**On Host (Linux):**

1. Verify IP forwarding is enabled:
   ```bash
   sysctl net.ipv4.ip_forward
   # Should return 1
   ```

2. Check NAT rules (if using manual configuration):
   ```bash
   sudo iptables -t nat -L -v
   ```

### DHCP Not Working

If PicoCalc doesn't get an IP via DHCP:

1. **Verify host DHCP server** is running (automatic with "Shared" mode in NetworkManager)

2. **On PicoCalc**, check systemd-networkd logs:
   ```bash
   journalctl -u systemd-networkd -f
   ```

3. **Restart network** on PicoCalc:
   ```bash
   sudo systemctl restart systemd-networkd
   ```

4. **Fallback to static IP** - PicoCalc will use 192.168.7.2 if DHCP fails

### Advanced Topics

### Network Configuration Details

The PicoCalc uses **dual IP addressing** for maximum compatibility:

- **Static IP**: `192.168.7.2/24` - Always available as a fallback
- **DHCP**: Automatically acquires an IP when the host provides DHCP (via internet sharing)

This configuration is handled by systemd-networkd and is defined in `/lib/systemd/network/usb0.network`:

```ini
[Match]
Name=usb0

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
   Name=usb0
   
   [Network]
   Address=10.0.0.2/24
   DHCP=yes
   ```

2. Restart systemd-networkd:
   ```bash
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

```bash
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

```
Calculinux 1.0.0-dev+abc1234 luckfox-lyra ttyGS0

luckfox-lyra login: 
```

Login with:
- Username: `pico`
- Password: `calc`

!!! tip "USB Serial vs Hardware Serial"
    - **USB Serial** (`/dev/ttyACM0` on host, `/dev/ttyGS0` on device): 1500000 baud, provided by USB gadget
    - **Hardware Serial** (`/dev/ttyUSB0` on host): 1500000 baud, physical UART bridge on PicoCalc USB-C port
    
    See [Serial Console Access](../hardware/serial/console-access.md) for the hardware serial connection.

## ADB over USB (Experimental)

!!! warning "Currently Disabled by Default"
    ADB support is included but **disabled by default** due to initialization complexity. The FunctionFS interface used by ADB requires special setup where the userspace daemon must be running before the gadget function can be bound.

Calculinux can expose ADB over the same USB gadget using FunctionFS. This runs a patched
adbd that works without Android, mounted via ConfigFS. This was ported from Luckfox's
buildroot SDK and the patches were updated to a newer version of adbd to support more
modern OpenSSL libraries.

### Enabling ADB

To enable ADB (advanced users):

1. Edit `/etc/default/usb-gadget-network` and set `ENABLE_ADB=1`
2. Ensure the adbd service will start before the gadget binds:
   ```bash
   sudo systemctl enable adbd
   sudo systemctl start adbd
   ```
3. Restart the USB gadget:
   ```bash
   sudo systemctl restart usb-gadget-network
   ```

### Prerequisites

- Host has Android Platform Tools (adb) installed
- usb-gadget-network service enabled
- adbd service running **before** the USB gadget binds

### Configure adbd auth and transport

- Set a password (preferred): create `/etc/adbd.passwd` (plaintext) or `/etc/adbd.passwd.md5` (md5 hash). Example:
   ```bash
   echo "strongpassword" | sudo tee /etc/adbd.passwd > /dev/null
   sudo systemctl restart adbd
   ```
- Runtime defaults: `/etc/default/adbd`
   - `ADB_SECURE=1` (default) enforces password prompt via `/usr/bin/adbd-auth.sh`
   - `ADB_TCP_PORT=0` keeps ADB on USB only; set to `5555` if you also want TCP
   - `ADBD_AUTH_COMMAND` can point to a custom helper if needed

### Host connection

1. Plug PicoCalc via USB and wait for usb-gadget-network + adbd
2. On host, restart adb and list devices:
    ```bash
    adb kill-server
    adb devices
    ```
3. Connect (accept password prompt):
    ```bash
    adb shell
    ```
    If you enabled TCP (`ADB_TCP_PORT=5555`), connect with `adb connect 192.168.7.2:5555`.

### Troubleshooting

- Check FunctionFS mount: `mount | grep functionfs`
- Inspect gadget functions: `ls /sys/kernel/config/usb_gadget/g1/functions`
- View adbd logs: `journalctl -u adbd -f`
- If host does not see ADB: `adb kill-server`, replug USB, verify `ENABLE_ADB=1`, ensure `usb_f_fs` module is loaded, and verify adbd is running

## See Also

- [Basic Usage](basic-usage.md) - General PicoCalc usage
- [WiFi Configuration](../getting-started/first-boot.md#wifi-setup-usb-adapter-required) - Alternative connectivity
- [Network Troubleshooting](../troubleshooting/network.md) - More troubleshooting tips
- [Serial Console Access](../hardware/serial/console-access.md) - Alternative access method
