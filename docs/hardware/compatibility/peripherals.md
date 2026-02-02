# Peripheral Compatibility

## Internal Peripherals

| Device Type | Status | Notes |
|-------------|--------|-------|
| **Display** | ✅ Fully Supported | Integrated LCD |
| **Keyboard** | ✅ Fully Supported | Matrix keyboard |
| **Lyra Storage** | ✅ Fully Supported | Lyra's SD card, optional NAND |
| **PicoCalc SD Card Slot** | ✅ Fully Supported | External SD card accessible on PicoCalc |

## Expansion Interfaces

!!! info "Internal Expansion Options"
    While the Luckfox Lyra is enclosed within the PicoCalc, it provides several expansion interfaces accessible for hardware modifications and custom projects. For detailed pinout information, see the [official Luckfox Lyra pinout documentation](https://wiki.luckfox.com/Luckfox-Lyra/Pinout).

| Interface | Voltage | Status | Notes |
|-----------|---------|--------|-------|
| **GPIO** | 3.3V | ✅ Available | External GPIO pins are free (display/keyboard do not use them) |
| **USB** | 3.3V | ✅ Available | Internal USB host/device |
| **I2C** | 3.3V | ✅ Available | I2C bus for sensors/peripherals |
| **I2S** | 3.3V | ❓ Untested | Audio interface available but untested |
| **SPI** | 3.3V | ✅ Available | SPI interface (shared with display) |
| **UART** | 3.3V | ✅ Available | Serial communication |

!!! warning "3.3V Logic Level Requirement"
    **CRITICAL**: All interfaces operate at **3.3V logic levels only**. Using 5V devices or signals will damage the hardware. The PicoCalc is designed for tinkering and experimentation, but proper voltage levels must be maintained.

## Expansion Peripheral Compatibility

| Peripheral Type | Interface | Status | Notes |
|----------------|-----------|--------|-------|
| **Sensors** | I2C/SPI | ✅ Compatible | Temperature, accelerometer, etc. |
| **External Storage** | USB 3.3V | ✅ Compatible | Flash drives, custom storage |
| **Network Modules** | USB/SPI | 🚧 Possible | WiFi/cellular modules (3.3V) |
| **Audio Devices (I2S)** | I2S | ❓ Untested | External audio codecs via I2S interface |
| **Audio Devices (PWM)** | GPIO (PWM) | ⚠️ Limited | See PWM audio note below |
| **Replacement Displays** | MIPI DSI | 🚧 Possible | 22-pin connector, 3.95" square |
| **Additional SPI Displays** | SPI | ⚠️ Conflicts | Would conflict with main display |
| **Input Devices** | GPIO/I2C | 🚧 Possible | Additional buttons, encoders |
| **Communication** | UART/USB | ✅ Compatible | Serial devices, modems |

!!! info "PWM Audio Details"
    The PicoCalc has built-in audio support using PWM (Pulse Width Modulation) on GPIO pins. However, there are significant limitations:

    - The Lyra's PWM is not available on the correct pins without hardware modification
    - Software PWM must be used instead on pins with only 1.2V tolerance
    - This results in **low volume** audio and **high CPU usage**

    For proper audio, hardware modifications are needed to access the correct PWM pins or use the I2S interface. See the [Hardware Modifications guide](../modifications.md) for details on enabling full-volume audio (documentation stub - refer to the [ClockworkPi forum](https://forum.clockworkpi.com/) for community solutions).

!!! note "Custom Hardware Projects"
    These expansion options enable custom hardware projects and modifications for advanced users comfortable with electronics work.
