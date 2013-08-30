#!/usr/bin/python

import os, sys, types
from collections import OrderedDict

folderPath = os.path.abspath('WeView2')
if (not os.path.exists(folderPath) or
    not os.path.isdir(folderPath)):
    raise Exception('Invalid folderPath: %s' % folderPath)

hFilePath = os.path.join(folderPath, 'UIView+WeView2.h')
mFilePath = os.path.join(folderPath, 'UIView+WeView2.m')
viewInfohFilePath = os.path.join(folderPath, 'WeView2ViewInfo.h')
viewInfomFilePath = os.path.join(folderPath, 'WeView2ViewInfo.m')
ViewEditorController_hFilePath = os.path.join(folderPath, '..', 'WeViews2DemoApp', 'WeViews2DemoApp', 'ViewEditorController.h')
ViewEditorController_mFilePath = os.path.join(folderPath, '..', 'WeViews2DemoApp', 'WeViews2DemoApp', 'ViewEditorController.m')

for filePath in (hFilePath, mFilePath,
                    viewInfohFilePath, viewInfomFilePath,
                    ViewEditorController_hFilePath,
                    ViewEditorController_mFilePath,
                     ):
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
        raise Exception('Missing block marker: %s in file: %s' % (startMarker, filePath, ))
    if endIndex < 0:
        raise Exception('Missing block marker: %s in file: %s' % (endMarker, filePath, ))

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
    return '// %s' % comment

def UpperName(name):
    return name[0].upper() + name[1:]

class CustomAccessor:
    def __init__(self, name, typeName, propertyList, setterValues=None, getterValue=None, comments=None):
        self.name = name
        self.typeName = typeName
        self.propertyList = propertyList
        self.setterValues = setterValues
        self.getterValue = getterValue
        self.comments = comments

    def propertyNames(self):
        return self.propertyList

    def UpperName(self):
        return UpperName(self.name)


customAccessors = (
                    CustomAccessor('minSize', 'CGSize', ('minWidth', 'minHeight',), ('.width', '.height',), getterValue='CGSizeMake(self.minWidth, self.minHeight)'),
                    CustomAccessor('maxSize', 'CGSize', ('maxWidth', 'maxHeight',), ('.width', '.height',), getterValue='CGSizeMake(self.maxWidth, self.maxHeight)'),

                    CustomAccessor('fixedWidth', 'CGFloat', ('minWidth', 'maxWidth',)),
                    CustomAccessor('fixedHeight', 'CGFloat', ('minHeight', 'maxHeight',)),
                    CustomAccessor('fixedSize', 'CGSize', ('minWidth', 'minHeight', 'maxWidth', 'maxHeight',), ('.width', '.height', '.width', '.height',)),

                    CustomAccessor('stretchWeight', 'CGFloat', ('vStretchWeight', 'hStretchWeight',)),

                    CustomAccessor('hMargin', 'CGFloat', ('leftMargin', 'rightMargin',)),
                    CustomAccessor('vMargin', 'CGFloat', ('topMargin', 'bottomMargin',)),
                    CustomAccessor('margin', 'CGFloat', ('leftMargin', 'rightMargin', 'topMargin', 'bottomMargin',)),

                    CustomAccessor('spacing', 'CGFloat', ('hSpacing', 'vSpacing',)),
                    )

# --------

lines = []
lines.append('')
lines.append('')
for propertyGroup in propertyGroups:
    for property in propertyGroup:
        lines.append('@property (nonatomic) %s %s;' % (property.typeName, property.name, ))
    lines.append('')

for customAccessor in customAccessors:
    comments = []
    comments.append(FormatComment('Convenience accessor(s) for the %s properties.' % FormatList(customAccessor.propertyNames())))
    lines.append('%s' % ('\n'.join(comments), ))
    # Getter
    if customAccessor.getterValue:
        lines.append('- (%s)%s;' % (customAccessor.typeName, customAccessor.name, ))
    # Setter
    lines.append('- (void)set%s:(%s)value;\n' % (customAccessor.UpperName(), customAccessor.typeName, ))
