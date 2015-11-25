#! /bin/sh

# Test de la commande en spécifiant un répertoire source ne contenant aucune image

DEST=dest
SRC=source

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr source dest
mkdir -p source dest

echo "Patate">source/fichier.txt

galerie-shell.sh --source $SRC --dest $DEST

if [ -f $DEST/index.html ]
then
    echo "Now run 'firefox dest/index.html' to check the result"
else
    echo "ERROR: $DEST/index.html was not generated"
fi
