# Quick Start Guide

Get up and running quickly with Calculinux basics.

## Essential Commands

### System Information

```shell
# System version
cat /etc/os-release

# Kernel version
uname -a

# Hardware info
cat /proc/cpuinfo
cat /proc/meminfo

# Disk usage
df -h

# Memory usage
free -h
```

### Package Management

```shell
# Update package list
opkg update

# Search for package
opkg find <name>

# Install package
opkg install <package>

# Remove package
opkg remove <package>

# List installed
opkg list-installed
```

### File Management

```shell
# Navigate directories
cd /path/to/directory
pwd  # Show current directory
ls -la  # List files

# Create/remove
mkdir dirname
rm filename
rm -r dirname

# Copy/move
cp source dest
mv source dest

# View files
cat filename
less filename
nano filename  # Edit
```

### System Management

```shell
# Reboot
reboot

# Shutdown
poweroff

# Check services
systemctl status
systemctl start <service>
systemctl stop <service>

# View logs
journalctl -f  # Follow logs
dmesg  # Kernel messages
```

## Common Tasks

### Connect to Network

```shell
# WiFi (USB adapter required)
uwific

# Ethernet (DHCP)
udhcpc -i eth0

# Check connection
ping 8.8.8.8
```

See the [WiFi guide](../user-guide/wifi.md) for keys and troubleshooting.

### Install Software

```shell
# Example: Install Python
opkg update
opkg install python3

# Example: Install text editor
opkg install vim
```

### Manage Files

```shell
# Create a file
echo "Hello World" > test.txt

# Edit a file
nano test.txt

# View a file
cat test.txt
```

### Monitor System

```shell
# Real-time process monitor
htop  # or top

# Disk usage by directory
du -h /home | sort -h

# Running processes
ps aux
```

## Development

### Python Example

```shell
# Create Python script
nano hello.py
```

```python
#!/usr/bin/env python3
print("Hello from Calculinux!")
```

```shell
# Make executable
chmod +x hello.py

# Run
./hello.py
```

### C Example

```shell
# Create C program
nano hello.c
```

```c
#include <stdio.h>

int main() {
    printf("Hello from Calculinux!\n");
    return 0;
}
```

```shell
# Compile
gcc hello.c -o hello

# Run
./hello
```

## Tips & Tricks

### Keyboard Shortcuts

- **Ctrl+C**: Stop current command
- **Ctrl+Z**: Suspend current command
- **Ctrl+D**: Exit/logout
- **Tab**: Auto-complete

### Command History

```shell
# View history
history

# Search history
Ctrl+R  # Then type search term

# Rerun last command
!!

# Rerun command from history
!123  # Run command #123
```

### Useful Aliases

Add to `~/.bashrc`:

```shell
alias ll='ls -la'
alias update='opkg update'
alias install='opkg install'
```

## Learning More

### Built-in Help

```shell
# Command manual
man <command>

# Command help
<command> --help

# Installed documentation
ls /usr/share/doc
```

### Further Reading

- [User Guide](../user-guide/basic-usage.md)
- [Package Management](../user-guide/package-management.md)
- [System Configuration](../user-guide/configuration.md)
- [Applications](../user-guide/applications.md)

## Getting Help

- Check [Troubleshooting](../troubleshooting/faq.md)
- Visit [Community](../resources/community.md)
- Read [External Docs](../resources/external-docs.md)

## Next Steps

Now that you know the basics:

- Explore [Basic Usage](../user-guide/basic-usage.md) for detailed guides
- Install your favorite [Applications](../user-guide/applications.md)
- Try [Development](../developer/overview.md) if interested in coding
- Join the [Community](../resources/community.md)!