lines.append('')
block = '\n'.join(lines)

replaceBlock(viewInfohFilePath, 'View Info Start', 'View Info End', block)
# viewInfohFilePath = os.path.join(folderPath, 'WeView2ViewInfo.h')
# viewInfomFilePath = os.path.join(folderPath, 'WeView2ViewInfo.m')

# --------

lines = []
lines.append('')
lines.append('')
for propertyGroup in propertyGroups:
    for property in propertyGroup:
        # Getter
        lines.append('- (%s)%s;' % (property.typeName, property.name, ))
        # Setter
        lines.append('- (UIView *)set%s:(%s)value;' % (property.UpperName(), property.typeName, ))

    lines.append('')

for customAccessor in customAccessors:
    comments = []
    comments.append(FormatComment('Convenience accessor(s) for the %s properties.' % FormatList(customAccessor.propertyNames())))
    lines.append('%s' % ('\n'.join(comments), ))
    # Getter
    if customAccessor.getterValue:
        lines.append('- (%s)%s;' % (customAccessor.typeName, customAccessor.name, ))
    # Setter
    lines.append('- (UIView *)set%s:(%s)value;\n' % (customAccessor.UpperName(), customAccessor.typeName, ))
lines.append('')
block = '\n'.join(lines)

replaceBlock(hFilePath, 'Start', 'End', block)

# --------

# lines = []
# lines.append('')
# lines.append('')
# for propertyGroup in propertyGroups:
#     for property in propertyGroup:
#         lines.append('static const void *kWeView2Key_%s = &kWeView2Key_%s;' % (property.UpperName(), property.UpperName(), ))
#
#     lines.append('')
# lines.append('')
# block = '\n'.join(lines)
#
# replaceBlock(mFilePath, 'Keys Start', 'Keys End', block)

# --------

lines = []
lines.append('')
for customAccessor in customAccessors:
    asserts = ''
    #     if pseudoProperty.asserts:
    #         if type(pseudoProperty.asserts) == types.StringType:
    #             asserts ='\n    WeView2Assert(%s);' % (property.asserts % 'value', )
    #             pass
    #         else:
    #             raise Exception('Unknown asserts: %s' % str(property.asserts))

    if customAccessor.getterValue:
        lines.append('''
- (%s)%s
{
    return %s;
}''' % (customAccessor.typeName, customAccessor.name, customAccessor.getterValue, ))

    subsetters = []
    for index, propertyName in enumerate(customAccessor.propertyNames()):
        valueName = 'value'
        if customAccessor.setterValues:
            valueName += customAccessor.setterValues[index]
        subsetters.append('    [self set%s:%s];' % (UpperName(propertyName), valueName,))

    lines.append('''
- (void)set%s:(%s)value
{
%s
}''' % (customAccessor.UpperName(), customAccessor.typeName, '\n'.join(subsetters), ))

lines.append('')
lines.append('')
block = '\n'.join(lines)

replaceBlock(viewInfomFilePath, 'View Info Start', 'View Info End', block)

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
    return [self.viewInfo %s];
}

- (UIView *)set%s:(%s)value
{
    [self.viewInfo set%s:value];
    return self;
}''' % (property.typeName, property.name, property.name, property.UpperName(), property.typeName, property.UpperName(), ))

for customAccessor in customAccessors:
    asserts = ''
    #     if pseudoProperty.asserts:
    #         if type(pseudoProperty.asserts) == types.StringType:
    #             asserts ='\n    WeView2Assert(%s);' % (property.asserts % 'value', )
    #             pass
    #         else:
    #             raise Exception('Unknown asserts: %s' % str(property.asserts))

    # Getter
    if customAccessor.getterValue:
        lines.append('''
