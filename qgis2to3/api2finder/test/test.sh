#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
python3 ${DIR}/../qgis2apifinder -na ${DIR}/test_file.txt > test_result.txt


function match_text {
    grep -q "$1" test_result.txt
    return $?
}

function find_text {
    echo "Searching:" \"$1\"
    if match_text "$1"
    then
        echo "Ok"
    else
        echo "Fail"
        exit 1
    fi
}

function not_find_text {
    echo "Avoiding:" \"$1\"
    if ! match_text "$1"
    then
        echo "Ok"
    else
        echo "Fail"
        exit 1
    fi
}

find_text "Found 11 API2 usages"
find_text "test_file.txt::2: Found QgsAttributeAction"
find_text "test_file.txt::3: Found QgsZonalStatistics"
find_text "test_file.txt::4: Found QgsZonalStatistics"
find_text "test_file.txt::5: Found QgsZonalStatistics"
find_text "test_file.txt::6: Found QgsZonalStatistics"
find_text "test_file.txt::7: Found QgsZonalStatistics"
find_text "test_file.txt::8: Found QgsZonalStatistics"
find_text "test_file.txt::9: Found QgsZonalStatistics"
not_find_text "test_file.txt::12: Found QgsZonalStatistics"
not_find_text "test_file.txt::13: Found QgsZonalStatistics"
not_find_text "test_file.txt::14: Found QgsZonalStatistics"
not_find_text "test_file.txt::15: Found QgsZonalStatistics"
not_find_text "test_file.txt::16: Found QgsZonalStatistics"
find_text "test_file.txt::19: Found layout"
find_text "test_file.txt::20: Found fields"
find_text "test_file.txt::21: Found layer"

echo "All tests OK"
exit 0