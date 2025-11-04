#!/bin/bash
set -euo pipefail

# temps et score
debut=$(date +%s)

# dossiers
state_dir=".game_state/terre"
mkdir -p "$state_dir"


echo " POPRTE DE LA TERRE - EPREUVE 4"
sleep 2
# Effet machine à écrire simple
type_out() {
  text="$1"
  speed=${2:-0.03}  # vitesse par lettre (0.03 = rapide / 0.1 = lent)
  for ((i=0; i<${#text}; i++)); do
    echo -n "${text:$i:1}"
    sleep $speed
  done
  echo ""
}

clear
type_out "PORTE DE LA TERRE - ÉPREUVE 4" 0.05
sleep 1.5

type_out "BiENveNueeeeeeeeeeeeeeeeeee chER joUeUUUr" 0.04
sleep 1.5

type_out "..." 0.2
sleep 0.5

type_out "Je Sui-" 0.05
sleep 0.5

type_out "Je SuiS La TeRRRRe- l'homme m'a" 0.04
sleep 0.5

type_out "détruit" 0.06
sleep 0.5

type_out "Aide moi" 0.05
sleep 0.5

type_out "SOS" 0.2
sleep 0.8

type_out "L'homme m'a renversé avec ses actions..." 0.04
sleep 0.5
type_out "Trop de CO2..." 0.05
sleep 0.5
type_out "Trop de méchaaaaanceté..." 0.05
sleep 0.5
type_out "Tu dois me sauver." 0.04

#effet réel
for c in "a" "u" "   " "s" "e" "c" "o" "u" "r" "s" "..." ; do
  echo -n "$c"
  sleep 0.1
done
echo ""
sleep 5

echo ""
echo ""
echo ""

#début de l'épreuve
echo ".etiurTéd a’m emmoh’l
.erreA al sius eJ
.Revuas em erocne xuep ut
.eiuofne ia’j euq eéhcac evihcra’l ehcrehc ,alec ruop
.tneitnoc elle’uq sreihcif sel sil te al-tiar txe
.elcycer ,esuer ,ecuder :sriopse siort sem tnevuort es euq àl tse’c"