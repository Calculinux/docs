# Display & Input Technical Details

This page provides technical information about the PicoCalc display and keyboard interfacing with Calculinux.

## Display System

### LCD Panel Specifications

| Specification | Details |
|--------------|---------|
| **Interface** | SPI (Serial Peripheral Interface) |
| **Controller** | ST7789V (or similar) |
| **Resolution** | 240x240 pixels (typical for PicoCalc) |
| **Color Depth** | 16-bit RGB565 |
| **Refresh Rate** | ~60Hz |

!!! note "Panel Variations"
    Different PicoCalc production runs may use slightly different LCD panels. The driver should auto-detect or support multiple variants.

### SPI Configuration

The display connects via SPI with the following characteristics:

```
SPI Bus: spi0
Mode: 0 (CPOL=0, CPHA=0)
Bits per word: 8
Max Speed: 40 MHz
```

### GPIO Pins

Additional control pins beyond SPI data/clock:

| Pin | Function | Direction |
|-----|----------|-----------|
| **CS** | Chip Select | Output |
| **DC** | Data/Command | Output |
| **RST** | Reset | Output |
| **BL** | Backlight | Output (PWM) |

### Display Driver

Calculinux uses a custom framebuffer driver:

**Driver Name**: `picocalc_st7789`

**Features**:
- Direct framebuffer access (`/dev/fb0`)
- Hardware acceleration where possible
- Configurable refresh rate
- Backlight PWM control
- Rotation support

**Driver Location**: `drivers/video/fbdev/picocalc_st7789.c`

### Device Tree Configuration

Example device tree snippet:

```dts
&spi0 {
    status = "okay";
    
    display@0 {
        compatible = "sitronix,st7789v";
        reg = <0>;
        spi-max-frequency = <40000000>;
        dc-gpios = <&gpio 24 GPIO_ACTIVE_HIGH>;
        reset-gpios = <&gpio 25 GPIO_ACTIVE_HIGH>;
        backlight-gpios = <&gpio 18 GPIO_ACTIVE_HIGH>;
        width = <240>;
        height = <240>;
        buswidth = <8>;
        rotation = <0>;
    };
};
```

### Performance Considerations

**Bandwidth Calculation**:
```
240 × 240 pixels × 2 bytes × 60 fps = 6.9 MB/s
At 40 MHz SPI: ~5 MB/s theoretical maximum
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

### Keyboard Matrix

The PicoCalc keyboard uses a matrix scanning design:

**Matrix Size**: 6 rows × 8 columns (typical)

**Scan Rate**: 100 Hz

**Debounce**: 10ms

### GPIO Mapping

The keyboard matrix connects to GPIO pins:

```
Rows: GPIO 0-5
Columns: GPIO 8-15
```

### Keyboard Driver

**Driver Name**: `picocalc_keyboard`

**Features**:
- Standard Linux input device
- Key repeat support
- Configurable scan rate
- Debouncing algorithm
- Event device interface

**Driver Location**: `drivers/input/keyboard/picocalc_keyboard.c`

### Device Tree Configuration

Example device tree snippet:

```dts
keyboard {
    compatible = "picocalc,matrix-keyboard";
    row-gpios = <&gpio 0 GPIO_ACTIVE_HIGH>,
                <&gpio 1 GPIO_ACTIVE_HIGH>,
                <&gpio 2 GPIO_ACTIVE_HIGH>,
                <&gpio 3 GPIO_ACTIVE_HIGH>,
                <&gpio 4 GPIO_ACTIVE_HIGH>,
                <&gpio 5 GPIO_ACTIVE_HIGH>;
    
    col-gpios = <&gpio 8 GPIO_ACTIVE_HIGH>,
                <&gpio 9 GPIO_ACTIVE_HIGH>,
                <&gpio 10 GPIO_ACTIVE_HIGH>,
                <&gpio 11 GPIO_ACTIVE_HIGH>,
                <&gpio 12 GPIO_ACTIVE_HIGH>,
                <&gpio 13 GPIO_ACTIVE_HIGH>,
                <&gpio 14 GPIO_ACTIVE_HIGH>,
                <&gpio 15 GPIO_ACTIVE_HIGH>;
    
    linux,keymap = <...>; /* Key mappings */
    debounce-delay-ms = <10>;
    col-scan-delay-us = <10>;
};
```

### Key Mapping

The physical keys are mapped to Linux keycodes:

| Physical Key | Linux Keycode | Function |
|--------------|---------------|----------|
| 0-9 | KEY_0 - KEY_9 | Number input |
| + | KEY_KPPLUS | Addition |
| - | KEY_KPMINUS | Subtraction |
| × | KEY_KPASTERISK | Multiplication |
| ÷ | KEY_KPSLASH | Division |
| = | KEY_KPENTER | Enter/Execute |
| C | KEY_ESC | Clear/Escape |
| ← | KEY_BACKSPACE | Backspace |

### Input Device Interface

The keyboard appears as a standard Linux input device:

**Device Path**: `/dev/input/event0` (or similar)

**Testing Input**:
```bash
# List input devices
cat /proc/bus/input/devices

