# Boot Problems

Detailed troubleshooting for boot-related issues.

## System Won't Boot

*This section will be populated with detailed boot troubleshooting steps.*

### SPI NAND Interference

Some Luckfox Lyra boards come with SPI NAND flash memory pre-installed. If your board has SPI NAND, you **must erase it first** or the board will attempt to boot from NAND instead of the SD card.

**To check if your board has SPI NAND:**
- Look for additional chip markings on the board
- Check your purchase order/specifications
- Lyra B and Lyra Plus models have 256MB SPI NAND

**To erase SPI NAND:**

See the comprehensive [SPI NAND Erase Guide](erase-nand.md) for detailed step-by-step instructions.

**Quick Summary:**
1. Download RKDevTool and drivers from the [official Luckfox documentation](https://wiki.luckfox.com/Luckfox-Lyra/Image-flashing/)
2. Enter Loader Mode (hold BOOT button while connecting USB)
3. Use RKDevTool to erase the flash
4. Insert Calculinux SD card and boot

!!! danger "Critical Warning: SPI NAND Erase"
    **IMPORTANT**: Erasing SPI NAND will permanently remove any existing firmware or data stored on the NAND flash. This process cannot be undone. Make sure you understand the implications before proceeding.
    
    **Data Loss**: All data on the SPI NAND will be permanently lost.
    
    **Recovery**: If you need to restore original firmware later, you'll need the original firmware files from the manufacturer
    or built from the SDK.

!!! warning "Linux-based NAND Erase Methods"
    Methods for erasing SPI NAND directly from Linux (without using external flashing tools) are not yet documented. Currently, the recommended approach is to use the official Luckfox flashing tools on a separate computer.

!!! info "Additional Resources"
    For detailed NAND erase procedures and troubleshooting, refer to:
    
    - **Calculinux Guide**: [SPI NAND Erase Guide](erase-nand.md)
    - **Official Luckfox Documentation**: [wiki.luckfox.com/Luckfox-Lyra/Image-flashing](https://wiki.luckfox.com/Luckfox-Lyra/Image-flashing/)

### Hardware Issues

*Hardware-related boot problems and solutions.*

### SD Card Issues

*SD card related boot problems.*

---

*This page is under development and will be populated with detailed troubleshooting information.*