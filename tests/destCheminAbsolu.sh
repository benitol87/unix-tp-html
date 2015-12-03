#! /bin/sh

# Test de l'option --dest avec un chemin absolu 

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

source=source
dest=$HERE/dest

rm -fr $source $dest
mkdir -p $source $dest 

make-img.sh $source/image1.jpg
make-img.sh $source/image2.jpg

galerie-shell.sh --source "$source" --dest "$dest" 

if [ -f "$dest/index.html" ]
then
    echo "Now run 'firefox $dest/index.html' to check the result"
else
    echo "ERROR: $dest/index.html was not generated"
fi
