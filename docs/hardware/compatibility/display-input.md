# Display & Input Compatibility

## Display Compatibility

### Integrated Display

| PicoCalc Model | Display Type | Status |
|----------------|--------------|--------|
| **PicoCalc** | ILI9488 LCD | ✅ Fully Supported |

### Replacement Display Options

| Display Type | Connector | Size Requirement | Status |
|--------------|-----------|------------------|--------|
| **MIPI DSI (Higher Resolution)** | 22-pin (CM4 compatible) | 3.95" diagonal, square | 🚧 Possible |
| **Original ILI9488** | SPI | 320×320 | ✅ Standard |

!!! info "MIPI DSI Display Upgrade"
    Higher resolution MIPI DSI displays are possible if they use the same 22-pin connector found on Raspberry Pi Compute Module IO boards. The display must be square format and exactly 3.95" diagonal to fit within the PicoCalc enclosure. This would require hardware modification and custom driver configuration.

## Input Device Compatibility

### Integrated Keyboard

| PicoCalc Model | Keyboard | Status |
|----------------|----------|--------|
| **All Models** | Matrix Keyboard | ✅ Fully Supported |

### External Input

| Device Type | Connection | Status | Notes |
|-------------|------------|--------|-------|
| **USB Input Devices** | USB-C OTG | 🧪 Experimental | Requires 3.3V devices or powered hub |
| **Keyboard/Mouse** | USB-C OTG | 🧪 Experimental | May work with compatible devices |

!!! info "USB OTG Input Support"
    While the integrated matrix keyboard is the primary input method, external USB input devices may be possible via the USB-C OTG port. This requires 3.3V compatible devices or an externally powered USB hub and is currently untested.
