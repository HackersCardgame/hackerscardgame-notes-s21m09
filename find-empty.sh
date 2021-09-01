#!/bin/bash
IFS=$'\n'
for i in $(ls /mnt/d/Music.noDupes/Compilations)
do
    [ -z "`find $i -type f`" ] && echo "$i is empty"
done

