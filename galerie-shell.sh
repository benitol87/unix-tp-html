src="."
dest="."
verb=0
force=0
fichier="index.html"

repCourant=$(pwd)
# On récupère le nom du dossier de l'exécutable
DIR=$(cd "$(dirname "$0")" && pwd)
# On se replace dans le répertoire de base
cd "$repCourant"

# Récupération des arguments en ligne de commande
while test $# -ne 0
do
    case "$1" in
        --source|-s) 
            src="$2"
            if test -z "${src// }"
            then
                echo "Le nom du dossier source est vide."
                exit 2
            fi
            shift;;
        --dest|-d)
            dest="$2"
            if test -z "${dest// }"
            then
                echo "Le nom du dossier de destination est vide."
                exit 2
            fi
            shift;;
        --verb|-v)
            verb=1;;
        --force|-f)
            force=1;;
        --help|-h)
            cat "galerie-shell-help.txt"
            exit 0;;
        --index|-i)
            fichier="$2"
            # Test nom de fichier vide ou ne contenant que des espaces
            if test -z "${fichier// }"
            then
                echo "Le nom du fichier de destination est vide."
                exit 2
            fi
            shift;;
        *)
            echo "Option non reconnue : $1"
            exit 1;;
    esac
    shift
done

# Inclusion du script utilities
. $DIR/utilities.sh

# Test de l'existence du fichier si besoin
if test "$force" -eq 0
then
    if test -f "$dest/$fichier"
    then
        echo "Un fichier du même nom existe déjà"
        exit 2
    fi
fi

 
# Ecriture de l'en-tete
html_head "Galerie d'images" >"$dest/$fichier"

# Ajout des images
attribut="active" # Classe donnée à la première balise image
compteur=0
PICTURE_FOLDER="${DIR}/pictures"

# Création si besoin du répertoire contenant les vignettes
mkdir $PICTURE_FOLDER 2>/dev/null

# On parcourt les fichiers du répertoire source
for fic in `ls "$src"`
do
    # ${fic##*.} permet de ne garder que l'extension des fichiers
    case "${fic##*.}" in
    jpg|jpeg|gif|png|bmp)
        if test $verb = 1
        then
            echo "\"$fic\""
        fi

        [ -f "$PICTURE_FOLDER/$fic" ] || convert -resize 200x200 "$src/$fic" "$PICTURE_FOLDER/$fic" # Si la vignette n'existe pas, on la crée

        ./generate-img-fragment.sh $PICTURE_FOLDER/$fic $attribut >>"$dest/$fichier"
        attribut=" "
        compteur=`expr $compteur + 1`;;
    *);;#pas un fichier image reconnu, on le passe
    esac
done

# Indication sur la position de l'image visualisée dans le carousel
attribut="active"
echo "<ol class=\"carousel-indicators\">" >>"$dest/$fichier"
for i in `seq 1 $compteur`
do
    echo "<li data-target='#myCarousel' data-slide-to='"`expr $i - 1`"' class='$attribut'></li>" >>"$dest/$fichier"
    attribut=" "
done
echo "</ol>" >>"$dest/$fichier"

# Ecriture de la fin du fichier
html_tail >>"$dest/$fichier"
