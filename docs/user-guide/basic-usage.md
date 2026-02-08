# Basic Usage

## Getting Started

First, please refer to (if you haven't already):

- [Quick Start Guide](../getting-started/quick-start.md) - Essential commands and tips
- [First Boot](../getting-started/first-boot.md) - Initial setup and configuration
- [Package Management](package-management.md) - Installing and managing software

## Daily usage patterns

Normally, for some daily usage patterns, you would need the following types of packages/apps:

- A text/code editor
- A file manager (not necessary, could be done through the command line)
- Any other tools or apps you use (like networking tools)

We recommend vim as a text editor to use with calculinux, as it has extensive documentation, useful features, and is lightweight.

As for the file management system, you could just use the command line, but it's sometimes more useful to display your files "graphically" so we recommend you use Midnight Commander (mc) which displays your files in a TUI-style way, to make it easier to do file management.

## Command line basics

The Linux Command Line can be difficult at first, but once you get the hang of it, you can utilize its full potential. Here are the basics of using the Linux command line:

|             Command             |                                Description                                  |
|---------------------------------|-----------------------------------------------------------------------------|
| pwd                             | Prints your current working directory.                                      |
| ls                              | Lists all the files in your current directory.                              |
| cd [directory name/path]        | Changes your current working directory.                                     |
| mkdir [directory name]          | Creates a new directory.                                                    |
| rmdir [directory name]          | Removes an empty directory.                                                 |
| touch [file name]               | Creates a new, empty file or updates the timestamp of an existing file.     |
| cp [source] [destination]       | Copies files or directories from one location to another.                   |
| mv [source] [destination]       | Moves or renames files and directories.                                     |
| rm [file name]                  | Deletes a file.                                                             |
| cat [file name]                 | Displays the contents of a file.                                            |
| less [file name]                | Opens a file for reading one page at a time.                                |
| head [file name]                | Shows the first 10 lines of a file.                                         |
| tail [file name]                | Shows the last 10 lines of a file.                                          |
| echo [text]                     | Prints text or variables to the terminal.                                   |
| man [command]                   | Displays the manual for a command.                                          |
| history                         | Shows the list of previously executed commands.                             |
| clear                           | Clears the terminal screen.                                                 |
| whoami                          | Displays the current logged-in username.                                    |
| uname -a                        | Prints system information such as kernel and OS details.                    |
| df -h                           | Shows disk space usage on all mounted filesystems in human-readable format. |
| du -sh [directory]              | Displays the total disk usage of a directory.                               |
| ps aux                          | Lists all running processes on the system.                                  |
| top                             | Displays active processes and resource usage in real time.                  |
| kill [PID]                      | Terminates a process using its process ID.                                  |

For more thorough command explanations, and a larger list, you may want to refer to: [100+ Linux Commands: A Complete Guide for Beginners and Professionals](https://dev.to/10000coders/100-linux-commands-a-complete-guide-for-beginners-and-professionals-5404)

## File management

You can do all file work on calculinux from the shell, but a visual tool is often quicker for day‑to‑day tasks like moving lots of files or comparing two folders.

### Midnight Commander

Midnight Commander (mc) is a TUI file manager that runs in your terminal and shows two panels side by side. It fits well with calculinux because it is light, keyboard‑driven, and doesn’t require a full desktop.

### Starting mc

Open a terminal, go to any directory you like, and run ```mc```.
It will take over the terminal with a full‑screen interface; press ```F10``` to quit and you will be back at the same shell prompt.

### Layout and navigation

mc splits the screen into left and right panels, each showing a directory. The bottom line lists function-key shortcuts; use ```Tab``` to switch the active panel, ```arrow keys``` to move the cursor, Enter to enter a directory, and select the .. entry to go up.

### Working with files

Highlight a file or directory to act on it, or mark multiple items if you want to work on more than one at a time. The actual operations (copy, move, delete, etc.) are the same ones shown in the command table above; mc just gives you a clearer view of what you are doing.

## System monitoring

Monitoring your system helps keep it running smoothly by showing how resources are being used.

### htop

htop is a real‑time, interactive system monitor that displays CPU, memory, and process activity in a color‑coded layout.

**Run:**

```shell
htop
```

**Basic keys:**

|  Key  |         Action         |
|-------|------------------------|
| ↑ / ↓ | Move through processes |
|  F3   |         Search         |
|  F6   |     Sort by column     |
|  F9   |      Kill process      |
|  F10  |          Quit          |

Use the bars at the top to quickly check load and memory usage.

### Command line tools

You can also check system health with basic commands:

|  Command  |          Description           |
|-----------|--------------------------------|
|   `top`   |     Live view of processes     |
| `uptime`  | System uptime and load average |
| `free -h` |     Memory and swap usage      |
|  `df -h`  |        Disk space usage        |
| `ps aux`  |     Detailed process list      |

---