- (%s)%s
{
    return [self.viewInfo %s];
}''' % (customAccessor.typeName, customAccessor.name, customAccessor.name, ))
    # Setter
    subsetters = []
    for index, propertyName in enumerate(customAccessor.propertyNames()):
        valueName = 'value'
        if customAccessor.setterValues:
            valueName += customAccessor.setterValues[index]
        subsetters.append('    [self set%s:%s];' % (UpperName(propertyName), valueName,))

    lines.append('''
- (UIView *)set%s:(%s)value
{
%s
    return self;
}''' % (customAccessor.UpperName(), customAccessor.typeName, '\n'.join(subsetters), ))

lines.append('')
lines.append('')
block = '\n'.join(lines)

replaceBlock(mFilePath, 'Accessors Start', 'Accessors End', block)

# --------

# lines = []
# lines.append('')
# for propertyGroup in propertyGroups:
#     for property in propertyGroup:
#         asserts = ''
#         if property.asserts:
#             if type(property.asserts) == types.StringType:
#                 asserts ='\n    WeView2Assert(%s);' % (property.asserts % 'value', )
#                 pass
#             else:
#                 raise Exception('Unknown asserts: %s' % str(property.asserts))
#         if property.typeName == 'CGFloat':
#             getterName = 'associatedFloat'
#             setterName = 'setAssociatedFloat'
#         elif property.typeName == 'BOOL':
#             getterName = 'associatedBoolean'
#             setterName = 'setAssociatedBoolean'
#         elif property.typeName == 'NSString *':
#             getterName = 'associatedString'
#             setterName = 'setAssociatedString'
#         else:
#             raise Exception('Unknown typeName: %s' % str(property.typeName))
#         defaultValue = ''
#         if property.defaultValue:
#             defaultValue = ' defaultValue:%s' % property.defaultValue
#         lines.append('''
# - (%s)%s
# {
#     return [self.viewInfo %s];
# }
#
# - (id)set%s:(%s)value
# {%s
#     [self %s:value key:kWeView2Key_%s];
#     return self;
# }''' % (property.typeName, property.name, property.name, property.UpperName(), property.typeName, asserts, setterName, property.UpperName(), ))
#
# for customAccessor in customAccessors:
#     asserts = ''
#     #     if pseudoProperty.asserts:
#     #         if type(pseudoProperty.asserts) == types.StringType:
#     #             asserts ='\n    WeView2Assert(%s);' % (property.asserts % 'value', )
#     #             pass
#     #         else:
#     #             raise Exception('Unknown asserts: %s' % str(property.asserts))
#     subsetters = []
#     for index, propertyName in enumerate(customAccessor.propertyNames()):
#         valueName = 'value'
#         if customAccessor.setterValues:
#             valueName += customAccessor.setterValues[index]
#         subsetters.append('    [self set%s:%s];' % (UpperName(propertyName), valueName,))
#
#     lines.append('''
# - (id)set%s:(%s)value
# {
# %s
#     return self;
# }''' % (customAccessor.UpperName(), customAccessor.typeName, '\n'.join(subsetters), ))
#
# lines.append('')
# lines.append('')
# block = '\n'.join(lines)
#
# replaceBlock(mFilePath, 'Accessors Start', 'Accessors End', block)

# --------

lines = []
lines.append('')
lines.append('')
for propertyGroup in propertyGroups:
    for property in propertyGroup:
        value = '@(self.%s)' % property.name
        if property.typeName.endswith(' *'):
            value = 'self.%s' % property.name
        lines.append('    [result appendString:[self formatLayoutDescriptionItem:@"%s" value:%s]];' % (property.name, value, ))

lines.append('')
lines.append('')
block = '\n'.join(lines)

replaceBlock(viewInfomFilePath, 'Debug Start', 'Debug End', block)

# --------

