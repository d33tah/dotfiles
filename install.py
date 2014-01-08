#!/usr/bin/python

import sys
import os
import shutil

argv0 = os.path.abspath(sys.argv[0])

for filename in os.listdir('.'):
    if os.path.abspath(filename) == argv0 or filename.startswith('.'):
        continue
    target = os.environ['HOME'] + os.sep + '.' + filename
    print(target)
    if os.path.exists(target):
        shutil.move(target, target + "_")
    source = os.path.abspath(os.path.curdir) + os.sep + filename
    os.symlink(source, target)
