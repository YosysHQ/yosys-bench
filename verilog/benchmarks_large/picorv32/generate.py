#!/usr/bin/env python3

import urllib.request
urllib.request.urlretrieve('https://raw.githubusercontent.com/cliffordwolf/picorv32/v1.0/picorv32.v', 'picorv32.vh')
urllib.request.urlretrieve('https://raw.githubusercontent.com/cliffordwolf/picorv32/v1.0/scripts/vivado/synth_area_top.v', 'synth_area_top.vh')
