# Yosys-bench

This is a collection of Verilog designs of different type and size, used as benchmarks in Yosys development.

Create a PR if you think you have an interesting benchmark.

### benchmarks_small

This directory contains small (mostly synthetic) benchmarks that can be used
to analyse and compare the performance of the tools in specific situations.


### benchmarks_large

This directory contains larger "real-world" designs. They can be used for
estimating the overall performance of the tools.

# Running the benchmarks

Benchmarks are processed by the ```./scripts/database_make.py``` Python3 script. The script performs the following steps:

* It traverses the enters the given directories and executes the `generate.py` Python script, if there is one. These scripts generate Verilog or VHDL files for some testbenches. 
* It checks for a `config.json` file. If there is one, it loads the configuration and reads which HDL files it should use for the testbench.
* If there wasn't a `config.json` file, it simply uses all the `.v` and `.vhdl` files it can find for the testbench.

example:
```./scripts/database_make.py yosys-ice40-lutcount <directory1> <directory2>```

Each benchmark produces an entry in the `./database` directory. Running `./scripts/database_html.sh` will generate a .html file with the results in the `./database` directory.

# Adding benchmarks
To add a benchmark, simply create a directory in the `benchmarks_small` or `benchmarks_large` directory, optionally supply a `generate.py` and/or `config.json` and add your HDL files.

Please also add a `README.md` file to your benchmark so others know what it is you are benchmarking.