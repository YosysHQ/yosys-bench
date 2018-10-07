#!/usr/bin/python3

# Generate spectrum of sigma-delta output bit sequence
# Author: Niels A. Moseley - Moseley Instruments / Symbiotic EDA
# 
# requires matplotlib and numpy
#

import numpy as np
import matplotlib.pyplot as plt

sdout = np.genfromtxt('sddac_out.txt', dtype=np.float)
sdout = sdout*2 - 1

# skip first 1000 samples to avoid FFTing startup transients
sdout = sdout[1001:]

N = sdout.size
print(N)
sdout_fft = np.abs(np.fft.fft(np.multiply(sdout, np.blackman(N))))

plt.figure(1)
plt.title("SDDAC output spectrum")
plt.xlabel("Frequency")
plt.ylabel("Signal Amplitude (dB)")

freqaxis = np.linspace(0,N//2-1,N//2)/N
plt.semilogx(freqaxis, 20.0*np.log10(sdout_fft[:N // 2]))

plt.show()
