# M0 Core Tutorial: Build, Load, and Use for Your Own Projects

The **RK3506** (used on the Luckfox Lyra and PicoCalc) includes a **Cortex-M0** coprocessor alongside the three Cortex-A7 cores. This tutorial walks you through building the example M0 firmware, loading it onto the M0 core, testing it, and adapting the project for your own bare-metal or real-time tasks.

## What is the M0 core and why use it?

The Cortex-M0 is a small, low-power ARM core that shares the SoC with the main Linux-running Cortex-A7 cores. Typical uses include:

- **Real-time or deterministic tasks** (e.g. precise timing, PWM, step generation) that are easier without Linux scheduling and interrupts
- **Low-latency I/O** such as bit-banging a protocol or driving a peripheral while Linux handles higher-level logic
- **Offloading** simple control loops (sensors, LEDs, motor control) so the A7 cores can focus on applications
- **Learning** bare-metal ARM programming and the RK3506 memory map

The M0 runs **bare-metal** code: no OS, no drivers. You program it like a classic microcontroller (registers, interrupts, tight loops). Linux loads the firmware into a dedicated SRAM region and starts or stops the M0 via the **remoteproc** subsystem.

!!! info "Driver and load address"
    Loading and starting the M0 is done via the [rk3506-mcu](https://github.com/nvitya/rk3506-mcu) remote processor driver. Firmware must be linked for the SRAM window at **0xFFF84000** (64 KB). The Calculinux/m0-example project is already set up for this.

## Prerequisites

### On your build machine (host)

- **ARM bare-metal toolchain**: `arm-none-eabi-gcc` and `arm-none-eabi-objcopy` in your PATH.
  - **Debian/Ubuntu:** `sudo apt install gcc-arm-none-eabi`
  - **Fedora:** `sudo dnf install arm-none-eabi-gcc`
- **Git** (to clone the example repo).

### On the device (PicoCalc / Luckfox Lyra running Calculinux)

- **rk3506-mcu remoteproc driver** loaded so that `/sys/class/remoteproc/remoteproc0` (or `remoteproc1`) exists. Calculinux images that include this driver provide the interface; otherwise build and install the driver from [rk3506-mcu/rk3506_rproc](https://github.com/nvitya/rk3506-mcu/tree/main/rk3506_rproc).
- **SSH or serial access** to run commands and copy files.

### Hardware (optional but recommended for the example)

- **LED and series resistor** (e.g. 330 Ω–1 kΩ) between **GPIO1_B1** and **GND** on the PicoCalc expansion header so you can see the blink. See your board pinout for the exact pin.

---

## Part 1: Build the M0 example firmware

The [Calculinux/m0-example](https://github.com/Calculinux/m0-example) repository contains a minimal project that blinks GPIO1_B1. Building it confirms your toolchain and produces the ELF file you will load onto the M0.

### Step 1: Clone the repository

```bash
git clone https://github.com/Calculinux/m0-example.git
cd m0-example
```

### Step 2: Build

```bash
make
```

You should see the compiler and linker run and no errors. The Makefile produces:

| Output | Description |
|--------|-------------|
| **`m0-gpio1_b1-blink.elf`** | ELF image with symbols and load addresses. This is what you give to remoteproc; the kernel loads segments into M0 SRAM. |
| **`m0-gpio1_b1-blink.bin`** | Raw binary at load address 0xFFF84000. Useful for flashing or other loaders; remoteproc uses the ELF. |

!!! tip "Clean build"
    To rebuild from scratch: `make clean && make`

### Step 3: Verify the ELF (optional)

Check that the program is linked for the correct load address:

```bash
arm-none-eabi-objdump -f m0-gpio1_b1-blink.elf
```

Look for `start address 0x...`; the code should start in the 0xFFF84000 region. The linker script in the repo enforces this.

---

## Part 2: Load the firmware into the M0 core

Loading is done on the **device** via the Linux remoteproc interface. You first copy the ELF to the device, then tell the driver which firmware to use and start the M0.

### Step 1: Copy the firmware to the device

From your **host** (in the `m0-example` directory):

```bash
scp m0-gpio1_b1-blink.elf root@<device-ip>:/lib/firmware/
```

Replace `<device-ip>` with your board’s IP or hostname. Using `/lib/firmware/` lets you reference the file by a short name when setting the `firmware` attribute; you can use another path if you prefer.

### Step 2: Find the remoteproc device

On the **device** (e.g. over SSH):

```bash
ls /sys/class/remoteproc/
```

You should see at least one directory such as `remoteproc0` (or `remoteproc1`). Use that name in the next steps. Set a variable for convenience:

```bash
RPROC=remoteproc0   # or remoteproc1, depending on your system
```

### Step 3: Load and start the M0

Run these commands **on the device**:

```bash
# Stop the M0 if it is already running (required before loading new firmware)
echo stop > /sys/class/remoteproc/$RPROC/state

# Tell the driver which firmware to load (path as on the device)
echo /lib/firmware/m0-gpio1_b1-blink.elf > /sys/class/remoteproc/$RPROC/firmware

# Start the M0; it will run the blink loop
echo start > /sys/class/remoteproc/$RPROC/state
```

If the driver and ELF are correct, the M0 starts executing. With an LED connected between **GPIO1_B1** and **GND**, you should see it blink at about 1–2 Hz.

### Step 4: Stop the M0 (when you want to unload or change firmware)

```bash
echo stop > /sys/class/remoteproc/$RPROC/state
```

!!! warning "No hot-swap of firmware"
    While the M0 is running, its SRAM (0xFFF84000) is in use. To run a different or updated firmware: stop the remoteproc, (optionally) replace the ELF on the device, set the `firmware` attribute again, then `echo start` again. A reboot also resets the M0 and allows loading a new image.

---

## Part 3: Test and verify

### Visual check

- **LED on GPIO1_B1:** If you connected an LED (with series resistor) between GPIO1_B1 and GND, it should blink. Blink rate is approximate and depends on M0 clock and the delay loop in the example.

### Check remoteproc state

On the device:

```bash
cat /sys/class/remoteproc/$RPROC/state
```

- `running` – M0 is executing your firmware.
- `stopped` – M0 is halted; you can load new firmware and start again.

### Check kernel messages

If something fails, check the kernel log:

```bash
dmesg | tail -30
```

Look for messages from the remoteproc driver (e.g. load address, start/stop, or errors).

---

## Part 4: Understand the project structure

Understanding the example helps you adapt it for your own code.

### Files in m0-example

| File | Purpose |
|------|---------|
| **`main.c`** | Application code: configures GPIO1_B1 as output and toggles it in a loop with a software delay. |
| **`startup.c`** | C runtime and interrupt setup: vector table, Reset_Handler (copies .data, zeros .bss, calls `main()`), and weak default handlers for exceptions. |
| **`linker.ld`** | Linker script: places code and data in the 64 KB M0 SRAM at 0xFFF84000, defines stack top and symbols used by startup. |
| **`Makefile`** | Builds with `arm-none-eabi-gcc`, produces `.elf` and `.bin`. |

### Memory layout (linker.ld)

- **RAM:** One region `mcu_ram` at **0xFFF84000**, length **64K**. All sections (`.isr_vector`, `.text`, `.rodata`, `.data`, `.bss`) go here. Stack grows down from the top of this region.
- **Load address:** The kernel (remoteproc) loads the ELF into this same address range. Do not change the origin address without aligning with the rk3506-mcu driver and kernel.

### Startup flow (startup.c)

1. On reset, the CPU uses the vector table (first word = initial stack pointer, second = Reset_Handler).
2. **Reset_Handler** copies `.data` from its load address to RAM, zeros `.bss`, then calls `main()`.
3. **main()** never returns in this example; if it did, the startup code would spin in an infinite loop.
4. Exceptions (NMI, HardFault, SVC, PendSV, SysTick) have weak default handlers that spin forever; you can override them in your code for interrupts or fault handling.

### GPIO in the example (main.c)

- **GPIO1 base address:** `0xFF870000` (from RK3506 documentation/device tree).
- **Registers used:** `GPIO_SWPORT_DDR` (direction) and `GPIO_SWPORT_DR` (data). One bit per pin; GPIO1_B1 is pin 9 in that bank.
- The code sets the pin as output and toggles it in a loop with `delay(2000000u)` to get roughly 1–2 Hz blink.

---

## Part 5: Use the M0 for your own purposes

You can use this project as a template for your own M0 firmware.

### Change the GPIO or add more pins

- **Different pin:** Look up the GPIO bank base and pin index for your pin (e.g. from RK3506 docs or device tree). In `main.c`, change `GPIO1_BASE` if you use another bank, and change the pin bit/mask (e.g. `GPIO1_PIN_B1_BIT` / `GPIO1_PIN_B1_MASK`) to match your pin.
- **Multiple pins:** Define more `*_BIT` and `*_MASK` constants and set direction and data bits for each. Be aware of pin multiplexing: the pin must not be claimed by another function in the device tree (e.g. UART, SPI).

### Add more logic

- **More C files:** Add them to `SRCS` in the Makefile and implement your logic in `main()` or in functions called from `main()`. Keep in mind you have 64 KB of RAM total; avoid large stacks and big global arrays.
- **Interrupts:** Implement the relevant exception handler in your code (e.g. override `SysTick_Handler` for a periodic tick, or add a vector and handler for a peripheral IRQ if the hardware and memory map support it). Ensure the vector table in `startup.c` includes the new handler.

### Change timing

- **Blink rate:** Change the argument to `delay(...)` in `main.c`; larger value = slower blink. Rebuild, copy the new ELF to the device, stop remoteproc, set `firmware`, then start again.
- **More precise timing:** For better accuracy you would typically use a timer and interrupts (e.g. SysTick or a hardware timer) instead of a busy-loop delay.

### Keep within resource limits

- **64 KB SRAM:** All code, data, and stack live in the 0xFFF84000 region. Use `-ffunction-sections -fdata-sections` and `--gc-sections` (already in the Makefile) to remove unused code/data. Monitor size with `arm-none-eabi-size m0-gpio1_b1-blink.elf`.
- **No standard library:** The project uses `-nostdlib` and `-ffreestanding`. You have no `malloc`, no `printf` to host. Use registers, globals, and simple loops; add minimal helpers (e.g. your own `putchar` over UART) if needed.

### Optional: Rename the target

If you create a different application (e.g. a different blink pin or a new project name), you can change the output name in the Makefile:

- Replace `m0-gpio1_b1-blink` with your target name in the `all` target and in the `.elf` / `.bin` rules.
- Copy and load the new `.elf` the same way; use the new path when writing to the `firmware` attribute.

---

## Pin and register reference (RK3506)

| Item | Value |
|------|--------|
| **Example pin** | GPIO1_B1 (global GPIO #41: bank 1, group B, pin 1) |
| **GPIO1 base** | 0xFF870000 |
| **M0 SRAM (load address)** | 0xFFF84000, 64 KB |
| **Direction register offset** | 0x04 (GPIO_SWPORT_DDR): 1 = output, 0 = input |
| **Data register offset** | 0x00 (GPIO_SWPORT_DR): read/write pin level |

Other GPIO banks have different base addresses; consult the RK3506 TRM or your board’s device tree.

---

## Troubleshooting

| Symptom | What to check |
|--------|----------------|
| **No `/sys/class/remoteproc/remoteproc0`** | rk3506-mcu remoteproc driver not loaded or not enabled in device tree. Build and install the driver from [rk3506-mcu](https://github.com/nvitya/rk3506-mcu). |
| **`echo start` fails or M0 doesn’t run** | Check `dmesg` for remoteproc errors. Ensure the ELF is built for 0xFFF84000 (the example’s linker script does this). |
| **LED does not blink** | GPIO1 may need its clock enabled (often left on by the kernel). Confirm the pin is not used by another function (UART, LCD, etc.) in the device tree. On PicoCalc, verify GPIO1_B1 and GND on the correct header pins and that the LED polarity and resistor are correct. |
| **Build fails: toolchain not found** | Install `gcc-arm-none-eabi` (and ensure `arm-none-eabi-gcc` is on your PATH). |
| **Want to change blink rate or behavior** | Edit `main.c` (and/or add files), run `make`, copy the new `.elf` to the device, then stop/start remoteproc (or reboot) and set `firmware` to the new file. |

---

## References

- **[Calculinux/m0-example](https://github.com/Calculinux/m0-example)** – Example M0 firmware (GPIO blink) used in this tutorial.
- **[nvitya/rk3506-mcu](https://github.com/nvitya/rk3506-mcu)** – Remote processor driver for RK3506; loads firmware at 0xFFF84000, start/stop via sysfs.
- **Testing the M0 Core (GPIO Blink)** – [Quick reference](m0-blink-test.md) for build and load steps.
- **Luckfox AMP** – Alternative: U-Boot can load M0 firmware from flash in an AMP setup (e.g. `rk3506g_buildroot_spinand_amp_defconfig`); see Luckfox SDK if you prefer that over remoteproc.
