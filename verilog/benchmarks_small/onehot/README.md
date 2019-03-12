# Onehot - binary to one-hot and one-hot to binary encoder/decoders

An N-bit one-hot decoder has 2^N output signals.
Only one of the output signals can be '1' at any time.
The index of the output that is set high, is equal to
the (unsigned) binary value at the input of the decoder.

The python script generates one-hot encoders and decoders of varying widths.

Binary to one-hot decoders are frequently used in D/A converters and RAM/ROM
row and column selection circuits.
