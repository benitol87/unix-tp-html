#! /bin/sh

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -rf source dest
mkdir -p source dest

make-img.sh source/image1.jpg
make-img.sh source/image2.jpg

# Tests d'options non existantes
galerie-shell.sh -source source
galerie-shell.sh --s source
galerie-shell.sh

