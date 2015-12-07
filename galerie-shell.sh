#! /bin/sh

#####################################################
# Script permettant de générer une galerie d'images #
# (cf galerie-shell-help.txt pour la syntaxe)       #
#####################################################

######### Initialisations #############
# Pour que les boucles for fonctionnent correctement avec les espaces et les guillemets
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

# Initialisations des variables utilisées
src="."
dest="."
verb=0
force=0
fichier="index.html"
compteur=0
attribut="active" # Classe donnée à la première balise image

# On récupère le nom du dossier de l'exécutable
DIR=$(cd "$(dirname "$0")" && pwd)

# Répertoire contenant les vignettes
PICTURE_FOLDER="$DIR/pictures"
# Création si besoin 
mkdir "$PICTURE_FOLDER" 2>/dev/null

# Inclusion du script utilities
. $DIR/utilities.sh

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

recuperation_arguments(){
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
}

parcourir_images_source (){
    # On parcourt les fichiers du répertoire source à la recherche d'images
    for fic in $(ls -Q "$src")
    do
        # ls -Q met les noms des fichiers entre guillemets => il faut les virer
        fic=${fic#\"} # On enlève le dernier
        fic=${fic%\"} # et le premier

        # ${fic##*.} permet de ne garder que l'extension des fichiers
        case "${fic##*.}" in
            jpg|jpeg|gif|png|bmp)
                if [ $force -eq 1 -o ! -f "$PICTURE_FOLDER/$fic" ] 
                then
                    convert -resize 200x200 "$src/$fic" "$PICTURE_FOLDER/$fic"
                    [ $verb = 1 ] && echo "Vignette créée : $src/$fic"
                fi

                # Ecriture du code HTML pour une image:
                #  - Argument 1 : Nom du fichier image utilisé
                #  - Argument 2 : Informations affichées dans l'infobulle (date de dernière modif de l'image, résultat de exiftags)
                #  - Argument 3 : Classe(s) du div contenant l'image
                # Le tout est redirigé vers le fichier HTML que l'on avait déjà commencé à remplir
                info=$(stat "$src/$fic" | tail -n 1 | cut -d' ' -f2,3 | cut -d'.' -f1)
                info=$info"
                "$($DIR/exiftags "$src/$fic" 2>/dev/null)
                
                $DIR/generate-img-fragment.sh "$PICTURE_FOLDER/$fic" "$info" "$attribut" >>"$dest/$fichier"
                [ $verb = 1 ] && echo "Image ajoutée : $PICTURE_FOLDER/$fic"

                attribut=" "
                compteur=`expr "$compteur" + 1`;;
            *);;#pas un fichier image reconnu, on le passe
        esac
    done
}

######### Début du programme #########
recuperation_arguments $@

# Ecriture de l'en-tete
[ $verb = 1 ] && echo "Ecriture de l'en-tête du fichier HTML"
html_head "Galerie d'images" >"$dest/$fichier"

# Ecriture des balises <img/>
parcourir_images_source

# Test si au moins une image a été trouvée
if [ "$compteur" = 0 ]
then
    echo "Aucune image trouvée dans le dossier source"
    rm "$dest/$fichier"
    exit 2
fi

# Ajout des points du carousel si besoin
$DIR/generate-carousel-indicators.sh "$compteur" >>"$dest/$fichier"

# Ecriture de la fin du fichier
[ $verb = 1 ] && echo "Ecriture de la fin du fichier HTML"
html_tail >>"$dest/$fichier"

# Affichage d'un message convivial
echo "Fichier créé, vous pouvez lancer 'firefox $dest/$fichier'"
######### Fin du programme #########

IFS=$SAVEIFS
