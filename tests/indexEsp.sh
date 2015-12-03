#! /bin/sh

# Test de l'option index avec un nom de fichier contenant un espace 

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

source=source
dest=dest
index="page html.html"

rm -fr $source $dest
mkdir -p $source $dest 

make-img.sh $source/image1.jpg
make-img.sh $source/image2.jpg

galerie-shell.sh --source "$source" --dest "$dest" --index "$index"

if [ -f "$dest/$index" ]
then
    echo "Now run 'firefox $dest/$index' to check the result"
else
    echo "ERROR: $dest/$index was not generated"
fi
