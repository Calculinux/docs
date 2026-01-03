# Applications

!!! warning "Under Construction"
    This page is currently being developed. Check back soon for application guides.

## Available Applications

For now, please refer to:

- [Package Management](package-management.md) - How to install applications
- [Quick Start Guide](../getting-started/quick-start.md) - Getting started with the system

## Installing new applications
Calculinux uses **opkg** (Open Package Management) as the package manager. Below, you will find a basic guide on how to install applications using opkg:
    
    opkg update
    opkg install package_name
This, first checks the main package list by using *opkg update* to see if any new packages have been added or if any existing packages have been updated. Then, the *opkg install package_name* command will make opkg look for *package_name* in the list of available packages, and attempt to install it, if all dependancies are available.

When you try to install a package using opkg without all the required dependencies, you may see an error message like *pkg_hash_check_unresolved: cannot find dependency <dependency_name> for <package_name>.* This indicates that the installation cannot proceed because the necessary dependencies are missing.

##### A dependency for a package in linux, is another package required for it to function properly or install successfully.

### Common opkg Package Installation Options
| Option                | Description                                                                                                                                               |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| **-k**                | This option is used to skip the integrity check of the packages during installation. It's helpful when dealing with local packages where you trust the source. |
| **-l**                | This option lists all available packages. It can be used to view a summary of packages that can be installed, updated, or removed.                       |
| **--force-reinstall** | Forces the reinstallation of a package even if it's already installed. Useful for ensuring that you have the latest version of a package.                  |
| **--no-cache**        | Disables caching during the installation process. This is useful when you want to ensure that the installation process always retrieves packages directly from the repository, rather than a local cache. |
| **-d**                | This option allows for installing a package without dependencies. Use this with caution, as it might lead to an unstable configuration.                      |
| **--dest**            | Specifies an alternate installation destination. This can be handy if you want to install a package in a specific location on your filesystem.            |

### Example Usage of opkg Package Installation Options/Arguements
```opkg
opkg install -k package-name
opkg list-installed
opkg list-installed | grep <package-name> # Searches Filter
opkg install --force-reinstall package-name
opkg install --no-cache package-name
opkg install -d package-name
opkg install --dest /desired/path package-name
```
If you want to refer to the lust of all available packages please refer to: [Available Packages](https://opkg.calculinux.org/ipk/walnascar/continuous/cortexa7t2hf-neon-vfpv4/)

## Coming Soon

This section will cover:

- Pre-installed applications
- Popular application recommendations
- Application configuration
- Troubleshooting applications

---

*Content planned for future release*
