design.json: design.v
	yosys -qp "script ../share/synth.ys; write_json $@" $<

design_mod.json: design.v
	yosys -DMODIFY -qp "script ../share/synth.ys; write_json $@" $<

design.config: design.json
	nextpnr-ecp5 --json $< --textcfg $@ --lpf versa.lpf --post-route ../share/dump_ffs.py --um5g-45k --package CABGA381

design_empty.config: design.config
	yosys -p "add -mod top; write_json empty.json"
	nextpnr-ecp5 --json empty.json --textcfg $@ --lpf versa.lpf --post-route ../share/create_empty.py --um5g-45k --package CABGA381

design_mod.config: design_mod.json
	nextpnr-ecp5 --json $< --textcfg $@ --lpf versa.lpf --pre-place ../share/place_ffs.py --um5g-45k --package CABGA381

%_halted.config: %.config
	sed 's/CEMUX\ 1/CEMUX\ 0/g' $< > $@.tmp
	mv $@.tmp $@

design.svf: design.config
	ecppack --background --svf $@ $<

design_halted.svf: design.config design_halted.config
	ecppack --background --svf $@ --delta $^

design_empty.svf: design_halted.config design_empty.config
	ecppack --background --svf $@ --delta $^

design_mod_halted.svf: design_empty.config design_mod_halted.config
	ecppack --background --svf $@ --delta $^

design_mod.svf: design_mod_halted.config design_mod.config
	ecppack --background --svf $@ --delta $^

prog: design.svf
	openocd -f versa5g_openocd.cfg -c "transport select jtag; init; svf quiet $<; exit"

prog_mod: design_halted.svf design_mod_halted.svf design_mod.svf
	# Halt existing design (so shifting in the config doesn't corrupt things)
	openocd -f versa5g_openocd.cfg -c "transport select jtag; init; svf quiet design_halted.svf; exit"
	# Shift in empty design to avoid conflicts/shortcircuits
	openocd -f versa5g_openocd.cfg -c "transport select jtag; init; svf quiet design_empty.svf; exit"
	# Shift in halted new design
	openocd -f versa5g_openocd.cfg -c "transport select jtag; init; svf quiet design_mod_halted.svf; exit"
	# Unhalt new design
	openocd -f versa5g_openocd.cfg -c "transport select jtag; init; svf quiet design_mod.svf; exit"
