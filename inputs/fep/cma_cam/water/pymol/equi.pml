#!/bin/python
load ../cma_prepped_final.pdb, equi
for i in range(1,5): cmd.load_traj("../eq%1d.dcd"%i,"equi")

hide everything, all
select waters, resn HOH
select ligand, resn CMA
deselect

util.cbaw
set light_count,8
set spec_count,1
set shininess, 10
set specular, 0.25
set ambient,0
set direct,0
set reflect,1.5
set ray_shadow_decay_factor, 0.1
set ray_shadow_decay_range, 2
#unset depth_cue

# For added coolness
#set field_of_view, 60
set sphere_scale, 1.0
set sphere_quality, 3
#set antialias, 10
#color grey50, elem c

set ray_shadow_decay_range, -5
color grey10, elem c
color blue,   elem n

#show spheres, ligand
show stick, ligand
show stick, waters

cmd.hide("(lig and hydro and (elem c extend 1))")

set ray_trace_mode, 1
intra_fit ligand and equi
zoom ligand

#set movie_panel=1
#movie.add_state_loop(1,0,start=1)
#movie.add_state_sweep(1,0,start=1)
#set movie_panel_row_height, 20
