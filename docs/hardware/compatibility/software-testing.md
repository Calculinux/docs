# Software & Testing Compatibility

## Software Compatibility

!!! info "Console-Only System"
    Calculinux is currently a **console-only** system with no graphical desktop environment. All interaction is via text terminal. This is by design to maximize performance on limited hardware (128 MB RAM).

### Console Applications

All console applications work well with the 128 MB RAM configuration:

| Application Type | Status | Notes |
|------------------|--------|-------|
| **Terminal Apps** | ✅ Fully Supported | All work well |
| **Text Editor (vim/nano)** | ✅ Fully Supported | All work well |
| **Scripting (Python/Bash)** | ✅ Fully Supported | All work well |
| **Development Tools** | ✅ Fully Supported | All work well |
| **Command-line Tools** | ✅ Fully Supported | All work well |

### Gaming and Entertainment (Community Tested)

!!! info "Community Testing Results"
    These applications have been tested by community members but may not be included in official Calculinux images.

| Application | Status | Notes |
|-------------|--------|-------|
| **Pico-8** | ✅ Working | Runs smoothly, audio requires hardware mod |
| **Doom (prboom)** | ✅ Working | Good performance, tested extensively |
| **RetroArch** | ⚠️ Issues | Has configuration problems |
| **tmux** | ✅ Working | Terminal multiplexer works well |
| **Framebuffer apps** | ✅ Working | FBV image viewer confirmed working |

!!! note "Gaming Performance"
    Gaming applications work but are limited by SPI display bandwidth. Not all emulators perform well due to hardware constraints.

## Testing Status

### Tested Configurations

| Configuration | Test Date | Status |
|--------------|-----------|--------|
| Lyra 128MB + 64GB SD | Mar 2025 | ✅ Working |

### Known Issues

| Issue | Affected Hardware | Status | Workaround |
|-------|------------------|--------|------------|
| SPI NAND Boot | Lyra with NAND | ✅ Documented | Erase NAND first |
| Slow SD Cards | External SD card | ⚠️ Known | Use internal storage for demanding tasks |

## Community Testing

We need community help testing various hardware combinations!

### Untested Configurations

Help us test these combinations:

- [ ] Different SD card brands (though performance differences are likely minimal)
- [ ] Various applications (request inclusion!)
- [ ] Luckfox Lyra Plus (Ethernet model) with custom backplate

### How to Report

If you test a configuration:

1. Open an issue on [GitHub](https://github.com/Calculinux/meta-calculinux/issues)
2. Include:
   - Hardware model and version
   - SD card brand and size
   - Any peripherals connected
   - What works / doesn't work
3. Use the "Hardware Compatibility Report" template

## Future Hardware Support

### Planned

- **Milk-V Duo**: Similar form factor, RISC-V processor
- **Custom Carrier Boards**: Community-designed alternatives

### Under Consideration

- **Pine64 Ox64**: RISC-V option
- **Raspberry Pi alternatives**: If form factor matches

## Next Steps

- Review [Hardware Requirements](../../getting-started/hardware-requirements.md)
- Check [Luckfox Lyra details](../luckfox-lyra.md)
- See [Hardware Modifications](../modifications.md) guide
