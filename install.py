#!/usr/bin/python

import sys
import os
import shutil

argv0 = os.path.abspath(sys.argv[0])

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

for filename in os.listdir('.'):
    if os.path.abspath(filename) == argv0 or filename.startswith('.'):
        continue
    if filename != 'bin':
        target = os.environ['HOME'] + os.sep + '.' + filename
    else:
        target = os.environ['HOME'] + os.sep + filename
    print(target)
    if file_exists(target):
        new_target = target + "_"
        while file_exists(new_target):
            new_target = new_target + "_"
        shutil.move(target, new_target)
    source = os.path.abspath(os.path.curdir) + os.sep + filename
    os.symlink(source, target)
