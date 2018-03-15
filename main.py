import os
from matchesdict import matches


def line_matches_dict(line):
    for k, v in matches.items():
        if k in line:
            print(k)
            print(v)
            return k, v
    return False


def check_file(file_path):
    with open(file_path) as fp:
        for linenumber, line in enumerate(fp):
            match = line_matches_dict(line)
            if match:
                pass#print("{}::{}: Found {} -> {}".format(file_path, linenumber, match[0], match[1]))


rootdir = '/home/marco/dev/GEM/oq-consolidate'
for subdir, dirs, files in os.walk(rootdir):
    for file in files:
        if '.py' in file:
            file_path = os.path.join(subdir, file)
            check_file(file_path)

