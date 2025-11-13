# Serial Console Access

A hardware serial console is the most reliable way to debug early boot
issues or recover a system when network access is unavailable. The
Picocalc exposes a USB-to-UART bridge that enumerates as `/dev/ttyUSB0`
on most Linux hosts. The console runs at **1,500,000 baud**, 8 data bits,
no parity, and 1 stop bit ("1500000 8N1").

## Prerequisites

- Linux host with `python3-serial` (for `miniterm.py`) or `minicom`
  installed.
- Access to `/dev/ttyUSB0`. If you are not root, add yourself to the
  `dialout` (or distribution-specific) group and re-login:


!!! info
    If you prefeer a GUI tool to access the serial port but don't know what to
    choose, options on Linux desktops include **CuteCom**, and **PuTTY** among 
    others; they provide point-and-click interfaces for selecting ports and baud
    rates. The only setting you will need to change is the 1,500,000 baud setting. 


  ```bash
  sudo usermod -a -G dialout "$USER"
  ```

- USB-C cable connecting the host to the Picocalc debug port.

## Verifying the device node

After connecting the board, confirm the kernel created the serial device:

```bash
ls /dev/ttyUSB*
```

You should see `/dev/ttyUSB0`. If the device is missing, check `dmesg`
for driver errors or verify cabling. If you already have other serial 
devices, it may have received a different number.

---

## Using `miniterm.py`

`miniterm.py` ships with the `pyserial` package and provides a simple
serial terminal.

1. Launch the terminal with the required baud rate:

   ```bash
   python3 -m serial.tools.miniterm /dev/ttyUSB0 1500000
   ```

2. Interact with the console directly in the terminal window.
3. Use `Ctrl+]` to open the miniterm command menu. From there you can
   toggle local echo (`e`), change settings, or quit (`q`).
4. Exit with `Ctrl+]` followed by `q`.

Optional flags:

- `--raw` disables line ending translations.
- `--write-log session.log` records all serial traffic to a file.

---

## Using `minicom`

`minicom` is a curses-based serial terminal that can persist
configuration between sessions.

1. Run the setup menu once to create a default profile:

   ```bash
   sudo minicom -s
   ```

2. In **Serial port setup**:
   - Set **Serial device** to `/dev/ttyUSB0`.
   - Set **Bps/Par/Bits** to `1500000 8N1`.
   - Disable both hardware (`RTS/CTS`) and software (`XON/XOFF`) flow
     control unless your setup requires them.

3. Choose **Save setup as dfl** so future invocations reuse these
   settings, then **Exit** the configuration menu.

4. Start minicom normally:

   ```bash
   minicom
   ```

Key shortcuts while running:

- `Ctrl+A` then `Z`: help and command summary.
- `Ctrl+A` then `O`: reopen the setup menu.
- `Ctrl+A` then `W`: toggle logging to the file defined in the
  configuration.
- `Ctrl+A` then `X`: exit minicom.

---

## Troubleshooting

- **Permission denied**: ensure your user is in the correct group or run
  minicom with `sudo`. Avoid running graphical terminals as root for
  security reasons.
- **Garbled output**: double-check the baud rate (must be 1,500,000) and
  make sure only one terminal program is connected to the port.
- **No output**: confirm the board is powered and the USB-to-UART bridge
  is enumerated by the host (`dmesg | tail`).

---

With the correct baud rate and settings, the serial console provides
boot logs, kernel messages, and a root shell even before networking is
available.
