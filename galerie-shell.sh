#! /bin/sh

#####################################################
# Script permettant de générer une galerie d'images #
# (cf galerie-shell-help.txt pour la syntaxe)       #
#####################################################

######### Initialisations #############
# Pour que les boucles for fonctionnent correctement avec les espaces et les guillemets
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

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


########### Fonctions #################

# Fonction qui affiche la syntaxe de ce script
usage (){
    cat "$DIR/galerie-shell-help.txt"
}

# Test de la validité du nom des répertoires source et destination
test_nom_dossier (){
    # Test nom de dossier non vide
    if [ -z "${1// }" ]
    then
        echo "Le nom du dossier $2 est vide."
        usage
        exit 1
    fi
    
    # Test dossier existant
    if [ ! -d "$1"  ]
    then
        echo "Le dossier $2 spécifié n'existe pas."
        exit 1
    fi
}

######### Début du programme #########

# Récupération des arguments en ligne de commande
while test $# -ne 0
do
    case "$1" in
        --source|-s) 
            src="$2"
            test_nom_dossier "$src" "source"
            shift;;
        --dest|-d)
            dest="$2"
            test_nom_dossier "$dest" "destination" 
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
                exit 1
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
mkdir "$PICTURE_FOLDER" 2>/dev/null

# On parcourt les fichiers du répertoire source à la recherche d'images
for fic in $(ls -Q "$src")
do
    # ls -Q met les noms des fichiers entre guillemets => il faut les virer
    fic=${fic#\"} # On enlève le dernier
    fic=${fic%\"} # et le premier

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
                [ $verb = 1 ] && echo "Vignette créée" # Si la vignette n'existe pas, on la crée
            fi

            # Ecriture du code HTML pour une image:
            #  - Argument 1 : Nom du fichier image utilisé
            #  - Argument 2 : Informations affichées dans l'infobulle (date de dernière modif de l'image)
            #  - Argument 3 : Classe(s) du div contenant l'image
            # Le tout est redirigé vers le fichier HTML que l'on avait déjà commencé à remplir
            info=$(stat "$src/$fic" | tail -n 1 | cut -d' ' -f2,3 | cut -d'.' -f1)
            $DIR/generate-img-fragment.sh "$PICTURE_FOLDER/$fic" "$info" "$attribut" >>"$dest/$fichier"

            attribut=" "
            compteur=`expr "$compteur" + 1`;;
        *);;#pas un fichier image reconnu, on le passe
    esac
done

if [ "$compteur" = 0 ]
then
    echo "Aucune image trouvée dans le dossier source"
    exit 2
fi

$DIR/generate-carousel-indicators.sh "$compteur" >>"$dest/$fichier"

# Ecriture de la fin du fichier
html_tail >>"$dest/$fichier"

# Fin du programme
echo "Fichier $dest/$fichier créé"
IFS=$SAVEIFS
