#!/bin/bash
# remove old pictures

for i in `find photos -type d`;
do
    if grep -q "$i" directories.txt;
    then
        : #echo $i in
    else
	echo deleting $i 
	rm -rf "$i"
    fi
done

for i in `find photos -type f`;
do
    if grep -q "$i" files.txt;
    then
        : #echo $i in
    else
	echo deleting $i 
	rm -f "$i"
    fi
done
