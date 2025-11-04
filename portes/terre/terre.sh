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

type_out "si tu le trouves... tu sauras où commencer... SOS"
sleep 1

#début de l'épreuve
cat > SOS <<'EOF'
.etiurTéd a’m emmoh’l
.erret al sius ee
.revuaAs em erocne xuep ut
.eiuofne ia’j euq eéhcac evihcRa’l ehcrehc ,alec ruop
.tneitnoc elle’uq sreihcif sel sil te al-tiartxe
.elcyceR ,esueR ,ecudeR :sriopse siort sem tnevuort es euq àl tse’c
EOF

# Création du dossier de travail (facultatif)
mkdir -p .terre_temp

# Création des 3 fichiers d’épreuve
cat > .terre_temp/REDUCE.txt <<'EOF'
Le monde est saturé. Trop de bruit, trop de mots, trop de tout.
Allège la Terre : garde l’essentiel, supprime le reste.
Quand tout sera plus léger, la vie reviendra.
EOF

cat > .terre_temp/REUSE.txt <<'EOF'
Rien n’est jamais vraiment perdu.
Réassemble, réutilise, reconstruis.
Ce qui était brisé peut encore respirer.
EOF

cat > .terre_temp/RECYCLE.txt <<'EOF'
La Terre renaît de ce qu’on choisit de préserver.
Rassemble ce qui est pur, écarte ce qui corrompt.
Recycle pour me redonner forme.
EOF

# Création de l’archive cachée 
tar -cf .terre_hidden.tar -C .terre_temp REDUCE.txt REUSE.txt RECYCLE.txt

# Nettoyage du dossier temporaire
rm -rf .terre_temp

