# Troubleshooting & FAQ

Common issues and frequently asked questions about Calculinux.

## Need troubleshooting?

Start with these guides:

- [Basic Troubleshooting](basic-troubleshooting.md)
- [Common Issues](common-issues.md)
- [Network Issues](network.md)
- [Erasing SPI NAND](erase-nand.md)

## Frequently Asked Questions

### General Questions

**Q: What is Calculinux?**

A: Calculinux is a Linux distribution built specifically for the PicoCalc handheld computer when equipped with a Luckfox Lyra or compatible SBC. It provides a full Linux environment in a pocket-sized device.

**Q: Is this the same as the stock PicoCalc firmware?**

A: No. The stock PicoCalc uses a Raspberry Pi Pico running **PicoMite MMBasic** firmware. Calculinux requires replacing this with a Luckfox Lyra SBC to run full Linux.

**Q: Will this void my warranty?**

A: No. The PicoCalc is designed with an interchangeable microcontroller in mind. That said, this project is **not** officially sanctioned by ClockworkPi. Proceed at your own risk.

**Q: Can I revert to the original firmware?**

A: Yes, if you kept the original RP2040 board. Simply reinstall it and reflash the original firmware.

### Hardware Questions

**Q: Which Luckfox Lyra version should I buy?**

A: The 128MB version without SPI NAND is recommended for simplicity. The SPI NAND versions work but require an extra NAND erasing step. The SPI NAND could be useful in the future, however.

**Q: What size SD card do I need?**

A: Minimum 8GB, but 16GB,32GB, or larger is recommended for comfortable use.

**Q: Does it work with other SBCs?**

A: Currently only Luckfox Lyra B is officially supported. Milk-V Duo support is planned. Other boards may work with community modifications.

**Q: Can I use WiFi?**

A: Not built-in, but USB WiFi adapters should work (requires testing). USB Ethernet adapters are confirmed working.

**Q: How long does the battery last?**

A: Battery life is less than stock firmware due to running full Linux. Expect 4-6 hours depending on usage. External USB battery packs work well, and you can always swap batteries.

### Software Questions

**Q: Can I install regular Linux software?**

A: Yes, using the opkg package manager. Many standard Linux packages are available, though some may not work well on the small display or with limited RAM. We are still building up the software library - if the application you're looking for is not present please request it!

**Q: Can I run a graphical desktop?**

A: Yes, lightweight desktop environments like LXDE work on 128MB+ systems. Full desktops like GNOME/KDE are too heavy. No significant effort has been taken yet to build or install these desktops, however.

**Q: Can I run Python/C/other languages?**

A: Yes, development tools including Python, GCC, and other compilers are available.

**Q: Can I browse the web?**

A: Text-mode browsers (lynx, w3m) work well. Graphical browsers require 256MB+ RAM and are slow on the small display.

**Q: How do I install more software?**

A: Use the opkg package manager:

```shell
opkg update
opkg install <package-name>
```

See [Package Management](../user-guide/package-management.md) for details.

### Build & Development Questions

**Q: How do I build Calculinux from source?**

A: Follow the [Developer Guide](../developer/overview.md), starting with [Yocto Setup](../developer/yocto-setup.md).

**Q: How long does a build take?**

A: First build: ~2 hours depending on your computer. Subsequent builds: much faster (minutes to an hour).

**Q: Can I contribute to Calculinux?**

A: Absolutely! See [Contributing Guide](../developer/contributing.md) for how to get involved.

**Q: Where is the source code?**

A: GitHub: [github.com/Calculinux](https://github.com/Calculinux)

### Troubleshooting Questions

**Q: Why won't my system boot from SD card?**

A: Most likely SPI NAND interference. If your Luckfox Lyra has SPI NAND, you must erase it first. See [Common Issues](common-issues.md#spi-nand-interference).

**Q: Why is my system so slow?**

A: Check RAM usage (`free -h`). With only 128MB, many applications will struggle. If you are trying to use a GUI, you may want to explore other lighter options.

**Q: Where can I get help?**

A:

1. Check this documentation
2. Join our [Discord Community](https://discord.gg/7quBbSPxcP)
3. Search the [Forum](https://forum.clockworkpi.com/t/luckfox-lyra-on-picocalc/16280)
4. Open a [GitHub issue](https://github.com/Calculinux/meta-calculinux/issues)

### Q: The display shows garbage/corruption

A: Try:

- Reducing SPI clock speed in device tree. The default should be stable, however.
- Reflashing SD card
- Testing with different SD card

---

*Can't find your issue? [Open a documentation issue](https://github.com/Calculinux/docs/issues) to request it be added!*
