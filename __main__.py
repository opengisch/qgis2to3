# -*- coding: utf-8 -*-

import os
import sys

from matches.matchesdict import matches


TOTAL = 0
RESULTS = {}


def line_matches_dict(line):
    for k, v in matches.items():
        if k in line:
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
                print("{}::{}: Found {} -> {}".format(file_path, linenumber, match, message))

    RESULTS[file_path] = match_counter
    TOTAL  += match_counter


def usage():
    print('Usages: \npython3 qgis_api2_usage_checker /path/to/plugin\npython3 qgis_api2_usage_checker /path/to/plugin/file.py')


if __name__ == "__main__":
    if len(sys.argv) > 1:
        rootdir = filename = sys.argv[1]

        if os.path.isfile(rootdir):
            check_file(rootdir)
        elif os.path.isdir(rootdir):
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
        print('Found {} API 2 usages\n'.format(TOTAL))
        print('Files with API 2 usages:')
        for f, c in RESULTS.items():
            print('{} -> {} usages found'.format(f, c))
    else:
        usage()
