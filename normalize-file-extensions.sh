#!/bin/bash

targetDir=''
dryRun='false'

while getopts 'df:v' flag; do
    case "${flag}" in
        d) dryRun='true' ;;
        f) targetDir="${OPTARG}" ;;
        *) error "unexpected option ${flag}" ;;
    esac
done

if ! [[ -n $targetDir ]]; then
    echo 'Must supply directory argument using "-f <DIR>", exiting...'
    exit
fi

if [[ $dryRun == 'true' ]]; then
    echo $'We are dry running. No files are being written\n'
fi

# JPEG -> JPG
while IFS= read -r -d '' file; do
    if [[ $dryRun == 'true' ]]; then
        a=$(echo "$file" | gsed 's/\(\.[^.]*$\)/.jpg/')
        echo mv "$file" "->" "${a}"
        echo $"\n"
    else
        a=$(echo "$file" | gsed 's/\(\.[^.]*$\)/.jpg/')
        mv "$file" "${a}"
    fi
done < <(find $targetDir -type f -name '*.jpeg' -print0)
