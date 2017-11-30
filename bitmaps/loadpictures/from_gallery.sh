#!/bin/bash

GALLERY_PATH="../../../spring1944.github.io/media/media/large"
LOGO_FILE="./resources/S44-logo-vector.png"

count=0
for i in $GALLERY_PATH/*.png; do
    # Convert the file, resizing it
    echo $i;
    o=$(printf "%03d.jpg" $count)
    echo $o
    convert $file -geometry 1024x $i $o;

    # Add the logo
    composite -gravity SouthWest $LOGO_FILE $o $o
    
    (( count++ ))
done
