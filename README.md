This tool finds usages of the QGIS api version 2 and proposes changes for api version 3

it is based on a machine parsing of https://qgis.org/api/api_break.html so the result are as good as the information there.
Also being a simple parser, it just give an hint were to look at. It is by no means a complete tool to find all the 
possible API incompatiblity.

Methods are matched just based on their names and not on their classes, so there might be various false positives.

Usage:
`python3 qgis_api2_usage_checker /path/to/plugin`
`python3 qgis_api2_usage_checker /path/to/plugin/file.py`