lines = []
lines.append('')
lines.append('')
for propertyGroup in propertyGroups:
    for property in propertyGroup:
        if property.typeName == 'CGFloat':
            lines.append('''
// --- %s ---
                            [ViewParameterSimple create:@"%s"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatFloat(view.%s);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"-5"
                                             setterBlock:^(UIView *view) {
                                                 view.%s = view.%s - 5;
                                             }],
                             [ViewParameterSetter create:@"-1"
                                             setterBlock:^(UIView *view) {
                                                 view.%s = view.%s - 1;
                                             }],
                             [ViewParameterSetter create:@"0"
                                             setterBlock:^(UIView *view) {
                                                 view.%s = 0;
                                             }],
                             [ViewParameterSetter create:@"+1"
                                             setterBlock:^(UIView *view) {
                                                 view.%s = view.%s + 1;
                                             }],
                             [ViewParameterSetter create:@"+5"
                                             setterBlock:^(UIView *view) {
                                                 view.%s = view.%s + 5;
                                             }],
                             ]],''' % (property.name, property.name, property.name, property.name, property.name, property.name, property.name, property.name, property.name, property.name, property.name, property.name, ) )
        elif property.typeName == 'BOOL':
            lines.append('''
// --- %s ---
                            [ViewParameterSimple create:@"%s"
                                            getterBlock:^NSString *(UIView *view) {
                                                return FormatBoolean(view.%s);
                                            }
                                                setters:@[
                             [ViewParameterSetter create:@"YES"
                                             setterBlock:^(UIView *view) {
                                                 view.%s = YES;
                                             }
                              ],
                             [ViewParameterSetter create:@"NO"
                                             setterBlock:^(UIView *view) {
                                                 view.%s = NO;
                                             }
                              ],
                             ]],''' % (property.name, property.name, property.name, property.name, property.name,  ) )
        else:
            print 'Unknown typeName:', property.typeName

        # value = '@(self.%s)' % property.name
        # if property.typeName.endswith(' *'):
        #     value = 'self.%s' % property.name
        # lines.append('    [result appendString:[self formatLayoutDescriptionItem:@"%s" value:%s]];' % (property.name, value, ))
        pass
lines.append('')
lines.append('')
block = '\n'.join(lines)

# propertyGroups = (
#                   (
#                    Property('minWidth', 'CGFloat', asserts='%s >= 0', ),
#                    Property('maxWidth', 'CGFloat', defaultValue="CGFLOAT_MAX", asserts='%s >= 0',  ),
#                    Property('minHeight', 'CGFloat', asserts='%s >= 0', ),
#                    Property('maxHeight', 'CGFloat', defaultValue="CGFLOAT_MAX", asserts='%s >= 0', ),
#                    ),
#                   (
#                    Property('hStretchWeight', 'CGFloat', asserts='%s >= 0', ),
#                    Property('vStretchWeight', 'CGFloat', asserts='%s >= 0', ),
#                    Property('ignoreNaturalSize', 'BOOL', ),
#                    ),
#                   (
#                    Property('leftMargin', 'CGFloat', ),
#                    Property('rightMargin', 'CGFloat', ),
#                    Property('topMargin', 'CGFloat', ),
#                    Property('bottomMargin', 'CGFloat', ),
#                    ),
#                   (
#                    Property('vSpacing', 'CGFloat', ),
#                    Property('hSpacing', 'CGFloat', ),
#                    ),
#                   # (
#                   #  Property('hAlign', 'HAlign', ),
#                   #  Property('vAlign', 'VAlign', ),
#                   #  ),
#                   (
#                    Property('debugName', 'NSString *', defaultValue="@\"?\"", ),
#                    Property('debugLayout', 'BOOL', ),
#                    ),
#
#                   )

replaceBlock(ViewEditorController_mFilePath, 'Parameters Start', 'Parameters End', block)

# --------

                    # ViewEditorController_hFilePath,
                    # ViewEditorController_mFilePath,

print 'Complete.'
