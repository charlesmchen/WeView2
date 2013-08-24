#!/usr/bin/python

import os, sys, types
from collections import OrderedDict

folderPath = os.path.abspath('WeView2')
if (not os.path.exists(folderPath) or
    not os.path.isdir(folderPath)):
    raise Exception('Invalid folderPath: %s' % folderPath)

hFilePath = os.path.join(folderPath, 'UIView+WeView2.h')
mFilePath = os.path.join(folderPath, 'UIView+WeView2.m')

for filePath in (hFilePath, mFilePath, ):
    if (not os.path.exists(filePath) or
        not os.path.isfile(filePath)):
        raise Exception('Invalid filePath: %s' % filePath)


def replaceBlock(filePath, blockStartKey, blockEndKey, block):
    with open(filePath, 'rt') as f:
        text = f.read()

    startMarker = '/* CODEGEN MARKER: %s */' % blockStartKey
    endMarker = '/* CODEGEN MARKER: %s */' % blockEndKey
    startIndex = text.find(startMarker)
    endIndex = text.find(endMarker)
    if startIndex < 0:
        raise Exception('Missing block marker: %s in file:' % (startMarker, filePath, ))
    if endIndex < 0:
        raise Exception('Missing block marker: %s in file:' % (endMarker, filePath, ))

    before = text[0:startIndex + len(startMarker)]
    after = text[endIndex:]
    text = before + block + after

    endIndex = text.find(endMarker)

    with open(filePath, 'wt') as f:
        f.write(text)


class Property:
    def __init__(self, name, typeName, defaultValue=None, asserts=None, comments=None):
        self.name = name
        self.typeName = typeName
        self.defaultValue = defaultValue
        self.asserts = asserts
        self.comments = comments

    def UpperName(self):
        return self.name[0].upper() + self.name[1:]


propertyGroups = (
                  (
                   Property('minWidth', 'CGFloat', asserts='%s >= 0', ),
                   Property('maxWidth', 'CGFloat', defaultValue="CGFLOAT_MAX", asserts='%s >= 0',  ),
                   Property('minHeight', 'CGFloat', asserts='%s >= 0', ),
                   Property('maxHeight', 'CGFloat', defaultValue="CGFLOAT_MAX", asserts='%s >= 0', ),
                   ),
                  (
                   Property('hStretchWeight', 'CGFloat', asserts='%s >= 0', ),
                   Property('vStretchWeight', 'CGFloat', asserts='%s >= 0', ),
                   Property('ignoreNaturalSize', 'BOOL', ),
                   ),
                  (
                   Property('leftMargin', 'CGFloat', ),
                   Property('rightMargin', 'CGFloat', ),
                   Property('topMargin', 'CGFloat', ),
                   Property('bottomMargin', 'CGFloat', ),
                   ),
                  (
                   Property('vSpacing', 'CGFloat', ),
                   Property('hSpacing', 'CGFloat', ),
                   ),
                  # (
                  #  Property('hAlign', 'HAlign', ),
                  #  Property('vAlign', 'VAlign', ),
                  #  ),
                  (
                   Property('debugName', 'NSString *', defaultValue="@\"?\"", ),
                   Property('debugLayout', 'BOOL', ),
                   ),

                  )

def FormatList(values):
    if len(values) > 1:
        return ', '.join(values[:-1]) + ' and ' + values[-1]
    else:
        return values[0]

def FormatComment(comment):
    # TODO: linewrap the comments.
    return '// %s\n' % comment

def UpperName(name):
    return name[0].upper() + name[1:]

class PseudoProperty:
    def __init__(self, name, typeName, propertyList, valueList=None, comments=None):
        self.name = name
        self.typeName = typeName
        self.propertyList = propertyList
        self.valueList = valueList
        self.comments = comments

    def propertyNames(self):
        return self.propertyList

    def UpperName(self):
        return UpperName(self.name)

pseudoProperties = (
                    PseudoProperty('minSize', 'CGSize', ('minWidth', 'minHeight',), ('.width', '.height',)),
                    PseudoProperty('maxSize', 'CGSize', ('maxWidth', 'maxHeight',), ('.width', '.height',)),

                    PseudoProperty('fixedWidth', 'CGFloat', ('minWidth', 'maxWidth',)),
                    PseudoProperty('fixedHeight', 'CGFloat', ('minHeight', 'maxHeight',)),
                    PseudoProperty('fixedSize', 'CGSize', ('minWidth', 'minHeight', 'maxWidth', 'maxHeight',), ('.width', '.height', '.width', '.height',)),

                    PseudoProperty('stretchWeight', 'CGFloat', ('vStretchWeight', 'hStretchWeight',)),

                    PseudoProperty('hMargin', 'CGFloat', ('leftMargin', 'rightMargin',)),
                    PseudoProperty('vMargin', 'CGFloat', ('topMargin', 'bottomMargin',)),
                    PseudoProperty('margin', 'CGFloat', ('leftMargin', 'rightMargin', 'topMargin', 'bottomMargin',)),

                    PseudoProperty('spacing', 'CGFloat', ('hSpacing', 'vSpacing',)),
                    )

