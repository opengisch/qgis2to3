# -*- coding: utf-8 -*-

import argparse
import os
import sys
import re

from matches.matchesdict import matches

TOTAL = 0
RESULTS = {}
REGXPS = {}
VERBOSE_KEYS = ['layout', 'layer', 'fields']


def line_matches_dict(line):
    global REGXPS
    if line.strip().startswith('#'):
        return False, None

    for k, v in matches.items():
        if not include_verbose_keys and k in VERBOSE_KEYS:
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
                if not summarize:
                    print("{}::{}: Found {} -> {}".format(
                        file_path, linenumber + 1, match, message))

    if match_counter > 0:
        RESULTS[file_path] = match_counter
    TOTAL += match_counter


def create_rgxps():
    for k in matches.keys():
        p = re.compile('.*\\b\.?{}\\b'.format(k))
        REGXPS[k] = p


def print_note():
    print('\n')
    print('#' * 79)
    print('NOTE:')
    readme = os.path.dirname(os.path.realpath(__file__))
    readme = os.path.join(readme, 'README.md')
    with open(readme, 'r') as f:
        for line in f:
            if '# Usage' in line:
                print('#' * 79)
                break
            print(line.rstrip())


def is_path_valid(arg):
    if not os.path.exists(arg):
        parser.error("The path %s does not exist!" % arg)
    else:
        return arg


def print_results():
    print('\n')
    print('*' * 79)
    print('Found {} API2 usages\n'.format(TOTAL))
    print('Files with API2 usages:')
    for f, c in RESULTS.items():
        print('{} -> {} usages found'.format(f, c))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Find usages of the QGIS api version 2 and propose '
                    'changes for api version 3')

    # parser arguments
    parser.add_argument(
        '-s', '--summarize',
        action="store_true",
        help='Show only the summaries for each analysed file')
    parser.add_argument(
        '-a', '--all',
        action="store_true",
        help='Include very frequent words like {} in the '
        'analysis'.format(VERBOSE_KEYS))
    parser.add_argument(
        'path',
        type=lambda arg: is_path_valid(arg),
        help='File or directory to be analysed')

    # enforce arguments check
    args = parser.parse_args()
    rootdir = filename = sys.argv[1]

    # catch options
    # --summary
    summarize = args.summarize
    # --all
    include_verbose_keys = args.all

    create_rgxps()
    if os.path.isfile(rootdir):
        check_file(rootdir)
    else:
        for subdir, dirs, files in os.walk(rootdir):
            for file in files:
                if file.endswith('.py'):
                    file_path = os.path.join(subdir, file)
                    check_file(file_path)

    print_results()
    print_note()
