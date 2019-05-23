#!/usr/bin/env python3

import os, subprocess
if not os.path.isdir('picorv32'):
    subprocess.run(['git', 'clone', 'https://github.com/cliffordwolf/picorv32'])
subprocess.run(['git', 'reset', '--hard', 'v1.0'], cwd='picorv32')
