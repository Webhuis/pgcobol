#!/usr/bin/env python3

'''
Simple Python script for the gixsql gnucobol compilation workflow.
The script accepts program names in the style:
    "program_name"."cbl" or "program_name"."cob"
The program_name has not dots in it.

The programs gixsql and cobc can also be executed manually, if specific parameters are required.
'''

import sys
import re
from subprocess import Popen, PIPE

if len(sys.argv) == 1:
  print ('Enter program name with suffix .cbl or .cob')
  sys.exit(1)

program_name = sys.argv[1]
program_list = program_name.split('.')
if len(program_list) == 2:
  if program_list[1] in ['cbl','cob']:
    pass
  else:
    print('Program name has to be one word, a comma and a suffix ".cbl" or ".cob".')
    sys.exit(3)

else:
  print('Program name has to be one word, a comma and a suffix ".cbl" or ".cob".')
  sys.exit(2)

program = program_list[0]

command = '/usr/bin/gixsql {} {}.cbsql -S -I . -e ".,*.cpy,*.CPY"'.format(program_name, program)
print(command)
try:
  process = Popen(command, shell=True, stdout=PIPE, stderr=PIPE)
  stdout, stderr = process.communicate()
except Exception:
  print("Error in gix precompile")
  sys.exit(4)

command = '/usr/bin/cobc -x {0}.cbsql -l:libgixsql.so -T {0}.out'.format(program)
print(command)
try:
  process = Popen(command, shell=True, stdout=PIPE, stderr=PIPE)
  stdout, stderr = process.communicate()
except Exception:
  print("Error in cobc compile")
  sys.exit(5)

