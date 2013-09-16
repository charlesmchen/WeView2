#!/usr/bin/python

import os, sys, types
from collections import OrderedDict

folderPath = os.path.abspath('WeView')
if (not os.path.exists(folderPath) or
    not os.path.isdir(folderPath)):
    raise Exception('Invalid folderPath: %s' % folderPath)

hFilePath = os.path.join(folderPath, 'UIView+WeView.h')
mFilePath = os.path.join(folderPath, 'UIView+WeView.m')
viewInfohFilePath = os.path.join(folderPath, 'WeViewViewInfo.h')
viewInfomFilePath = os.path.join(folderPath, 'WeViewViewInfo.m')
ViewEditorController_hFilePath = os.path.join(folderPath, '..', 'WeViews2DemoApp', 'WeViews2DemoApp', 'ViewEditorController.h')
ViewEditorController_mFilePath = os.path.join(folderPath, '..', 'WeViews2DemoApp', 'WeViews2DemoApp', 'ViewEditorController.m')
WeViewLayout_hFilePath = os.path.join(folderPath, 'Layouts', 'WeViewLayout.h')
WeViewLayout_mFilePath = os.path.join(folderPath, 'Layouts', 'WeViewLayout.m')

for filePath in (hFilePath,
                    mFilePath,
                    viewInfohFilePath, viewInfomFilePath,
                    ViewEditorController_hFilePath,
                    ViewEditorController_mFilePath,
                    WeViewLayout_hFilePath,
                    WeViewLayout_mFilePath,
                     ):
    if (not os.path.exists(filePath) or
        not os.path.isfile(filePath)):
        raise Exception('Invalid filePath: %s' % filePath)


def replaceBlock(filePath, blockStartKey, blockEndKey, block):
    block = block.replace('\n\n\n', '\n\n')

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
    def __init__(self, name, typeName, defaultValue=None, asserts=None, comments=None, layoutProperty=False, extraSetterLine=None):
        self.name = name
        self.typeName = typeName
        self.defaultValue = defaultValue
        self.asserts = asserts
        self.comments = comments
        self.layoutProperty = layoutProperty
        self.extraSetterLine = extraSetterLine


    def UpperName(self):
        return self.name[0].upper() + self.name[1:]


view_propertyGroups = (
                  (
                   Property('minWidth', 'CGFloat',
                       comments='The minimum desired width of this view. Trumps the maxWidth.',
                       asserts='%s >= 0', ),
                   Property('maxWidth', 'CGFloat',
                       comments='The maximum desired width of this view. Trumped by the minWidth.',
                       defaultValue="CGFLOAT_MAX", asserts='%s >= 0',  ),
                   Property('minHeight', 'CGFloat',
                       comments='The minimum desired height of this view. Trumps the maxHeight.',
                       asserts='%s >= 0', ),
                   Property('maxHeight', 'CGFloat',
                       comments='The maximum desired height of this view. Trumped by the minHeight.',
                       defaultValue="CGFLOAT_MAX", asserts='%s >= 0', ),
                   ),
                  (
                   Property('hStretchWeight', 'CGFloat',
                       comments=(
                           'The horizontal stretch weight of this view. If non-zero, the view is willing to take available space or be cropped if necessary.',
                           'Subviews with larger relative stretch weights will be stretched more.',
                           ),
                       asserts='%s >= 0', ),
                   Property('vStretchWeight', 'CGFloat',
                       comments=(
                           'The vertical stretch weight of this view. If non-zero, the view is willing to take available space or be cropped if necessary.',
                           'Subviews with larger relative stretch weights will be stretched more.',
                           ),
                       asserts='%s >= 0', ),
                   ),
                  (
                   Property('desiredWidthAdjustment', 'CGFloat',
                       comments='This adjustment can be used to manipulate the desired width of a view.',
                       asserts='%s >= 0', ),
                   Property('desiredHeightAdjustment', 'CGFloat',
                       comments='This adjustment can be used to manipulate the desired height of a view.',
                       asserts='%s >= 0', ),
                   Property('ignoreDesiredSize', 'BOOL', ),
                   ),
                  (
                   Property('cellHAlign', 'HAlign',
                       comments=(
                           'The horizontal alignment preference of this view within in its layout cell.',
                           'This value is optional.  The default value is the contentHAlign of its superview.',
                           'cellHAlign should only be used for cells whose alignment differs from its superview\'s.',
                           ),
                       extraSetterLine='self.hasCellHAlign = YES;'),
                   Property('cellVAlign', 'VAlign',
                       comments=(
                           'The vertical alignment preference of this view within in its layout cell.',
                           'This value is optional.  The default value is the contentVAlign of its superview.',
                           'cellVAlign should only be used for cells whose alignment differs from its superview\'s.',
                           ),
                       extraSetterLine='self.hasCellVAlign = YES;'),
                   Property('hasCellHAlign', 'BOOL', ),
                   Property('hasCellVAlign', 'BOOL', ),
                   ),
                  (
                   Property('debugName', 'NSString *',
                       defaultValue="@\"?\"", ),
                   ),

                  )

