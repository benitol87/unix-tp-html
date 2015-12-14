cd $(dirname $0)

mkdir -p dest source

for name in img1.jpg img2.jpg pic.jpg
do
    ./make-img.sh source/"$name"
done
