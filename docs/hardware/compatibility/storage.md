# Storage Compatibility

## MicroSD Cards

| Brand/Type | Speed Class | Size | Status | Notes |
|------------|-------------|------|--------|-------|
| **SanDisk Ultra** | Class 10 | 8-32 GB | ✅ Recommended | Good reliability |
| **Samsung EVO** | Class 10 | 8-32 GB | ✅ Recommended | Good value |
| **Generic/No-Name** | Varies | Any | ⚠️ Use Caution | May be unreliable |

**Recommendations**:

- **Minimum**: 8 GB Class 10
- **Recommended**: 16-32 GB from reputable brand

!!! note "SD Card Performance"
    Given the hardware speeds, different SD card classes are unlikely to have significant impact on performance.

## PicoCalc External SD Card Slot

| Type | Status | Notes |
|------|--------|-------|
| **Internal Lyra Storage** | ✅ Fully Supported | Main SD card and optional SPI NAND |
| **PicoCalc SD Card Slot** | ✅ Supported | Accessible external SD card slot on PicoCalc for additional storage |
| **External USB Storage (OTG)** | 🧪 Experimental | Via Lyra's USB-C port with 3.3V devices or powered hub |

!!! info "USB-C OTG Support"
    The Lyra's USB-C port supports USB On-The-Go functionality, enabling connection of external USB storage devices. However, this requires 3.3V compatible devices or an externally powered USB hub. This feature is currently experimental and may require additional configuration.
