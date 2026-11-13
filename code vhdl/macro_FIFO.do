transcript quietly
add wave -r /*
#fréquence d'horloge : 50 MHz
#hypothèse : signaux stables n*dt ns après le front actif d'horloge
#temps en ns
set Th 20
set dt 1
echo "Période d'horloge : [expr 1e3/$Th] MHz"
echo "paramètres FIFO : DATA_WIDTH = 8, FIFO_SIZE = 2"

set currentTime 0
#initialisation de la pile et des signaux
force -freeze sim:/FIFO_nmots_mbits/horloge 1 0, 0 [expr $Th/2] ns -r $Th ns
force -freeze sim:/FIFO_nmots_mbits/initfifo 0 0
force -freeze sim:/FIFO_nmots_mbits/initfifo 1 [expr ($currentTime)*$Th + $dt] ns
force -freeze sim:/FIFO_nmots_mbits/initfifo 0 [expr ($currentTime+1)*$Th + $dt] ns
force -freeze sim:/FIFO_nmots_mbits/wrfifo 0 0
force -freeze sim:/FIFO_nmots_mbits/rdfifo 0 0
force -freeze sim:/FIFO_nmots_mbits/datain XXXXXXXX 0

set currentTime 10
#Remplissage de la pile
#Data 1
echo "Donnée n1 : 0x11 à t = [expr ($currentTime)*$Th + $dt] ns"
force -freeze sim:/FIFO_nmots_mbits/datain 00010001 [expr ($currentTime)*$Th + $dt] ns
force -freeze sim:/FIFO_nmots_mbits/wrfifo 1 [expr ($currentTime)*$Th + $dt] ns
#Data 2
echo "Donnée n2 : 0x22 à t = [expr ($currentTime+1)*$Th + $dt] ns"
force -freeze sim:/FIFO_nmots_mbits/datain 00100010 [expr ($currentTime+1)*$Th + $dt] ns
#Data 3
echo "Donnée n3 : 0x33 à t = [expr ($currentTime+2)*$Th + $dt] ns"
force -freeze sim:/FIFO_nmots_mbits/datain 00110011 [expr ($currentTime+2)*$Th + $dt] ns
#Data 4
echo "Donnée n4 : 0x44 à t = [expr ($currentTime+3)*$Th + $dt] ns"
force -freeze sim:/FIFO_nmots_mbits/datain 01000100 [expr ($currentTime+3)*$Th + $dt] ns

#Pause
force -freeze sim:/FIFO_nmots_mbits/wrfifo 0 [expr ($currentTime+4)*$Th + $dt] ns

set currentTime ($currentTime+5)

#Data Debordement
echo "Débordement à t = [expr ($currentTime+1)*$Th] ns"
force -freeze sim:/FIFO_nmots_mbits/datain 11111111 [expr ($currentTime)*$Th + $dt] ns
force -freeze sim:/FIFO_nmots_mbits/wrfifo 1 [expr ($currentTime)*$Th + $dt] ns
force -freeze sim:/FIFO_nmots_mbits/wrfifo 0 [expr ($currentTime+1)*$Th + $dt] ns

set currentTime ($currentTime+5)

#Vidage de la pile : données 1 et 2
echo "Lecture donnée n1 à t = [expr ($currentTime)*$Th + $dt] ns"
force -freeze sim:/FIFO_nmots_mbits/rdfifo 1 [expr ($currentTime)*$Th + $dt]ns
echo "Lecture donnée n2 à t = [expr ($currentTime+1)*$Th + $dt] ns"
force -freeze sim:/FIFO_nmots_mbits/rdfifo 0 [expr ($currentTime+2)*$Th + $dt]ns

#Dépilement donnée n°3 et empilement simultané
echo "Lecture donnée n3 et empilement à t = [expr ($currentTime+5)*$Th + $dt] ns"
force -freeze sim:/FIFO_nmots_mbits/rdfifo 1 [expr ($currentTime+5)*$Th + $dt]ns
force -freeze sim:/FIFO_nmots_mbits/datain 11111111 [expr ($currentTime+5)*$Th + $dt] ns
force -freeze sim:/FIFO_nmots_mbits/wrfifo 1 [expr ($currentTime+5)*$Th + $dt] ns
force -freeze sim:/FIFO_nmots_mbits/wrfifo 0 [expr ($currentTime+6)*$Th + $dt] ns

#Vidage de la pile (suite)
echo "Lecture donnée n4 à t = [expr ($currentTime+6)*$Th + $dt] ns"
echo "Lecture dernière donnée à t = [expr ($currentTime+7)*$Th + $dt] ns"
force -freeze sim:/FIFO_nmots_mbits/rdfifo 0 [expr ($currentTime+8)*$Th + $dt] ns

run [expr 40*$Th] ns
