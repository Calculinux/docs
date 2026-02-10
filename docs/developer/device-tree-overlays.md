# Creating Device Tree Overlays

This guide covers creating custom device tree overlays for Calculinux, from writing the overlay source to integrating it into the build system.

## Overview

Device tree overlays allow you to extend hardware support without modifying the base device tree. This is useful for:

- Adding support for external I2C/SPI peripherals
- Configuring GPIO-based hardware
- Enabling custom hardware modules
- Testing configurations before mainlining

## Prerequisites

- Familiarity with device tree syntax
- Understanding of Linux device drivers
- Yocto/BitBake development environment set up
- Access to hardware documentation

!!! tip "User Guide"
    For information on using pre-built overlays, see the [Device Tree Overlays User Guide](../hardware/device-tree-overlays.md).

## Overlay Structure

Device tree overlays use the `/plugin/` keyword and reference existing nodes with `&`:

```dts
/dts-v1/;
/plugin/;

/* Optional metadata */
/ {
    compatible = "rockchip,rk3506";
};

/* Modify existing nodes */
&i2c2 {
    status = "okay";
    clock-frequency = <100000>;
    
    my_device: device@50 {
        compatible = "vendor,device";
        reg = <0x50>;
        /* Device properties */
    };
};
```

## Step 1: Create the Overlay Source

