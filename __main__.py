import os
import sys

from matchesdict import matches


def line_matches_dict(line):
    for k, v in matches.items():
        if k in line:
            return k, v
    return False, None


def check_file(file_path):
    with open(file_path) as fp:
        for linenumber, line in enumerate(fp):
            match, message = line_matches_dict(line)
            if match:
                print("{}::{}: Found {} -> {}".format(file_path, linenumber, match, message))


if __name__ == "__main__":
    if len(sys.argv) > 1:
        rootdir = filename = sys.argv[1]
        for subdir, dirs, files in os.walk(rootdir):
            for file in files:
                if '.py' in file:
                    file_path = os.path.join(subdir, file)
                    check_file(file_path)
    else:
        print('Usage: python3 api_usage_checker /path/to/plugin')