lines = []
lines.append('')
lines.append('')
for propertyGroup in propertyGroups:
    for property in propertyGroup:
        # Getter
        lines.append('- (%s)%s;' % (property.typeName, property.name, ))
        # Setter
        lines.append('- (id)set%s:(%s)value;' % (property.UpperName(), property.typeName, ))

    lines.append('')

for pseudoProperty in pseudoProperties:
    comments = []
    comments.append(FormatComment('Sets the %s properties.' % FormatList(pseudoProperty.propertyNames())))
    lines.append('%s- (id)set%s:(%s)value;\n' % ('\n'.join(comments), pseudoProperty.UpperName(), pseudoProperty.typeName, ))
lines.append('')
block = '\n'.join(lines)

replaceBlock(hFilePath, 'Start', 'End', block)

# --------

lines = []
lines.append('')
lines.append('')
for propertyGroup in propertyGroups:
    for property in propertyGroup:
        lines.append('static const void *kWeView2Key_%s = &kWeView2Key_%s;' % (property.UpperName(), property.UpperName(), ))

    lines.append('')
lines.append('')
block = '\n'.join(lines)

replaceBlock(mFilePath, 'Keys Start', 'Keys End', block)

# --------

lines = []
lines.append('')
for propertyGroup in propertyGroups:
    for property in propertyGroup:
        asserts = ''
        if property.asserts:
            if type(property.asserts) == types.StringType:
                asserts ='\n    WeView2Assert(%s);' % (property.asserts % 'value', )
                pass
            else:
                raise Exception('Unknown asserts: %s' % str(property.asserts))
        if property.typeName == 'CGFloat':
            getterName = 'associatedFloat'
            setterName = 'setAssociatedFloat'
        elif property.typeName == 'BOOL':
            getterName = 'associatedBoolean'
            setterName = 'setAssociatedBoolean'
        elif property.typeName == 'NSString *':
            getterName = 'associatedString'
            setterName = 'setAssociatedString'
        else:
            raise Exception('Unknown typeName: %s' % str(property.typeName))
        defaultValue = ''
        if property.defaultValue:
            defaultValue = ' defaultValue:%s' % property.defaultValue
        lines.append('''
- (%s)%s
{
    return [self %s:kWeView2Key_%s%s];
}

- (id)set%s:(%s)value
{%s
    [self %s:value key:kWeView2Key_%s];
    return self;
}''' % (property.typeName, property.name, getterName, property.UpperName(), defaultValue, property.UpperName(), property.typeName, asserts, setterName, property.UpperName(), ))

for pseudoProperty in pseudoProperties:
    asserts = ''
    #     if pseudoProperty.asserts:
    #         if type(pseudoProperty.asserts) == types.StringType:
    #             asserts ='\n    WeView2Assert(%s);' % (property.asserts % 'value', )
    #             pass
    #         else:
    #             raise Exception('Unknown asserts: %s' % str(property.asserts))
    subsetters = []
    for index, propertyName in enumerate(pseudoProperty.propertyNames()):
        valueName = 'value'
        if pseudoProperty.valueList:
            valueName += pseudoProperty.valueList[index]
        subsetters.append('    [self set%s:%s];' % (UpperName(propertyName), valueName,))

    lines.append('''
- (id)set%s:(%s)value
{
%s
    return self;
}''' % (pseudoProperty.UpperName(), pseudoProperty.typeName, '\n'.join(subsetters), ))

lines.append('')
lines.append('')
block = '\n'.join(lines)

replaceBlock(mFilePath, 'Accessors Start', 'Accessors End', block)

# --------

lines = []
lines.append('')
for propertyGroup in propertyGroups:
    for property in propertyGroup:
        lines.append('''
    if (objc_getAssociatedObject(self, kWeView2Key_%s))
    {
        [result appendString:[self formatLayoutDescriptionItem:@"%s"
                                                         value:objc_getAssociatedObject(self, kWeView2Key_%s)]];
    }''' % (property.UpperName(), property.name, property.UpperName(), ))

lines.append('')
lines.append('')
block = '\n'.join(lines)

replaceBlock(mFilePath, 'Debug Start', 'Debug End', block)

# --------

print 'Complete.'
