sinks = []
# Rip the LED net up
for i in range(8):
	ctx.ripupNet(f"soc_led[{i}]")
	sinks.append(ctx.nets[f"soc_led[{i}]"].users[0])
write_bitstream(ctx, "", "soc_dbg_unrouted.config")

# Lock all other nets
for net, net_data in ctx.nets:
	ctx.lockNetRouting(net)

# Rewire to target debug register
for i in range(8):
	ctx.disconnectPort(sinks[i].cell.name, sinks[i].port)
	ctx.connectPort(f"soc_i.cpu.reg_next_pc[{i+2}]", sinks[i].cell.name, sinks[i].port)