#!/bin/bash
# Dependencies
# - brew install gnu-sed for macOSX

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

while IFS= read -r -d '' file; do
    if [[ $dryRun == 'true' ]]; then
        a=$(echo "$file" | gsed 's/\(\.[^.]*$\)/\L\1/')
        echo mv "$file" "->" "${a}"
        echo $"\n"
    else
        a=$(echo "$file" | gsed 's/\(\.[^.]*$\)/\L\1/')
        mv "$file" "$a"
    fi
done < <(find $targetDir -type f -name '*.PNG' -print0 -o -name '*.JPEG' -print0 -o -name '*.JPG' -print0 -o -name '*.GIF' -print0 -o -name '*.TIFF' -print0 -o -name '*.TIF' -print0)
