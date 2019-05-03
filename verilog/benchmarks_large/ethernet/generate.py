#!/usr/bin/env python3

import os, subprocess
if not os.path.isdir('verilog-ethernet'):
    subprocess.run(['git', 'clone', 'https://github.com/alexforencich/verilog-ethernet'])
subprocess.run(['git', 'reset', '--hard', '696c634726da5d8a80393089417362823c065492'], cwd='verilog-ethernet')
