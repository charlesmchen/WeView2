#!/usr/bin/python

import os
import sys
import commands
    
videosDirPath = os.path.abspath(os.path.join(os.curdir, 'videos'))
print 'videosDirPath', videosDirPath

rmCmds = []
for filename in os.listdir(videosDirPath):
    print 'filename', filename
    # filePath = os.
    cmd = 'grep -rl --binary-files=without-match "%s" "%s" ' % ( filename, os.path.abspath(os.curdir), )
    print '\t', cmd
    
    cmdOutput = commands.getstatusoutput(cmd)
    print '\t\t', 'cmdOutput', len(cmdOutput), cmdOutput
    code, output = cmdOutput
    if code not in (0, 256,):
        raise Exception('Invalid code: ' + str(code))
    if len(output) == 0:
        filePath = os.path.abspath(os.path.join(videosDirPath, filename))
        print '\t\t', 'to delete:', filePath
        rmCmds.append(filePath)

print

for filePath in rmCmds:
    cmd = 'rm "%s" ' % ( filePath, )
    print '\t', cmd
            