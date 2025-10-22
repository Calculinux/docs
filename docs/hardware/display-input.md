# Display & Input Technical Details

This page provides technical information about the PicoCalc display and keyboard interfacing with Calculinux.

## Display System

### LCD Panel Specifications

| Specification | Details |
|--------------|---------|
| **Interface** | SPI (Serial Peripheral Interface) |
| **Controller** | ILI9488 (or similar) |
| **Resolution** | 320×320 pixels |
| **Text Mode** | 53 columns × 40 rows (6×8 font) |
| **Color Depth** | 16-bit RGB565 |
| **Refresh Rate** | ~60Hz |

!!! note "Panel Variations"
    The PicoCalc uses a 320×320 pixel display with an ILI9488 controller. The small text area (53×40 characters) means that many applications will wrap text lines, but this is usually manageable with proper terminal configuration.

### SPI Configuration

The display connects via SPI with the following characteristics:

```
SPI Bus: spi0
Mode: 0 (CPOL=0, CPHA=0)
Bits per word: 8
Max Speed: 80 MHz (overclocked for better performance)
Standard Speed: 40 MHz
```

!!! info "SPI Overclocking"
    Community testing shows the display SPI can be safely overclocked to 80MHz for improved performance, though this may be limited by SPI bandwidth for full framerate applications.

### Framerate Limitations

| Usage Type | Expected Performance |
|------------|---------------------|
| **Text/Console** | Full speed |
| **Graphics Applications** | <60fps due to SPI bandwidth |
| **Gaming** | Varies by complexity |

### Text Display Considerations

The 320×320 pixel display with 6×8 font provides a text area of **53 columns × 40 rows**. This is smaller than most software expects:

- Standard terminal: 80×24 or larger
- Many applications assume at least 80 columns
- Text lines will often wrap, requiring horizontal scrolling
- Some TUI applications may have layout issues

**Workarounds**:
- Use applications designed for small terminals
- Configure `COLUMNS=53` and `LINES=40` environment variables
- Use terminal pagers with line wrapping (`less -S` for side-scrolling)
- Choose compact display options when available in applications

### Backlight Control

The backlight is controlled by the STM32 MCU, not directly by the Linux system:

**Current Implementation**: Limited display sleep functionality
**Interface**: Via MFD drivers (experimental)
**MCU Control**: Brightness managed by keyboard MCU firmware

!!! warning "Backlight Limitations"
    Current display sleep functionality does not yet control the backlight directly. Full backlight control is intended to be implemented through the experimental MFD drivers that communicate with the keyboard MCU.

**Display Sleep** (without backlight control):
```bash
# Turn off display (framebuffer only)
echo 0 > /sys/class/backlight/picocalc/bl_power

# Turn on display
echo 1 > /sys/class/backlight/picocalc/bl_power
```

### Display Driver

Calculinux uses a custom ILI9488 framebuffer driver:

**Driver Name**: `ili9488`
**Compatible**: `ilitek,ili9488`

**Features**:
- Direct framebuffer access (`/dev/fb0`)
- 320×320 pixel resolution
- 30 FPS target frame rate
- SPI interface at up to 80MHz
- Hardware-specific optimizations

