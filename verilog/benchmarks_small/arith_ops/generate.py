#!/usr/bin/env python3

## Add, Sub, Mul

ops = [
    ("add", "+", lambda i, j: max(i, j)+1),
    ("sub", "-", lambda i, j: max(i, j)+1),
    ("mul", "*", lambda i, j: i + j),
]

for opname, opstr, opsize in ops:
    for i in range(1, 16):
        for j in range(i, 16):
            for signed in [False, True]:
                name = "%s%s_%d_%d" % (opname, "s" if signed else "", i, j)
                signed_str = " signed" if signed else ""
                with open("%s.v" % name, "w") as f:
                    print("module %s (input%s [%d:0] A, input%s [%d:0] B, output [%d:0] Y);" %
                            (name, signed_str, i-1, signed_str, j-1, opsize(i, j)-1), file=f)
                    print("  assign Y = A %s B;" % opstr, file=f)
                    print("endmodule", file=f)

## Shift Ops

ops = [
    ("shl", "<<", ""),
    ("shr", ">>", ""),
    ("sshr", ">>>", " signed"),
]

for opname, opstr, signed_str in ops:
    for i in range(1, 32):
        for j in range(1, 6):
            name = "%s_%d_%d" % (opname, i, j)
            with open("%s.v" % name, "w") as f:
                print("module %s (input%s [%d:0] A, input [%d:0] B, output [%d:0] Y);" %
                        (name, signed_str, i-1, j-1, i-1), file=f)
                print("  assign Y = A %s B;" % opstr, file=f)
                print("endmodule", file=f)

