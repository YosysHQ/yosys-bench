# Various - various designs

The following designs can be found here:

## latch8

A simple 8-bit latch, like grandmother used to make them.

## crc32

A 32-bit CRC based on https://msdn.microsoft.com/en-us/library/dd905031.aspx
It has an 8-bit input and 32-bit output.
The CRC is updated on every clock.

## pwm256

An 8-bit counter and comparator can generate a pulse-width modulated single-bit output.
This PWM module can be used to control the brightness of an LED, or be used (after analogue filtering) as a D/A converter featuring impressive intermodulation distortion.
