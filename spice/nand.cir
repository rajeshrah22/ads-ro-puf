* This is a nand gate
.subckt nand2x1 a b o 
M1 o b vdd vdd tp W=260n L=65n
M2 o a vdd vdd tp W=260n L=65n
M3 o a n0 vss tn W=130n L=65n
M4 n0 b vss vss tn W=130n L=65n 
.model tn nmos level=54 version=4.8.2 TOXP=1.85e-9 TOXE=1.85e-9
.model tp pmos level=54 version=4.8.2 TOXP=1.95e-9 TOXE=1.95e-9
.ends
