#!/usr/bin/python2.7

import sys
import os

packages= sys.argv[1:]

os.system("apt-get install -y %s" % " ".join(packages))
