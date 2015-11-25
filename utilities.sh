DIR=$(cd "$(dirname "$0")" && pwd)
INCLUDE="include"

html_title(){
    echo "      <h1>$1</h1>"
}

html_head(){
    # $1 = titre de la page
    cat $DIR/snippets/head.html 
    echo "      <title>$1</title>"
    echo "      <link rel=\"stylesheet\" href=\"$DIR/$INCLUDE/bootstrap.min.css\"/>"
    echo "      <script src=\"$DIR/$INCLUDE/jquery.min.js\"></script>"
    echo "      <script src=\"$DIR/$INCLUDE/bootstrap.min.js\"></script>"
    echo "  </head>" 
    echo "  <body>"
    html_title "Galerie d'images"
    cat $DIR/snippets/body.html
}

html_tail(){
    cat $DIR/snippets/tail.html
}
