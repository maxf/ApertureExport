#!/bin/bash

echo 1. retrieving aperture data
if [ "/Users/mf/Pictures/Aperture Library.aplibrary/ApertureData.xml" -nt ApertureData.xml ]
then
  cp "/Users/mf/Pictures/Aperture Library.aplibrary/ApertureData.xml" .
  echo 2. generating script
  make photos.sh
  echo 3. running script
  ./photos.sh
  echo 4. removing unused files
  ./remove-extras.sh

  echo 5. copying to device
  echo Please make sure device is connected as /Volumes/NO NAME/ and press enter.
  read
  rsync -rvhu --delete photos "/Volumes/NO NAME/media"
else
  echo No new version of ApertureData.xml. Ending.
fi


