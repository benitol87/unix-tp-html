#! /bin/sh

# Test de la commande en spécifiant un répertoire de destination non existant

dest=dest
source=source

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -fr $source $dest
rm $dest/index.html 2>/dev/null
mkdir -p $source

galerie-shell.sh --source "$source" --dest "$dest" >/dev/null #2>/dev/null

if [ -f $dest/index.html ]
then
    echo "Test failed"
else
    echo "Test succeeded"
fi
