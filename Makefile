# Source and destination directories, to be configured here:
SOURCE=./source
DEST=./dest
 
LISTE_IMAGES=${shell cd $(SOURCE) && echo *.jpg} # Les images présentes dans la page sont celles contenues dans le répertoire 'source' contenu dans celui du makefile
LISTE_INC=$(LISTE_IMAGES:%.jpg=$(DEST)/%.inc) # Même liste que celle au-dessus en remplaçant les .jpg par .inc

$(DEST)/%.inc: $(SOURCE)/%.jpg 
	./generate-img-fragment.sh ${shell echo $< | cut -d'/' -f2} " " " " "../$<"  >$@

index.html: $(LISTE_INC)
	./generate-index.sh $(DEST)

%.jpg: $(SOURCE)/%.jpg
	convert -resize 200x200 $< $(DEST)/$@

.PHONY: gallery
gallery: index.html $(LISTE_IMAGES)

.PHONY: view
view: gallery
	firefox $(DEST)/index.html

.PHONY: clean
clean:
	rm -f $(DEST)/*.inc  
	rm -f $(DEST)/*.jpg

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

