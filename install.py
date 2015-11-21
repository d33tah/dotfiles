#!/usr/bin/python

import sys
import os
import shutil

EXCLUDED = ['requirements.txt']
argv0 = os.path.abspath(sys.argv[0])

# TODO:
#
# Don't overwrite bin
# If the symlink points to the same place, don't overwrite it.

def file_exists(path):
    try:
        os.stat(path)
        return True
    except OSError:
        # we got a "file does not exist". perhaps it's a broken link?
        try:
            os.readlink(path)
            return True
        except OSError:
            pass
    return False

for fn in os.listdir('.'):
    if os.path.abspath(fn) == argv0 or fn.startswith('.') or fn in EXCLUDED:
        continue
    # Don't add a dot for bin-scripts files.
    if fn not in ['bin-scripts']:
        target = os.environ['HOME'] + os.sep + '.' + fn
    else:
        target = os.environ['HOME'] + os.sep + fn
    print(target)
    if file_exists(target):
        new_target = target + "_"
        while file_exists(new_target):
            new_target = new_target + "_"
        shutil.move(target, new_target)
    source = os.path.abspath(os.path.curdir) + os.sep + fn
    os.symlink(source, target)
