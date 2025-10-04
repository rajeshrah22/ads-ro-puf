* This is an inverter
.subckt inverter in out
+params:
+ tplv =1 tpmv=1
+ tnln =1 tnwn=1
+ tpotv =1 tnotv=1

Mp out in vdd vdd tp L={tplv*65n} W={tplv*130n}
+ AS=75.3f AD=75.3f PS=1.23u PD=1.23u

Mn out in vss vss tn L={tplv*65n} W={tplv*130n}
+ AS=75.3f AD=75.3f PS=1.12u PD=1.23u

.model tn nmos level=54 version=4.8.2 TOXP=1.85e-9 TOXE=1.85e-9
.model tp pmos level=54 version=4.8.2 TOXP=1.95e-9 TOXE=1.95e-9

.ends inverter
