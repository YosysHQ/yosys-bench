# BOOM RISC-V core

Generated from https://github.com/riscv-boom/boom-template commit 8241911d3fa13ab81df276899c2ab839fd8b3912

SmallBoom and MediumBoom are default single-core configs. Other multi-core configs are custom:
```scala
class SmallQuadBoomConfig extends Config(
  new WithRVC ++
  new WithSmallBooms ++
  new DefaultBoomConfig ++
  new WithNBoomCores(4) ++
  new WithoutTLMonitors ++
  new freechips.rocketchip.system.BaseConfig)

class MediumOctoBoomConfig extends Config(
  new WithRVC ++
  new WithMediumBooms ++
  new DefaultBoomConfig ++
  new WithNBoomCores(8) ++
  new WithoutTLMonitors ++
  new freechips.rocketchip.system.BaseConfig)

class MegaOctoBoomConfig extends Config(
  new WithRVC ++
  new WithMegaBooms ++
  new DefaultBoomConfig ++
  new WithNBoomCores(8) ++
  new WithoutTLMonitors ++
  new freechips.rocketchip.system.BaseConfig)
```

Note that MegaOctoBoomConfig is primarily intended as a torture test rather than a useful benchmark,
as a large percentage of the final resource usage is used for bit-blasted 16-write-port memories.

Copyright:
```

Copyright (c) 2017, The Regents of the University of California (Regents).
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

3. Neither the name of the Regents nor the
   names of its contributors may be used to endorse or promote products
   derived from this software without specific prior written permission.

IN NO EVENT SHALL REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING
OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF REGENTS HAS
BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

REGENTS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED
HEREUNDER IS PROVIDED "AS IS". REGENTS HAS NO OBLIGATION TO PROVIDE
MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
```
