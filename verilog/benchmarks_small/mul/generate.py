#!/usr/bin/env python3

from common import gen_mul

ARange = ['16','16s','24','24s','32','32s','48','48s','64','64s','128','128s']
BRange = ['2','2s','4','4s','8','8s','16','16s','24','24s','32','32s','48','48s']

if __name__ == "__main__":
    gen_mul(ARange, BRange)
