#!/bin/bash
set -euo pipefail

# chemins
STATE_DIR="game_state"
declare -A files=(
  [feu]="$STATE_DIR/code_feu.txt"
  [eau]="$STATE_DIR/code_eau.txt"
  [air]="$STATE_DIR/code_air.txt"
  [terre]="$STATE_DIR/code_terre.txt"
)
STARS_FILE="$STATE_DIR/stars.txt"

# intro
clear
echo ""
echo "PORTE FINALE — LE SANCTUAIRE DES QUATRE"
echo "Rassemble les codes secret de chaque élément dans l'ordre : FEU, EAU, AIR, TERRE."
echo ""

# collecter les chiffres
missing=()
code=""
for elem in feu eau air terre; do
  f="${files[$elem]}"
  if [[ -s "$f" ]]; then
    digit="$(tr -d '\n\r ' < "$f")"
    code+="$digit"
  else
    missing+=("$elem")
  fi
done

# éléments manquants
if (( ${#missing[@]} > 0 )); then
  echo "Il te manque encore des épreuves : ${missing[*]}"
  echo "Termine-les, puis reviens ouvrir la porte."
  exit 1
fi

# afficher indices
echo "Symboles obtenus :"
for elem in feu eau air terre; do
  echo "  - ${elem^^} : $(<"${files[$elem]}")"
done
echo ""

# saisir le code
read -rp "Entre le code (4 chiffres, FEU→EAU→AIR→TERRE) : " saisie

# vérif code
if [[ "$saisie" != "$code" ]]; then
  echo ""
  echo "La porte vibre, mais ne cède pas."
  echo "Code incorrect."
  echo "Astuce : vérifie l'ordre FEU→EAU→AIR→TERRE."
  exit 1
fi

# succès
echo ""
echo "Le sceau se fissure… La porte s’ouvre dans un souffle de lumière."
echo "Code validé : $code"
echo ""

# bilan étoiles
total=0
if [[ -f "$STARS_FILE" ]]; then
  while IFS=: read -r elem stars; do
    [[ -n "${stars:-}" ]] && total=$((total + stars))
  done < "$STARS_FILE"
fi

# rang
rank="Chercheur d’étincelles"
if   (( total >= 12 )); then rank="Maître des Éléments"
elif (( total >= 9  )); then rank="Héraut des Courants"
elif (( total >= 6  )); then rank="Adepte des Forces"
fi

echo "Étoiles totales : $total"
echo "Rang : $rank"
echo ""

#temps
total_time=0
for elem in feu eau air terre; do
  file=".game_state/${elem}/time_${elem}.txt"
  if [[ -f "$file" ]]; then
    t=$(<"$file")
    total_time=$(( total_time + t ))
  fi
done

minutes=$(( total_time / 60 ))
seconds=$(( total_time % 60 ))
echo "Temps total des épreuves : ${minutes} min ${seconds} s"
echo ""

echo "Au-delà de cette porte, un nouveau voyage commence."
echo ""