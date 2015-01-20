#!/bin/bash

srcfile=src/com/cc/assets/GameDataPreloader.as
md5=/usr/bin/md5sum
for hashfile in $(find src/staging/configs -name '*.data')
do
	sum=$($md5 $hashfile | awk '{print $1}')
	echo "Substituting md5 checksum for $hashfile: $sum"
	sed "s/\"\($(basename $hashfile)\)\"\: *\"\([^\"]*\)\"/\"\1\": \"${sum}\"/g" < $srcfile > $srcfile.tmp
	mv $srcfile.tmp $srcfile
done 
