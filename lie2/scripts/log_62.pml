#
# load initial structure
load eq1.pdb, top
# Load MD frames 
#
#load eq1.pdb, complex
#load eq2.pdb, complex
#load eq3.pdb, complex
#load eq4.pdb, complex
#load eq5.pdb, complex
#load eq6.pdb, complex
load dc1.pdb, complex
load dc2.pdb, complex
load dc3.pdb, complex
load dc4.pdb, complex
load dc5.pdb, complex
load dc6.pdb, complex
load dc7.pdb, complex
load dc8.pdb, complex
load dc9.pdb, complex
load dc10.pdb, complex
#
# Set view
#
sel lig, resi 203-204
set stick_radius,.15
show sticks, lig and not hydro
util.cba(3,"lig",_self=cmd)
util.cba(6,"top")
cmd.disable('lig')
cmd.mouse('forward')
cmd.edit("(complex`3349)",None,None,None,pkresi=0,pkbond=0)
cmd.edit("(complex`3349)","(complex`3321)",None,None,pkresi=0,pkbond=0)
cmd._ctrl(chr(84))
cmd.mouse('forward')
scene F1,store
_ set_view (\
_    -0.881979167,   -0.443013012,   -0.160789356,\
_    -0.466044694,    0.769088626,    0.437381148,\
_    -0.070103951,    0.460697174,   -0.884786785,\
_     0.000000000,    0.000000000,  -33.312160492,\
_   144.481582642,  -24.588581085,   73.271163940,\
_    26.263561249,   40.360759735,    0.000000000 )
#scene F1
#
# Save binary session
#
#save /home/hteran/work/teaching/Estructural_USC1208/lab5/LIE/MD_autodock/S62/lig62_dk1_OLD/log.pse,format=pse
