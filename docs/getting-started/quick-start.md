# Quick Start Guide

Get up and running quickly with Calculinux basics.

## Essential Commands

### System Information

```bash
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

```bash
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

```bash
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

```bash
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

```bash
# Ethernet (DHCP)
udhcpc -i eth0

# Check connection
ping 8.8.8.8
```

### Install Software

```bash
# Example: Install Python
opkg update
opkg install python3

# Example: Install text editor
opkg install vim
```

### Manage Files

```bash
# Create a file
echo "Hello World" > test.txt

# Edit a file
nano test.txt

# View a file
cat test.txt
```

### Monitor System

```bash
# Real-time process monitor
htop  # or top

# Disk usage by directory
du -h /home | sort -h

# Running processes
ps aux
```

## Desktop Environment

If using a GUI image:

```bash
# Start X server
startx

# Or if using display manager
systemctl start lightdm
```

### Window Manager Shortcuts

(Varies by window manager installed)

## Development

### Python Example

```bash
# Create Python script
nano hello.py
```

```python
#!/usr/bin/env python3
print("Hello from Calculinux!")
```

```bash
# Make executable
chmod +x hello.py

# Run
./hello.py
```

### C Example

```bash
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

```bash
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

```bash
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

```bash
alias ll='ls -la'
alias update='opkg update'
alias install='opkg install'
```

## Learning More

### Built-in Help

```bash
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
