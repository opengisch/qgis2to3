#!/bin/bash
fin="$1"

dict_file=matchesdict.py

echo 'matches = {' >${dict_file}

# moved classes
cat "$fin" | sed -n '/^Moved Classes/,/<\/table/p'  | grep '^<tr><td>' | \
    sed 's/^<tr><td>\([^<]*\)<td>\([^<]*\)<td>\(.*\)/    "\2.\1": "\3.\1",/g' >> ${dict_file}

echo "ZIZIZI1"

# renamed classes
cat "$fin" | sed -n '/^Renamed Classes/,/<\/table/p'  | grep '^<tr><td>' | \
    sed 's/^<tr><td>\([^<]*\)<td>\(.*\)/    "\1": "\2",/g' >> ${dict_file}

echo "ZIZIZI2"

# renamed enums
cat "$fin" | sed -n '/^<caption id="renamed_enum_values">Renamed enum values/,/<\/table>/p' | grep '^<tr><td>' | \
    sed 's/^<tr><td>\([^<]*\)<td>\([^<]*\)<td>\(.*\)/    "\2": "\3",/g' >> ${dict_file}


echo "ZIZIZI3"
# renamed method  names
cat "$fin" | sed -n '/^<caption id="renamed_methods">Renamed method names/,/<\/table>/p' | grep '^<tr><td>' | \
    sed 's/^<tr><td>\([^<]*\)<td>\([^<]*\)<td>\(.*\)/    "\2": "\3",/g' >> ${dict_file}

echo "ZIZIZI4"
cat "$fin" | sed -n '/^Removed Classes /,/^General changes/p' | grep '^-' | sed 's/^- //g;s/[\. ].*//g' | \
    sed 's/\(.*\)/    "\1": "=== Removed ===",/g' >> ${dict_file}

echo "ZIZIZI5"

cat "$fin" | sed -n '/^General changes /,/^QGIS 2.6/p' | grep '^- `\?[a-zA-Z0-9_]\+()`\?' | \
    sed 's/- `\?\([a-zA-Z0-9_]\+\)()`\? \?\(.*\)/    "\1": "\2",/g' >> ${dict_file}


echo '}' >> ${dict_file}