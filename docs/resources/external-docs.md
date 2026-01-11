# External Documentation & Resources

This page provides links to external documentation, resources, and references
that are helpful for working with Calculinux, the PicoCalc, and related
technologies.

## Official Project Resources

### Calculinux

| Resource            | URL                                                                                    | Description                  |
| ------------------- | -------------------------------------------------------------------------------------- | ---------------------------- |
| **Main Repository** | [github.com/Calculinux/meta-calculinux](https://github.com/Calculinux/meta-calculinux) | Yocto layer and build system |
| **Documentation**   | [github.com/Calculinux/docs](https://github.com/Calculinux/docs)                       | This documentation source    |
| **Meta Layer**      | [github.com/Calculinux/meta-calculinux](https://github.com/Calculinux/meta-calculinux) | Main Yocto meta-layer        |

### ClockworkPi / PicoCalc

| Resource             | URL                                                                                | Description              |
| -------------------- | ---------------------------------------------------------------------------------- | ------------------------ |
| **Official Website** | [clockworkpi.com](https://www.clockworkpi.com/)                                    | Manufacturer website     |
| **PicoCalc Forum**   | [forum.clockworkpi.com/c/picocalc/31](https://forum.clockworkpi.com/c/picocalc/31) | Official forum category  |
| **Luckfox Thread**   | [forum thread](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280)     | Original port discussion |

### Luckfox

| Resource             | URL                                                                                | Description              |
| -------------------- | ---------------------------------------------------------------------------------- | ------------------------ |
| **Official Website** | [luckfox.com](https://www.luckfox.com/)                                            | Manufacturer website     |
| **Pico SDK**         | [github.com/LuckfoxTECH/luckfox-pico](https://github.com/LuckfoxTECH/luckfox-pico) | Official SDK (Buildroot) |
| **Wiki**             | [wiki.luckfox.com](https://wiki.luckfox.com/)                                      | Documentation            |

## Build System Documentation

### Yocto Project

| Resource          | URL                                                                                | Description            |
| ----------------- | ---------------------------------------------------------------------------------- | ---------------------- |
| **Main Website**  | [yoctoproject.org](https://www.yoctoproject.org/)                                  | Official Yocto site    |
| **Documentation** | [docs.yoctoproject.org](https://docs.yoctoproject.org/)                            | Complete documentation |
| **Quick Start**   | [Quick Build Guide](https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html) | Getting started        |
| **Mega-Manual**   | [Mega-Manual](https://docs.yoctoproject.org/singleindex.html)                      | All-in-one reference   |
| **Dev Manual**    | [Developer Manual](https://docs.yoctoproject.org/dev-manual/)                      | Development guide      |
| **Kernel Manual** | [Kernel Dev Manual](https://docs.yoctoproject.org/kernel-dev/)                     | Kernel development     |
| **Board Support** | [BSP Guide](https://docs.yoctoproject.org/bsp-guide/)                              | BSP creation           |

### OpenEmbedded

| Resource         | URL                                                              | Description         |
| ---------------- | ---------------------------------------------------------------- | ------------------- |
| **Main Website** | [openembedded.org](https://www.openembedded.org/)                | Project homepage    |
| **Layer Index**  | [layers.openembedded.org](https://layers.openembedded.org/)      | Find layers/recipes |
| **User Manual**  | [OE User Manual](https://docs.yoctoproject.org/overview-manual/) | Usage guide         |

### BitBake

| Resource             | URL                                                                                                             | Description       |
| -------------------- | --------------------------------------------------------------------------------------------------------------- | ----------------- |
| **Documentation**    | [BitBake Manual](https://docs.yoctoproject.org/bitbake/)                                                        | Build engine docs |
| **Syntax Reference** | [Syntax Guide](https://docs.yoctoproject.org/bitbake/2.0/bitbake-user-manual/bitbake-user-manual-metadata.html) | Recipe syntax     |

## Hardware Documentation

### Rockchip RV1106

| Resource          | URL                                                            | Description                         |
| ----------------- | -------------------------------------------------------------- | ----------------------------------- |
| **SDK**           | [github.com/rockchip-linux](https://github.com/rockchip-linux) | Rockchip Linux repos                |
| **Kernel**        | [Rockchip Kernel](https://github.com/rockchip-linux/kernel)    | Kernel source                       |
| **Documentation** | Rockchip Wiki                                                  | Chip documentation (when available) |

### ARM Cortex-A7

| Resource             | URL                                                                          | Description             |
| -------------------- | ---------------------------------------------------------------------------- | ----------------------- |
| **ARM Developer**    | [developer.arm.com](https://developer.arm.com/Processors/Cortex-A7)          | Processor documentation |
| **Technical Manual** | [ARM Documentation](https://developer.arm.com/documentation/ddi0464/latest/) | TRM                     |

## Linux Kernel Resources

### General Linux Development

| Resource                 | URL                                                       | Description            |
| ------------------------ | --------------------------------------------------------- | ---------------------- |
| **Kernel.org**           | [kernel.org](https://www.kernel.org/)                     | Official kernel source |
| **Documentation**        | [kernel.org/doc](https://www.kernel.org/doc/html/latest/) | Kernel documentation   |
| **Device Tree**          | [devicetree.org](https://www.devicetree.org/)             | DT specification       |
| **Linux Driver Project** | [ldp.net](https://www.tldp.org/LDP/lkmpg/2.6/html/)       | Driver development     |

### ARM Linux

| Resource              | URL                                                                             | Description       |
| --------------------- | ------------------------------------------------------------------------------- | ----------------- |
| **ARM Linux**         | [arm.linux.org.uk](http://www.arm.linux.org.uk/)                                | ARM-specific info |
| **Device Tree Guide** | [DT for ARM](https://www.kernel.org/doc/Documentation/devicetree/bindings/arm/) | ARM DT bindings   |

## Display & Input

### SPI LCD (ST7789)

| Resource          | URL                                                        | Description              |
| ----------------- | ---------------------------------------------------------- | ------------------------ |
| **Datasheet**     | ST7789V Datasheet                                          | Display controller specs |
| **Linux Driver**  | [fbtft](https://github.com/notro/fbtft)                    | Framebuffer drivers      |
| **Documentation** | [Kernel fbdev](https://www.kernel.org/doc/html/latest/fb/) | Framebuffer docs         |

### Input Subsystem

| Resource        | URL                                                                                                         | Description     |
| --------------- | ----------------------------------------------------------------------------------------------------------- | --------------- |
| **Input Docs**  | [Kernel Input](https://www.kernel.org/doc/html/latest/input/)                                               | Input subsystem |
| **Event Codes** | [input-event-codes.h](https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h) | Key definitions |

## Development Tools

### Cross-Compilation

| Resource           | URL                                                                         | Description         |
| ------------------ | --------------------------------------------------------------------------- | ------------------- |
| **Crosstool-NG**   | [crosstool-ng.github.io](https://crosstool-ng.github.io/)                   | Toolchain builder   |
| **ARM Toolchains** | [ARM GNU](https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain) | Official toolchains |

### Debugging

| Resource      | URL                                                       | Description        |
| ------------- | --------------------------------------------------------- | ------------------ |
| **GDB**       | [gnu.org/software/gdb](https://www.gnu.org/software/gdb/) | GNU debugger       |
| **OpenOCD**   | [openocd.org](http://openocd.org/)                        | On-chip debugging  |
| **JTAG Info** | Various                                                   | Hardware debugging |

### Version Control

| Resource     | URL                                            | Description         |
| ------------ | ---------------------------------------------- | ------------------- |
| **Git**      | [git-scm.com](https://git-scm.com/)            | Version control     |
| **Git Book** | [Git Pro Book](https://git-scm.com/book/en/v2) | Comprehensive guide |

## Linux Distribution Resources

### Package Management

| Resource          | URL                                             | Description           |
| ----------------- | ----------------------------------------------- | --------------------- |
| **opkg**          | [opkg docs](https://git.yoctoproject.org/opkg/) | Package manager       |
| **Package Feeds** | Configured in Calculinux                        | Software repositories |

### System Management

| Resource         | URL                                                                  | Description     |
| ---------------- | -------------------------------------------------------------------- | --------------- |
| **systemd**      | [systemd.io](https://systemd.io/)                                    | Init system     |
| **systemd Docs** | [freedesktop.org](https://www.freedesktop.org/software/systemd/man/) | Complete manual |

## Desktop Environments

!!! note "Future Feature" Desktop environments are not currently implemented in
Calculinux. These resources are provided for future reference if GUI support is
added.

### Lightweight Options

| Resource    | URL                                | Description              |
| ----------- | ---------------------------------- | ------------------------ |
| **LXDE**    | [lxde.org](https://www.lxde.org/)  | Lightweight desktop      |
| **XFCE**    | [xfce.org](https://www.xfce.org/)  | Feature-rich lightweight |
| **i3**      | [i3wm.org](https://i3wm.org/)      | Tiling window manager    |
| **Openbox** | [openbox.org](http://openbox.org/) | Minimal WM               |

### Display Servers

| Resource    | URL                                                         | Description             |
| ----------- | ----------------------------------------------------------- | ----------------------- |
| **X.Org**   | [x.org](https://www.x.org/)                                 | X11 server              |
| **Wayland** | [wayland.freedesktop.org](https://wayland.freedesktop.org/) | Modern display protocol |

## Programming Languages

### C/C++

| Resource          | URL                                              | Description        |
| ----------------- | ------------------------------------------------ | ------------------ |
| **GCC**           | [gcc.gnu.org](https://gcc.gnu.org/)              | GNU compiler       |
| **C++ Reference** | [cppreference.com](https://en.cppreference.com/) | Language reference |

### Python

| Resource       | URL                                   | Description     |
| -------------- | ------------------------------------- | --------------- |
| **Python.org** | [python.org](https://www.python.org/) | Official Python |
| **PyPI**       | [pypi.org](https://pypi.org/)         | Package index   |

### Shell Scripting

| Resource       | URL                                                                | Description     |
| -------------- | ------------------------------------------------------------------ | --------------- |
| **Bash Guide** | [gnu.org/software/bash](https://www.gnu.org/software/bash/manual/) | Bash manual     |
| **ShellCheck** | [shellcheck.net](https://www.shellcheck.net/)                      | Script analysis |

## Community & Learning

### Forums & Discussion

| Resource                | URL                                                                   | Description     |
| ----------------------- | --------------------------------------------------------------------- | --------------- |
| **ClockworkPi Forum**   | [forum.clockworkpi.com](https://forum.clockworkpi.com/)               | Official forums |
| **Yocto Mailing Lists** | [yoctoproject.org/community](https://www.yoctoproject.org/community/) | Yocto community |
| **Stack Overflow**      | [stackoverflow.com](https://stackoverflow.com/)                       | Q&A site        |
| **Reddit /r/embedded**  | [reddit.com/r/embedded](https://www.reddit.com/r/embedded/)           | Embedded Linux  |

### Learning Resources

| Resource                | URL                                                       | Description             |
| ----------------------- | --------------------------------------------------------- | ----------------------- |
| **Linux From Scratch**  | [linuxfromscratch.org](https://www.linuxfromscratch.org/) | Build Linux from source |
| **Embedded Linux Wiki** | [elinux.org](https://elinux.org/)                         | Embedded Linux info     |
| **Free Electrons**      | [bootlin.com](https://bootlin.com/docs/)                  | Training materials      |

### Video Tutorials

| Resource           | URL                                                                | Description           |
| ------------------ | ------------------------------------------------------------------ | --------------------- |
| **YouTube Search** | "Yocto Project Tutorial"                                           | Video tutorials       |
| **YouTube Search** | "Embedded Linux"                                                   | General embedded info |
| **Original Video** | [Luckfox on PicoCalc](https://www.youtube.com/watch?v=DaVv7h8cKAE) | Hardware demo         |

## Datasheets & Specifications

### Obtaining Datasheets

Many datasheets require registration or NDA:

- **Rockchip**: Contact for RV1106 documentation
- **LCD Controllers**: Search by part number
- **Component Vendors**: Check manufacturer websites

### Useful Specifications

| Specification | Description                          |
| ------------- | ------------------------------------ |
| **SPI**       | Serial Peripheral Interface standard |
| **I2C**       | Inter-Integrated Circuit bus         |
| **USB 2.0**   | USB specification                    |
| **MIPI CSI**  | Camera Serial Interface              |

## Related Projects

### Similar Devices

| Project        | URL         | Description             |
| -------------- | ----------- | ----------------------- |
| **PocketCHIP** | Archived    | Similar pocket computer |
| **GameShell**  | ClockworkPi | Gaming handheld         |
| **DevTerm**    | ClockworkPi | Portable terminal       |

### Embedded Linux Distributions

| Distribution        | URL                                                      | Focus              |
| ------------------- | -------------------------------------------------------- | ------------------ |
| **Buildroot**       | [buildroot.org](https://buildroot.org/)                  | Lightweight builds |
| **OpenWrt**         | [openwrt.org](https://openwrt.org/)                      | Router focus       |
| **Raspberry Pi OS** | [raspberrypi.com](https://www.raspberrypi.com/software/) | RPi optimized      |

## Books

### Recommended Reading

**Embedded Linux**:

- "Mastering Embedded Linux Programming" - Chris Simmonds
- "Embedded Linux Primer" - Christopher Hallinan
- "Building Embedded Linux Systems" - Karim Yaghmour

**Yocto/OpenEmbedded**:

- "Embedded Linux Development Using Yocto Project" - Otavio Salvador
- "Yocto for Raspberry Pi" - Pierre-Jean Texier

**Kernel Development**:

- "Linux Device Drivers" - Corbet, Rubini, Kroah-Hartman
- "Linux Kernel Development" - Robert Love

**General Linux**:

- "The Linux Command Line" - William Shotts
- "How Linux Works" - Brian Ward

## Online Courses

### Free Courses

- **Yocto Project Training** (bootlin.com)
- **Embedded Linux Courses** (various MOOCs)
- **ARM University Program** (free materials)

### Paid Courses

- Linux Foundation courses
- Udemy embedded Linux courses
- Professional training companies

## Tools & Utilities

### Online Tools

| Tool                     | URL                                           | Purpose         |
| ------------------------ | --------------------------------------------- | --------------- |
| **Device Tree Compiler** | [devicetree.org](https://www.devicetree.org/) | DT compilation  |
| **Regex Tester**         | [regex101.com](https://regex101.com/)         | Pattern testing |
| **Color Picker**         | Various                                       | GUI development |

### Software Tools

- **Etcher**: [balena.io/etcher](https://www.balena.io/etcher/) - Image flashing
- **PuTTY**: [putty.org](https://www.putty.org/) - Serial terminal
- **VS Code**: [code.visualstudio.com](https://code.visualstudio.com/) - Editor

## Standards & Specifications

| Standard  | Organization     | Relevance            |
| --------- | ---------------- | -------------------- |
| **POSIX** | IEEE             | Unix standards       |
| **FHS**   | Linux Foundation | Filesystem hierarchy |
| **LSB**   | Linux Foundation | Linux standards      |

## Contributing Resources

See [Contributing Guide](../developer/contributing.md) for Calculinux-specific
guidelines.

### General Open Source

| Resource              | URL                                           | Description         |
| --------------------- | --------------------------------------------- | ------------------- |
| **Open Source Guide** | [opensource.guide](https://opensource.guide/) | Contributing basics |
| **How to Contribute** | GitHub guides                                 | PR workflow         |
| **Code of Conduct**   | Various                                       | Community standards |

## Stay Updated

### News Sources

- **Phoronix** - Linux hardware news
- **LWN.net** - Linux Weekly News
- **Hacker News** - Tech discussions
- **r/linux** - Linux subreddit

### Blogs

- Yocto Project Blog
- ClockworkPi Blog
- Embedded Linux blogs (various)

## Need More Help?

Can't find what you're looking for?

1. Check our [Troubleshooting](../troubleshooting/faq.md) section
2. Search the
   [Forum](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280)
3. Ask in [Community Chat](community.md)
4. Open a [Documentation Issue](https://github.com/Calculinux/docs/issues)

## Contributing to This List

Found a useful resource not listed here?

- Submit a pull request to add it
- Open an issue with the suggestion
- Post in the forum

---

_Last updated: October 2025_
