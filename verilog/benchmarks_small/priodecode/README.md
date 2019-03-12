# priodecode - Priority decoders

The priority decoder takes a bit-vector of request signals and
lets the request with the most weight through. I.e. only one of the
output signals is high, or none of the output signals are high.

The Python script generates priority decoders of various widths.

Priority decoders are using in interrupt processing, where the
interrupt with the highest priority should be serviced first.
