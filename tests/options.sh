#! /bin/sh

HERE=$(cd "$(dirname "$0")" && pwd)
PATH="$HERE/..:$PATH"

rm -rf source dest
mkdir -p source dest

make-img.sh source/image1.jpg
make-img.sh source/image2.jpg

# Tests d'options non existantes
galerie-shell.sh -source source >/dev/null && echo "Test failed"
galerie-shell.sh --s source >/dev/null && echo "Test failed"
galerie-shell.sh verb >/dev/null && echo "Test failed"
galerie-shell.sh -verb >/dev/null && echo "Test failed"
galerie-shell.sh --source source -x -y --dest dest >/dev/null && echo "Test failed"
galerie-shell.sh --source source --dest dest --patate >/dev/null && echo "Test failed"

# Tests options avec paramètres vides
galerie-shell.sh --source "  " --dest dest --index page.html >/dev/null && echo "Test failed"
galerie-shell.sh --source source --dest " " --index page.html >/dev/null && echo "Test failed"
galerie-shell.sh --source source --dest dest --index "" >/dev/null && echo "Test failed"

echo "Fin du test, aucun fichier HTML n'a été généré si tout va bien"
