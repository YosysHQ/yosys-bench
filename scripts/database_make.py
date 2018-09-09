#!/python

import os
import sys
import subprocess

# Check the number of arguments to provide help, if needed.
if (len(sys.argv) < 3):
    print("Usage: database_make <mode> <dir1> .. <dirN>")
    sys.exit(1);


# call all generate.py scripts
for dir in sys.argv[2:]:
    for subdir, dirs, files in os.walk(dir):
        for file in files:
            if (file == "generate.py"):
                script = os.path.join(dir, file)
                print("Executing " + script);
                retval = subprocess.check_call(["python3","generate.py"], 
                                               cwd=os.path.abspath("./"+dir),
                                               stdout=sys.stdout,
                                               stderr=sys.stderr
                                               )

# execute all .v scripts
for dir in sys.argv[2:]:
    print(dir)
    for subdir, dirs, files in os.walk(dir):
        for file in files:
            if (file.endswith(".v")):
                verilogsrc = os.path.join(dir, file)
                filewithoutext, file_extension = os.path.splitext(file)
                datfile = open(os.path.join(dir, filewithoutext + ".dat"), "wt")
                print("  Running Verilog file " + file);
                retval = subprocess.check_call([os.path.abspath("./scripts/"+sys.argv[1]+".sh"),os.path.abspath("./" +verilogsrc)],
                                               cwd=os.path.abspath("./"+dir),
                                               stdout=datfile,
                                               stderr=sys.stderr
                                               )
                datfile.close()
                
        for file in files:
            if (file.endswith(".vhdl")):
                vhdlsrc = os.path.join(dir, file)
                filewithoutext, file_extension = os.path.splitext(file)
                datfile = open(os.path.join(dir, filewithoutext + ".dat"), "wt")
                print("  Running VHDL file " + file);
                retval = subprocess.check_call([os.path.abspath("./scripts/"+sys.argv[1]+".sh"),os.path.abspath("./" +vhdlsrc)],
                                               cwd=os.path.abspath("./"+dir),
                                               stdout=datfile,
                                               stderr=sys.stderr
                                               )
                datfile.close()                
