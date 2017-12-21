load cma_top.pdb
sel water, resn HOH
cmd.enable('water')
cmd.hide("(cma_top and hydro)")
cmd.show("lines"     ,"water")
cmd.show("ribbon"    ,"cma_top")
cmd.hide("lines"     ,"cma_top")
cmd.show("lines"     ,"water")
cmd.disable('water')
sel ligand, resn cma
cmd.show("sticks"    ,"ligand")
cmd.disable('ligand')
cmd.color(6,"cma_top")
util.cba(26,"water")
util.cba(26,"ligand")
zoom water
sel no_charged, resi 297+240
cmd.show("lines"     ,"no_charged")
util.cba(26,"no_charged")
cmd.disable('no_charged')
sel no_charged, resi 288+231
cmd.hide("lines"     ,"cma_top")
cmd.show("lines"     ,"water")
cmd.show("lines"     ,"no_charged")
util.cba(26,"no_charged")
sel heme, resi hem
cmd.show("sticks"    ,"heme")
sel heme, resn hem
cmd.show("sticks"    ,"heme")
cmd.color(4,"heme")
cmd.disable('heme')
zoom water

