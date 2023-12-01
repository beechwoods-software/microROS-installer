#!/bin/bash
curdir=`pwd`

checkd()
{
    cd $curdir/$1
    pwd
    git status
}

for d in *; do
    [ -d $d ] || continue
    find $d -type d -name .git | sed 's/..git$//' | while read g; do
        checkd $g
    done
done
