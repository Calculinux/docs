# SBC & Luckfox Lyra Variants

## SBC Compatibility

| SBC Model | Status | RAM Options | Notes |
|-----------|--------|-------------|-------|
| **Luckfox Lyra** | ✅ Fully Supported | 128 MB | Primary platform |
| **Luckfox Lyra (SPI NAND)** | ✅ Supported | 128 MB | Requires NAND erase |
| **Luckfox Lyra Plus** | ❓ Unknown | 128 MB | RK3506-based with Ethernet (untested) |
| **Milk-V Duo** | 🚧 Planned | 64 MB | Future support |
| **Milk-V Duo256** | 🚧 Planned | 256 MB | Future support |
| **Raspberry Pi Zero** | ❌ Not Compatible | N/A | Form factor mismatch |
| **Custom Boards** | ❓ Unknown | Varies | Community experiments |

**Legend**:

- ✅ Fully Supported - Works out of box with official images
- 🚧 Planned - Under development or planned for future
- ❓ Unknown - Not tested, may work with modifications
- ❌ Not Compatible - Known not to work

## Luckfox Lyra Variants

Calculinux currently supports the Luckfox Lyra board with 128 MB RAM. View compatibility details by category:

=== "Supported Variants"

    | RAM | Storage | Status | Notes |
    |-----|---------|--------|-------|
    | **128 MB** | SD Card Only | ✅ **Recommended** | Simplest setup |
    | **128 MB** | SPI NAND + SD | ✅ Supported | Requires NAND erase first |

    !!! note "Other Lyra Models"
        - **Luckfox Lyra Plus**: RK3506-based with Ethernet (untested with Calculinux)
        - **256 MB Lyra variants**: Would require custom adapter boards due to different pinouts; community members are experimenting with this

=== "By Storage Type"

    | Storage | Boot Priority | Calculinux Support |
    |---------|---------------|-------------------|
    | **SD Card Only** | Primary | ✅ **Recommended** - simplest setup |
    | **SPI NAND + SD** | NAND first | ✅ Supported after NAND erase |

=== "By Network Capability"

    !!! info "Limited Network Options"
        The basic Luckfox Lyra has no built-in networking. The Luckfox Lyra Plus with Ethernet would require a custom 3D-printed backplate to access the port and has not been tested with Calculinux. USB WiFi adapters are the only tested networking option.

    | Connectivity | Hardware Required | Status | Notes |
    |--------------|-------------------|--------|-------|
    | **Luckfox Lyra Plus (Ethernet)** | Custom backplate | ❓ Untested | Plus model has Ethernet but not tested |
    | **USB WiFi** | USB WiFi adapter (3.3V or powered hub) | ✅ Supported | Only tested networking option |
