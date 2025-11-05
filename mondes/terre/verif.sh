#!/bin/bash
set -euo pipefail

# chemins (alignés sur le style FEU)
PROJECT_DIR="$(cd "$(dirname "$0")/../.."; pwd)"
STATE_ROOT="$PROJECT_DIR/.game_state"
STATE_DIR="$STATE_ROOT/terre"

LAB_ROOT_FILE="$STATE_DIR/lab_root.txt"
START_HMS_FILE="$STATE_DIR/depart.txt"
EXPECTED_OUT="$STATE_DIR/expected_pur.txt"
STARS_TERRE="$STATE_DIR/stars.txt"
CODE_TERRE="$STATE_DIR/code_terre.txt"
TIME_TERRE = "$STATE_DIR/time_terre.txt"

# barème 
LIMITE=630          # temps max (10 min 30)
THREE_STAR_MAX=150 
TWO_STAR_MAX=300    
PENALITE=15        

# utilitaires
hms_to_sec(){ IFS=: read -r h m s <<<"$1"; echo $((10#$h*3600+10#$m*60+10#$s)); }

# prérequis d'état
[[ -f "$LAB_ROOT_FILE" ]] || { echo "⚠️ Lance d'abord l'épreuve de la TERRE."; exit 1; }
lab_root="$(<"$LAB_ROOT_FILE")"

# OUT (abandon propre)
OUT_FLAG="$lab_root/OUT.txt"
if [[ -f "$OUT_FLAG" ]]; then
  echo "Abandon détecté : $OUT_FLAG"
  echo "Épreuve TERRE interrompue proprement. Tu pourras la relancer plus tard."
  rm -f "$OUT_FLAG"
  exit 0
fi

# temps écoulé
temps=9999
if [[ -f "$START_HMS_FILE" ]]; then
  s1=$(hms_to_sec "$(cat "$START_HMS_FILE")")
  s2=$(hms_to_sec "$(date +%H:%M:%S)")
  (( s2 < s1 )) && s2=$((s2+86400))  # passage minuit
  temps=$(( s2 - s1 ))
fi

# si limite dépassée → fin
if (( temps > LIMITE )); then
  echo "Le temps imparti est écoulé (${temps}s > ${LIMITE}s)."
  echo "La Terre s'effondre... Épreuve TERRE échouée. Recommence cette épreuve avant de passer à la suivante."
  exit 1
fi

# fichiers attendus dans le répertoire de travail du joueur
reduce_file="$lab_root/reduce.txt"
reuse_file="$lab_root/reuse.txt"
recycle_file="$lab_root/recycle.txt"

[[ -f "$reduce_file"  ]] || { echo "Fichier manquant : $(basename "$reduce_file")"; exit 1; }
[[ -f "$reuse_file"   ]] || { echo "Fichier manquant : $(basename "$reuse_file")";  exit 1; }
[[ -f "$recycle_file" ]] || { echo "Fichier manquant : $(basename "$recycle_file")"; exit 1; }

# --- Vérif REUSE (phrase exacte) ---
expected_reuse=$'Les arbres \nproduisent \nde l’air pur.'
user_reuse="$(sed 's/[[:space:]]\+$//' "$reuse_file")"
if [[ "$user_reuse" != "$expected_reuse" ]]; then
  echo "reuse.txt incorrect. Vérifie l'ordre/texte exact :"
  echo "Attendu :"
  printf "%s\n" "Les arbres " "produisent " "de l’air pur."
  exit 1
fi

# --- Vérif RECYCLE (filtrage des impuretés depuis RECYCLE/monde.txt) ---
monde_src="$lab_root/RECYCLE/monde.txt"
[[ -f "$monde_src" ]] || { echo "Source manquante : RECYCLE/monde.txt"; exit 1; }

expected_recycle="$(grep -vE 'pollution|déchet' "$monde_src" | sed 's/[[:space:]]\+$//')"
user_recycle="$(sed 's/[[:space:]]\+$//' "$recycle_file")"
if [[ "$user_recycle" != "$expected_recycle" ]]; then
  echo "recycle.txt incorrect (impuretés restantes ou lignes manquantes)."
  echo "Attendu (extrait des lignes 'propres' de monde.txt) :"
  printf "%s\n" "$expected_recycle"
  exit 1
fi

# --- Vérif de l'archive finale SAVED au chemin imposé ---
ARCHIVE="$HOME/Documents/GitHub/Porta-Elementa/portes/terre/SAVED"
[[ -f "$ARCHIVE" ]] || { echo "Archive finale manquante : $ARCHIVE"; exit 1; }

# L'archive doit contenir EXACTEMENT ces 3 fichiers à la racine (ordre indifférent)
mapfile -t entries < <(tar -tf "$ARCHIVE" | sed 's#^.*/##' | LC_ALL=C sort)
expected_list=$'reduce.txt\nrecycle.txt\nreuse.txt'
got_list="$(printf "%s\n" "${entries[@]}")"
if [[ "$got_list" != "$expected_list" ]]; then
  echo "Contenu de l'archive SAVED invalide."
  echo "Attendu (à la racine) : reduce.txt, recycle.txt, reuse.txt"
  echo "Trouvé :"
  printf "  - %s\n" "${entries[@]}"
  exit 1
fi

# --- Étoiles (avec éventuelle pénalité cumulée si tu veux l'utiliser) ---
errors=0
penalite=$(( errors * PENALITE ))
effectif=$(( temps + penalite ))

stars=1
if   (( effectif <= THREE_STAR_MAX )); then stars=3
elif (( effectif <= TWO_STAR_MAX ));  then stars=2
fi

# chiffre aléatoire
digit=$(( RANDOM % 10 ))

# enregistrements
mkdir -p "$(dirname "$STARS_FILE")" "$(dirname "$CODE_TERRE")"
echo "terre:$stars" >> "$STARS_TERRE"
echo "$digit" > "$CODE_TERRE"
echo "$temps" > "$TIME_TERRE"

# Fin
echo "Épreuve TERRE validée."
echo "Temps: ${temps}s "
echo "Étoiles: $stars"
echo " Votre code secret est : ${digit}"

echo "Si vous avez fini toutes les épreuves, vous pouvez lancer ./portail.sh dans la racine du jeu." 
