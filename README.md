# HRT - Hot ReconfiguraTion

This is a _very_ ugly proof-of-concept of loading a modified FPGA design without losing state, using the partial reconfiguration-like features of the ECP5.

It includes a small demo that turns an up counter into a down counter, keeping the count value.

Currently it is only suited for demos of this size and is a long way from something useful, but is a taste of the future where FPGAs have edit-and-continue support.

Key issues:
 - FF tracking through Yosys is currently not guaranteed
 - All of the logic is currently rebuilt, when only changed cones really need to be rebuilt
 - IO are currently tristated during reconfiguration, which will upset a lot of connected devices in a real-world application
 - The nextpnr-ecp5 packer isn't up to the job here, so we fudge things with a Yosys techmap rule instead. Only LUTs and minimal FFs supported, no RAM etc
 - Using a JTAGG connected DCC to freeze the clock would be more predictable than shifting in a bitstream that ties the FFs' CE to 0

To run the demo, run `make prog` and then `make prog_mod` in the `example/` folder. This supports the ECP5 Versa-5G only.
