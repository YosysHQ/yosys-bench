#!/usr/bin/env python3

import urllib.request
urllib.request.urlretrieve('https://raw.githubusercontent.com/alexforencich/verilog-cam/32a2b86b0b1fee22f975bf15a64432b60540ac0e/rtl/cam_srl.v', 'cam_srl.vh')
urllib.request.urlretrieve('https://raw.githubusercontent.com/alexforencich/verilog-cam/32a2b86b0b1fee22f975bf15a64432b60540ac0e/rtl/cam_bram.v', 'cam_bram.vh')
urllib.request.urlretrieve('https://raw.githubusercontent.com/alexforencich/verilog-cam/32a2b86b0b1fee22f975bf15a64432b60540ac0e/rtl/priority_encoder.v', 'priority_encoder.vh')
urllib.request.urlretrieve('https://raw.githubusercontent.com/alexforencich/verilog-cam/32a2b86b0b1fee22f975bf15a64432b60540ac0e/rtl/ram_dp.v', 'ram_dp.vh')
