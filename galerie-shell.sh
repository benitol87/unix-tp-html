src="."
dest="."
verb=0
force=0
fichier="index.html"

# Récupération des arguments en ligne de commande
while test $# -ne 0
do
    case "$1" in
        --source) 
            src="$2"
            if test -z "${src// }"
            then
                echo "Le nom du dossier source est vide."
                exit 2
            fi
            shift;;
        --dest)
            dest="$2"
            if test -z "${dest// }"
            then
                echo "Le nom du dossier de destination est vide."
                exit 2
            fi
            shift;;
        --verb)
            verb=1;;
        --force)
            force=1;;
        --help)
            cat "galerie-shell-help.txt"
            exit 0;;
        --index)
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
. utilities.sh

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
html_head >"$dest/$fichier"

# Ajout des images
attribut="active"
compteur=0

for fic in `ls "$src"`
do
    case "${fic##*.}" in
    jpg|jpeg|gif|png|bmp)
        if test $verb = 1
        then
            echo "\"$fic\""
        fi
        ./generate-img-fragment.sh "$src/$fic" $attribut >>"$dest/$fichier"
        attribut=" "
        compteur=`expr $compteur + 1`;;
    *);;#pas un fichier image reconnu
    esac
done

# Points indiquant l'image sur laquelle on se trouve
attribut="active"
echo "<ol class=\"carousel-indicators\">" >>"$dest/$fichier"
for i in `seq 1 $compteur`
do
    echo "<li data-target='#myCarousel' data-slide-to='$i' class='$attribut'></li>" >>"$dest/$fichier"
    attribut=" "
done
echo "</ol>" >>"$dest/$fichier"

# Ecriture de la fin du fichier
html_tail >>"$dest/$fichier"
