#!/usr/bin/python

import os
import sys

class Link:
    def __init__(self, filename, name, indent=1, dstFilename=None, sidebarFilename=None):
        self.srcFilename = filename
        self.dstFilename = filename[:-3] + '.html'
        if dstFilename:
            self.dstFilename = dstFilename
        self.sidebarFilename = self.dstFilename
        if sidebarFilename:
            self.sidebarFilename = sidebarFilename
        self.name = name
        self.indent = indent
  
'''
---
title: Index
permalink: index_temp.html
layout: default
---
''' 
links = ( 
  Link('home.md', 'Home', indent=0, sidebarFilename='index.html'),
  Link('designPhilosophy.md', 'Design Philosophy'),
  Link('whyAutolayout.md', 'Why Auto Layout?'),
  Link('whyWeView2.md', 'Why WeView 2?'),
  Link('whatsNewWeView2.md', 'What\'s new in WeView 2'),
  Link('License.md', 'License'),
  Link('Tutorial1.md', 'Tutorial 1: Examples'),
  Link('Tutorial2.md', 'Tutorial 2: Layouts'),
  Link('Tutorial3.md', 'Tutorial 3: Test'),
)

for index, link in enumerate(links):
    linkery = []
    if index > 0:
        prevLink = links[index - 1]
        linkery.append('Prev\: [%s](%s)' % (prevLink.name, prevLink.sidebarFilename,) )
    if index + 1 < len(links):
        nextLink = links[index + 1]
        linkery.append('Next\: [%s](%s)' % (nextLink.name, nextLink.sidebarFilename,) )
    linkery = '\n\n'.join(linkery)
    
    startMarker = '<!-- TEMPLATE START -->'
    endMarker = '<!-- TEMPLATE END -->'

    # print 'link.srcFilename', link.srcFilename
    with open(link.srcFilename, 'rt') as f:
        text = f.read()
        
    startIndex = text.index(startMarker)
    endIndex = text.index(endMarker)
    
# title: Index
    newText = '''---
permalink: %s
layout: default
---

%s

''' % (link.dstFilename, linkery)

    newText += text[startIndex:endIndex + len(endMarker)] + '\n\n' + linkery

    with open(link.srcFilename, 'wt') as f:
        f.write(newText)
        

headerFilepath = '_includes/header.html'

lines = []

for link in links:
    lines.append('''
			<li>%s<a href="%s">%s</a></li>
''' % ('&nbsp;' * (link.indent * 3), link.sidebarFilename, link.name))

sidebarHtml = '''
%s
''' % ('\n'.join(lines), )

with open(headerFilepath, 'rt') as f:
    text = f.read()

startMarker = '<!-- SIDEBAR START -->'
endMarker = '<!-- SIDEBAR END -->'
startIndex = text.index(startMarker)
endIndex = text.index(endMarker)

text = text[:startIndex + len(startMarker)] + sidebarHtml + text[endIndex:]

with open(headerFilepath, 'wt') as f:
    f.write(text)
    