**Driver Location**: Available in the [picocalc-drivers repository](https://github.com/Calculinux/picocalc-drivers)

### Device Tree Configuration

Actual device tree configuration from `rk3506-luckfox-lyra.dtsi`:

```dts
&spi0 {
    status = "okay";
    pinctrl-names = "default";
    pinctrl-0 = <&rm_io7_spi0_clk &rm_io6_spi0_mosi &rm_io5_spi0_miso>;

    ili9488: ili9488@0 {
        status = "okay";
        compatible = "ilitek,ili9488";
        spi-max-frequency = <80000000>;
        reg = <0>;
        pinctrl-names = "default";
        pinctrl-0 = <&ili9488_pins>;
        fps = <30>;
        width = <320>;
        height = <320>;
        cs = <&gpio0 RK_PA4 GPIO_ACTIVE_HIGH>;
        dc = <&gpio0 RK_PA3 GPIO_ACTIVE_HIGH>;
        rst = <&gpio0 RK_PA2 GPIO_ACTIVE_HIGH>;
    };
};
```

**GPIO Pin Configuration**:
```dts
ili9488 {
    ili9488_pins: ili9488-pins {
        rockchip,pins =
            <0 RK_PA4 RK_FUNC_GPIO &pcfg_pull_none>,  /* CS */
            <0 RK_PA3 RK_FUNC_GPIO &pcfg_pull_none>,  /* DC */
            <0 RK_PA2 RK_FUNC_GPIO &pcfg_pull_none>;  /* RST */
    };
};
```

### Performance Considerations

**Bandwidth Calculation**:
```
320 × 320 pixels × 2 bytes × 60 fps = 12.3 MB/s
At 80 MHz SPI: ~10 MB/s theoretical maximum
```

The driver implements:
- Frame skipping if needed
- Partial updates for efficiency
- Double buffering to reduce tearing

### Backlight Control

The backlight is controlled via PWM:

**Interface**: `/sys/class/backlight/picocalc/`

**Control**:
```bash
# Set brightness (0-255)
echo 200 > /sys/class/backlight/picocalc/brightness

# Get current brightness
cat /sys/class/backlight/picocalc/brightness

# Get maximum brightness
cat /sys/class/backlight/picocalc/max_brightness
```

## Keyboard System

### Keyboard Architecture

The PicoCalc keyboard uses a sophisticated architecture with a dedicated microcontroller:

**MCU**: STM32F103R8T6 "southbridge" chip running Arduino code
**Interface**: I2C communication to the Luckfox Lyra
**Matrix**: Physical matrix keyboard handled internally by the MCU

!!! info "MCU Southbridge Design"
    The keyboard MCU handles matrix scanning internally and presents a clean I2C interface to the main SBC. This design offloads keyboard processing and enables additional functionality like power management and brightness control.

### MCU Functions

The STM32F103R8T6 microcontroller provides multiple functions:

| Function | Status | Notes |
|----------|--------|-------|
| **Keyboard Matrix Scanning** | ✅ Active | Internal matrix handling |
| **I2C Communication** | ✅ Active | Interface to Luckfox Lyra |
| **Battery Monitoring** | 🧪 Experimental | Via MFD drivers |
| **Brightness Control** | 🧪 Experimental | Screen and keyboard backlight |
| **Power Button Support** | 🧪 Experimental | System shutdown control |
| **RTC (Alternate Firmware)** | 🚧 Future | Custom firmware feature |

### Firmware Options

#### Default Firmware

**Source**: [clockworkpi/PicoCalc](https://github.com/clockworkpi/PicoCalc/tree/master/Code/picocalc_keyboard)
**Platform**: Arduino code for STM32F103R8T6
**Features**: Basic keyboard and I2C communication

#### Custom BIOS Firmware

**Source**: [Custom PicoCalc BIOS](https://git.jcsmith.fr/jackcartersmith/picocalc_BIOS)
**Forum Discussion**: [Custom PicoCalc BIOS Thread](https://forum.clockworkpi.com/t/custom-picocalc-bios-keyboard-firmware/17292)
**Additional Features**:
- Real-Time Clock (RTC) support
- Enhanced power management
- Extended I2C functionality

!!! note "Firmware Development"
    The keyboard MCU firmware is user-upgradeable, enabling community development of enhanced features and functionality.

### I2C Communication

**I2C Address**: (Device-specific, check firmware documentation)
**Bus Speed**: Standard mode (100 kHz) or Fast mode (400 kHz)
**Protocol**: Custom protocol defined by firmware

### Linux Driver Integration

#### MFD (Multi-Function Device) Drivers

**Status**: 🧪 Experimental - under development
**Purpose**: Unified driver for all MCU functions

**Driver Components**:
- Keyboard input device
- Battery monitoring
- Brightness control
- Power management
- RTC support (custom firmware)

!!! warning "Driver Development Status"
    The MFD drivers are experimental and not yet complete. They show promise but may not be fully functional in current releases.

### Keyboard Driver

**Driver Type**: MFD (Multi-Function Device) with I2C communication
**Driver Name**: `picocalc_mfd` (experimental)

**Features**:
- I2C communication with STM32 MCU
- Standard Linux input device interface
- Integration with MCU power management
- Battery monitoring support
- Brightness control interface

**Driver Location**: `drivers/mfd/picocalc_mfd.c` (experimental)

!!! info "Legacy vs MFD Drivers"
    Current stable releases may use simpler keyboard-only drivers, while experimental MFD drivers provide full MCU integration. Check your kernel configuration for which driver is active.

### Device Tree Configuration

Actual device tree configuration for I2C keyboard MCU from `rk3506-luckfox-lyra.dtsi`:

```dts
&i2c2 {
    status = "okay";
    pinctrl-names = "default";
    pinctrl-0 = <&rm_io10_i2c2_scl &rm_io11_i2c2_sda>;
    max-frequency = <400000>;

    picocalc_kbd: picocalc_kbd@1f {
        status = "okay";
        compatible = "picocalc_kbd";
        reg = <0x1F>;
    };
};
```

**I2C Pin Configuration**:
```dts
&pinctrl {
    rm_io11 {
        rm_io11_i2c2_sda: rm-io11-i2c2-sda {
            rockchip,pins = <0 RK_PB3 35 &pcfg_pull_none>;
        };
    };

    rm_io10 {
        rm_io10_i2c2_scl: rm-io10-i2c2-scl {
            rockchip,pins = <0 RK_PB2 34 &pcfg_pull_none>;
        };
    };
};
```

!!! note "I2C Configuration"
    The keyboard MCU is connected to I2C bus 2 at address 0x1F, running at 400kHz (fast mode).

### Input Device Interface

The keyboard appears as a standard Linux input device:

**Device Path**: `/dev/input/event0`

**Testing Input**:
```bash
# List input devices
cat /proc/bus/input/devices

# Monitor keyboard events
evtest /dev/input/event0
```

### Custom Key Bindings

Users can remap keys using standard Linux tools:

**Using udev/hwdb**:
```
# /etc/udev/hwdb.d/90-picocalc-keyboard.hwdb
evdev:input:b0003v*p*
 KEYBOARD_KEY_1e=leftshift
```

## Display Output

### Console (Text Mode)

**Console Driver**: `fbcon` (framebuffer console)
**Default Font**: 6×8 pixels
**Text Area**: **53 columns × 40 rows** (at 320×320 with 6×8 font)

**Configuration**:
```bash
# /etc/default/console-setup
ACTIVE_CONSOLES="/dev/tty[1-6]"
FONTFACE="Terminus"
FONTSIZE="6x8"
```

**Font Rendering**:
- Character size: 6×8 pixels
- Text area: 53×40 characters
- VGA text mode emulation
- UTF-8 support

### Graphical Display

The display is graphics-capable but no graphical environment is installed by default:

**Current State**: Console-only by default
**Experimentation Encouraged**: Community testing of graphical environments

**Potential Display Servers**:
- **X11**: Would require `xf86-video-fbdev` driver installation
- **Wayland**: Would require compositor with fbdev backend
- **Direct Rendering**: Via `/dev/fb0` for custom applications

!!! info "Graphics Capability"
    While Calculinux ships as console-only, the hardware supports graphics applications. Community experimentation with X11, Wayland, or direct framebuffer graphics is encouraged.

## Power Management

### Display Sleep

The display can be put to sleep to save power:

```bash
# Turn off display
echo 0 > /sys/class/backlight/picocalc/bl_power

# Turn on display
echo 1 > /sys/class/backlight/picocalc/bl_power
```

### Automatic Dimming

Configure automatic dimming:

```bash
# Using systemd-logind
# /etc/systemd/logind.conf
IdleAction=ignore
IdleActionSec=5min
```

## Troubleshooting

### Display Issues

**Symptom**: No display output

**Check**:
```bash
# Verify framebuffer device exists
ls -l /dev/fb0

# Check ILI9488 driver loaded
lsmod | grep ili9488

# View kernel logs
dmesg | grep -i ili9488
```

**Symptom**: Display corruption or tearing

**Solutions**:
- Check display cable is fully inserted
- Reduce SPI clock speed in device tree
- Enable double buffering
- Verify power supply stability

### Keyboard Issues

**Symptom**: Keys not responding

**Check via Serial Console**:
1. Connect to PicoCalc USB-C port at 1500000 baud
2. Log in to the system
3. Check which keyboard driver is loaded:

```bash
# Check for picocalc_kbd driver
lsmod | grep picocalc_kbd

# Check for MFD keyboard driver  
lsmod | grep picocalc_mfd_kbd

# Try loading the alternative driver if needed
modprobe picocalc_mfd_kbd
# or
modprobe picocalc_kbd
```

**Additional Checks**:
```bash
# Verify input device exists
ls -l /dev/input/event*

# Check I2C communication
i2cdetect -y 2  # MCU is on I2C bus 2

# Test raw input
evtest /dev/input/event0
```

**If Problems Persist**:
File a bug report with:
- Which drivers you tested
- Serial console output
- Kernel log messages (`dmesg | grep -i picocalc`)

**Symptom**: Intermittent key responses

**Check**:
```bash
# Check I2C bus errors
dmesg | grep -i i2c

# Monitor MCU communication
# (requires debug firmware or driver)
```

**Symptom**: Key repeat too fast/slow

**Adjust**:
```bash
# Set repeat rate (delay, rate)
kbdrate -d 250 -r 30
```

## Development & Debugging

### Graphics Programming

For graphics applications, we recommend using SDL rather than direct framebuffer access:

**SDL (Simple DirectMedia Layer)**:
- Cross-platform graphics library
- Handles framebuffer abstraction
- Better compatibility and portability
- Hardware acceleration where available

**SDL Documentation**: [SDL2 Documentation](https://wiki.libsdl.org/)

**Basic SDL Setup**:
```c
#include <SDL2/SDL.h>

int main() {
    SDL_Init(SDL_INIT_VIDEO);
    SDL_Window* window = SDL_CreateWindow("PicoCalc App", 
        SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 
        320, 320, SDL_WINDOW_SHOWN);
    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, 0);
    
    // Your graphics code here
    
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
```

### Reading Keyboard Events

Example Python code:

```python
from evdev import InputDevice, categorize, ecodes

dev = InputDevice('/dev/input/event0')

for event in dev.read_loop():
    if event.type == ecodes.EV_KEY:
        print(categorize(event))
```

## Driver Source Code

The complete driver source code is available in the Calculinux picocalc-drivers repository:

- **Display Driver (ILI9488)**: [picocalc-drivers repository](https://github.com/Calculinux/picocalc-drivers)
- **MFD Keyboard Driver**: [picocalc-drivers repository](https://github.com/Calculinux/picocalc-drivers)
- **Hisptoot Keyboard Driver**: [picocalc-drivers repository](https://github.com/Calculinux/picocalc-drivers)
- **Device Tree**: [meta-calculinux repository](https://github.com/Calculinux/meta-calculinux)

### MCU Firmware Source Code

- **Default Firmware**: [clockworkpi/PicoCalc](https://github.com/clockworkpi/PicoCalc/tree/master/Code/picocalc_keyboard)
- **Custom BIOS**: [jackcartersmith/picocalc_BIOS](https://git.jcsmith.fr/jackcartersmith/picocalc_BIOS)

!!! info "Driver Repository"
    Hardware-specific drivers are maintained in the picocalc-drivers repository, while the meta-calculinux repository contains the build system and device tree configurations.

## Contributing

Improvements to the display and keyboard drivers are welcome! See [Contributing](../developer/contributing.md) for guidelines.

## Next Steps

- Learn about [Power Management](power.md)
- Review [Hardware Modifications](modifications.md)
- Explore [Kernel Development](../developer/kernel.md)
