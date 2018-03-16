# -*- coding: utf-8 -*-

import os
import sys
import re

from matches.matchesdict import matches


TOTAL = 0
RESULTS = {}
REGXPS = {}


def line_matches_dict(line):
    global REGXPS
    for k, v in matches.items():
        if line.strip().startswith('#'):
            continue
        p = REGXPS[k]
        if p.match(line):
            return k, v
    return False, None


def check_file(file_path):
    global RESULTS, TOTAL

    match_counter = 0
    with open(file_path) as fp:
        for linenumber, line in enumerate(fp):
            match, message = line_matches_dict(line)
            if match:
                match_counter += 1
                print("{}::{}: Found {} -> {}".format(file_path, linenumber+1, match, message))

    RESULTS[file_path] = match_counter
    TOTAL += match_counter


def create_rgxps():
    for k in matches.keys():
        p = re.compile('.*\\b\.?{}\\b'.format(k))
        REGXPS[k] = p


def usage():
    print('Usages: \npython3 qgis_api2_usage_checker /path/to/plugin\n'
          'python3 qgis_api2_usage_checker /path/to/plugin/file.py')


if __name__ == "__main__":
    if len(sys.argv) > 1:
        rootdir = filename = sys.argv[1]

        if os.path.isfile(rootdir):
            create_rgxps()
            check_file(rootdir)
        elif os.path.isdir(rootdir):
            create_rgxps()
            for subdir, dirs, files in os.walk(rootdir):
                for file in files:
                    if file.endswith('.py'):
                        file_path = os.path.join(subdir, file)
                        check_file(file_path)
        else:
            usage()
            exit(0)
        print('\n')
        print('*' * 79)
        print('Found {} API2 usages\n'.format(TOTAL))
        print('Files with API2 usages:')
        for f, c in RESULTS.items():
            print('{} -> {} usages found'.format(f, c))
    else:
        usage()
