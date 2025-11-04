#!/bin/bash
set -euo pipefail

# temps et score
debut=$(date +%s)

# dossiers
state_dir=".game_state/feu"
mkdir -p "$state_dir"


# intro
clear
echo "PORTE DU FEU — ÉPREUVE 1"
echo ""
echo "Bienvenue, voyageur..."
echo "Tu viens d’ouvrir la Porte du Feu."
echo ""
sleep 3
echo "Déroulement du jeu :"
echo "  🔸 Cherche le fichier flamme.txt caché dans le labyrinthe."
sleep 2
echo "  🔸 Lis l’énigme."
sleep 2
echo "  🔸 Crée à la racine un fichier dont le nom = la réponse."
sleep 2
echo " Par exemple, la bonne réponse est "test", le fichier sera crée à la racine avec le nom "test" . " 
echo ""
sleep 3

# option OUT initial
read -rp "Souhaites-tu continuer ? (Entrée pour continuer, ou tape OUT pour quitter) : " choix
if [[ "${choix,,}" == "out" ]]; then
  echo ""
  echo "💨 Tu t’éloignes du brasier... La flamme s’éteint doucement."
  echo "🔥 Épreuve du FEU abandonnée."
  exit 0
fi

sleep 2

echo "À tout moment, tu peux quitter en créant le fichier : lab_feu/OUT.txt puis lancer le scirpt ./verif.sh "
echo "Tu peux vérifier le temps restant en lançant le script ./temps_feu.sh "
sleep 2
echo ""
echo " Attention, tu as 10 minutes à partir de maintenant. "
date +%H:%M:%S > "$state_dir/depart.txt"

# labyrinthe
lab="lab_feu"
rm -rf "$lab"
mkdir -p "$lab"/{combustible/{bois,papier},comburant/{air,oxygene},energie/{etincelle,friction}}

# placement aléatoire de flamme.txt
mapfile -t dossiers < <(find "$lab" -mindepth 1 -type d)
[[ ${#dossiers[@]} -eq 0 ]] && dossiers=("$lab")
fichier="${dossiers[RANDOM % ${#dossiers[@]}]}/flamme.txt"

# --- Liste des énigmes ---
enigmes=(
$'Je suis née du feu, morte dans la lumière, vivante dans la poussière.\nJe garde le souvenir de la flamme éteinte.\nQui suis-je ?'
$'Je jaillis d’un frottement, d’un choc ou d’un hasard.\nMinuscule, je peux pourtant tout embraser.\nQui suis-je ?'
$'Je fais naître le feu en le nourrissant,\nmais trop de moi, et il meurt.\nQui suis-je ?'
$'Je ne brûle pas, mais j’annonce l’incendie.\nQuand je parle, c’est souvent trop tard.\nQui suis-je ?'
$'Je tombe du ciel et j’éteins la flamme.\nParfois je sauve, parfois j’efface.\nQui suis-je ?'
)

reponses=("cendre" "etincelle" "air" "alarme" "pluie")

# tirage aléatoire
i=$(( RANDOM % ${#enigmes[@]} ))
enigme="${enigmes[$i]}"
bonne="${reponses[$i]}"

# état
printf "%b\n" "$enigme" > "$fichier"
echo "$bonne"   > "$state_dir/expected_answer.txt"
echo "$fichier" > "$state_dir/riddle_path.txt"
echo "$lab"     > "$state_dir/lab_root.txt"

echo " Racine : $lab"
echo " Bonne chance !"

