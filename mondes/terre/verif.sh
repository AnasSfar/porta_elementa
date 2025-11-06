#!/bin/bash
set -euo pipefail

# chemins
PROJECT_DIR="$(cd "$(dirname "$0")/../.."; pwd)"
STATE_ROOT="$PROJECT_DIR/.game_state"
STATE_DIR="$STATE_ROOT/terre"

LAB_ROOT_FILE="$STATE_DIR/lab_root.txt"
START_HMS_FILE="$STATE_DIR/depart.txt"
STARS_TERRE="$STATE_DIR/stars.txt"
CODE_TERRE="$STATE_DIR/code_terre.txt"
TIME_TERRE="$STATE_DIR/time_terre.txt"

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

# OUT 
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

# --- Vérif du dossier SAVED ---
SAVED_DIR="$lab_root/SAVED"
[[ -d "$SAVED_DIR" ]] || { echo "Dossier SAVED manquant."; exit 1; }

[[ -f "$SAVED_DIR/reuse.txt" ]] || { echo "reuse.txt manquant dans SAVED."; exit 1; }
[[ -f "$SAVED_DIR/monde.txt" ]] || { echo "monde.txt manquant dans SAVED."; exit 1; }


# --- Vérif REUSE (phrase exacte) ---
expected_reuse="Les arbres produisent de l'air pur."
user_reuse="$(tr -d '\r' < "$SAVED_DIR/reuse.txt" | sed 's/[[:space:]]\+$//')"
if [[ "$user_reuse" != "$expected_reuse" ]]; then
  echo "reuse.txt incorrect. Vérifie le texte exact :"
  echo "Attendu : \"$expected_reuse\""
  echo "Trouvé : \"$user_reuse\""
  exit 1
fi

# --- Vérif contenu de monde.txt ---
monde_src="$lab_root/03.RECYCLE/monde.txt"
if [[ -f "$monde_src" ]]; then
  expected_recycle="$(grep -E '^(forêt pure|océan propre|désert pur|glacier clair|air pur)$' "$monde_src")"
  user_recycle="$(cat "$SAVED_DIR/monde.txt")"
  if [[ "$user_recycle" != "$expected_recycle" ]]; then
    echo "Contenu de SAVED/monde.txt incorrect (lignes sales ou manquantes)."
    echo "Attendu :"
    printf "%s\n" "$expected_recycle"
    exit 1
  fi
fi

# --- Étoiles ---
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
mkdir -p "$(dirname "$STARS_TERRE")" "$(dirname "$CODE_TERRE")"
echo "terre:$stars" >> "$STARS_TERRE"
echo "$digit" > "$CODE_TERRE"
echo "$temps" > "$TIME_TERRE"

# calcul du temps en minutes et secondes
minutes=$(( temps / 60 ))
secondes=$(( temps % 60 ))

# Fin
echo "Épreuve TERRE validée. Tu as sauvé la planète."
echo "Temps : ${minutes} minutes et ${secondes} secondes."
echo "Étoiles: $stars"
echo "Code secret de la TERRE : ${digit}"
echo ""
echo "Si tu as terminé toutes les épreuves, lance ./portail.sh dans la racine du jeu pour ouvrir la porte finale."