layout_propertyGroups = (
                  (
                   Property('leftMargin', 'CGFloat',
                       comments='The left margin of the contents of this view.',
                       layoutProperty=True, ),
                   Property('rightMargin', 'CGFloat',
                       comments='The right margin of the contents of this view.',
                       layoutProperty=True, ),
                   Property('topMargin', 'CGFloat',
                       comments='The top margin of the contents of this view.',
                       layoutProperty=True, ),
                   Property('bottomMargin', 'CGFloat',
                       comments='The bottom margin of the contents of this view.',
                       layoutProperty=True, ),
                   ),
                  (
                   Property('vSpacing', 'CGFloat',
                       comments='The vertical spacing between subviews of this view.',
                       layoutProperty=True, ),
                   Property('hSpacing', 'CGFloat',
                       comments='The horizontal spacing between subviews of this view.',
                        layoutProperty=True, ),
                   ),
                  (
                   Property('hAlign', 'HAlign',
                       comments='The horizontal alignment of this layout.',
                       layoutProperty=True, ),
                   Property('vAlign', 'VAlign',
                       comments='The vertical alignment of this layout.',
                        layoutProperty=True, ),
                   ),
                  (
                   Property('cropSubviewOverflow', 'BOOL',
                       comments=(
                           'By default, if the content size (ie. the total subview size plus margins and spacing) of a WeView overflows its bounds, subviews are cropped to fit inside the available space.',
                           'If cropSubviewOverflow is NO, no cropping occurs and subviews may overflow the bounds of their superview.',
                           ),
                       layoutProperty=True, ),
                   Property('cellPositioning', 'CellPositioningMode',
                       comments=(
                           'By default, cellPositioning has a value of CELL_POSITION_NORMAL and cell size is based on their desired size and they are aligned within their layout cell.',
                           'If cellPositioning is set to CELL_POSITION_FILL, subviews fill the entire bounds of their layout cell, regardless of their desired size.',
                           'If cellPositioning is set to CELL_POSITION_FILL_W_ASPECT_RATIO, subviews fill the entire bounds of their layout cell but retain the aspect ratio of their desired size.',
                           'If cellPositioning is set to CELL_POSITION_FIT_W_ASPECT_RATIO, subviews are "fit" inside the bounds of their layout cell and retain the aspect ratio of their desired size.',
                           ),
                       layoutProperty=True, ),
                   ),
                  (
                   Property('debugLayout', 'BOOL',
                       layoutProperty=True, ),
                   Property('debugMinSize', 'BOOL',
                       layoutProperty=True, ),
                   ),

                  )

def FormatList(values):
    if len(values) > 1:
        return ', '.join(values[:-1]) + ' and ' + values[-1]
    else:
        return values[0]

def FormatComment(comment):
    return FormatComments((comment,))

def SplitCommentLine(comment):
    remainder = comment
    comments = []
    maxLength = 95
    while len(remainder):
        if len(comment) < maxLength:
            comments.append(remainder)
            remainder = ''
        else:
            index = remainder[:maxLength].rfind(' ')
            if index >= 0:
                comments.append(remainder[:index].strip())
                remainder = remainder[index:].strip()
            else:
                comments.append(remainder)
                remainder = ''

    # print '\t', 'SplitCommentLine', 'comment', comment
    # print '\t', 'SplitCommentLine', 'comments', comments
    return comments

def FormatComments(comment):
    # TODO: linewrap the comments.
    comments = []
    if type(comment) in (types.ListType, types.TupleType,):
        comments = list(comment)
    elif type(comment) in (types.StringType,):
        comments = [comment,]
    else:
        raise Exception('Unknown comment type: %s' % str(type(comment)))

    formattedComments = []
    for index, comment in enumerate(comments):
        if index > 0:
            formattedComments.append('')
        formattedComments.extend(SplitCommentLine(comment))

    if not formattedComments:
        return []
    result = (['',] + ['// %s' % comment for comment in formattedComments])
    # print '--', result
    return result


def UpperName(name):
    return name[0].upper() + name[1:]

