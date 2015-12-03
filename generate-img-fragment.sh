# Ecriture du code HTML pour une image:
#  $1 : Nom du fichier image utilisé
#  $2 : Informations affichées dans l'infobulle
#  $3 : Classe(s) du div contenant l'image
echo "      <div class=\"item $3\">"
echo "          <img src=\"$1\" title=\"Dernière modification : $2\"/>"
echo "          <div class='carousel-caption'>${1##*/}</div>"
echo "      </div>"