Add your overlay source to the [picocalc-drivers repository](https://github.com/Calculinux/picocalc-drivers).

### Choose a Descriptive Name

Use a clear, descriptive filename in `devicetree-overlays/`:

- `ds3231-rtc-overlay.dts` - DS3231 RTC module
- `100khz-i2c-overlay.dts` - I2C speed reduction
- `neo-m8n-gps-overlay.dts` - GPS module

### Write the Overlay

!!! example "Example: Adding an I2C Sensor"
    ```dts
    /dts-v1/;
    /plugin/;

    / {
        compatible = "rockchip,rk3506";
    };

    &i2c2 {
        #address-cells = <1>;
        #size-cells = <0>;
        status = "okay";

        bme280: bme280@76 {
            compatible = "bosch,bme280";
            reg = <0x76>;
            status = "okay";
        };
    };
    ```

### Important Considerations

- **Compatible strings**: Use standard bindings from `Documentation/devicetree/bindings/` in the Linux kernel
- **I2C addresses**: Verify your device's address (check datasheet)
- **Pin configuration**: May require pinctrl entries for GPIO configuration
- **Dependencies**: Ensure required kernel drivers are enabled

## Step 2: Test Compilation Locally

Before creating a recipe, test your overlay compiles:

```shell
# In picocalc-drivers directory
dtc -@ -I dts -O dtb -o test.dtbo devicetree-overlays/my-overlay.dts

# Check for errors or warnings
```

The `-@` flag generates symbols needed for overlays.

## Step 3: Create a Yocto Recipe

Create a recipe in `meta-calculinux-distro/recipes-bsp/drivers/` or `meta-picocalc-bsp-rockchip/recipes-bsp/drivers/`.

### Recipe Template

Create `picocalc-<device>-overlay_1.0.bb`:

```bitbake
SUMMARY = "Device tree overlay for <device description>"
DESCRIPTION = "Enables support for <device> on PicoCalc via I2C/SPI/GPIO"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

PR = "r0"

# Include shared source from picocalc-drivers
require picocalc-drivers-source.inc

COMPATIBLE_MACHINE = "luckfox-lyra"
DEPENDS = "dtc-native"

do_compile() {
    dtc -@ -I dts -O dtb \
        -o ${B}/<overlay-name>.dtbo \
        ${S}/devicetree-overlays/<overlay-source>.dts
}

do_install() {
    install -d ${D}${nonarch_base_libdir}/firmware/overlays
    install -m 0644 ${B}/<overlay-name>.dtbo \
        ${D}${nonarch_base_libdir}/firmware/overlays/
}

FILES:${PN} = "${nonarch_base_libdir}/firmware/overlays/<overlay-name>.dtbo"
PACKAGES = "${PN}"
```

### Multiple Overlays in One Recipe

If your recipe builds multiple overlays:

```bitbake
do_compile() {
    dtc -@ -I dts -O dtb -o ${B}/overlay1.dtbo ${S}/overlay1.dts
    dtc -@ -I dts -O dtb -o ${B}/overlay2.dtbo ${S}/overlay2.dts
}

do_install() {
    install -d ${D}${nonarch_base_libdir}/firmware/overlays
    install -m 0644 ${B}/overlay1.dtbo ${D}${nonarch_base_libdir}/firmware/overlays/
    install -m 0644 ${B}/overlay2.dtbo ${D}${nonarch_base_libdir}/firmware/overlays/
}

FILES:${PN} = "${nonarch_base_libdir}/firmware/overlays/*.dtbo"
```

## Step 4: Add to System Image

### Option 1: Add to PICOCALC_DRIVERS

Edit `kas-luckfox-lyra-bundle.yaml` to include your overlay:

```yaml
PICOCALC_DRIVERS = "\
  picocalc-drivers-lcd-drm \
  picocalc-drivers-snd-pwm \
  picocalc-drivers-mfd \
  picocalc-<device>-overlay \
"
```

### Option 2: Create a Package Group

For optional overlays, create a package group:

```bitbake
# In meta-calculinux-distro/recipes-core/packagegroups/
SUMMARY = "Device tree overlays for optional peripherals"
inherit packagegroup

RDEPENDS:${PN} = " \
    picocalc-ds3231-overlay \
    picocalc-gps-overlay \
    picocalc-sensor-overlay \
"
```

## Step 5: Update SRCREV

After committing your overlay to the picocalc-drivers repository:

1. Get the new commit hash:
   ```shell
   cd picocalc-drivers
   git log -1 --format=%H
   ```

2. Update `meta-calculinux-distro/recipes-bsp/drivers/picocalc-drivers-source.inc`:
   ```bitbake
   SRCREV = "<new-commit-hash>"
   ```

## Step 6: Build and Test

Build your image with the new overlay:

```shell
# From calculinux-build/ directory
./meta-calculinux/kas-container build \
    ./meta-calculinux/kas-luckfox-lyra-bundle.yaml
```

After flashing to your device, verify the overlay is present:

```shell
ls -l /lib/firmware/overlays/
```

Load and test the overlay as described in the [user guide](../hardware/device-tree-overlays.md).

## Common Overlay Patterns

### I2C Device

```dts
/dts-v1/;
/plugin/;

&i2c2 {
    status = "okay";
    
    device@addr {
        compatible = "vendor,device";
        reg = <0xaddr>;
        /* Device-specific properties */
    };
};
```

### SPI Device

```dts
/dts-v1/;
/plugin/;

&spi0 {
    status = "okay";
    
    device@0 {
        compatible = "vendor,device";
        reg = <0>;
        spi-max-frequency = <1000000>;
        /* Device-specific properties */
    };
};
```

### GPIO Device

```dts
/dts-v1/;
/plugin/;

&gpio0 {
    device_pins: device-pins {
        rockchip,pins = <0 RK_PA0 RK_FUNC_GPIO &pcfg_pull_up>;
    };
};

/ {
    device {
        compatible = "gpio-keys";
        pinctrl-names = "default";
        pinctrl-0 = <&device_pins>;
        
        button {
            gpios = <&gpio0 RK_PA0 GPIO_ACTIVE_LOW>;
            /* Other properties */
        };
    };
};
```

### Modifying Existing Properties

```dts
/dts-v1/;
/plugin/;

&i2c2 {
    clock-frequency = <100000>;  /* Reduce from default 400kHz */
};
```

## Pin Configuration Reference

### I2C Buses on Luckfox Lyra

| Bus | Device | SCL Pin | SDA Pin | Available |
|-----|--------|---------|---------|-----------|
| I2C2 | `/dev/i2c-2` | GPIO IO4 | GPIO IO5 | Yes (Expansion) |

### GPIO Naming

Rockchip GPIO pins use the format: `<&gpioN RK_PAx GPIO_ACTIVE_HIGH/LOW>`

- `gpioN`: GPIO bank (0-4)
- `RK_PAx`: Port A, pin x (or PB, PC, PD)
- Active level: HIGH or LOW

Check the RK3506 datasheet and Luckfox Lyra schematics for available pins.

## Debugging Overlays

### Check Overlay Loading

```shell
# Load with verbose output
cat /lib/firmware/overlays/my-overlay.dtbo > \
    /sys/kernel/config/device-tree/overlays/test/dtbo 2>&1 | tee load.log

# Check kernel messages
dmesg | tail -20
```

### Common Errors

- **"OF: overlay: Failed to apply"**: Node reference doesn't exist or syntax error
- **"Invalid argument"**: Malformed device tree binary
- **Device not appearing**: Check driver is loaded and device tree properties are correct

### Decompiling Overlays

To inspect a compiled overlay:

```shell
dtc -I dtb -O dts /lib/firmware/overlays/my-overlay.dtbo
```

## Advanced Topics

### Conditional Overlays

Overlays can target specific hardware revisions:

```dts
/ {
    compatible = "rockchip,rk3506", "calculinux,picocalc-v1.1";
};
```

### Fragment Syntax

Alternative syntax using fragments:

```dts
/dts-v1/;
/plugin/;

/ {
    fragment@0 {
        target = <&i2c2>;
        __overlay__ {
            status = "okay";
            /* properties */
        };
    };
};
```

### Removing Properties

Delete properties in overlays:

```dts
&node {
    property = /delete-property/;
};
```

## Testing Best Practices

1. **Test on hardware**: Always verify on actual PicoCalc hardware
2. **Check device registration**: Use `ls /dev/`, `i2cdetect`, `lsmod`
3. **Monitor kernel messages**: `dmesg -w` during overlay loading
4. **Test loading/unloading**: Verify overlay can be cleanly removed
5. **Document wiring**: Include connection diagram in documentation

## Documentation Requirements

When adding a new overlay, create user documentation in `docs/hardware/`:

- Hardware connection diagram
- Required parts list
- Software setup steps
- Troubleshooting guide
- Example usage

See [ds3231-rtc.md](../hardware/ds3231-rtc.md) for a complete example.

## Resources

### Device Tree Documentation

- [Linux Device Tree Documentation](https://www.kernel.org/doc/html/latest/devicetree/)
- [Device Tree Bindings](https://www.kernel.org/doc/html/latest/devicetree/bindings/)
- [Rockchip Device Trees](https://github.com/rockchip-linux/kernel/tree/develop-4.19/arch/arm/boot/dts)

### Calculinux Resources

- [picocalc-drivers Repository](https://github.com/Calculinux/picocalc-drivers)
- [Hardware Documentation](../hardware/luckfox-lyra.md)
- [Contributing Guide](contributing.md)

## Example: Complete Workflow

Here's a complete example of adding support for a BMP280 pressure sensor:

1. **Create overlay source** in picocalc-drivers:
   ```dts
   /dts-v1/;
   /plugin/;
   
   &i2c2 {
       status = "okay";
       bmp280@76 {
           compatible = "bosch,bmp280";
           reg = <0x76>;
       };
   };
   ```

2. **Create recipe** `picocalc-bmp280-overlay_1.0.bb`

3. **Add to kas-luckfox-lyra-bundle.yaml**

4. **Update SRCREV** after committing to picocalc-drivers

5. **Build and test**

6. **Document** in `docs/hardware/bmp280-sensor.md`

7. **Submit PR** with all changes
