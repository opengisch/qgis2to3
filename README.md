[![Build status](https://travis-ci.org/opengisch/qgis2to3.svg?master)](https://travis-ci.org/opengisch/qgis2to3)
[![Release](https://img.shields.io/github/release/opengisch/qgis2to3.svg)](https://github.com/opengisch/qgis2to3/releases)

This repository includes two tools to help you migrate your QGIS 2 plugins 
to QGIS 3: `qgis2to3` and `qgis2apifinder`. Both tools are distributed as a 
Python package installable via 


## qgis2to3
The codeporting package is a copy of the files found in https://github
.com/qgis/QGIS/tree/master/scripts to allow for quick downloading and simple
 installation without the need of downloading the whole QGIS repository.
This is a set of fixers for the python 2to3 command that will update your 
Python 2 code to Python 3. The additional fixers will also take care of the 
PyQt4 to PyQt5 porting as well as some other things.


## qgis2apifinder
The api2finder package is a tool that helps you find usages of the QGIS API 
version 2 and proposes changes to API version 3

it is based on a machine parsing of https://qgis.org/api/api_break.html so 
the results are as good as the information there.
Also, being a simple parser, it just gives a hint where to look at. It is by 
no means a complete tool to find all the
possible API incompatibility.

Methods are matched just based on their names and not on their classes, so 
there might be various false positives.

## install
`pip install qgis2to3`

## Usage

### qgis2to3
```
Usage: qgis2to3 [options] file|dir ...

Options:
  -h, --help            show this help message and exit
  -d, --doctests_only   Fix up doctests only
  -f FIX, --fix=FIX     Each FIX specifies a transformation; default: all
  -j PROCESSES, --processes=PROCESSES
                        Run 2to3 concurrently
  -x NOFIX, --nofix=NOFIX
                        Prevent a transformation from being run
  -l, --list-fixes      List available transformations
  -p, --print-function  Modify the grammar so that print() is a function
  -v, --verbose         More verbose logging
  --no-diffs            Don't show diffs of the refactoring
  -w, --write           Write back modified files
  -n, --nobackups       Don't write backups for modified files
  -o OUTPUT_DIR, --output-dir=OUTPUT_DIR
                        Put output files in this directory instead of
                        overwriting the input files.  Requires -n.
  -W, --write-unchanged-files
                        Also write files even if no changes were required
                        (useful with --output-dir); implies -w.
  --add-suffix=ADD_SUFFIX
                        Append this string to all output filenames. Requires
                        -n if non-empty.  ex: --add-suffix='3' will generate
                        .py3 files.

```

### qgis2apifinder
```
qgis2apifinder [-h] [-s] [-a] [-n] path

Find usages of the QGIS api version 2 and propose changes for api version 3

positional arguments:
  path             File or directory to be analysed

optional arguments:
  -h, --help       show this help message and exit
  -s, --summarize  Show only the summaries for each analysed file
  -a, --all        Include very frequent words like ['layout', 'layer',
                   'fields'] in the analysis
  -n, --nonote     Do not show the note about false positives

```