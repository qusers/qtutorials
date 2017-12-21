#!/bin/python
load ../cma_prepped_final.pdb, initial
load ../cma_prepped_final.pdb, fepall
#load ../cma_masked.pdb, fep
for i in range(0,31): cmd.load_traj("../fepstep%1d.dcd"%i,"fepall",interval=11)
#load ../fepstep1.dcd, fep
#for i in range(0,31): cmd.load("../fepstep%1d.dcd"%i,"fep", discrete=0)

split_states fepall, prefix="fepnew"
set sphere_color, red, (fepnew_0094 and name H21)
#color red, (name H21 and fep_1241)
python
for x in cmd.get_names():
    print x
    cmd.create("combined_model", x, 1, -1)
python end

#group fep, fepnew*

hide everything, all
select waters, resn HOH
select ligand, resn CMA
select lighyd, ligand and elem H
select carboninitial, (initial and resn CMA and elem c)

util.cbaw
#set light_count,8
#set spec_count,1
#set shininess, 10
#set specular, 0.25
#set ambient,0
#set direct,0
#set reflect,1.5
#set ray_shadow_decay_factor, 0.1
#set ray_shadow_decay_range, 2
#unset depth_cue

# For added coolness
#set field_of_view, 60
set sphere_scale, 0.2
set sphere_quality, 3
#set antialias, 10
#color grey50, elem c

set ray_shadow_decay_range, -5
color grey10, elem c
color blue,   elem n

#show spheres, ligand
show stick, ligand
set stick_radius, 0.05
hide stick, lighyd
show lines, lighyd
show spheres, lighyd
show stick, waters
color darksalmon, initial
set sphere_scale, 0.1, initial
set orthoscopic, 1
select oxidized, name H21 and fep
#import spectrum_states
#spectrum_states (ID 6466), sphere, white red
#set sphere_color, red, oxidized, state=2
#color red, fep and state 2 and name H21
#m = cmd.get_model("oxidized", 1240)
#print m
#m.set("sphere_color","red","oxidized")

#split_states oxidized, 1241, 1241, prefix="oxidized"
#color red, oxidized_1241
#cmd.alter('name H21 and fep', 'name="O"', state=1241)

#cmd.hide("(lig and hydro and (elem c extend 1))")

set ray_trace_mode, 1
select lignoh, (fep and ligand and elem C)
intra_fit lignoh
align lignoh, carboninitial
zoom ligand

#set movie_panel=1
#movie.add_state_loop(1,0,start=1)
#movie.add_state_sweep(1,0,start=1)
#set movie_panel_row_height, 20


deselect
