# Script appelé par le makefile et qui génère la page HTML à partir des fichiers .inc

# Inclusion du script utilities.sh
. ./utilities.sh

# Génération du fichier html
html_head "Galerie d'image (make)" >.temp

html_tail | grep "<iframe" >>.temp

cat *.inc >>.temp

html_tail | tail -n 7 | sed '/<iframe/d' >>.temp

# Quelques modifications par rapport à la version shell
sed '/script/d' .temp | sed '/"carousel-inner"/d'  | sed 's/title="Dernière modification : "/class="img"/g' | sed 's/carousel-caption/legende/g' | sed '/width: 400px;/d' >index.html 

# Suppression du fichier temporaire
rm .temp
