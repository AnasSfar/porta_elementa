#!/bin/bash
set -euo pipefail

# chemins
state_dir="$HOME/.porta_elementa/air"
LAB_ROOT_FILE="$STATE_DIR/lab_root.txt"
START_HMS_FILE="$STATE_DIR/depart.txt"
EXPECTED_PHRASE_FILE="$STATE_DIR/expected_phrase.txt"
STARS_FILE=".game_states/stars.txt"
CODE_FILE=".game_states/code_air.txt"

# --- barème ---
LIMITE=1230        # 20 min
THREE_STAR_MAX=300 
TWO_STAR_MAX=600   
PENALITE=15        

# --- vérifications de base ---
for f in "$LAB_ROOT_FILE" "$START_HMS_FILE" "$EXPECTED_PHRASE_FILE"; do
  [[ -f "$f" ]] || { echo "L'air reste silencieux... Lance d'abord ./air.sh"; exit 1; }
done

lab_root="$(<"$LAB_ROOT_FILE")"
expected="$(<"$EXPECTED_PHRASE_FILE")"
start_time="$(<"$START_HMS_FILE")"

#out
OUT_FLAG="$lab_root/OUT.txt"
if [[ -f "$OUT_FLAG" ]]; then
  echo "Abandon détecté : $OUT_FLAG"
  echo "Épreuve interrompue proprement. Tu pourras la relancer plus tard."
  rm -f "$OUT_FLAG"   
  exit 0
fi

# --- conversion HH:MM:SS -> secondes ---
hms_to_sec(){ IFS=: read -r h m s <<<"$1"; echo $((10#$h*3600 + 10#$m*60 + 10#$s)); }

start_s=$(hms_to_sec "$start_time")
now_s=$(hms_to_sec "$(date +%H:%M:%S)")
(( now_s < start_s )) && now_s=$((now_s + 86400))  # passage minuit
temps=$(( now_s - start_s ))

# --- conditions de réussite ---
target="$lab_root/brise/air.txt"

echo ""
echo "Vérification du souffle..."

if [[ ! -d "$lab_root/brise" ]]; then
  echo "Aucun passage 'brise' trouvé dans $lab_root."
  echo "Le vent a besoin d’un couloir pour circuler."
  exit 1
fi

if [[ ! -f "$target" ]]; then
  echo "Le fichier 'air.txt' est manquant dans le passage 'brise'."
  echo "Déplace la clé : mv $lab_root/cle.txt $lab_root/brise/air.txt"
  exit 1
fi

if ! grep -qF "$expected" "$target"; then
  echo "La phrase finale n’est pas correcte."
  echo "Ajoute exactement : \"$expected\" à la fin du fichier."
  exit 1
fi

# pénalités: fichiers supplémentaires dans brise/ 
files_extra=$(find "$lab_root/brise" -type f ! -name "air.txt" | wc -l)
total=$(( temps + files_extra * PENALITE ))

# étoiles
if   (( total <= THREE_STAR_MAX )); then stars=3; 
elif (( total <= TWO_STAR_MAX ));  then stars=2;
else                                stars=1;
fi

# --- symbole aléatoire ---
symbol=$(( RANDOM % 10 ))
mkdir -p .game_state
echo "AIR:${stars}" >> "$STARS_FILE"
echo "$symbol" > "$CODE_FILE"

# --- affichage final ---
echo ""
echo "Le vent est libre."
echo "Temps : ${temps}s "
echo "Étoiles obtenues : ${stars}"

echo "Code secret de l’AIR : ${symbol}"
echo ""
echo ""
echo "Tu peux maintenant passer à l’épreuve suivante : ./terre.sh"