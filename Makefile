# Source and destination directories, to be configured here:
SOURCE=../exemples-html/galerie_style/
DEST=./dest

IMAGES=${shell cd $(SOURCE) && echo *.jpg}
THUMBS=$(IMAGES:%=$(DEST)/%)
IMAGE_DESC=$(IMAGES:%.jpg=$(DEST)/%.inc) 
LISTE_IMAGES=${shell cd source && ls *.jpg} # Les images présentes dans la page sont celles contenues dans le répertoire 'source' contenu dans celui du makefile
LISTE_INC=${shell echo $(LISTE_IMAGES) | sed s/.jpg/.inc/g} # Même liste que celle au-dessus en remplaçant les .jpg par .inc

%.inc: %.jpg
	./generate-img-fragment.sh $< >$@

index.html: $(LISTE_INC)
	./generate-index.sh

%.jpg: source/%.jpg
	convert -resize 200x200 $< $@

gallery: index.html $(LISTE_IMAGES)

view: gallery
	firefox index.html

clean:
	rm -f *.inc  

# Simplified version of exiftags's Makefile
EXIFTAGS_OBJS=exiftags-1.01/exif.o exiftags-1.01/tagdefs.o exiftags-1.01/exifutil.o \
	exiftags-1.01/exifgps.o exiftags-1.01/jpeg.o exiftags-1.01/makers.o \
	exiftags-1.01/canon.o exiftags-1.01/olympus.o exiftags-1.01/fuji.o \
	exiftags-1.01/nikon.o exiftags-1.01/casio.o exiftags-1.01/minolta.o \
	exiftags-1.01/sanyo.o exiftags-1.01/asahi.o exiftags-1.01/leica.o \
	exiftags-1.01/panasonic.o exiftags-1.01/sigma.o exiftags-1.01/exiftags.o
EXIFTAGS_HDRS=exiftags-1.01/exif.h exiftags-1.01/exifint.h \
	exiftags-1.01/jpeg.h exiftags-1.01/makers.h

%.o: %.c $(EXIFTAGS_HDRS)
	$(CC) $(CFLAGS) -o $@ -c $<

./exiftags: $(EXIFTAGS_OBJS)
	$(CC) $(CFLAGS) -o $@ $(EXIFTAGS_OBJS) -lm

