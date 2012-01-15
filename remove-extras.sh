#!/bin/bash
# remove old pictures

find photos -type d -print0 | while read -d $'\0' i
do
    if grep -q "$i" directories.txt;
    then
        : #echo $i in
    else
        echo deleting $i 
        rm -r "$i"
    fi
done
exit
find photos -type f -print0 | while read -d $'\0' i
do
    if grep -q "$i" files.txt;
    then
        : #echo $i in
    else
	echo deleting $i 
	rm -f "$i"
    fi
done
