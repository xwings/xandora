#!/usr/bin/python
# Copyright (C) 2011 KaiJern, Lau
#
# This is a simple dll function dumper
#

import hashlib
import time
import binascii
import string
import os, sys
import commands

try:
    import pefile
    import peutils
except ImportError:
    print 'pefile not installed, see http://code.google.com/p/pefile/'
    sys.exit()


if len(sys.argv) != 2:
	print "Usage: %s <targeted dll file>\n" % (sys.argv[0])
	sys.exit()

pe  = pefile.PE (sys.argv[1])

if hasattr(pe, 'DIRECTORY_ENTRY_EXPORT'):
                for exp in pe.DIRECTORY_ENTRY_EXPORT.symbols:
                                print exp.name

