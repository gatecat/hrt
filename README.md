# HRT - Hot ReconfiguraTion

FPL 2022 demo special edition!

This is a _very_ basic proof-of-concept of loading a modified FPGA design without losing state, using the partial reconfiguration-like features of the ECP5.

It demonstrates debug insertion on a simple picorv32 based SoC. In the base design the LEDs are connected to a MMIO register and display computed primes; this is reconfigured at runtime by hot-reconfiguring routing bits to output the current PC register content on the LEDs instead. All this without even stopping the clock!

To run the demo, first run `make prog` to load the base design to the board. Then run `make prog_dbg` to apply the debug insertion patch (without stopping or resetting the SoC) and `make prog_reset` to remove the patch and restore the original routing.

This requires an ECP5 Versa-5G board (frame addressing for densities other than the ECP5-45k hasn't been reverse engineered yet).
