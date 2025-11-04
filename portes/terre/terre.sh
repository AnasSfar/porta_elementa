#!/bin/bash
set -euo pipefail

# temps et score
debut=$(date +%s)

# dossiers
state_dir=".game_state/terre"
mkdir -p "$state_dir"

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

type_out "au secourrrs" 0.04
sleep 0.5

type_out "Aide moi" 0.05
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

type_out "SOS" 0.2
sleep 0.8

type_out "si tu le trouves... tu sauras où commencer... SOS"
sleep 1

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
REDUCE — Le Poids du Monde
Le monde ploie sous le poids de l'excès.
Garde ce qui est vivant, détruis ce qui m'écrase.
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
REUSE — Les Fragments de Mémoire
Mes souvenirs sont dispersés.
Assemble mes fragments et rends-moi ma voix.
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
RECYCLE — La Purification
Distingue la vie de la corruption.
Ne garde que ce qui est pur.
EOF

# ---------- Création de l’archive cachée ----------
tar -cf .terre_hidden.tar -C .terre_temp REDUCE REUSE RECYCLE

# ---------- Nettoyage du dossier temporaire ----------
rm -rf .terre_temp