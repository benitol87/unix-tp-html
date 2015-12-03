#! /bin/sh

# Test de la commande en spécifiant un répertoire source ne contenant aucune image

dest="dest"
source="source"

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr $source $dest
mkdir -p $source $dest

echo "Patate">$source/fichier.txt

galerie-shell.sh --source "$source" --dest "$dest"

if [ "$?" = 0 ]
then
    echo "Test failed"
else
    echo "Test succeeded"
fi
