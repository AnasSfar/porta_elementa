#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/../.."; pwd)"
STATE_ROOT="$PROJECT_DIR/.game_state"
state_dir="$STATE_ROOT/air"

lab="lab_air"
mkdir -p "$state_dir"

date +%H:%M:%S > "$state_dir/depart.txt"

clear
echo ""
echo "PORTE DE L'AIR — ÉPREUVE 3"
echo ""
# option OUT initial
read -rp "Souhaites-tu continuer ? (Entrée pour continuer, ou tape OUT pour quitter) : " choix
if [[ "${choix,,}" == "out" ]]; then
  echo ""
  echo "Tu as décidé de quitter l'épreuve."
  echo "Épreuve de l'AIR abandonnée."
  exit 0
fi
sleep 2
echo "À tout moment, tu peux quitter en créant le fichier : lab_air/OUT.txt puis lancer le scirpt ./verif.sh "
echo ""
sleep 2

echo "Cher voyaguer, le vent est prisonnier d’un labyrinthe invisible."
echo "Lis les couloirs dans l’ordre indiqué par les indices et libère-le."
echo ""
echo "Quand tu penses avoir fini, tu pourras lancer : ./verif_air.sh"
echo "Tu as 20 minutes pour libérer l'air."
echo "Tu peux vérifier le temps restant en lançant le script ./temps_air.sh "

# labyrinthe
rm -rf "$lab" #supprime tout ancien labyrinthe
mkdir -p "$lab"

# cle du vent
echo "Souffle captif." > "$lab/cle.txt"

# couloirs
cat > "$lab/nord.txt" <<'TXT'
[NORD]
Le vent se cache dans les ombres.
Révèle ce qui est invisible dans ce dossier pour entendre son premier souffle = ton premier indice.
TXT

cat > "$lab/sud.txt" <<'TXT'
[SUD]
L’air est brûlant ici.
Crée-lui un passage (un dossier) plus frais nommé « brise », puis cherche plus loin vers l’EST.
TXT

cat > "$lab/est.txt" <<'TXT'
[EST]
Un passage existe, mais la clé du vent n’y est pas encore.
Déplace la clé (cle.txt) dans le couloir « brise » et renomme-la « air.txt ».
Quand ce sera fait, le vent te parlera à l’OUEST.
TXT

cat > "$lab/ouest.txt" <<'TXT'
[OUEST]
Dernière étape : transforme l’air lui-même.
Ouvre « lab_air/brise/air.txt » et ajoute à la fin la phrase exacte :
Le vent est libre.
Quand ton chant est complet, lance : ./verif_air.sh
TXT

# indice caché après NORD
echo "Le vent descend vers le sud." > "$lab/.indice.txt"

# etat pour verif
echo "$lab" > "$state_dir/lab_root.txt"
printf '%s\n' "Le vent est libre." > "$state_dir/expected_phrase.txt"

# depart
echo "Commence par : cat $lab/nord.txt"