class CustomAccessor:
    def __init__(self, name, typeName, propertyList, setterValues=None, getterValue=None, comments=None, layoutProperty=False):
        self.name = name
        self.typeName = typeName
        self.propertyList = propertyList
        self.setterValues = setterValues
        self.getterValue = getterValue
        self.comments = comments
        self.layoutProperty = layoutProperty

    def propertyNames(self):
        return self.propertyList

    def UpperName(self):
        return UpperName(self.name)


view_customAccessors = (
                    CustomAccessor('minSize', 'CGSize', ('minWidth', 'minHeight',), ('.width', '.height',), getterValue='CGSizeMake(self.minWidth, self.minHeight)'),
                    CustomAccessor('maxSize', 'CGSize', ('maxWidth', 'maxHeight',), ('.width', '.height',), getterValue='CGSizeMake(self.maxWidth, self.maxHeight)'),
                    CustomAccessor('desiredSizeAdjustment', 'CGSize',
                        ('desiredWidthAdjustment', 'desiredHeightAdjustment',),
                         ('.width', '.height',),
                         getterValue='CGSizeMake(self.desiredWidthAdjustment, self.desiredHeightAdjustment)'),

                    CustomAccessor('fixedWidth', 'CGFloat', ('minWidth', 'maxWidth',)),
                    CustomAccessor('fixedHeight', 'CGFloat', ('minHeight', 'maxHeight',)),
                    CustomAccessor('fixedSize', 'CGSize', ('minWidth', 'minHeight', 'maxWidth', 'maxHeight',), ('.width', '.height', '.width', '.height',)),

                    CustomAccessor('stretchWeight', 'CGFloat', ('vStretchWeight', 'hStretchWeight',)),
                    )

layout_customAccessors = (
                    CustomAccessor('hMargin', 'CGFloat', ('leftMargin', 'rightMargin',), layoutProperty=True, ),
                    CustomAccessor('vMargin', 'CGFloat', ('topMargin', 'bottomMargin',), layoutProperty=True, ),
                    CustomAccessor('margin', 'CGFloat', ('leftMargin', 'rightMargin', 'topMargin', 'bottomMargin',), layoutProperty=True, ),

                    CustomAccessor('spacing', 'CGFloat', ('hSpacing', 'vSpacing',), layoutProperty=True, ),
                    )

# --------

lines = []
lines.append('')
lines.append('')
for propertyGroup in view_propertyGroups:
    for property in propertyGroup:
        if property.comments:
            lines.extend(FormatComments(property.comments))
        lines.append('@property (nonatomic) %s %s;' % (property.typeName, property.name, ))
    lines.append('')

for customAccessor in view_customAccessors:
    comments = []
    comments.append('Convenience accessor(s) for the %s properties.' % FormatList(customAccessor.propertyNames()))
    lines.extend(FormatComments(comments))
    # Getter
    if customAccessor.getterValue:
        lines.append('- (%s)%s;' % (customAccessor.typeName, customAccessor.name, ))
    # Setter
    lines.append('- (void)set%s:(%s)value;\n' % (customAccessor.UpperName(), customAccessor.typeName, ))
lines.append('')
block = '\n'.join(lines)

replaceBlock(viewInfohFilePath, 'View Info Start', 'View Info End', block)

# --------

lines = []
lines.append('')
lines.append('')
for propertyGroup in view_propertyGroups:
    for property in propertyGroup:
        if property.comments:
            lines.extend(FormatComments(property.comments))
        # Getter
        lines.append('- (%s)%s;' % (property.typeName, property.name, ))
        # Setter
        lines.append('- (UIView *)set%s:(%s)value;' % (property.UpperName(), property.typeName, ))

    lines.append('')

for customAccessor in view_customAccessors:
    comments = []
    comments.append('Convenience accessor(s) for the %s properties.' % FormatList(customAccessor.propertyNames()))
    lines.extend(FormatComments(comments))
    # Getter
    if customAccessor.getterValue:
        lines.append('- (%s)%s;' % (customAccessor.typeName, customAccessor.name, ))
    # Setter
    lines.append('- (UIView *)set%s:(%s)value;\n' % (customAccessor.UpperName(), customAccessor.typeName, ))
lines.append('')
block = '\n'.join(lines)

replaceBlock(hFilePath, 'Start', 'End', block)

# --------

lines = []
lines.append('')

for propertyGroup in view_propertyGroups:
    for property in propertyGroup:
        if property.extraSetterLine:
            lines.append('''
- (void)set%s:(%s)value
{
    _%s = value;
    %s
}''' % (property.UpperName(), property.typeName, property.name, property.extraSetterLine, ))

