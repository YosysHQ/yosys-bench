#!/usr/bin/env python3

from common import gen_muladd

ARange = ['16','16s','24','24s','32','32s']
BRange = ['2','2s','4','4s','8','8s','16','16s']
CRange = ['16','16s','24','24s','32','32s']

if __name__ == "__main__":
    gen_muladd(ARange, BRange, CRange)
