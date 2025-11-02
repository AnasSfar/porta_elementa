#!/bin/bash
set -euo pipefail

# Création du labyrinthe 
rm -rf "$lab"
mkdir -p "$lab"/{source/{ruisseau,riviere},ocean/{atlantique,pacifique},delta/{bras1,bras2}}

clear
echo ""
echo "PORTE DE L'EAU — ÉPREUVE 2"
sleep 1
echo ""
echo "Les flots s'agitent doucement alors que tu approches."
echo "Une voix fluide résonne dans ton esprit :"
sleep 2
echo ""
echo "   « Voyageur... l’eau te mettra à l’épreuve. »"
echo "   « Purifie-la des impuretés et rends-lui sa clarté. »"
sleep 2
echo ""
echo "RÈGLE :"
echo "  ─ Trouve le fichier *flots.txt* caché dans le labyrinthe."
echo "  ─ Il t’indiquera le chemin d’un fichier *source.txt*."
echo "  ─ Garde SEULEMENT les lignes sans le mot 'sel' (insensible à la casse)."
echo "  ─ Crée à la racine de '$lab' un fichier nommé *pur.txt* contenant l’eau filtrée."
echo ""
echo ""
echo "Tu disposes de 15 minutes avant que le flot ne s’assèche."
sleep 3

# ─── Choix aléatoire de l’endroit où cacher la source ─
mapfile -t dirs < <(find "$lab" -type d -mindepth 1)
target="${dirs[$((RANDOM % ${#dirs[@]}))]}"
src="$target/source.txt"

# ─── Contenu de la source ────────────────────────────
cat > "$src" <<'TXT'
L’eau du ruisseau est claire
La mer contient du sel
Le torrent chante
La pluie tombe
Sel gemme et sel marin
Les gouttes brillent
TXT

# État du jeu (pour vérification) 
echo "$lab" > "$state_dir/lab_root.txt"
echo "$src" > "$state_dir/source_path.txt"
echo "$lab/pur.txt" > "$state_dir/expected_output_path.txt"

# Fichier de consigne caché 
cons="${dirs[$((RANDOM % ${#dirs[@]}))]}/flots.txt"
echo "L’eau est troublée. Tu dois la purifier." > "$cons"
echo "Garde seulement les lignes SANS le mot « sel » (insensible à la casse)." >> "$cons"
echo "Fichier à filtrer (chemin relatif depuis la racine) : ${src#$lab/}" >> "$cons"

# Fichier attendu (pour diff) 
grep -vi "sel" "$src" > "$state_dir/expected_pur.txt"

# Message final 
echo ""
echo "Une onde mystérieuse parcourt le labyrinthe..."
sleep 1
echo "Quelque part, le fichier *flots.txt* t’attend."
sleep 1
echo "Trouve-le, lis-le, et apprends à séparer l’eau pure de l’eau salée."
sleep 2
echo ""
echo "Quand tu auras terminé, lance :  ./verif_eau.sh"
echo ""
echo "Le flot commence à s’écouler..."
echo ""
