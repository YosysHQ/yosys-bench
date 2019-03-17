# CIC5 - Cascaded Integrator-Comb DSP structure

This module decimates the incoming data stream by a factor of 5,
using a cascaded integrators and comb filters. It is a well-known
efficient DSP structure primarily found in high-speed A/D conversion
applications, such as Software Defined Radios (SDR).

The data widths are: 16-bit signed input, 28 bit signed output.

Reference: https://en.wikipedia.org/wiki/Cascaded_integrator%E2%80%93comb_filter