# Monitor keyboard events
evtest /dev/input/event0
```

### Custom Key Bindings

Users can remap keys using standard Linux tools:

**Using xmodmap** (for X11):
```bash
xmodmap -e "keycode 82 = Super_L"
```

**Using udev/hwdb**:
```
# /etc/udev/hwdb.d/90-picocalc-keyboard.hwdb
evdev:input:b0003v*p*
 KEYBOARD_KEY_1e=leftshift
```

## Display Output

### Console (Text Mode)

**Console Driver**: `fbcon` (framebuffer console)

**Configuration**:
```bash
# /etc/default/console-setup
ACTIVE_CONSOLES="/dev/tty[1-6]"
FONTFACE="Terminus"
FONTSIZE="8x16"
```

**Font Rendering**:
- Calculable: 30×15 characters (at 240×240 with 8×16 font)
- VGA text mode emulation
- UTF-8 support

### Graphical Display

**Display Server Options**:
- **X11**: Requires `xf86-video-fbdev` driver
- **Wayland**: Requires compositor with fbdev backend
- **Direct Rendering**: Via `/dev/fb0` for custom apps

**X11 Configuration**:
```
# /etc/X11/xorg.conf.d/99-fbdev.conf
Section "Device"
    Identifier "picocalc fb"
    Driver "fbdev"
    Option "fbdev" "/dev/fb0"
EndSection
```

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

# Check driver loaded
lsmod | grep fb

# View kernel logs
dmesg | grep -i display
```

**Symptom**: Display corruption or tearing

**Solutions**:
- Reduce SPI clock speed in device tree
- Enable double buffering
- Check power supply stability

### Keyboard Issues

**Symptom**: Keys not responding

**Check**:
```bash
# Verify input device exists
ls -l /dev/input/event*

# Check driver loaded
lsmod | grep keyboard

# Test raw input
evtest /dev/input/event0
```

**Symptom**: Key repeat too fast/slow

**Adjust**:
```bash
# Set repeat rate (delay, rate)
kbdrate -d 250 -r 30
```

## Development & Debugging

### Accessing Framebuffer Directly

Example C code to write to framebuffer:

```c
#include <fcntl.h>
#include <linux/fb.h>
#include <sys/mman.h>
#include <sys/ioctl.h>

int fd = open("/dev/fb0", O_RDWR);
struct fb_var_screeninfo vinfo;
ioctl(fd, FBIOGET_VSCREENINFO, &vinfo);

size_t screensize = vinfo.yres * vinfo.xres * vinfo.bits_per_pixel / 8;
uint16_t *fbp = mmap(0, screensize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

// Draw a red pixel at (100, 100)
fbp[100 * vinfo.xres + 100] = 0xF800; // RGB565 red
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

The complete driver source code is available in the Calculinux repository:

- **Display Driver**: [drivers/video/fbdev/picocalc_st7789.c](https://github.com/Calculinux/meta-calculinux)
- **Keyboard Driver**: [drivers/input/keyboard/picocalc_keyboard.c](https://github.com/Calculinux/meta-calculinux)
- **Device Tree**: [arch/arm/boot/dts/picocalc-luckfox.dts](https://github.com/Calculinux/meta-calculinux)

## Contributing

Improvements to the display and keyboard drivers are welcome! See [Contributing](../developer/contributing.md) for guidelines.

## Next Steps

- Learn about [Power Management](power.md)
- Review [Hardware Modifications](modifications.md)
- Explore [Kernel Development](../developer/kernel.md)
