#!/usr/bin/env python3

import os
import sys
import subprocess
import json

## execute a JSON configuration
def executeConfig(cellibpath, shellScriptName, dbpath, subdir, config):
    for fileName in config["files"]:
        hdlsrc = os.path.join(subdir, fileName)
        filewithoutext, file_extension = os.path.splitext(fileName)
        datfile = open(os.path.join(dbpath, filewithoutext + ".dat"), "wt")
        print("  Running HDL file " + fileName)
        retval = subprocess.check_call([os.path.abspath("./scripts/"+shellScriptName+".sh"), os.path.abspath("./" +hdlsrc), celllibpath],
                                cwd=os.path.abspath(subdir),
                                stdout=datfile,
                                stderr=sys.stderr
                                )
        datfile.close()
    return

##########################################################################################
## MAIN PROGRAM STARTS HERE
##########################################################################################

# Check the number of arguments to provide help, if needed.
if (len(sys.argv) < 3):
    print("Usage: database_make <mode> <dir1> .. <dirN>")
    sys.exit(1)

shellScriptName = sys.argv[1]
dbpath = os.path.abspath("./database/"+shellScriptName)
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

# execute all .v or .vhdl scripts specified in the config.json file
# or if there is no config.json, simply walk the directory.
for dir in sys.argv[2:]:
    print(dir)
    for subdir, dirs, files in os.walk(dir):

        # check if there is a config.json file
        configFileName = subdir + "/config.json"
        if (os.path.isfile(configFileName)):
            print("  Running config " + configFileName)
            with open(configFileName, 'r') as configFile:
                config = json.load(configFile)
                executeConfig(celllibpath, shellScriptName, dbpath, subdir, config)
        else:
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
                    retval = subprocess.check_call([os.path.abspath("./scripts/"+shellScriptName+".sh"), os.path.abspath("./" +verilogsrc), celllibpath],
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
                    retval = subprocess.check_call([os.path.abspath("./scripts/"+shellScriptName+".sh"),os.path.abspath("./" +vhdlsrc), celllibpath],
                                                cwd=os.path.abspath(subdir),
                                                stdout=datfile,
                                                stderr=sys.stderr
                                                )
                    datfile.close()                
