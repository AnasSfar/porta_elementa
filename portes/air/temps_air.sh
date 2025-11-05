#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/../.."; pwd)"
STATE_ROOT="$PROJECT_DIR/.game_state"
state_dir="$STATE_ROOT/air"
depart_file="$state_dir/depart.txt"
limite=600  # 10 minutes

if [[ ! -f "$depart_file" ]]; then
  echo "⚠️  Aucune épreuve en cours ou non commencée."
  exit 1
fi

hms_to_sec(){ IFS=: read -r h m s <<<"$1"; echo $((10#$h*3600 + 10#$m*60 + 10#$s)); }

start_time="$(cat "$depart_file")"
start_s=$(hms_to_sec "$start_time")
now_s=$(hms_to_sec "$(date +%H:%M:%S)")
(( now_s < start_s )) && now_s=$((now_s + 86400))

elapsed=$(( now_s - start_s ))
remaining=$(( limite - elapsed ))

if (( remaining <= 0 )); then
  echo "Le temps est écoulé."
  exit 0
fi

min=$(( remaining / 60 ))
sec=$(( remaining % 60 ))
echo ""
echo "Il te reste environ ${min} minute(s) et ${sec} seconde(s) avant que la fin de l'épreuve."
echo ""