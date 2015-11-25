#! /bin/sh

# Test de l'option --help

HERE=$(cd "$(dirname "$0")" && pwd)

# A partir du répertoire de test
cd $HERE
$HERE/../galerie-shell.sh --help 1>/dev/null || echo "Test help failed"

# A partir du répertoire contenant le script galerie-shell
cd ..
$HERE/../galerie-shell.sh --help 1>/dev/null || echo "Test help failed"

# A partir du répertoire /
cd /
$HERE/../galerie-shell.sh --help 1>/dev/null || echo "Test help failed"

echo "Fin du test"
