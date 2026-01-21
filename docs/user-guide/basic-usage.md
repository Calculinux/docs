# Basic Usage

!!! warning "Under Construction"
    This page is currently being developed. Check back soon for comprehensive usage instructions.

## Getting Started

For now, please refer to:

- [Quick Start Guide](../getting-started/quick-start.md) - Essential commands and tips
- [First Boot](../getting-started/first-boot.md) - Initial setup and configuration
- [Package Management](package-management.md) - Installing and managing software

## Daily usage patterns

Normally, for some daily usage patterns, you would need the following types of packages/apps:
- A text/code editor
- A file manager (not neccesarry, could be done through the command line)
- Any other tools or apps you use (like networking tools)

We recommend vim as a text editor to use with calculinux, as it has extensive documentation, useful feature, and is very lightweight.

As for the file management system, you could just use the command line, but it's sometimes more useful to display your files "graphically" so we reccomend you use Midnight Commander (mc) which displays your files in a TUI-style way, to make it easier to do file management.

## Command line basics

The Linux Command Line can be difficult at first, but once you get the hang of it, you can utilise its full potential. Here are the basics of using the Linux command line:

| Command | Description |
|----------|-------------|
| pwd | Prints your current working directory. |
| ls | Lists all the files in your current directory. |
| cd [directory name/path] | Changes your current working directory. |
| mkdir [directory name] | Creates a new directory. |
| rmdir [directory name] | Removes an empty directory. |
| touch [file name] | Creates a new, empty file or updates the timestamp of an existing file. |
| cp [source] [destination] | Copies files or directories from one location to another. |
| mv [source] [destination] | Moves or renames files and directories. |
| rm [file name] | Deletes a file. |
| cat [file name] | Displays the contents of a file. |
| less [file name] | Opens a file for reading one page at a time. |
| head [file name] | Shows the first 10 lines of a file. |
| tail [file name] | Shows the last 10 lines of a file. |
| echo [text] | Prints text or variables to the terminal. |
| man [command] | Displays the manual for a command. |
| history | Shows the list of previously executed commands. |
| clear | Clears the terminal screen. |
| whoami | Displays the current logged-in username. |
| uname -a | Prints system information such as kernel and OS details. |
| df -h | Shows disk space usage on all mounted filesystems in a human-readable format. |
| du -sh [directory] | Displays the total disk usage of a directory. |
| ps aux | Lists all running processes on the system. |
| top | Displays active processes and resource usage in real time. |
| kill [PID] | Terminates a process using its process ID. |

For more thourough command explinations, and a larger list, you may want to refer to: [100+ Linux Commands: A Complete Guide for Beginners and Professionals](https://dev.to/10000coders/100-linux-commands-a-complete-guide-for-beginners-and-professionals-5404)

## Coming Soon

This section will cover:

- File management (using mc and others, not command line because already explained above)
- System monitoring (using packages and command line)
- Common tasks

---

*Content planned for future release*
