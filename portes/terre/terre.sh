#!/bin/bash
set -euo pipefail

# temps et score
debut=$(date +%s)

# dossiers
state_dir=".game_state/terre"
mkdir -p "$state_dir"


echo " POPRTE DE LA TERRE - EPREUVE 4"
sleep 2

# Effet machine à écrire
type_out() {
  text="$1"
  speed=${2:-0.03}
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

type_out "Je SuiS La TeRRRRe- l'homme m'a-" 0.04
sleep 0.5

type_out "détruit" 0.06
sleep 0.5

type_out "L'homme m'a ren/inversé avec ses actions..." 0.04
sleep 0.5
type_out "Trop de CO2..." 0.05
sleep 0.5
type_out "Trop de méchaaaaanceté..." 0.05
sleep 0.5
type_out "Tu dois me sauver." 0.04
sleep 0.5

type_out "au secourrrs" 0.04
sleep 0.5
sleep 5

type_out "Aide moi" 0.05
sleep 0.5

type_out "..."
sleep 0.8
type_out "j’ai... essayé de parler..."
sleep 1
type_out "mais ma voix se perd... dans les signaux..."
sleep 1.2
type_out "il reste un... message..."
sleep 1.5
type_out "quelque part... dans le bruit..."
sleep 1.3

type_out "SOS" 0.2
sleep 0.8

type_out "SOS" 0.2
sleep 0.8

type_out "SOS" 0.2
sleep 0.8

type_out "SOS" 0.2
sleep 0.8

echo ""
echo ""
echo ""

#début de l'épreuve
cat > SOS <<'EOF'
.etiurTéd a’m emmoh’l
.erret al sius ee
.revuaAs em erocne xuep ut
.eiuofne ia’j euq eéhcac evihcRa’l ehcrehc ,alec ruop
.tneitnoc elle’uq sreihcif sel sil te al-tiartxe
.elcyceR ,esueR ,ecudeR :sriopse siort sem tnevuort es euq àl tse’c
EOF