#! /bin/sh


# Test de l'option --force : les vignettes doivent être recréées si elles existent déjà

DEST=dest
SRC=source

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source 
mkdir -p source dest 

make-img.sh source/image1.jpg
make-img.sh source/image2.jpg

# Les vignettes sont créées ici si elles n'existent pas encore
galerie-shell.sh --source $SRC --dest $DEST 
infoAvant=$(stat $HERE/../pictures/image1.jpg)

# Petit temps d'attente pour que la commande stat renvoie des résultats différents en cas de modification
sleep 2

galerie-shell.sh --source $SRC --dest $DEST --force
infoApres=$(stat $HERE/../pictures/image1.jpg)

if [ "$infoAvant" = "$infoApres" ]
then
    echo "Test force1 failed"
else
    echo "Now run 'firefox dest/index.html' to check the result"
fi
