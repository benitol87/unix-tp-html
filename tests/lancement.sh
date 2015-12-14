#! /bin/sh

# Test du lancement du programme à partir de différents répertoires

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

source=$HERE/source
dest=$HERE/dest

rm -fr $source $dest
mkdir -p $source $dest

make-img.sh $source/image1.jpg
make-img.sh $source/image2.jpg

# A partir de l'endroit où on a lancé le test
galerie-shell.sh --source $source --dest $dest 1>/dev/null || echo "Test failed"

# A partir de la racine
cd /
galerie-shell.sh --source $source --dest $dest 1>/dev/null || echo "Test failed"

# A partir du répertoire home
cd
galerie-shell.sh --source $source --dest $dest 1>/dev/null || echo "Test failed"

# A partir du répertoire contenant l'exécutable
cd $HERE
galerie-shell.sh --source $source --dest $dest 1>/dev/null || echo "Test failed"

if [ -f $dest/index.html ]
then
    echo "Now run 'firefox $dest/index.html' to check the result"
else
    echo "ERROR: dest/index.html was not generated"
fi
