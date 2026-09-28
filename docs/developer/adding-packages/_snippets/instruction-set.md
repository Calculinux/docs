## ARM vs Thumb-2

Calculinux builds for the Luckfox Lyra with `DEFAULTTUNE = "cortexa7thf-neon-vfpv4"`,
so every recipe compiles to Thumb-2 by default (work directories are named
`cortexa7t2hf-*`). The Cortex-A7 also runs full ARM (A32) code, and a recipe can
choose either.

Thumb-2 is the distro-wide default: code is roughly 25–30% smaller and usually
within a few percent of ARM mode's speed, which matters on the RAM-limited Lyra.
Debian and Fedora build their armhf ports the same way.

A recipe can opt out:

```bitbake
ARM_INSTRUCTION_SET = "arm"
```

Do this when:

- the package has CPU-bound hot loops (emulators, codecs) and benchmarking shows
  ARM mode is faster, or
- ARM inline assembly fails to build in Thumb mode with
  `'asm' operand has impossible constraints` (Thumb reserves `r7` as the frame
  pointer, leaving fewer free registers).

Add a comment to the recipe explaining why. `dosbox-x` in `meta-calculinux-apps`
is an example; `picoarch` deliberately stays in Thumb mode and passes
`-Wa,-mimplicit-it=thumb` instead.