for customAccessor in view_customAccessors:
    asserts = ''
    #     if pseudoProperty.asserts:
    #         if type(pseudoProperty.asserts) == types.StringType:
    #             asserts ='\n    WeViewAssert(%s);' % (property.asserts % 'value', )
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
for propertyGroup in view_propertyGroups:
    for property in propertyGroup:
        asserts = ''
        if property.asserts:
            if type(property.asserts) == types.StringType:
                asserts ='\n    WeViewAssert(%s);' % (property.asserts % 'value', )
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
        elif property.typeName in ('HAlign', 'VAlign', 'CellPositioningMode', ):
            getterName = 'associatedInt'
            setterName = 'setAssociatedInt'
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

for customAccessor in view_customAccessors:
    asserts = ''
    #     if pseudoProperty.asserts:
    #         if type(pseudoProperty.asserts) == types.StringType:
    #             asserts ='\n    WeViewAssert(%s);' % (property.asserts % 'value', )
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
#                 asserts ='\n    WeViewAssert(%s);' % (property.asserts % 'value', )
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
#     [self %s:value key:kWeViewKey_%s];
#     return self;
# }''' % (property.typeName, property.name, property.name, property.UpperName(), property.typeName, asserts, setterName, property.UpperName(), ))
#
# for customAccessor in customAccessors:
#     asserts = ''
#     #     if pseudoProperty.asserts:
#     #         if type(pseudoProperty.asserts) == types.StringType:
#     #             asserts ='\n    WeViewAssert(%s);' % (property.asserts % 'value', )
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
for propertyGroup in view_propertyGroups:
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

def createViewEditorControllerParameters(propertyGroups, blockStartKey, blockEndKey, itemCast):
    lines = []
    lines.append('')
    for propertyGroup in propertyGroups:
        for property in propertyGroup:
            if property.typeName == 'CGFloat':
                lines.append('''
                                [ViewParameterSimple floatProperty:@"%s"],''' % (property.name, ) )
            elif property.typeName == 'BOOL':
                lines.append('''
                                [ViewParameterSimple booleanProperty:@"%s"],''' % (property.name, ) )
            elif property.typeName == 'HAlign':
                lines.append('''
                                [ViewParameterSimple create:@"%s"
                                                getterBlock:^NSString *(id item) {
                                                    return FormatHAlign(%s.%s);
                                                }
                                                    setters:@[
                                 [ViewParameterSetter create:@"Left"
                                                 setterBlock:^(id item) {
                                                     %s.%s = H_ALIGN_LEFT;
                                                 }],
                                 [ViewParameterSetter create:@"Center"
                                                 setterBlock:^(id item) {
                                                     %s.%s = H_ALIGN_CENTER;
                                                 }],
                                 [ViewParameterSetter create:@"Right"
                                                 setterBlock:^(id item) {
                                                     %s.%s = H_ALIGN_RIGHT;
                                                 }],
                                 ]
                                 doubleHeight:YES],
                                 ''' % (property.name, itemCast, property.name, itemCast, property.name, itemCast, property.name, itemCast, property.name, ) )
            elif property.typeName == 'VAlign':
                lines.append('''
                                [ViewParameterSimple create:@"%s"
                                                getterBlock:^NSString *(id item) {
                                                    return FormatVAlign(%s.%s);
                                                }
                                                    setters:@[
                                 [ViewParameterSetter create:@"Top"
                                                 setterBlock:^(id item) {
                                                     %s.%s = V_ALIGN_TOP;
                                                 }],
                                 [ViewParameterSetter create:@"Center"
                                                 setterBlock:^(id item) {
                                                     %s.%s = V_ALIGN_CENTER;
                                                 }],
                                 [ViewParameterSetter create:@"Bottom"
                                                 setterBlock:^(id item) {
                                                     %s.%s = V_ALIGN_BOTTOM;
                                                 }],
                                 ]
                                 doubleHeight:YES],
                                 ''' % (property.name, itemCast, property.name, itemCast, property.name, itemCast, property.name, itemCast, property.name, ) )
            elif property.typeName == 'CellPositioningMode':
                lines.append('''
                                [ViewParameterSimple create:@"%s"
                                                getterBlock:^NSString *(id item) {
                                                    return FormatCellPositioningMode(%s.%s);
                                                }
                                                    setters:@[
                                 [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITION_NORMAL)
                                                 setterBlock:^(id item) {
                                                     %s.%s = CELL_POSITION_NORMAL;
                                                 }],
                                 [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITION_FILL)
                                                 setterBlock:^(id item) {
                                                     %s.%s = CELL_POSITION_FILL;
                                                 }],
                                 [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITION_FILL_W_ASPECT_RATIO)
                                                 setterBlock:^(id item) {
                                                     %s.%s = CELL_POSITION_FILL_W_ASPECT_RATIO;
                                                 }],
                                 [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITION_FIT_W_ASPECT_RATIO)
                                                 setterBlock:^(id item) {
                                                     %s.%s = CELL_POSITION_FIT_W_ASPECT_RATIO;
                                                 }],
                                 ]
                                 doubleHeight:YES],
                                 ''' % (property.name, itemCast, property.name, itemCast, property.name, itemCast, property.name, itemCast, property.name, itemCast, property.name, ) )
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

    replaceBlock(ViewEditorController_mFilePath, blockStartKey, blockEndKey, block)

