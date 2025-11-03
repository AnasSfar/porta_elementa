#!/bin/bash
set -euo pipefail

# --- Vérification des arguments ---
if [[ $# -ne 1 ]]; then
  echo "Usage: ./temps.sh [feu|eau|air|terre]"
  exit 1
fi

element="$1"
state_dir="game_state/$element"
depart_file="$state_dir/depart.txt"

# --- Vérification du fichier de départ ---
if [[ ! -f "$depart_file" ]]; then
  echo "⚠️  Aucune épreuve $element en cours ou non commencée."
  exit 1
fi

# --- Limite de temps selon l’épreuve ---
case "$element" in
  feu)   limite=600 ;;   # 10 min
  eau)   limite=900 ;;   # 15 min
  air)   limite=1200 ;;  # 20 min
  terre) limite=1200 ;;  # 20 min
  *) echo "Élément inconnu : $element"; exit 1 ;;
esac

# --- Conversion HH:MM:SS → secondes ---
hms_to_sec(){ IFS=: read -r h m s <<<"$1"; echo $((10#$h*3600 + 10#$m*60 + 10#$s)); }

start_time="$(cat "$depart_file")"
start_s=$(hms_to_sec "$start_time")
now_s=$(hms_to_sec "$(date +%H:%M:%S)")

# Gérer passage minuit
(( now_s < start_s )) && now_s=$((now_s + 86400))

elapsed=$(( now_s - start_s ))
remaining=$(( limite - elapsed ))

if (( remaining <= 0 )); then
  echo "⏰ Le temps est écoulé pour l’épreuve du $element."
  exit 0
fi

# --- Affichage du temps restant ---
min=$(( remaining / 60 ))
sec=$(( remaining % 60 ))

echo ""
echo "⏱  Il te reste environ ${min} minute(s) et ${sec} seconde(s) pour terminer l’épreuve du ${element^^}."
echo ""