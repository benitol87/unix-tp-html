# Script créant les balises en dessous du nom de l'image servant à connaitre la position de l'image affichée dans le carousel
# Arguments :
#   $1 : Nombre d'images dans le carousel
if [ "$1" -gt 1 ]
then
    attribut="active" # Classe attribuée au point correspondant à l'image active
    echo "<ol class=\"carousel-indicators\">"
    for i in `seq 1 "$1"`
    do
        echo "<li data-target='#myCarousel' data-slide-to='"`expr $i - 1`"' class='$attribut'></li>" 
        attribut=" " # Seule une balise li doit avoir cette classe
    done
    echo "</ol>" 
fi
