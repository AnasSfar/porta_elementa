#!/bin/bash
set -euo pipefail

# temps et score
debut=$(date +%s)

# chemins
PROJECT_DIR="$(cd "$(dirname "$0")/../.."; pwd)"
STATE_ROOT="$PROJECT_DIR/.game_state"
state_dir="$STATE_ROOT/terre"
date +%H:%M:%S > "$state_dir/depart.txt"

# Effet machine à écrire
type_out() {
  text="$1"
  speed=${2:-0.03}
  for ((i=0; i<${#text}; i++)); do
    echo -n "${text:$i:1}"
    sleep $speed
  done
  echo ""
}

clear
type_out "PORTE DE LA TERRE - ÉPREUVE 4" 0.05
sleep 1.5

# option OUT initial
read -rp "Souhaites-tu continuer ? (Entrée pour continuer, ou tape OUT pour quitter) : " choix
if [[ "${choix,,}" == "out" ]]; then
  echo ""
  echo "Tu t’éloignes du brasier... La flamme s’éteint doucement."
  echo "Épreuve du FEU abandonnée."
  exit 0
fi
sleep 2
echo ""
sleep 2


type_out "BiENveNueeeeeeeeeeeeeeeeeee chER joUeUUUr" 0.04
sleep 1.5

type_out "..." 0.2
sleep 0.5

type_out "Je Sui-" 0.05
sleep 0.5

type_out "Je SuiS La TeRRRRe- l'homme m'a-" 0.04
sleep 0.5

type_out "détruit" 0.06
sleep 0.5

type_out "L'homme m'a ren/inversé avec ses actions..." 0.04
sleep 0.5
type_out "Trop de CO2..." 0.05
sleep 0.5
type_out "Trop de méchaaaaanceté..." 0.05
sleep 0.5
type_out "Tu dois me sauver." 0.04
sleep 0.5

type_out "..."
sleep 0.8
type_out "j’ai... essayé de parler..."
sleep 1
type_out "mais ma voix se perd... dans les signaux..."
sleep 1.2
type_out "il reste un... message..."
sleep 1.5
type_out "quelque part... dans le bruit..."
sleep 1.3

type_out "SOS" 0.2
sleep 0.8

type_out "SOS" 0.2
sleep 0.8

type_out "SOS" 0.2
sleep 0.8

type_out "si tu le trouves... tu sauras où commencer... SOS"
sleep 1

type_out "Tu as 20 minutes pour ... m'aider ..."
type_out "Tu peux vérifier le temps restant en lançant le script ./temps_terre.sh "


date +%H:%M:%S > "$state_dir/depart.txt"

#début de l'épreuve
cat > SOS <<'EOF'
.etiurTéd a’m emmoh’l
.erret al sius ee
.revuaAs em erocne xuep ut
.eiuofne ia’j euq eéhcac evihcRa’l ehcrehc ,alec ruop
.tneitnoc elle’uq sreihcif sel sil te al-tiartxe
.elcyceR ,esueR ,ecudeR :sriopse siort sem tnevuort es euq àl tse’c
EOF

# Création du dossier de travail (temporaire)
mkdir -p .terre_temp/REDUCE .terre_temp/REUSE .terre_temp/RECYCLE

# ---------- REDUCE ----------
cat > .terre_temp/REDUCE/montagne.txt <<'EOF'
Roche ancienne, stable et fière.
EOF

cat > .terre_temp/REDUCE/ocean.txt <<'EOF'
Profondeur calme et bleue.
EOF

cat > .terre_temp/REDUCE/industrie.txt <<'EOF'
Fumées, machines et métal froid.
EOF

cat > .terre_temp/REDUCE/plastique.txt <<'EOF'
Déchets éternels, morts sans fin.
EOF

cat > .terre_temp/REDUCE/foret.txt <<'EOF'
Souffle vert et vie silencieuse.
EOF

cat > .terre_temp/REDUCE/message.txt <<'EOF'
Supprime les fichiers qui représentent la pollution et l’industrie.
Garde seulement les éléments naturels.
Quand il ne restera que trois fichiers, passe à l’épreuve suivante : REUSE.
EOF

# ---------- REUSE ----------
cat > .terre_temp/REUSE/reused_1.txt <<'EOF'
Les arbres 
EOF

cat > .terre_temp/REUSE/reused_2.txt <<'EOF'
produisent 
EOF

cat > .terre_temp/REUSE/reused_3.txt <<'EOF'
de l’air pur.
EOF

cat > .terre_temp/REUSE/message.txt <<'EOF'
Il y a trois fichiers contenant des fragments d’une phrase.
Rassemble-les dans le bon ordre dans un nouveau fichier appelé reuse.txt.
Quand tu auras fini, passe à l'épreuve RECYCLE.
EOF

# ---------- RECYCLE ----------
cat > .terre_temp/RECYCLE/monde.txt <<'EOF'
forêt pure
océan propre
désert pur
pollution toxique
glacier clair
plastique déchet
air pur
EOF

cat > .terre_temp/RECYCLE/message.txt <<'EOF'
Lis le fichier monde.txt.
Crée un nouveau fichier appelé recycle.txt contenant uniquement les lignes propres et naturelles.
Ne garde pas celles qui parlent de pollution ou de déchets.
Après avoir fini, crée une archive dans ~porta-elementa/portes/terre avec les trois fichiers reduce.txt , reuse.txt et recycle.txt .
EOF

# ---------- Création de l’archive cachée ----------
tar -cf .terre_hidden.tar -C .terre_temp REDUCE REUSE RECYCLE

# ---------- Nettoyage du dossier temporaire ----------
rm -rf .terre_temp