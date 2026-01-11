# Boot Problems

Detailed troubleshooting for boot-related issues.

## System Won't Boot

_This section will be populated with detailed boot troubleshooting steps._

### SPI NAND Interference

Some Luckfox Lyra boards include SPI NAND flash memory. The RK3506G2 boot ROM
**always tries NAND first**, so if your board has NAND with any firmware on it,
the boot ROM will ignore your SD card completely.

**Quick Check:**

- Lyra models with "SPI NAND" or "Lyra B" or "Lyra Plus" have NAND
- Check your purchase specifications
- If unsure, try booting - if SD card is ignored, you likely have NAND

**Solution:** You must erase the SPI NAND flash. See the comprehensive
**[SPI NAND Erase Guide](erase-nand.md)** for detailed step-by-step instructions
covering:

- Windows method (RKDevTool)
- Linux method (upgrade_tool)
- MaskRom mode recovery
- Troubleshooting failed erases

!!! danger "Critical: Data Loss" Erasing SPI NAND will **permanently delete all
data** on the NAND flash. This cannot be undone. Ensure you understand the
implications before proceeding.

!!! info "More Information" - **Complete Erase Guide**:
[SPI NAND Erase Guide](erase-nand.md) - **Boot Priority Details**:
[Hardware Specifications - Boot Priority](../hardware/specifications.md#boot-priority) -
**Luckfox Official Docs**:
[wiki.luckfox.com/Luckfox-Lyra/Image-flashing](https://wiki.luckfox.com/Luckfox-Lyra/Image-flashing/)

### Hardware Issues

_Hardware-related boot problems and solutions._

### SD Card Issues

_SD card related boot problems._

---

_This page is under development and will be populated with detailed
troubleshooting information._
