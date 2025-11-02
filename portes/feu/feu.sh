#!/bin/bash
set -euo pipefail

# temps et score
debut=$(date +%s)

# dossiers
state_dir="game_state/feu"
mkdir -p "$state_dir"
date +%H:%M:%S > "$state_dir/depart.txt"

# intro
clear
echo "PORTE DU FEU — ÉPREUVE 1"
echo ""
echo "Bienvenue, voyageur..."
echo "Tu viens d’ouvrir la Porte du Feu."
echo ""
echo "Règles :"
echo "  🔸 Cherche le fichier flamme.txt caché dans le labyrinthe."
echo "  🔸 Lis l’énigme."
echo "  🔸 Crée à la racine un fichier dont le nom = la réponse."
echo " Par exemple, la bonne réponse est "test", le fichier sera crée à la racine avec le nom "test". " 
echo " Attention, tu as seulement 10 minutes à partir de maintenant. "
echo "Tape OUT pour abandonner."
echo ""
sleep 2

# labyrinthe
lab="lab_feu"
rm -rf "$lab"
mkdir -p "$lab"/{combustible/{bois,papier},comburant/{air,oxygene},energie/{etincelle,friction}}

# énigme
dossiers=($(find "$lab" -mindepth 1 -type d))
fichier="${dossiers[$RANDOM % ${#dossiers[@]}]}/flamme.txt"

enigme="Je reste quand tout brûle. Qui suis-je ?"
bonne="cendre"


# écriture
echo "$enigme" > "$fichier"
echo "$bonne"   > "$state_dir/expected_answer.txt"
echo "$fichier" > "$state_dir/riddle_path.txt"
echo "$lab"     > "$state_dir/lab_root.txt"

echo " Racine : $lab"
echo " Bonne chance !"