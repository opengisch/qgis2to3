#!/bin/bash
fin="data/qgis_api_break.dox"

matches_file=matches.txt


echo '' >${matches_file}

echo 'moved classes'
cat "$fin" | sed -n '/^Moved Classes/,/<\/table/p'  | grep '^<tr><td>' | sed "s/\"/'/g" | \
    sed 's/^<tr><td>\([^<]*\)<td>\([^<]*\)<td>\(.*\)/\2.\1:>>>:==Moved to== \3    .\1/g' >> ${matches_file}

echo "renamed classes"
cat "$fin" | sed -n '/^Renamed Classes/,/<\/table/p'  | grep '^<tr><td>' | sed "s/\"/'/g" | \
    sed 's/^<tr><td>\([^<]*\)<td>\(.*\)/\1:>>>:==Renamed to== \2/g' >> ${matches_file}


echo "renamed enums"
cat "$fin" | sed -n '/^<caption id="renamed_enum_values">Renamed enum values/,/<\/table>/p' | grep '^<tr><td>' | \
    sed "s/\"/'/g" | sed 's/^<tr><td>\([^<]*\)<td>\([^<]*\)<td>\(.*\)/\2:>>>:==Renamed enum to == \3/g' >> ${matches_file}


echo "renamed method  names"
cat "$fin" | sed -n '/^<caption id="renamed_methods">Renamed method names/,/<\/table>/p' | grep '^<tr><td>' | \
    sed "s/\"/'/g" | sed 's/^<tr><td>\([^<]*\)<td>\([^<]*\)<td>\(.*\)/\2:>>>:==Renamed method to== \3/g' >> ${matches_file}

cat "$fin" | sed -n '/^Removed Classes /,/^General changes/p' | grep '^-' | sed 's/^- //g' | sed "s/\"/'/g" | \
 sed -r 's/(\w*)[\. ]?(.*)/\1:>>>:==Removed== \2/' >> ${matches_file}

echo "free text changes"
cat "$fin" | sed -n '/^General changes /,/^QGIS 2.6/p' | grep '^- `\?[a-zA-Z0-9_]\+()`\?' | \
    sed "s/\"/'/g" | sed 's/- `\?\([a-zA-Z0-9_]\+\)()`\? \?\(.*\)/\1:>>>:==General change== \2/g' >> ${matches_file}


python merge_duplicates.py