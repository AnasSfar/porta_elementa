#!/bin/bash
set -euo pipefail

# state
PROJECT_DIR="$(cd "$(dirname "$0")/../.."; pwd)"
STATE_ROOT="$PROJECT_DIR/.game_state"
state_dir="$STATE_ROOT/eau"
lab="lab_eau"
mkdir -p "$state_dir"
date +%H:%M:%S > "$state_dir/depart.txt"  

clear
echo ""
echo "PORTE DE L'EAU — ÉPREUVE 2"
sleep 1
# option OUT initial
read -rp "Souhaites-tu continuer ? (Entrée pour continuer, ou tape OUT pour quitter) : " choix
if [[ "${choix,,}" == "out" ]]; then
  echo ""
  echo "La purification de l'eau n'aura pas lieu parce que tu as choisi de quitter l'épreuve..."
  echo "Épreuve de l'EAU abandonnée."
  exit 0
fi
sleep 2

echo "À tout moment, tu peux quitter en créant le fichier : lab_eau/OUT.txt puis lancer le scirpt ./verif.sh "
echo ""
echo "Les flots s'agitent doucement alors que tu approches."
echo "Une voix fluide résonne dans ton esprit :"
sleep 1
echo ""
echo "  Voyageur... l’eau te mettra à l’épreuve."
echo "  Purifie-la des impuretés et rends-lui sa clarté."
sleep 1
echo ""
echo "Déroulement :"
echo "  • Trouve le fichier flots.txt caché dans le labyrinthe."
echo "  • Il t’indiquera le chemin d’un fichier source.txt que tu devras purifier."
echo "  • Crée un fichier pur.txt contenant seulement (... -v ... > ...) les lignes sans le mot interdit : 'sel'. Il est interdit d'utiliser la commande 'vi'. "
echo "  • Déplace ton fichier pur.txt dans la racine du labyrinthe $lab "
echo ""


# lab
rm -rf "$lab"
mkdir -p "$lab"/{source/{ruisseau,riviere},ocean/{atlantique,pacifique},delta/{bras1,bras2}}

# liste des dossiers (ordre d’options corrigé)
mapfile -t dirs < <(find "$lab" -mindepth 1 -type d)
[[ ${#dirs[@]} -eq 0 ]] && dirs=("$lab")

# endroit aléatoire pour la source
target="${dirs[$((RANDOM % ${#dirs[@]}))]}"
src="$target/source.txt"

# contenu de la source
cat > "$src" <<'TXT'
L’eau du ruisseau est claire
La mer contient du sel
Le torrent chante
La pluie tombe
Sel gemme et sel marin
Les gouttes brillent
TXT

# état pour vérification
echo "$lab" > "$state_dir/lab_root.txt"
echo "$src" > "$state_dir/source_path.txt"
echo "$lab/pur.txt" > "$state_dir/expected_output_path.txt"

# consigne cachée (flots.txt) à un autre endroit
cons="${dirs[$((RANDOM % ${#dirs[@]}))]}/flots.txt"
{
  echo "L’eau est troublée. Tu dois la purifier."
  echo "Garde seulement les lignes SANS le mot « sel » (insensible à la casse)."
  echo "Fichier à filtrer (chemin relatif depuis la racine) : ${src#$lab/}"
} > "$cons"

# fichier attendu (référence pour verif)
grep -vi "sel" "$src" > "$state_dir/expected_pur.txt"

echo ""
echo "Une onde mystérieuse parcourt le labyrinthe…"
sleep 1
echo "Quelque part, le fichier flots.txt t’attend."
sleep 1
echo "Trouve-le, lis-le, et apprends à séparer l’eau pure de l’eau salée."
sleep 1
echo ""
echo "Quand tu auras terminé, lance : ./verif_eau.sh"
echo ""
echo "⏱ Tu disposes de 15 minutes à partir de maintenant."
echo "Tu peux vérifier le temps restant en lançant le script ./temps_eau.sh "
sleep 2