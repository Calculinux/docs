# Screen Capture with FFmpeg

Calculinux includes FFmpeg with DRM/KMS framebuffer capture support, enabling direct screen capture from your PicoCalc's display without requiring X11 or Wayland.

## Overview

FFmpeg's `kmsgrab` input device captures directly from the Linux Direct Rendering Manager (DRM) framebuffer. This provides efficient, low-overhead screen recording and screenshot capabilities.

## Prerequisites

- FFmpeg is pre-installed in Calculinux
- The ILI9488 DRM display driver must be loaded (standard on Calculinux)
- User must have access to `/dev/dri/card0` (members of `video` and `render` groups)

!!! info "Default Permissions"
    The default `pico` user is already in the `video` and `render` groups and has the necessary permissions.

## Taking Screenshots

### Single Frame Capture

Capture a single frame (screenshot) to a PNG file:

```shell
ffmpeg -device /dev/dri/card0 -f kmsgrab -i - -vframes 1 screenshot.png
```

### With Timestamp

Add the current date and time to the filename:

```shell
ffmpeg -device /dev/dri/card0 -f kmsgrab -i - -vframes 1 \
  screenshot-$(date +%Y%m%d-%H%M%S).png
```

## Recording Video

### Basic Video Recording

Record the screen to an MP4 file:

```shell
ffmpeg -device /dev/dri/card0 -f kmsgrab -i - \
    -vf 'hwdownload,format=bgr0' \
    -c:v libx264 -preset ultrafast \
    output.mp4
```

Press `q` to stop recording.

### With Specific Framerate

Record at 15 frames per second (recommended for PicoCalc):

```shell
ffmpeg -framerate 15 -device /dev/dri/card0 -f kmsgrab -i - \
    -vf 'hwdownload,format=bgr0' \
    -c:v libx264 -preset veryfast -crf 23 \
    screencast.mp4
```

!!! tip "Performance Tip"
    Lower framerates (10-15 fps) work better on the RK3506's Cortex-A7 processor.

### Timed Recording

Record for a specific duration (e.g., 10 seconds):

```shell
ffmpeg -t 10 -framerate 15 -device /dev/dri/card0 -f kmsgrab -i - \
    -vf 'hwdownload,format=bgr0' \
    -c:v libx264 -preset veryfast \
    10sec.mp4
```

## Creating Animated GIFs

Convert screen capture to an animated GIF:

```shell
ffmpeg -t 5 -framerate 10 -device /dev/dri/card0 -f kmsgrab -i - \
    -vf 'hwdownload,format=bgr0,fps=10,scale=320:-1:flags=lanczos' \
    -c:v gif \
    animation.gif
```

This captures 5 seconds at 10 fps and creates an optimized GIF.

## Advanced Options

### Hardware Encoding

If hardware encoding is available on your system:

```shell
ffmpeg -framerate 15 -device /dev/dri/card0 -f kmsgrab -i - \
    -vf 'hwdownload,format=nv12' \
    -c:v h264_v4l2m2m -b:v 2M \
    screencast.mp4
```

### With Timestamp Overlay

Add a timestamp to your recording:

```shell
ffmpeg -framerate 10 -device /dev/dri/card0 -f kmsgrab -i - \
    -vf "hwdownload,format=bgr0,drawtext=fontfile=/usr/share/fonts/terminus/ter-u32n.otb:text='%{localtime\:%X}':fontcolor=white:x=10:y=10" \
    -c:v libx264 -preset ultrafast \
    timestamped.mp4
```

### Lower Resolution

Reduce output resolution for smaller file sizes:

```shell
ffmpeg -framerate 10 -device /dev/dri/card0 -f kmsgrab -i - \
    -vf 'hwdownload,format=bgr0,scale=160:240' \
    -c:v libx264 -preset veryfast \
    small.mp4
```

## FFmpeg Preset Options

The `-preset` option controls encoding speed vs. compression:

| Preset | Speed | File Size | Recommended For |
|--------|-------|-----------|-----------------|
| `ultrafast` | Fastest | Largest | Real-time capture on PicoCalc |
| `veryfast` | Very Fast | Large | Good balance |
| `fast` | Fast | Medium | Post-processing |
| `medium` | Medium | Small | Archive/sharing (slow on PicoCalc) |

!!! warning "Performance Impact"
    Use `ultrafast` or `veryfast` presets on PicoCalc. Slower presets may cause dropped frames.

## Troubleshooting

### Permission Denied

If you get "Cannot open device /dev/dri/card0":

```shell
# Check device exists
ls -l /dev/dri/

# Verify your groups
groups

# Add user to video group if needed (requires logout)
sudo usermod -a -G video,render $USER
```

### Display Not Found

Verify the DRM device exists and the driver is loaded:

```shell
# Check for DRM devices
ls -l /dev/dri/

# Check if ILI9488 driver is loaded
lsmod | grep ili9488

# Check kernel messages
dmesg | grep -i ili9488
```

### Low Framerate or Dropped Frames

To improve performance:

1. **Reduce framerate**: Use `-framerate 10` or even `-framerate 5`
2. **Use faster preset**: Switch to `-preset ultrafast`
3. **Lower quality**: Increase CRF value to `-crf 28` (lower quality, smaller file)
4. **Reduce resolution**: Add scale filter `-vf '...,scale=160:240'`

### Black Screen or Corrupted Output

If the output is black or corrupted:

1. **Ensure display is active**: Run an application that draws to the screen first
2. **Test with SDL**: Run `sdl2-test` or another graphical application
3. **Check plane status**: The DRM plane must be active for capture

### Recording Stops Immediately

If FFmpeg exits right away:

- Check that another process isn't already capturing the display
- Verify the display driver is functioning: `cat /sys/class/graphics/fb0/name`

## Technical Details

### Display Specifications

The PicoCalc's LCD is **320×480 pixels**. FFmpeg automatically detects this resolution from the DRM device.

### How kmsgrab Works

The `kmsgrab` input device:

1. Opens the DRM device (`/dev/dri/card0`)
2. Finds the active plane (framebuffer layer)
3. Reads frame data directly from video memory
4. Converts to the requested pixel format

This bypasses the framebuffer entirely and provides the most efficient capture method.

### Performance Considerations

Screen capture on the RK3506 is CPU-intensive:

- The Cortex-A7 cores are limited compared to modern processors
- Video encoding requires significant computation
- Real-time encoding at higher framerates may not be possible
- Consider recording at lower framerates and speeding up in post-processing

## Example Use Cases

### Documenting a Process

Record your screen while demonstrating a process:

```shell
ffmpeg -framerate 10 -device /dev/dri/card0 -f kmsgrab -i - \
    -vf 'hwdownload,format=bgr0' \
    -c:v libx264 -preset ultrafast \
    tutorial.mp4
```

### Creating Animated Demos

Capture a 5-second GIF for sharing:

```shell
ffmpeg -t 5 -framerate 10 -device /dev/dri/card0 -f kmsgrab -i - \
    -vf 'hwdownload,format=bgr0,fps=10' \
    demo.gif
```

### Time-lapse Recording

Record at very low framerate for a time-lapse effect:

```shell
ffmpeg -framerate 1 -device /dev/dri/card0 -f kmsgrab -i - \
    -vf 'hwdownload,format=bgr0' \
    -c:v libx264 -preset ultrafast \
    timelapse.mp4
```

## Related Topics

- [Applications](applications.md) - Other software available on Calculinux
- [Display & Input](../hardware/display-input.md) - Display driver details
- [Basic Usage](basic-usage.md) - General command-line usage

## References

- [FFmpeg kmsgrab Documentation](https://trac.ffmpeg.org/wiki/Capture/Desktop)
- [FFmpeg Official Documentation](https://ffmpeg.org/documentation.html)
- [Linux DRM/KMS Documentation](https://www.kernel.org/doc/html/latest/gpu/drm-kms.html)
