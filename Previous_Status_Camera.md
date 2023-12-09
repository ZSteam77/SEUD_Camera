Environment Vivado 2021.2

Camera emulator, DMA, AXI4 existing codes:

1. pass simulation of the existing testbench

2. pass synthesis after auto upgrading of IPs



Problems:

1. Camera emulator instead of the real Camera module (1280x720), need further testing on the actual Camera module.

2. No controller subsystem implementation:
   
   1. Missing part: Camera Controller, AXI Lite Slave input, I2C Master, Camera Config, Clk transmission unit


