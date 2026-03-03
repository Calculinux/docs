# Testing the Cortex-M0 Core (GPIO Blink)

The RK3506 (used on the Luckfox Lyra and PicoCalc) includes a **Cortex-M0** coprocessor alongside the three Cortex-A7 cores. This guide walks through building and loading a minimal bare-metal firmware that blinks an LED on **GPIO1_B1** to verify the M0 core is working.

GPIO1_B1 is an external GPIO on the PicoCalc, located next to a ground pin, so you can connect an LED (with a series resistor) between that pin and GND to see the blink.

## Overview

- **Goal:** Run a small M0 program that toggles GPIO1_B1 at about 1–2 Hz.
- **Firmware:** Built from the [Calculinux/m0-example](https://github.com/Calculinux/m0-example) repository (`main.c`, `startup.c`, `linker.ld`, `Makefile`).
- **Loading:** The M0 firmware is loaded into SRAM at **0xFFF84000** and started via the Linux **remoteproc** interface, using the [rk3506-mcu](https://github.com/nvitya/rk3506-mcu) remote processor driver.

!!! info "External project: rk3506-mcu"
    The remote processor driver and loading process are documented in **[nvitya/rk3506-mcu](https://github.com/nvitya/rk3506-mcu)**. That project provides the kernel driver and notes on firmware layout. This page focuses on using the [Calculinux/m0-example](https://github.com/Calculinux/m0-example) blink firmware with that setup.

## Prerequisites

### On your build machine

- **ARM bare-metal toolchain:** `arm-none-eabi-gcc` and `arm-none-eabi-objcopy` in your PATH.
  - On Debian/Ubuntu: `sudo apt install gcc-arm-none-eabi`
  - On Fedora: `sudo dnf install arm-none-eabi-gcc`

### On the PicoCalc / Luckfox Lyra (running Calculinux)

- **rk3506-mcu remoteproc driver** built and loaded so that `/sys/class/remoteproc/remoteproc0` exists (or `remoteproc1` depending on your device tree). If you are using a Calculinux image that includes this driver, the interface will be available; otherwise you need to build and install the driver from [rk3506-mcu/rk3506_rproc](https://github.com/nvitya/rk3506-mcu/tree/main/rk3506_rproc).

### Hardware (optional but recommended)

- **LED + resistor** (e.g. 330 Ω–1 kΩ) between **GPIO1_B1** and **GND** on the PicoCalc expansion header. GPIO1_B1 is the pin next to a ground pin; see your board pinout for the exact position.

## Build the firmware

1. Clone the [Calculinux/m0-example](https://github.com/Calculinux/m0-example) repository:

   ```bash
   git clone https://github.com/Calculinux/m0-example.git
   cd m0-example
   ```

2. Build:

   ```bash
   make
   ```

   This produces:

   - **`m0-gpio1_b1-blink.elf`** – ELF image (used by remoteproc)
   - **`m0-gpio1_b1-blink.bin`** – raw binary at load address 0xFFF84000

   The ELF is what you load via the remoteproc `firmware` attribute; the driver uses it to load the program into the M0 SRAM.

## Deploy and load on the device

### 1. Copy the firmware to the device

Copy the ELF file to the PicoCalc, for example to `/lib/firmware/` so the kernel can find it by name, or to any path you will pass to remoteproc:

```bash
scp m0-gpio1_b1-blink.elf root@<device-ip>:/lib/firmware/
```

(Replace `<device-ip>` with your board’s IP or hostname.)

### 2. Find the remoteproc device

On the device, check that the M0 remoteproc is available:

```bash
ls /sys/class/remoteproc/
```

You should see at least one `remoteprocN` (often `remoteproc0`). Use that name in the next steps.

### 3. Load and start the M0 firmware

Run these commands **on the PicoCalc** (e.g. over SSH):

```bash
# Use the remoteproc node you found (e.g. remoteproc0)
RPROC=remoteproc0

# Stop the M0 core if it is already running
echo stop > /sys/class/remoteproc/$RPROC/state

# Tell the driver which firmware to load (path to the .elf on the device)
echo /lib/firmware/m0-gpio1_b1-blink.elf > /sys/class/remoteproc/$RPROC/firmware

# Start the M0 core; it will run the blink loop
echo start > /sys/class/remoteproc/$RPROC/state
```

If the driver and firmware are correct, the M0 starts executing and GPIO1_B1 toggles. With an LED connected between GPIO1_B1 and GND, you should see it blink.

### 4. Stop the M0 (optional)

To stop the firmware and release the M0:

```bash
echo stop > /sys/class/remoteproc/$RPROC/state
```

!!! warning "No hot-swap"
    Once the M0 is running, the SRAM at 0xFFF84000 is in use and cannot be overwritten by Linux until the M0 is stopped or the system is rebooted. To run a new or modified firmware, stop the remoteproc, (optionally) replace the ELF file, set the `firmware` attribute again, then `echo start` again. A full reboot is also a reliable way to load a new image.

## Pin and register reference

| Item | Value |
|------|--------|
| **Pin** | GPIO1_B1 (global GPIO #41: bank 1, group B, pin 1) |
| **GPIO1 base** | 0xFF870000 (from RK3506 device tree) |
| **M0 load address** | 0xFFF84000 (SRAM window used by rk3506-mcu) |

The firmware sets GPIO1_B1 as output and toggles it in a loop with a software delay; blink rate is approximate and depends on M0 clock.

## Troubleshooting

| Symptom | What to check |
|--------|----------------|
| No `/sys/class/remoteproc/remoteproc0` | rk3506-mcu remoteproc driver not loaded or not enabled in device tree. Build and install the driver from [rk3506-mcu](https://github.com/nvitya/rk3506-mcu). |
| `echo start` fails or M0 doesn’t run | Check `dmesg` for remoteproc errors. Ensure the ELF is built for 0xFFF84000 (linker script in [Calculinux/m0-example](https://github.com/Calculinux/m0-example) uses this). |
| LED does not blink | GPIO1 may need its clock enabled; the kernel often leaves GPIO1 clock on. Confirm the pin is not used by another function (e.g. UART or LCD) in the device tree. On PicoCalc, verify you’re using GPIO1_B1 and GND on the correct header pins. |
| Want to change blink rate | Edit the `delay(...)` argument in `main.c` in [Calculinux/m0-example](https://github.com/Calculinux/m0-example), rebuild, and redeploy; then stop/start remoteproc (or reboot) and load the new ELF. |

## References

- **[nvitya/rk3506-mcu](https://github.com/nvitya/rk3506-mcu)** – Remote processor driver for RK3506, loading at 0xFFF84000, start/stop/restart via sysfs.
- **Calculinux/m0-example** – [github.com/Calculinux/m0-example](https://github.com/Calculinux/m0-example): bare-metal blink firmware (main.c, startup.c, linker.ld, Makefile) for GPIO1_B1.
- **Luckfox AMP** – Alternative approach: build an AMP image where U-Boot loads the M0 firmware from flash; see Luckfox SDK and `rk3506g_buildroot_spinand_amp_defconfig` if you prefer that over remoteproc.
