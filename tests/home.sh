#! /bin/sh

# Répertoire source :
#  - chemin relatif
#  - pas de caractères spéciaux dans les noms de fichiers/répertoires
#  - contient des images, et uniquement des images.
# Répertoire destination (home directory) :
#  - existant avant le lancement du script

DEST=~
SRC=source

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source 
mkdir -p source 

make-img.sh source/image1.jpg
make-img.sh source/image2.jpg

galerie-shell.sh --source $SRC --dest $DEST

if [ -f $DEST/index.html ]
then
    echo "Now run 'firefox dest/index.html' to check the result"
else
    echo "ERROR: $DEST/index.html was not generated"
fi
