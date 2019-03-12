
This is a collection of Verilog designs of different type and size, used as
benchmarks in Yosys development.

Create a PR if you think you have an interesting benchmark.


benchmarks_small
----------------

This directory contains small (mostly synthetic) benchmarks that can be used
to analyse and compare the performance of the tools in specific situations.


benchmarks_large
----------------

This directory contains larger "real-world" designs. They can be used for
estimating the overall performance of the tools.

running the benchmarks
----------------------

example:
run './scripts/database_make.py yosys-ice40-lutcount <directory1> <directory2>'
