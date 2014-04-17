#!/usr/bin/python

import os
import sys
import cgi

class Link:
    def __init__(self, filename, name, indent=1, dstFilename=None, sidebarFilename=None, pageTitle=None, groupKey=None):
        self.srcFilename = filename
        self.dstFilename = filename[:-3] + '.html'
        if dstFilename:
            self.dstFilename = dstFilename
        self.sidebarFilename = self.dstFilename
        if sidebarFilename:
            self.sidebarFilename = sidebarFilename
        self.name = name
        self.indent = indent
        self.pageTitle = name
        self.groupKey = groupKey
        if pageTitle:
            self.pageTitle = pageTitle

'''
---
title: Index
permalink: index_temp.html
layout: default
---
'''
links = (
  Link('home.md', 'Home', indent=0, sidebarFilename='index.html', pageTitle='WeView 2'),
  Link('whyAutolayout.md', 'Why use Dynamic Layout?'),
  Link('whyWeView2.md', 'Why use WeView 2?'),
  Link('TutorialOverview.md', 'Overview', groupKey='Tutorial'),
  Link('TutorialInstalling.md', 'Installing', groupKey='Tutorial'),
  Link('TutorialTerminology.md', 'Terminology', groupKey='Tutorial'),
  Link('TutorialBasics.md', 'Basics', groupKey='Tutorial'),
  Link('TutorialLayoutModel.md', 'Layout Model', groupKey='Tutorial'),
  Link('TutorialLayoutProperties.md', 'Layout Properties', groupKey='Tutorial'),
  Link('TutorialSubviewProperties.md', 'Subview Properties', groupKey='Tutorial'),
  Link('TutorialLayouts.md', 'The Layouts', groupKey='Tutorial'),
  Link('TutorialGridLayout.md', 'Grid Layout', groupKey='Tutorial'),
  Link('TutorialDesiredSize.md', 'Sizing', groupKey='Tutorial'),
  Link('TutorialStretch.md', 'Stretch', groupKey='Tutorial'),
  Link('TutorialDiscussion.md', 'Discussion', groupKey='Tutorial'),
  Link('TutorialConvenience.md', 'Conveniences', groupKey='Tutorial'),
  Link('TutorialIPhoneDemo.md', 'Example', groupKey='Tutorial'),
  Link('DemoApp.md', 'Demo App'),
  Link('FAQ.md', 'FAQ'),
  Link('Issues.md', 'Bugs & Feature Requests'),
  Link('designPhilosophy.md', 'Design Philosophy'),
  Link('whatsNewWeView2.md', 'What\'s New in WeView 2'),
  Link('License.md', 'License'),
  Link('CHANGELOG.md', 'Change Log'),
  Link('Acknowledgments.md', 'Acknowledgments'),
)
# Layout model - Cells.
# FAQ
# Text wrapping.

linkGroupMap = {}
for index, link in enumerate(links):
  if link.groupKey:
    groupIndex = linkGroupMap.get(link.groupKey, 1)
    link.name = '%s %d: %s' % (link.groupKey, groupIndex, link.name, )
    link.pageTitle = link.name
    linkGroupMap[link.groupKey] = groupIndex + 1

for index, link in enumerate(links):
    linkery = []
    # if index > 0:
    #     prevLink = links[index - 1]
    #     linkery.append('Prev\: [%s](%s)' % (prevLink.name, prevLink.sidebarFilename,) )
    if index + 1 < len(links):
        nextLink = links[index + 1]
        linkery.append('<p class="nextLink">%s <a href="%s">%s</a></p>' % ('Next: ', nextLink.sidebarFilename, cgi.escape(nextLink.name), ))
        # linkery.append('Next\: [%s](%s)' % (nextLink.name, nextLink.sidebarFilename,) )

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

# %s


''' % (link.dstFilename, link.pageTitle, )

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
