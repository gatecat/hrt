with open("ffs.dat", "r") as f:
    for line in f:
        sl = line.strip().split(" ")
        if len(sl) != 2:
            continue
        if sl[0] not in ctx.cells:
        	print("WARNING: FF {} not found!".format(sl[0]))
        	continue
        print("Locking FF {} to {}".format(sl[0], sl[1]))
        ctx.bindBel(sl[1], ctx.cells[sl[0]], STRENGTH_LOCKED)
