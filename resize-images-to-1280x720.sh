#!/bin/bash

targerDir=''
startNumber=1
destinationDir="Library-Resize"

while getopts 's:g:d:' flag; do 
    case ${flag} in
        d) destinationDir=${OPTARG} ;;
        g) targetGlob=${OPTARG} ;;
        s) startNumber=${OPTARG} ;;
        *) error "unexpected option ${flag}" ;;
    esac
done

ffmpeg_glob() {
    if ! [[ -n $targetGlob ]]; then
        echo "Must supply a target glob -g dir/**/*.jpg"
        exit
    fi

    ffmpeg -pattern_type glob -i \
        "$targetGlob" \
        -q:v 2 \
        -vf "scale=w=1280:h=720:flags=lanczos:force_original_aspect_ratio=1,pad=1280:720:(ow-iw)/2:(oh-ih)/2" \
        -start_number "$startNumber" \
        "$destinationDir/film_sequence-%4d.jpg"
}

ffmpeg_glob
