# Package Management

Calculinux uses `opkg` (Open Package Management) for installing, updating, and removing software packages.

## Understanding Package Feeds

Calculinux packages are hosted on package feeds at `https://opkg.calculinux.org/`. **Your system is automatically configured to use the appropriate feed based on your installed version.** You typically don't need to modify the feed configuration.

### Feed Types

**Continuous Feed**: Rolling release packages with the latest updates
- URL format: `https://opkg.calculinux.org/ipk/{codename}/continuous/`
- Updated automatically as changes are made
- Best for staying current with development
- May include experimental features
- Used by main and develop branch builds

**Release Feed**: Stable versioned packages
- URL format: `https://opkg.calculinux.org/ipk/{codename}/release/`
- Locked to specific release versions
- Thoroughly tested before release
- Recommended for production use
- Used by tagged releases (e.g., v1.0.0)

### Which Feed Am I Using?

Check your current feed configuration:

```bash
cat /etc/opkg/base-feeds.conf
```

Example output for a continuous build:
```
src/gz all https://opkg.calculinux.org/ipk/walnascar/continuous/all
src/gz cortexa7t2hf-neon-vfpv4 https://opkg.calculinux.org/ipk/walnascar/continuous/cortexa7t2hf-neon-vfpv4
src/gz luckfox_lyra https://opkg.calculinux.org/ipk/walnascar/continuous/luckfox_lyra
```

The feed configuration is set during the image build process and matches the image type:
- Images from `main` branch → `walnascar/continuous` feed
- Images from `develop` branch → `develop/continuous` feed  
- Images from tagged releases → `walnascar/release` feed

## Basic Commands

### Updating Package Lists

Before installing or updating packages, refresh the package list:

```bash
opkg update
```

### Installing Packages

Install a package:

```bash
opkg install <package-name>
```

Example:
```bash
opkg install vim
```

### Removing Packages

Remove a package:

```bash
opkg remove <package-name>
```

Remove a package and its configuration files:

```bash
opkg remove --force-removal-of-dependent-packages <package-name>
```

### Searching for Packages

Search for available packages:

```bash
opkg list | grep <search-term>
```

Example:
```bash
opkg list | grep python
```

Search for installed packages:

```bash
opkg list-installed | grep <search-term>
```

### Viewing Package Information

Get information about a package:

```bash
opkg info <package-name>
```

List files in an installed package:

```bash
opkg files <package-name>
```

### Updating Packages

Update all installed packages:

```bash
opkg update
opkg upgrade
```

Update a specific package:

```bash
opkg update
opkg upgrade <package-name>
```

## Advanced Usage

### Installing from a File

Install a `.ipk` package file directly:

```bash
opkg install /path/to/package.ipk
```

### Listing Available Packages

List all available packages:

```bash
opkg list
```

List all installed packages:

```bash
opkg list-installed
```

List upgradeable packages:

```bash
opkg list-upgradable
```

### Finding Which Package Provides a File

```bash
opkg search <filename>
```

Example:
```bash
opkg search /usr/bin/python3
```

### Package Dependencies

View package dependencies:

```bash
opkg depends <package-name>
```

View reverse dependencies (what depends on this package):

```bash
opkg whatdepends <package-name>
```

## Feed Configuration

!!! info "Automatic Configuration"
    **Package feeds are automatically configured during image creation.** You typically don't need to change feed configuration unless you're testing different package versions or have specific advanced requirements.

### Switching Feeds (Advanced)

!!! warning "Advanced Users Only"
    Switching feeds may cause package version conflicts and is only recommended for testing or specific use cases. Most users should use the pre-configured feed that came with their image.

To switch from continuous to release feed, edit `/etc/opkg/base-feeds.conf`:

```bash
# Backup current configuration
cp /etc/opkg/base-feeds.conf /etc/opkg/base-feeds.conf.backup

# Edit feed URLs
vi /etc/opkg/base-feeds.conf
```

Change `continuous` to `release` in all URLs (or vice versa):

```
src/gz all https://opkg.calculinux.org/ipk/walnascar/release/all
src/gz cortexa7t2hf-neon-vfpv4 https://opkg.calculinux.org/ipk/walnascar/release/cortexa7t2hf-neon-vfpv4
src/gz luckfox_lyra https://opkg.calculinux.org/ipk/walnascar/release/luckfox_lyra
```

