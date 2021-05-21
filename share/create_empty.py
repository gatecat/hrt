float_net = ctx.createNet("floating")

with open("ffs.dat", "r") as f:
    for line in f:
        sl = line.strip().split(" ")
        if len(sl) != 2:
            continue
        cell = ctx.createCell(sl[0], "TRELLIS_SLICE")
        #CEMUX=0 stops the flop from toggling
        cell.setParam("CEMUX", "0 ")
        ctx.bindBel(sl[1], cell, STRENGTH_LOCKED)
        #Leave LUT inputs explictly floating
        for p in ("A", "B", "C", "D"):
            for i in range(2):
                n = "{}{}".format(p, i)
                cell.addInput(n)
                cell.setParam("{}{}MUX".format(p, i), "{}{}".format(p, i))
                ctx.connectPort("floating", cell.name, n)
