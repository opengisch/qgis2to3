# -*- coding: utf-8 -*-
import json

newdict = {}

# load manual addition dict
with open('./manual_addition.json', 'r') as f:
    manual_addition = json.load(f)


print('merging duplicates')
with open('matches.txt', 'r') as f:
    for l in f:
        line = l.strip()
        # skip empty lines and lines with no key
        if not line or line.startswith(':>>>:'):
            continue
        try:
            k, v = line.split(':>>>:')
        except ValueError:
            continue
        if k in newdict and v not in newdict[k]:
            newdict[k].append(v)
        else:
            newdict[k] = [v]
print('creating python dict file')

newdict.update(manual_addition)

with open('matchesdict.py', 'w') as f:
    f.write('matches = ' + json.dumps(newdict, indent=4, sort_keys=True))

