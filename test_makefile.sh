cd $(dirname "$0")

# Initialisations
nbIterations=50
./init_test_makefile.sh >/dev/null
make clean >/dev/null

echo "Début du test 'make gallery' avec l'option -j"

# Fonction qui crée la gallerie "nbIterations" fois
test(){
    for i in $(seq 1 "$nbIterations")
    do
        make -j "$1" gallery >/dev/null
        make clean >/dev/null
    done
}

# Test avec les différentes valeurs de j
for j in $(seq 1 10)
do 
    echo "Test avec j=$j"
    time test "$j"
done
