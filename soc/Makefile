all: soc.svf

soc.json: attosoc.v wrapper.v
	yosys -p "synth_ecp5 -top top -nowidelut -nolutram -json $@" $^
soc.config: soc.json versa.lpf
	nextpnr-ecp5 --json soc.json --textcfg $@ --lpf versa.lpf --um5g-45k --package CABGA381 --write soc_pnr.json --disable-router-lutperm
soc.svf: soc.config
	ecppack --compress --background --svf $@ $^ 
prog: soc.svf
	openocd -f versa5g_openocd.cfg -c "transport select jtag; init; svf quiet $<; exit"

soc_dbg.config: soc_pnr.json
	nextpnr-ecp5 --um5g-45k --package CABGA381 --json soc_pnr.json --no-pack --no-place --pre-route debug_insert.py --textcfg $@

soc_dbg_unrouted.config: soc_dbg.config

soc_dbg_unrouted.svf: soc.config soc_dbg_unrouted.config
	ecppack  --background --svf $@ --delta $^ 

soc_dbg.svf: soc_dbg_unrouted.config soc_dbg.config
	ecppack  --background --svf $@ --delta $^ 

prog_dbg: soc_dbg_unrouted.svf soc_dbg.svf
	openocd -f versa5g_openocd.cfg -c "transport select jtag; init; svf quiet soc_dbg_unrouted.svf; exit"
	openocd -f versa5g_openocd.cfg -c "transport select jtag; init; svf quiet soc_dbg.svf; exit"

soc_unrouted_dbg.svf: soc_dbg.config soc_dbg_unrouted.config
	ecppack  --background --svf $@ --delta $^ 

soc_rerouted.svf: soc_dbg_unrouted.config soc.config
	ecppack  --background --svf $@ --delta $^ 

prog_reset: soc_unrouted_dbg.svf soc_rerouted.svf
	openocd -f versa5g_openocd.cfg -c "transport select jtag; init; svf quiet soc_unrouted_dbg.svf; exit"
	openocd -f versa5g_openocd.cfg -c "transport select jtag; init; svf quiet soc_rerouted.svf; exit"


clean:
	rm *.config *.svf *.json

.PHONY: prog
.PRECIOUS: soc.json soc.config