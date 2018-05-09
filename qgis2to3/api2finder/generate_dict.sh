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
# extract text between "General changes" and "QGIS 2.6" lines (excluded)
cat "$fin" | sed -n '/^General changes /,/^QGIS 2.6/p' | \
    #
    # lines like:
    # "- expressionContext(), setExpressionContext(), setMapCanvas() and mapCanvas() have been removed in favor of setContext()/context()"
    # are split like following:
    # - expressionContext(), setExpressionContext(), setMapCanvas() and mapCanvas() have been removed in favor of setContext()/context()
    # - setExpressionContext(), setMapCanvas() and mapCanvas() have been removed in favor of setContext()/context()
    # - setMapCanvas() and mapCanvas() have been removed in favor of setContext()/context()
    # - mapCanvas() have been removed in favor of setContext()/context()
    # - have been removed in favor of setContext()/context()
    sed -n 's/^\(- \w\+().*\)/\1/g;T LAB;h;x;s/^-[, ]*\(\w*()\)\(.*\)/- \2/;T LAB; { x;p;x;s/^- , /- /g;s/-  and /- /g;s/^\(.*\)/\n\1/;D };:LAB;p' | \
    #
    # add the class name to the methods
    sed 's/^\([^ ]*\).*{#qgis_api_break_3_0.*/\1: /g; T LAB; h;d;:LAB;G;s/^\(.*\)\n\(.*\)/\2 \1/' | \
    grep '^\w\+: *- `\?[a-zA-Z0-9_]\+()`\?' | \
    sed "s/\"/'/g" | sed 's/^\(\w\+\): *- *\(\w\+\)()\(.*\)/\2:>>>:(class \1)\3/g' >> ${matches_file}

python merge_duplicates.py

