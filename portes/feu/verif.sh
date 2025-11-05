#!/bin/bash
set -euo pipefail

# chemins
PROJECT_DIR="$(cd "$(dirname "$0")/../.."; pwd)"
STATE_ROOT="$PROJECT_DIR/.game_state"
STATE_DIR="$STATE_ROOT/feu"

LAB_ROOT_FILE="$STATE_DIR/lab_root.txt"
START_HMS_FILE="$STATE_DIR/depart.txt"
EXPECTED_FILE="$STATE_DIR/expected_answer.txt"
STARS_FEU="$STATE_DIR/stars.txt"
CODE_FEU="$STATE_DIR/code_feu.txt"

# barème
LIMITE=630          # temps max (10 min)
THREE_STAR_MAX=150
TWO_STAR_MAX=300
PENALITE=15

# fonctions utilitaires
hms_to_sec(){ IFS=: read -r h m s <<<"$1"; echo $((10#$h*3600+10#$m*60+10#$s)); }

# vérif fichiers
[[ -f "$EXPECTED_FILE" && -f "$LAB_ROOT_FILE" ]] || { echo "⚠️ Lance d'abord l'épreuve du FEU."; exit 1; }

# lecture
expected="$(<"$EXPECTED_FILE")"
lab_root="$(<"$LAB_ROOT_FILE")"
candidate="$lab_root/$expected"

#out
OUT_FLAG="$lab_root/OUT.txt"
if [[ -f "$OUT_FLAG" ]]; then
  echo "Abandon détecté : $OUT_FLAG"
  echo "Épreuve interrompue proprement. Tu pourras la relancer plus tard."
  rm -f "$OUT_FLAG"   
  exit 0
fi

# erreurs 
total_files=$(find "$lab_root" -maxdepth 1 -type f | wc -l)
if [[ -f "$candidate" ]]; then
  errors=$(( total_files > 0 ? total_files - 1 : 0 ))
else
  errors=$total_files
fi

# temps écoulé
temps=9999
if [[ -f "$START_HMS_FILE" ]]; then
  s1=$(hms_to_sec "$(cat "$START_HMS_FILE")")
  s2=$(hms_to_sec "$(date +%H:%M:%S)")
  (( s2 < s1 )) && s2=$((s2+86400))
  temps=$(( s2 - s1 ))
fi

# si limite dépassée → fin du jeu
if (( temps > LIMITE )); then
  echo "Le temps imparti est écoulé (${temps}s > ${LIMITE}s)."
  echo "La flamme s'éteint... Épreuve du FEU échouée. Il faut recommencer cette épreuve avant de passer à l'épreuve suivante"
  exit 1
fi

# si la réponse est absente → échec
if [[ ! -f "$candidate" ]]; then
  echo "Fichier '$expected' non trouvé dans $lab_root."
  echo "Erreurs : $errors"
  exit 1
fi



# chiffre aléatoire
digit=$(( RANDOM % 10 ))

#étoiles
total=$(( temps + errors * PENALITE ))
if   (( total <= THREE_STAR_MAX )); then stars=3;
elif (( total <= TWO_STAR_MAX ));  then stars=2;
else                                stars=1; 
fi
# enregistrement
mkdir -p game_state
echo "FEU:$stars" >> "$STARS_FEU"
echo "$digit" > "$CODE_FEU"

# calcul du temps en minutes et secondes
minutes=$(( temps / 60 ))
secondes=$(( temps % 60 ))

# réponse
sleep 2
echo " Bravo, vous avez réussi l'épreuve du feu!"
echo " Temps : ${minutes} minutes et ${secondes} secondes."
echo " Vous avez commis ${errors} erreurs. "
echo " Vous avez gagnez ${stars} étoiles lors de cette épreuve "
echo " Votre code secret est : ${digit}"
echo ""
sleep 5
echo "Le feu s'apaise, et la vapeur s'élève dans l'air..."
sleep 1
echo "L'EAU t'appelle à présent."
echo "Pour accéder à l'épreuve suivante :"
echo "     cd ../  et accède à la porte eau"
echo "     puis lance : ./eau.sh"
echo ""
echo "Que ton esprit reste clair pour affronter l’eau."
echo ""
