#!/bin/bash
set -euo pipefail

# chemins
STATE_DIR="game_state/eau"
LAB_ROOT_FILE="$STATE_DIR/lab_root.txt"
START_HMS_FILE="$STATE_DIR/depart.txt"
EXPECTED_OUT="$STATE_DIR/expected_pur.txt"
STARS_FILE="game_state/stars.txt"
CODE_EAU="game_state/code_eau.txt"

# barème
LIMITE=900
THREE_STAR_MAX=90
TWO_STAR_MAX=180
PENALITE=15

# fonction sec
hms_to_sec(){ IFS=: read -r h m s <<<"$1"; echo $((10#$h*3600+10#$m*60+10#$s)); }

# vérification des fichiers essentiels
for f in "$LAB_ROOT_FILE" "$START_HMS_FILE" "$EXPECTED_OUT"; do
  [[ -f "$f" ]] || { echo " L’eau ne coule pas encore... Lance d’abord l’épreuve."; exit 1; }
done

lab_root="$(<"$LAB_ROOT_FILE")"
player_out="$lab_root/pur.txt"

echo ""
echo " Les flots se calment..."
sleep 1

# mesure du temps écoulé
s1=$(hms_to_sec "$(cat "$START_HMS_FILE")")
s2=$(hms_to_sec "$(date +%H:%M:%S)")
(( s2 < s1 )) && s2=$((s2+86400))
temps=$(( s2 - s1 ))

if (( temps > LIMITE )); then
  echo " L’eau s’est écoulée trop longtemps (${temps}s)."
  echo " Le courant t’emporte... ton esprit n’a pas su maîtriser le flot du temps."
  exit 1
fi

# présence du fichier
if [[ ! -f "$player_out" ]]; then
  echo " Tu tends les mains... mais aucune eau pure ne répond."
  echo " Fichier '$player_out' manquant."
  exit 1
fi

# erreurs : fichiers parasites
total_files=$(find "$lab_root" -maxdepth 1 -type f | wc -l)
errors=$(( total_files > 0 ? total_files - 1 : 0 ))

# comparaison du contenu
if ! diff -q "$player_out" "$EXPECTED_OUT" >/dev/null 2>&1; then
  echo " Ton eau est encore trouble..."
  echo " Conseil du courant : « utilise grep -vi 'sel' source.txt > pur.txt »"
  echo " Les reflets de la surface cachent encore des impuretés."
  exit 1
fi

# chiffre aléatoire
digit=$(( RANDOM % 10 ))

#étoiles
# score
total=$(( temps + errors * PENALITE ))
if   (( total <= THREE_STAR_MAX )); then stars=3; echo " L’eau obéit à ta volonté. Elle reflète la pureté de ton esprit."
elif (( total <= TWO_STAR_MAX ));  then stars=2; echo " Tu as maîtrisé le flot, mais il reste quelques remous."
else                                stars=1; echo " Tu as purifié l’eau, mais la maîtrise t’échappe encore."
fi

# sauvegarde
mkdir -p game_state
echo "EAU:$stars" >> "$STARS_FILE"
echo "$digit" > "$CODE_EAU"

echo ""
echo " Temps écoulé : ${temps}s (+${errors}×${PENALITE}s de remous) → total ${total}s"
echo " Étoiles : ${stars}"




echo "Code secret de l’EAU : ${digit}"
echo ""
