#! /bin/sh


# Test de l'option --force : les vignettes ne doivent pas être recréées si elles existent déjà
# ( Pas d'utilisation de l'option ici )

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

galerie-shell.sh --source $SRC --dest $DEST
infoApres=$(stat $HERE/../pictures/image1.jpg)

if [ "$infoAvant" = "$infoApres" ]
then
    echo "Now run 'firefox dest/index.html' to check the result"
else
    echo "Test force1 failed"
fi