createViewEditorControllerParameters(view_propertyGroups, 'View Parameters Start', 'View Parameters End', '((UIView *) item)')
createViewEditorControllerParameters(layout_propertyGroups, 'Layout Parameters Start', 'Layout Parameters End', '((WeViewLayout *) item)')

# --------

lines = []
lines.append('')
lines.append('')
for propertyGroup in layout_propertyGroups:
    hasGroup = False
    for property in propertyGroup:
        if not property.layoutProperty:
            continue
        hasGroup = True
        if property.comments:
            lines.extend(FormatComments(property.comments))
        # Getter
        lines.append('- (%s)%s;' % (property.typeName, property.name, ))
        # Setter
        lines.append('- (WeViewLayout *)set%s:(%s)value;' % (property.UpperName(), property.typeName, ))

    if hasGroup:
        lines.append('')

for customAccessor in layout_customAccessors:
    if not customAccessor.layoutProperty:
        continue

    comments = []
    comments.append('Convenience accessor(s) for the %s properties.' % FormatList(customAccessor.propertyNames()))
    lines.extend(FormatComments(comments))
    # Getter
    if customAccessor.getterValue:
        lines.append('- (%s)%s;' % (customAccessor.typeName, customAccessor.name, ))
    # Setter
    lines.append('- (WeViewLayout *)set%s:(%s)value;\n' % (customAccessor.UpperName(), customAccessor.typeName, ))
lines.append('')
block = '\n'.join(lines)
block = block.replace('\n\n\n', '\n\n')

replaceBlock(WeViewLayout_hFilePath, 'Start', 'End', block)

# --------

lines = []
lines.append('')
lines.append('')
for propertyGroup in layout_propertyGroups:
    hasGroup = False
    for property in propertyGroup:
        if not property.layoutProperty:
            continue
        hasGroup = True
        # Getter
        lines.append('%s _%s;' % (property.typeName, property.name, ))

    if hasGroup:
        lines.append('')
lines.append('')
block = '\n'.join(lines)

replaceBlock(WeViewLayout_mFilePath, 'Members Start', 'Members End', block)


# --------

lines = []
lines.append('')
for propertyGroup in layout_propertyGroups:
    for property in propertyGroup:
        if not property.layoutProperty:
            continue
        asserts = ''
        if property.asserts:
            if type(property.asserts) == types.StringType:
                asserts ='\n    WeViewAssert(%s);' % (property.asserts % 'value', )
                pass
            else:
                raise Exception('Unknown asserts: %s' % str(property.asserts))
        defaultValue = ''
        if property.defaultValue:
            defaultValue = ' defaultValue:%s' % property.defaultValue
        lines.append('''
- (%s)%s
{
    return _%s;
}''' % (property.typeName, property.name, property.name, ))
        lines.append('''
- (WeViewLayout *)set%s:(%s)value
{
    _%s = value;
    [_superview setNeedsLayout];
    return self;
}''' % (property.UpperName(), property.typeName, property.name, ))

for customAccessor in layout_customAccessors:
    if not customAccessor.layoutProperty:
        continue
    # Getter
    if customAccessor.getterValue:
        lines.append('''
- (%s)%s:(UIView *)view
{
    return [view %s];
}''' % (customAccessor.typeName, customAccessor.name, customAccessor.name, ))
    # Setter
    subsetters = []
    for index, propertyName in enumerate(customAccessor.propertyNames()):
        valueName = 'value'
        if customAccessor.setterValues:
            valueName += customAccessor.setterValues[index]
        subsetters.append('    [self set%s:%s];' % (UpperName(propertyName), valueName,))

    lines.append('''
- (WeViewLayout *)set%s:(%s)value
{
%s
    [_superview setNeedsLayout];
    return self;
}''' % (customAccessor.UpperName(), customAccessor.typeName, '\n'.join(subsetters), ))

lines.append('')
lines.append('')
block = '\n'.join(lines)

replaceBlock(WeViewLayout_mFilePath, 'Accessors Start', 'Accessors End', block)

# --------

print 'Complete.'
