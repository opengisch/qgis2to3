#!/bin/bash
fin="qgis_api_break.dox"

dict_file=matchesdict.py


echo '# -*- coding: utf-8 -*-' >${dict_file}
echo 'matches = {' >>${dict_file}

echo 'moved classes'
cat "$fin" | sed -n '/^Moved Classes/,/<\/table/p'  | grep '^<tr><td>' | \
    sed 's/^<tr><td>\([^<]*\)<td>\([^<]*\)<td>\(.*\)/    "\2.\1": "\3.\1",/g' >> ${dict_file}

echo "renamed classes"
cat "$fin" | sed -n '/^Renamed Classes/,/<\/table/p'  | grep '^<tr><td>' | \
    sed 's/^<tr><td>\([^<]*\)<td>\(.*\)/    "\1": "\2",/g' >> ${dict_file}


echo "renamed enums"
cat "$fin" | sed -n '/^<caption id="renamed_enum_values">Renamed enum values/,/<\/table>/p' | grep '^<tr><td>' | \
    sed 's/^<tr><td>\([^<]*\)<td>\([^<]*\)<td>\(.*\)/    "\2": "\3",/g' >> ${dict_file}


echo "renamed method  names"
cat "$fin" | sed -n '/^<caption id="renamed_methods">Renamed method names/,/<\/table>/p' | grep '^<tr><td>' | \
    sed 's/^<tr><td>\([^<]*\)<td>\([^<]*\)<td>\(.*\)/    "\2": "\3",/g' >> ${dict_file}

cat "$fin" | sed -n '/^Removed Classes /,/^General changes/p' | grep '^-' | sed 's/^- //g;s/[\. ].*//g' | \
    sed 's/\(.*\)/    "\1": "=== Removed ===",/g' >> ${dict_file}

echo "free text changes"
cat "$fin" | sed -n '/^General changes /,/^QGIS 2.6/p' | grep '^- `\?[a-zA-Z0-9_]\+()`\?' | \
    sed 's/- `\?\([a-zA-Z0-9_]\+\)()`\? \?\(.*\)/    "\1": "\2",/g' >> ${dict_file}


echo '}' >> ${dict_file}