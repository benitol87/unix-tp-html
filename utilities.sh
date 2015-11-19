DIR=$(cd "$(dirname "$0")" && pwd)

html_head(){
    # $1 = titre de la page
    cat snippets/head.html 
    echo "      <title>$1</title>"
    echo "      <link rel=\"stylesheet\" href=\"$DIR/bootstrap.min.css\"/>"
    echo "      <script src=\"$DIR/jquery.min.js\"></script>"
    echo "      <script src=\"$DIR/bootstrap.min.js\"></script>"
    echo "  </head>" 
    cat snippets/body.html
}

html_tail(){
    cat snippets/tail.html
}

html_title(){
    echo "      <h1>$1</h1>"
}
