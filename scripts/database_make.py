#!/usr/bin/env python3

import os
import sys
import subprocess

# Check the number of arguments to provide help, if needed.
if (len(sys.argv) < 3):
    print("Usage: database_make <mode> <dir1> .. <dirN>")
    sys.exit(1)

dbpath = os.path.abspath("./database/"+sys.argv[1])
celllibpath = os.path.abspath("./celllibs")

os.system("rm -rf "+dbpath)
os.system("mkdir -p "+dbpath)

# call all generate.py scripts
for dir in sys.argv[2:]:
    for subdir, dirs, files in os.walk(dir):
        for file in files:
            if (file == "generate.py"):
                script = os.path.join(subdir, file)
                print("Executing " + script)
                retval = subprocess.check_call(["python3","generate.py"], 
                                               cwd=os.path.abspath(subdir),
                                               stdout=sys.stdout,
                                               stderr=sys.stderr
                                               )

# execute all .v scripts
for dir in sys.argv[2:]:
    print(dir)
    for subdir, dirs, files in os.walk(dir):
        for file in files:
            if (file.endswith(".v")):
                # skip all files that end in _tb.v as they are testbench files
                # containing unsynthesizable code
                if (file.endswith("_tb.v")):
                    print("  Skipping Verilog testbench file " + file)
                    continue
                # skip any netlist files that might have been produced in 
                # previous runs
                if (file.endswith("_netlist.v")):
                    print("  Skipping Verilog netlist file " + file)
                    continue
                verilogsrc = os.path.join(subdir, file)
                filewithoutext, file_extension = os.path.splitext(file)
                datfile = open(os.path.join(dbpath, filewithoutext + ".dat"), "wt")
                print("  Running Verilog file " + file)
                retval = subprocess.check_call([os.path.abspath("./scripts/"+sys.argv[1]+".sh"), os.path.abspath("./" +verilogsrc), celllibpath],
                                               cwd=os.path.abspath(subdir),
                                               stdout=datfile,
                                               stderr=sys.stderr
                                               )
                datfile.close()
                
        for file in files:
            if (file.endswith(".vhdl")):
                vhdlsrc = os.path.join(subdir, file)
                filewithoutext, file_extension = os.path.splitext(file)
                datfile = open(os.path.join(dbpath, filewithoutext + ".dat"), "wt")
                print("  Running VHDL file " + file)
                retval = subprocess.check_call([os.path.abspath("./scripts/"+sys.argv[1]+".sh"),os.path.abspath("./" +vhdlsrc), celllibpath],
                                               cwd=os.path.abspath(subdir),
                                               stdout=datfile,
                                               stderr=sys.stderr
                                               )
                datfile.close()                
