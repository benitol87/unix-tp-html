#! /bin/sh

# Test de la commande en spécifiant un répertoire source contenant des images avec des noms faits pour faire planter les programmes des étudiants

DEST=dest
SRC=source

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source dest
mkdir -p source dest

#make-img.sh "source/*.jpg" Nope, convert considère l'astérisque comme une expression régulière
make-img.sh "source/   .jpg"
make-img.sh "source/~.jpg"
make-img.sh "source/une image.jpg"
make-img.sh "source/\<\'\`\,\?\;\!\§\%\$\>.jpg"
#make-img.sh source/\".jpg

galerie-shell.sh --source $SRC --dest $DEST

if [ -f $DEST/index.html ]
then
    echo "Now run 'firefox dest/index.html' to check the result"
else
    echo "ERROR: $DEST/index.html was not generated"
fi
