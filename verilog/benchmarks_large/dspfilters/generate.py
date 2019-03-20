#!/usr/bin/env python3

import urllib.request
urllib.request.urlretrieve('https://raw.githubusercontent.com/ZipCPU/dspfilters/49b9a0235f88c34b9a997b1aa9a634ad130ea719/rtl/fastfir.v', 'fastfir.vh')
urllib.request.urlretrieve('https://raw.githubusercontent.com/ZipCPU/dspfilters/49b9a0235f88c34b9a997b1aa9a634ad130ea719/rtl/slowfil.v', 'slowfil.vh')
urllib.request.urlretrieve('https://raw.githubusercontent.com/ZipCPU/dspfilters/49b9a0235f88c34b9a997b1aa9a634ad130ea719/rtl/firtap.v', 'firtap.vh')