Then update:

```bash
opkg update
```

!!! note "Persistence"
    Changes to `/etc/opkg/base-feeds.conf` persist across reboots because Calculinux uses overlayfs - your changes are stored in the upper (writable) layer.

### Adding Custom Feeds

To add a custom package feed:

```bash
echo "src/gz custom-feed https://example.com/ipk/all" >> /etc/opkg/custom-feeds.conf
opkg update
```

### Development vs. Stable Codenames

Different Calculinux versions use different distribution codenames in their feed URLs:

- **walnascar**: Stable releases and main branch continuous builds
  - Example: `https://opkg.calculinux.org/ipk/walnascar/continuous/`
  - Example: `https://opkg.calculinux.org/ipk/walnascar/release/`
  
- **develop**: Development branch builds (bleeding-edge features)
  - Example: `https://opkg.calculinux.org/ipk/develop/continuous/`

!!! warning "Codename Compatibility"
    Switching between different codenames (e.g., `walnascar` ↔ `develop`) may cause significant package compatibility issues. This is **not recommended** except for advanced testing scenarios. If you want bleeding-edge packages, it's better to flash a new develop branch image rather than switching feeds.

## Common Tasks

### Installing Development Tools

```bash
opkg update
opkg install gcc g++ make git
```

### Installing Python Packages

```bash
opkg update
opkg install python3 python3-pip
```

### Installing Networking Tools

```bash
opkg update
opkg install curl wget netcat iproute2
```

### Cleaning Package Cache

Free up disk space by removing downloaded package files:

```bash
rm -rf /var/cache/opkg/*
```

## Troubleshooting

### Package Installation Fails

If a package fails to install:

1. Update package lists:
   ```bash
   opkg update
   ```

2. Check available space:
   ```bash
   df -h
   ```

3. Check error message for missing dependencies:
   ```bash
   opkg install --force-depends <package-name>
   ```

### Repository Connection Issues

If you can't connect to the package feeds:

1. Check network connectivity:
   ```bash
   ping opkg.calculinux.org
   ```

2. Verify feed URLs:
   ```bash
   cat /etc/opkg/base-feeds.conf
   ```

3. Try updating manually:
   ```bash
   opkg update --verbosity=3
   ```

### Version Conflicts

If you encounter version conflicts:

```bash
# Force reinstallation
opkg install --force-reinstall <package-name>

# Force downgrade
opkg install --force-downgrade <package-name>
```

### Broken Packages

To fix broken package installations:

```bash
# Remove partially installed package
opkg remove --force-remove <package-name>

# Reinstall
opkg update
opkg install <package-name>
```

## Package Feed Structure

Calculinux package feeds are organized by architecture:

- **all**: Architecture-independent packages
- **cortexa7t2hf-neon-vfpv4**: ARM Cortex-A7 optimized packages
- **luckfox_lyra**: Board-specific packages for Luckfox Lyra

Your system automatically uses packages from all relevant feeds.

## Best Practices

1. **Always update before installing**: Run `opkg update` before `opkg install`
2. **Regular updates**: Keep your system updated with `opkg update && opkg upgrade`
3. **Check dependencies**: Use `opkg info` to check dependencies before installing
4. **Backup configurations**: Keep backups of important config files before major updates
5. **Use stable feeds for production**: Stick to release feeds for production devices
6. **Test on continuous feeds**: Use continuous feeds for testing new features

## Comparison with Other Package Managers

If you're coming from other Linux distributions:

| Opkg | APT (Debian/Ubuntu) | DNF (Fedora) |
|------|---------------------|--------------|
| `opkg update` | `apt update` | `dnf check-update` |
| `opkg install` | `apt install` | `dnf install` |
| `opkg remove` | `apt remove` | `dnf remove` |
| `opkg list` | `apt list` | `dnf list` |
| `opkg upgrade` | `apt upgrade` | `dnf upgrade` |

## See Also

- [System Configuration](configuration.md) - Configure your system
- [Updates](updates.md) - System update procedures
- [Building Calculinux](../developer/building.md) - Build configuration and feeds
- [Adding Packages](../developer/adding-packages.md) - Create your own packages
