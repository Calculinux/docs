# Power Compatibility

## Power Supply Compatibility

### Internal Battery Power

| Power Source | Status | Notes |
|--------------|--------|-------|
| **PicoCalc Internal Battery** | ✅ Fully Supported | Rechargeable lithium-ion |
| **PicoCalc USB-C Port** | ✅ Supported | Battery charging + serial console to Lyra |
| **Lyra USB-C Port** | ✅ Supported | USB-OTG data only (does NOT charge PicoCalc) |

!!! info "Two USB-C Ports"
    The PicoCalc has TWO USB-C ports with different functions:

    - **PicoCalc USB-C Port**: Used for charging the internal battery and provides a USB serial console connection to the Lyra (at 1500000 baud)
    - **Lyra USB-C Port**: Provides USB On-The-Go (OTG) functionality for external devices but does NOT charge the PicoCalc batteries. External devices must be 3.3V compatible or use an externally powered USB hub.
