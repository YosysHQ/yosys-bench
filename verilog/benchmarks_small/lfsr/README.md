# LFSR - Linear Feedback Shift Register

Linear feedback shift registers can be thought of as pseudo-random number generators.
Possibly uses in digital design include efficient counters, noise/stimulus generators, etc.

The python script generates maximal-length XNOR-based LFSRs from 3 to 168 bits with no more than
5 taps, based on coefficients https://www.xilinx.com/support/documentation/application_notes/xapp210.pdf
