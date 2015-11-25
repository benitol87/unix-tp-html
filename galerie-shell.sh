#! /bin/sh

#################################################################################################
# Script permettant de générer une galerie d'images (cf galerie-shell-help.txt pour la syntaxe) #
#################################################################################################

# Initialisations
src="."
dest="."
verb=0
force=0
fichier="index.html"

repCourant=$(pwd)
# On récupère le nom du dossier de l'exécutable
DIR=$(cd "$(dirname "$0")" && pwd)
# On se replace dans le répertoire dans lequel on était au départ
cd "$repCourant"

# Fonction qui affiche la syntaxe de ce script
usage (){
    cat "$DIR/galerie-shell-help.txt"
}

# Récupération des arguments en ligne de commande
while test $# -ne 0
do
    case "$1" in
        --source|-s) 
            src="$2"
            if [ -z "${src// }" ]
            then
                echo "Le nom du dossier source est vide."
                usage
                exit 2
            fi
            shift;;
        --dest|-d)
            dest="$2"
            if [ -z "${dest// }" ]
            then
                echo "Le nom du dossier de destination est vide."
                usage
                exit 2
            fi
            shift;;
        --verb|-v)
            verb=1;;
        --force|-f)
            force=1;;
        --help|-h)
            usage
            exit 0;;
        --index|-i)
            fichier="$2"
            # Test nom de fichier vide ou ne contenant que des espaces
            if [ -z "${fichier// }" ]
            then
                echo "Le nom du fichier de destination est vide."
                usage
                exit 2
            fi
            shift;;
        *)
            echo "Option non reconnue : $1"
            usage
            exit 1;;
    esac
    shift
done

# Inclusion du script utilities
. $DIR/utilities.sh

# Ecriture de l'en-tete
html_head "Galerie d'images" >"$dest/$fichier"

# Ajout des images
attribut="active" # Classe donnée à la première balise image
compteur=0
PICTURE_FOLDER="$DIR/pictures"

# Création si besoin du répertoire contenant les vignettes
mkdir $PICTURE_FOLDER 2>/dev/null

# On parcourt les fichiers du répertoire source à la recherche d'images
for fic in `ls "$src"`
do
    # ${fic##*.} permet de ne garder que l'extension des fichiers
    case "${fic##*.}" in
    jpg|jpeg|gif|png|bmp)
        if [ $verb = 1 ]
        then
            echo "\"$fic\""
        fi

        if [ $force -eq 1 -o ! -f "$PICTURE_FOLDER/$fic" ] 
        then
            convert -resize 200x200 "$src/$fic" "$PICTURE_FOLDER/$fic"
            [ $verb -eq 1 ] && echo "Vignette créée" # Si la vignette n'existe pas, on la crée
        fi

        # Ecriture du code HTML pour une image:
        #  - Argument 1 : Nom du fichier image utilisé
        #  - Argument 2 : Informations affichées dans l'infobulle (date de dernière modif de l'image)
        #  - Argument 3 : Classe(s) du div contenant l'image
        # Le tout est redirigé vers le fichier HTML que l'on avait déjà commencé à remplir
        info=$(stat "$src/$fic" | tail -n 1 | cut -d' ' -f2,3 | cut -d'.' -f1)\"
        $DIR/generate-img-fragment.sh "$PICTURE_FOLDER/$fic" "$info" "$attribut" >>"$dest/$fichier"

        attribut=" "
        compteur=`expr "$compteur" + 1`;;
    *);;#pas un fichier image reconnu, on le passe
    esac
done

# Indication sur la position de l'image visualisée dans le carousel
attribut="active" # Classe attribuée au point correspondant à l'image active
echo "<ol class=\"carousel-indicators\">" >>"$dest/$fichier"
for i in `seq 1 "$compteur"`
do
    echo "<li data-target='#myCarousel' data-slide-to='"`expr $i - 1`"' class='$attribut'></li>" >>"$dest/$fichier"
    attribut=" " # Seule une balise li doit avoir cette classe
done
echo "</ol>" >>"$dest/$fichier"

# Ecriture de la fin du fichier
html_tail >>"$dest/$fichier"
