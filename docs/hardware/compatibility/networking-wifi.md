# Networking & WiFi

This section consolidates networking options, USB gadget networking, and WiFi compatibility.

## Built-in Network

| Model | Interface | Speed | Status |
|-------|-----------|-------|--------|
| **Lyra Plus** | Ethernet (10/100) | 100 Mbps | ❓ Untested - Requires custom backplate |
| **Lyra** | None | N/A | N/A - USB WiFi adapters and USB gadget networking supported |

!!! info "Network Options"
    - **Luckfox Lyra**: No built-in networking. USB WiFi adapters (3.3V or via powered hub) are the only tested option.
    - **Luckfox Lyra Plus**: Has built-in Ethernet but has not been tested with Calculinux and would require a custom 3D-printed backplate to access the port.

=== "USB Gadget Networking"

    !!! info "USB Gadget Networking"
        Calculinux includes USB gadget networking over the Lyra USB-C port. Connect the PicoCalc to your host via USB-C, and the device appears as a USB Ethernet adapter.

    **Defaults:**

    - **Device IP**: 192.168.7.2/24
    - **Interface**: usb0
    - **Mode**: ECM (Linux/macOS), RNDIS (Windows)

    **Quick SSH:**

    - `ssh pico@192.168.7.2` (password: `calc`)

    For detailed setup steps and troubleshooting, see [USB Networking](../../user-guide/usb-networking.md).

=== "Tested WiFi Adapters"

    The following USB WiFi adapters have been tested with Calculinux:

    | Model | Type | Notes | Link |
    |-------|------|-------|------|
    | **RTL8188FTV/FU** | USB module | Requires soldering; 3.3V native | [AliExpress](https://www.aliexpress.us/item/3256807590709883.html) |
    | **AIC8800DC** | USB adapter | Requires cable; 3.3V tolerant | [AliExpress](https://www.aliexpress.us/item/3256805850412278.html) |
    | **RTL8188EU** | USB adapter | Requires cable; 3.3V tolerant | [Amazon](https://a.co/d/gRErxAn) |

    !!! note "USB Adapter Connection"
        USB WiFi adapters require a USB-C cable (similar to [this Waveshare cable](https://a.co/d/hQKiBRK)) to connect to the Lyra's USB-C port. The cable is a very tight fit inside the PicoCalc enclosure and may require rear casing modifications or a 3D-printed case.

    !!! note "USB Modules vs. Adapters"
        - **USB Modules** (like RTL8188FTV) are compact circuit boards with castellated edges that require soldering. Most modules support 3.3V natively, providing better stability at low battery levels.
        - **USB Adapters** are standard USB devices that plug directly into a cable but require an external USB cable.

    !!! warning "3.3V Requirement"
        USB WiFi adapters **must operate at 3.3V** as the Lyra's USB provides only 3.3V power. Use an externally powered USB hub for 5V devices. Many USB adapters are 5V rated but tolerate 3.3V due to voltage regulator design, but may malfunction at low battery levels.

=== "WiFi Drivers"

    The following WiFi chipsets have drivers enabled in the Calculinux kernel:

    **Realtek:**

    - **RTL8192CU** - Single-band USB adapter
    - **R8712U** - Single-band USB adapter
    - **R8188EU** - Single-band USB adapter
    - **RTL8723BS** - Dual-band (SDIO/USB)

    **Ralink/MediaTek:**

    - **RT2500USB** - Legacy 802.11b/g
    - **RT73USB** - Legacy 802.11b/g
    - **RT2800USB** - 802.11n with variants: RT33XX, RT35XX, RT3572, RT5370, RT5372, RT55XX
    - **MT7601U** - Single-band 802.11n
    - **MT7663U** - Dual-band 802.11ac
    - **MT7921U** - Dual-band 802.11ax (WiFi 6)

    **Atheros:**

    - **AR5523** - Legacy 802.11a/b/g
    - **ATH9K_USB** - 802.11n
    - **AR9170_USB** - 802.11n

    **AIC:**

    - **AIC8800DC** - Single-band 802.11n (out-of-tree module)

    **Others:**

    - **ZD1211RW** - Zydas 802.11b/g
    - **LIBERTAS_USB** - Marvell 802.11b/g

    The following chipsets have drivers available in the kernel but are not currently enabled. They may be enabled in future releases:

    - MT7612U, MT7610U (MediaTek)
