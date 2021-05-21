with open("ffs.dat", "w") as f:
    for cell_name, cell in ctx.cells:
        if "is_ff" in cell.attrs:
            print("{} {}".format(cell_name, cell.bel), file=f)
