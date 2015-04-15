#!/usr/bin/python

import os, sys, types
from collections import OrderedDict

folderPath = os.path.abspath('WeView')
if (not os.path.exists(folderPath) or
    not os.path.isdir(folderPath)):
    raise Exception('Invalid folderPath: %s' % folderPath)

viewCategoryhFilePath = os.path.join(folderPath, 'UIView+WeView.h')
viewCategorymFilePath = os.path.join(folderPath, 'UIView+WeView.m')
viewInfohFilePath = viewCategorymFilePath
viewInfomFilePath = viewCategorymFilePath
viewProxyFilePath = os.path.join(folderPath, 'WeViewProxyView.m')

ViewEditorController_hFilePath = os.path.join(folderPath, '..', 'WeViews2DemoApp', 'WeViews2DemoApp', 'ViewEditorController.h')
ViewEditorController_mFilePath = os.path.join(folderPath, '..', 'WeViews2DemoApp', 'WeViews2DemoApp', 'ViewEditorController.m')
WeViewLayout_hFilePath = os.path.join(folderPath, 'Layouts', 'WeViewLayout.h')
WeViewLayout_mFilePath = os.path.join(folderPath, 'Layouts', 'WeViewLayout.m')
WeViewGridLayout_hFilePath = os.path.join(folderPath, 'Layouts', 'WeViewGridLayout.h')
WeViewGridLayout_mFilePath = os.path.join(folderPath, 'Layouts', 'WeViewGridLayout.m')
DemoCodeGeneration_mFilePath = os.path.join(folderPath, '..', 'WeViews2DemoApp', 'WeViews2DemoApp', 'DemoCodeGeneration.m')

for filePath in (viewCategoryhFilePath,
                    viewCategorymFilePath,
                    viewInfohFilePath, viewInfomFilePath,
                    ViewEditorController_hFilePath,
                    ViewEditorController_mFilePath,
                    WeViewLayout_hFilePath,
                    WeViewLayout_mFilePath,
                    WeViewGridLayout_hFilePath,
                    WeViewGridLayout_mFilePath,
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
    def __init__(self, name, typeName, defaultValue=None, asserts=None, comments=None, extraSetterLine=None, doubleHeight=False, omitFromHeader=False):
        self.name = name
        self.typeName = typeName
        self.defaultValue = defaultValue
        self.asserts = asserts
        self.comments = comments
        self.extraSetterLine = extraSetterLine
        self.doubleHeight = doubleHeight
        self.omitFromHeader = omitFromHeader


    def UpperName(self):
        return self.name[0].upper() + self.name[1:]


view_propertyGroups = (
                  (
                   Property('minDesiredWidth', 'CGFloat',
                       comments='The minimum desired width of this view. Trumps the maxWidth.',
                       asserts='%s >= 0', ),
                   Property('maxDesiredWidth', 'CGFloat',
                       comments='The maximum desired width of this view. Trumped by the minWidth.',
                       defaultValue="CGFLOAT_MAX", asserts='%s >= 0',  ),
                   Property('minDesiredHeight', 'CGFloat',
                       comments='The minimum desired height of this view. Trumps the maxHeight.',
                       asserts='%s >= 0', ),
                   Property('maxDesiredHeight', 'CGFloat',
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
                   Property('leftSpacingAdjustment', 'int',
                       comments=(
                           'An adjustment to the spacing to the left of this view, if any.',
                           'This value can be positive or negative.',
                           'Only applies to the horizontal, vertical and flow layouts.',
                           ),
                       doubleHeight=True,
                       ),
                   Property('topSpacingAdjustment', 'int',
                       comments=(
                           'An adjustment to the spacing above this view, if any.',
                           'This value can be positive or negative.',
                           'Only applies to the horizontal and vertical layouts.',
                           ),
                       doubleHeight=True,
                       ),
                   Property('rightSpacingAdjustment', 'int',
                       comments=(
                           'An adjustment to the spacing to the right of this view, if any.',
                           'This value can be positive or negative.',
                           'Only applies to the horizontal, vertical and flow layouts.',
                           ),
                       doubleHeight=True,
                       ),
                   Property('bottomSpacingAdjustment', 'int',
                       comments=(
                           'An adjustment to the spacing below this view, if any.',
                           'This value can be positive or negative.',
                           'Only applies to the horizontal and vertical layouts.',
                           ),
                       doubleHeight=True,
                       ),
                   ),
                  (
                   Property('desiredWidthAdjustment', 'CGFloat',
                       comments=(
                           'This adjustment can be used to manipulate the desired width of a view.',
                           'It is added to the desired width reported by the subview.',
                           'This value can be negative.',
                           ),
                       asserts='%s >= 0',
                       doubleHeight=True,
                        ),
                   Property('desiredHeightAdjustment', 'CGFloat',
                       comments=(
                           'This adjustment can be used to manipulate the desired height of a view.',
                           'It is added to the desired width reported by the subview.',
                           'This value can be negative.',
                           ),
                       asserts='%s >= 0',
                       doubleHeight=True,
                        ),
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
                   Property('skipLayout', 'BOOL',
                       comments='If YES, this view is ignored by WeViews during layout.',
                       ),
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
                        ),
                   Property('rightMargin', 'CGFloat',
                       comments='The right margin of the contents of this view.',
                        ),
                   Property('topMargin', 'CGFloat',
                       comments='The top margin of the contents of this view.',
                        ),
                   Property('bottomMargin', 'CGFloat',
                       comments='The bottom margin of the contents of this view.',
                        ),
                   ),
                  (
                   Property('vSpacing', 'int',
                       comments='The vertical spacing between subviews of this view.',
                        ),
                   Property('hSpacing', 'int',
                       comments='The horizontal spacing between subviews of this view.',
                         ),
                   ),
                  (
                   Property('hAlign', 'HAlign',
                       comments='The horizontal alignment of this layout.',
                        ),
                   Property('vAlign', 'VAlign',
                       comments='The vertical alignment of this layout.',
                         ),
                   ),
                  # (
                  #  Property('spacingStretches', 'BOOL',
                  #      comments=(
                  #          'If YES, the spacings between subviews will be stretched if there is any extra space.',
                  #          'Extra space will be distributed evenly between the spacings.',
                  #          'Layouts will prefer to stretch subviews if possible.  Spacings will only be stretched if there are no stretching subviews to receive the extra space.',
                  #          'The spacings will not be cropped if the layout cannot fit its subviews within their superview, even if this property is YES.'
                  #          'Only applies to the horizontal, vertical and flow layouts.  In a flow layout where spacingStretches is YES, the subviews are justified.',
                  #          ),
                  #       ),
                  #  ),
                  (
                   Property('cropSubviewOverflow', 'BOOL',
                       comments=(
                           'By default, if the content size (ie. the total subview size plus margins and spacing) of a WeView overflows its bounds, subviews are cropped to fit inside the available space.',
                           'If cropSubviewOverflow is NO, no cropping occurs and subviews may overflow the bounds of their superview.',
                           ),
                       ),
                   Property('cellPositioning', 'CellPositioningMode',
                       comments=(
                           'By default, if the content size (ie. the total subview size plus margins and spacing) of a WeView overflows its bounds, subviews are cropped to fit inside the available space.',
                           'If cropSubviewOverflow is NO, no cropping occurs and subviews may overflow the bounds of their superview.',
                           ),
                       omitFromHeader=True,
                       ),
                  ),
                  (
                   Property('debugLayout', 'BOOL',
                        ),
                   Property('debugMinSize', 'BOOL',
                        ),
                   ),

                  )

gridLayout_propertyGroups = (
                  (
                   Property('leftMarginInfo', 'WeViewSpacing *',
                       comments=('Optional.',
                           'The left margin of the contents of this view.',
                           ),
                        omitFromHeader=True,
                        ),
                   Property('rightMarginInfo', 'WeViewSpacing *',
                       comments=('Optional.',
                           'The right margin of the contents of this view.',
                           ),
                        omitFromHeader=True,
                        ),
                   Property('topMarginInfo', 'WeViewSpacing *',
                       comments=('Optional.',
                           'The top margin of the contents of this view.',
                           ),
                        omitFromHeader=True,
                        ),
                   Property('bottomMarginInfo', 'WeViewSpacing *',
                       comments=('Optional.',
                           'The bottom margin of the contents of this view.',
                           ),
                        omitFromHeader=True,
                        ),
                   ),
                  (
                   Property('defaultRowSizing', 'WeViewGridSizing *',
                       comments=('Optional.',
                           'The default sizing behavior of all rows.  Only applies to rows for which no row-specific sizing behavior has been specified with rowSizings.',
                           ),
                       defaultValue="[[WeViewGridSizing alloc] init]",
                        ),
                   Property('defaultColumnSizing', 'WeViewGridSizing *',
                       comments=('Optional.',
                           'The default sizing behavior of all columns.  Only applies to columns for which no column-specific sizing behavior has been specified with columnSizings.',
                           ),
                       defaultValue="[[WeViewGridSizing alloc] init]",
                        ),
                   ),
                  (
                   Property('rowSizings', 'NSArray *',
                       comments=(
                            'Optional.',
                            'Row-specific sizing behavior.',
                            'All contents must be instances of WeViewGridSizing.',
                            'The first element of rowSizings applies to the first (top-most row), etc.',
                            'Does not need to exactly match the number of rows.  defaultRowSizing applies to any rows without a corresponding element in rowSizings.',
                           ),
                       defaultValue="nil",
                        ),
                   Property('columnSizings', 'NSArray *',
                       comments=(
                            'Optional.',
                            'Column-specific sizing behavior.',
                            'All contents must be instances of WeViewGridSizing.',
                            'The first element of columnSizings applies to the first (left-most column), etc.',
                            'Does not need to exactly match the number of columns.  defaultColumnSizing applies to any columns without a corresponding element in columnSizings.',
                           ),
                       defaultValue="nil",
                        ),
                   ),
                  (
                   Property('defaultRowSpacing', 'WeViewSpacing *',
                       comments=('Optional.',
                           'The default vertical spacing between subviews of this view.',
                           ),
                       defaultValue="[[WeViewSpacing alloc] init]",
                        ),
                   Property('defaultColumnSpacing', 'WeViewSpacing *',
                       comments=('Optional.',
                           'The default horizontal spacing between subviews of this view.',
                           ),
                       defaultValue="[[WeViewSpacing alloc] init]",
                        ),
                   ),
                  (
                   Property('rowSpacings', 'NSArray *',
                       comments=(
                            'Optional.',
                            'Specifies the spacing between specific rows.',
                            'All contents must be instances of WeViewSpacing.',
                            'The first element of rowSpacings applies to the spacing between the first and second rows, etc.',
                            'Does not need to exactly match the number of spacings between rows.  defaultVSpacing applies to any spacings without a corresponding element in rowSpacings.',
                           ),
                       defaultValue="[[WeViewSpacing alloc] init]",
                        ),
                   Property('columnSpacings', 'NSArray *',
                       comments=(
                            'Optional.',
                            'Specifies the spacing between specific columns.',
                            'All contents must be instances of WeViewSpacing.',
                            'The first element of columnSpacings applies to the spacing between the first and second columns, etc.',
                            'Does not need to exactly match the number of spacings between columns.  defaultHSpacing applies to any spacings without a corresponding element in columnSpacings.',
                           ),
                       defaultValue="[[WeViewSpacing alloc] init]",
                        ),
                   ),
                  (
                   Property('isRowHeightUniform', 'BOOL',
                       comments=(
                            'If YES, all rows will have the same height - the height of the tallest row.',
                            'Default is NO.',
                           ),
                       defaultValue="[[WeViewSpacing alloc] init]",
                        ),
                   Property('isColumnWidthUniform', 'BOOL',
                       comments=(
                            'If YES, all columns will have the same width - the width of the widest column.',
                            'Default is NO.',
                           ),
                       defaultValue="[[WeViewSpacing alloc] init]",
                        ),
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
    result = (['',] + ['// %s' % comment.strip() for comment in formattedComments])
    result = [line.strip() for line in result]
    # print '--', result
    return result


def UpperName(name):
    return name[0].upper() + name[1:]

class CustomAccessor:
    def __init__(self, name, typeName, propertyList, setterValues=None, getterValue=None, comments=None, setterStatements=None, skipCodeGenSimplification=False):
        self.name = name
        self.typeName = typeName
        self.propertyList = propertyList
        self.setterStatements = setterStatements
        self.setterValues = setterValues
        self.getterValue = getterValue
        self.comments = comments
        self.skipCodeGenSimplification = skipCodeGenSimplification

    def propertyNames(self):
        return self.propertyList

    def UpperName(self):
        return UpperName(self.name)


view_customAccessors = (
                    CustomAccessor('minDesiredSize', 'CGSize', ('minDesiredWidth', 'minDesiredHeight',), ('.width', '.height',), getterValue='CGSizeMake(self.minDesiredWidth, self.minDesiredHeight)'),
                    CustomAccessor('maxDesiredSize', 'CGSize', ('maxDesiredWidth', 'maxDesiredHeight',), ('.width', '.height',), getterValue='CGSizeMake(self.maxDesiredWidth, self.maxDesiredHeight)'),
                    CustomAccessor('desiredSizeAdjustment', 'CGSize',
                        ('desiredWidthAdjustment', 'desiredHeightAdjustment',),
                         ('.width', '.height',),
                         getterValue='CGSizeMake(self.desiredWidthAdjustment, self.desiredHeightAdjustment)'),

                    CustomAccessor('fixedDesiredWidth', 'CGFloat', ('minDesiredWidth', 'maxDesiredWidth',)),
                    CustomAccessor('fixedDesiredHeight', 'CGFloat', ('minDesiredHeight', 'maxDesiredHeight',)),
                    CustomAccessor('fixedDesiredSize', 'CGSize', ('minDesiredWidth', 'minDesiredHeight', 'maxDesiredWidth', 'maxDesiredHeight',), ('.width', '.height', '.width', '.height',)),

                    CustomAccessor('stretchWeight', 'CGFloat', ('vStretchWeight', 'hStretchWeight',)),
                    )

layout_customAccessors = (
                    CustomAccessor('hMargin', 'CGFloat', ('leftMargin', 'rightMargin',),  ),
                    CustomAccessor('vMargin', 'CGFloat', ('topMargin', 'bottomMargin',),  ),
                    CustomAccessor('margin', 'CGFloat', ('leftMargin', 'rightMargin', 'topMargin', 'bottomMargin',),  ),

                    CustomAccessor('spacing', 'int', ('hSpacing', 'vSpacing',),  ),
                    )

gridLayout_customAccessors = (

                    # CustomAccessor('leftMargin', 'int', ('leftMarginInfo',),
                    #     getterValue='self.leftMarginInfo.size',
                    #     setterStatements=('\tself.leftMarginInfo.size = value;', ),
                    #     skipCodeGenSimplification=True,
                    #      ),
                    # CustomAccessor('rightMargin', 'int', ('rightMarginInfo',),
                    #     getterValue='self.rightMarginInfo.size',
                    #     setterStatements=('\tself.rightMarginInfo.size = value;', ),
                    #     skipCodeGenSimplification=True,
                    #      ),
                    # CustomAccessor('topMargin', 'int', ('topMarginInfo',),
                    #     getterValue='self.topMarginInfo.size',
                    #     setterStatements=('\tself.topMarginInfo.size = value;', ),
                    #     skipCodeGenSimplification=True,
                    #      ),
                    # CustomAccessor('bottomMargin', 'int', ('bottomMarginInfo',),
                    #     getterValue='self.bottomMarginInfo.size',
                    #     setterStatements=('\tself.bottomMarginInfo.size = value;', ),
                    #     skipCodeGenSimplification=True,
                    #      ),
                    #
                    # CustomAccessor('leftMarginStretchWeight', 'CGFloat', ('leftMarginInfo',),
                    #     getterValue='self.leftMarginInfo.stretchWeight',
                    #     setterStatements=('\tself.leftMarginInfo.stretchWeight = value;', ),
                    #     skipCodeGenSimplification=True,
                    #      ),
                    # CustomAccessor('rightMarginStretchWeight', 'CGFloat', ('rightMarginInfo',),
                    #     getterValue='self.rightMarginInfo.stretchWeight',
                    #     setterStatements=('\tself.rightMarginInfo.stretchWeight = value;', ),
                    #     skipCodeGenSimplification=True,
                    #      ),
                    # CustomAccessor('topMarginStretchWeight', 'CGFloat', ('topMarginInfo',),
                    #     getterValue='self.topMarginInfo.stretchWeight',
                    #     setterStatements=('\tself.topMarginInfo.stretchWeight = value;', ),
                    #     skipCodeGenSimplification=True,
                    #      ),
                    # CustomAccessor('bottomMarginStretchWeight', 'CGFloat', ('bottomMarginInfo',),
                    #     getterValue='self.bottomMarginInfo.stretchWeight',
                    #     setterStatements=('\tself.bottomMarginInfo.stretchWeight = value;', ),
                    #     skipCodeGenSimplification=True,
                    #      ),

                    # CustomAccessor('hMargin', 'CGFloat', ('leftMargin', 'rightMargin',),  ),
                    # CustomAccessor('vMargin', 'CGFloat', ('topMargin', 'bottomMargin',),  ),
                    # CustomAccessor('margin', 'CGFloat', ('leftMargin', 'rightMargin', 'topMargin', 'bottomMargin',),  ),
                    #
                    # # CustomAccessor('spacing', 'int', ('hSpacing', 'vSpacing',),  ),
                    # CustomAccessor('defaultSpacing', 'WeViewSpacing *', ('defaultHSpacing', 'defaultVSpacing',),
                    #     skipCodeGenSimplification=True,
                    #      ),
                    # CustomAccessor('hSpacing', 'int', ('defaultHSpacing',),
                    #     getterValue='self.defaultHSpacing.size',
                    #     setterStatements=('\tself.defaultHSpacing.size = value;', ),
                    #     skipCodeGenSimplification=True,
                    #      ),
                    # CustomAccessor('vSpacing', 'int', ('defaultVSpacing',),
                    #     getterValue='self.defaultVSpacing.size',
                    #     setterStatements=('\tself.defaultVSpacing.size = value;', ),
                    #     skipCodeGenSimplification=True,
                    #      ),
                    # CustomAccessor('spacing', 'int', ('hSpacing', 'vSpacing',),
                    #     skipCodeGenSimplification=True,
                    #      ),
                    )

# --------

def defaultCommentForCustomAccessor(customAccessor):
    comments = []
    if len(customAccessor.propertyNames()) > 1:
        comments.append('Convenience accessor(s) for the %s properties.' % FormatList(customAccessor.propertyNames()))
    else:
        comments.append('Convenience accessor(s) for the %s property.' % FormatList(customAccessor.propertyNames()))
    return comments

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

replaceBlock(viewInfomFilePath, 'View Info M Start', 'View Info M End', block)

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

replaceBlock(viewInfomFilePath, 'View Info Debug Start', 'View Info Debug End', block)

# --------

def createViewEditorControllerParameters(propertyGroups, blockStartKey, blockEndKey, itemCast):
    lines = []
    lines.append('')
    for propertyGroup in propertyGroups:
        for property in propertyGroup:
            if property.typeName == 'CGFloat':
                doubleHeight = " doubleHeight:YES" if property.doubleHeight else ""
                lines.append('''
                                [ViewParameterSimple floatProperty:@"%s"%s],''' % (property.name, doubleHeight, ) )
            elif property.typeName == 'int':
                doubleHeight = " doubleHeight:YES" if property.doubleHeight else ""
                lines.append('''
                                [ViewParameterSimple intProperty:@"%s"%s],''' % (property.name, doubleHeight, ) )
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
                                 [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITIONING_NORMAL)
                                                 setterBlock:^(id item) {
                                                     %s.%s = CELL_POSITIONING_NORMAL;
                                                 }],
                                 [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITIONING_FILL)
                                                 setterBlock:^(id item) {
                                                     %s.%s = CELL_POSITIONING_FILL;
                                                 }],
                                 [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITIONING_FILL_W_ASPECT_RATIO)
                                                 setterBlock:^(id item) {
                                                     %s.%s = CELL_POSITIONING_FILL_W_ASPECT_RATIO;
                                                 }],
                                 [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITIONING_FIT_W_ASPECT_RATIO)
                                                 setterBlock:^(id item) {
                                                     %s.%s = CELL_POSITIONING_FIT_W_ASPECT_RATIO;
                                                 }],
                                 ]
                                 doubleHeight:YES],
                                 ''' % (property.name, itemCast, property.name, itemCast, property.name, itemCast, property.name, itemCast, property.name, itemCast, property.name, ) )
            # elif property.typeName == 'WeViewSpacing *':
            #     lines.append('''
            #                     [ViewParameterSimple create:@"%s"
            #                                     getterBlock:^NSString *(id item) {
            #                                         return FormatCellPositioningMode(%s.%s);
            #                                     }
            #                                         setters:@[
            #                      [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITIONING_NORMAL)
            #                                      setterBlock:^(id item) {
            #                                          %s.%s = CELL_POSITIONING_NORMAL;
            #                                      }],
            #                      [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITIONING_FILL)
            #                                      setterBlock:^(id item) {
            #                                          %s.%s = CELL_POSITIONING_FILL;
            #                                      }],
            #                      [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITIONING_FILL_W_ASPECT_RATIO)
            #                                      setterBlock:^(id item) {
            #                                          %s.%s = CELL_POSITIONING_FILL_W_ASPECT_RATIO;
            #                                      }],
            #                      [ViewParameterSetter create:FormatCellPositioningMode(CELL_POSITIONING_FIT_W_ASPECT_RATIO)
            #                                      setterBlock:^(id item) {
            #                                          %s.%s = CELL_POSITIONING_FIT_W_ASPECT_RATIO;
            #                                      }],
            #                      ]
            #                      doubleHeight:YES],
            #                      ''' % (property.name, itemCast, property.name, itemCast, property.name, itemCast, property.name, itemCast, property.name, itemCast, property.name, ) )
            else:
                print 'Unknown typeName(1):', property.typeName, property.name

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
# TODO: gridLayout_propertyGroups


# --------

def generatePropertiesForHeader(propertyGroups, customAccessors, returnType, filepath, blockStartKey, blockEndKey, synthesize=False):
    lines = []
    lines.append('')
    lines.append('')
    for propertyGroup in propertyGroups:
        hasGroup = False
        for property in propertyGroup:
            if property.omitFromHeader:
                continue
            hasGroup = True
            if property.comments:
                lines.extend(FormatComments(property.comments))
            if synthesize:
                lines.append('@property (nonatomic) %s %s;' % (property.typeName, property.name, ))
            else:
                # Getter
                lines.append('- (%s)%s;' % (property.typeName, property.name, ))
                # Setter
                lines.append('- (%s)set%s:(%s)value;' % (returnType, property.UpperName(), property.typeName, ))

        if hasGroup:
            lines.append('')

    for customAccessor in customAccessors:
        comments = []
        comments.extend(defaultCommentForCustomAccessor(customAccessor))
        lines.extend(FormatComments(comments))
        # Getter
        if customAccessor.getterValue:
            lines.append('- (%s)%s;' % (customAccessor.typeName, customAccessor.name, ))
        # Setter
        lines.append('- (%s)set%s:(%s)value;\n' % (returnType, customAccessor.UpperName(), customAccessor.typeName, ))
    lines.append('')
    block = '\n'.join(lines)
    block = block.replace('\n\n\n', '\n\n')

    replaceBlock(filepath, blockStartKey, blockEndKey, block)

# --------

generatePropertiesForHeader(view_propertyGroups, view_customAccessors, 'UIView *', viewCategoryhFilePath, 'Properties Start', 'Properties End')
generatePropertiesForHeader(view_propertyGroups, view_customAccessors, 'void', viewInfohFilePath, 'View Info Properties Start', 'View Info Properties End', synthesize=True)
generatePropertiesForHeader(layout_propertyGroups, layout_customAccessors, 'WeViewLayout *', WeViewLayout_hFilePath, 'Properties Start', 'Properties End')
generatePropertiesForHeader(gridLayout_propertyGroups, gridLayout_customAccessors, 'WeViewGridLayout *', WeViewGridLayout_hFilePath, 'Properties Start', 'Properties End')

# --------

def generateMembersForSource(propertyGroups, filepath, blockStartKey, blockEndKey):
    lines = []
    lines.append('')
    lines.append('')
    for propertyGroup in propertyGroups:
        hasGroup = False
        for property in propertyGroup:
            hasGroup = True
            # Getter
            lines.append('%s%s_%s;' % (property.typeName, ' ' if ' ' not in property.typeName else '', property.name, ))

        if hasGroup:
            lines.append('')
    lines.append('')
    block = '\n'.join(lines)

    replaceBlock(filepath, blockStartKey, blockEndKey, block)

# --------

generateMembersForSource(layout_propertyGroups, WeViewLayout_mFilePath, 'Members Start', 'Members End')
generateMembersForSource(gridLayout_propertyGroups, WeViewGridLayout_mFilePath, 'Members Start', 'Members End')

# --------

def generateAccessorsForSource(propertyGroups, customAccessors, filepath, blockStartKey, blockEndKey, isViewCategory=False):

    lines = []
    lines.append('')
    for propertyGroup in propertyGroups:
        for property in propertyGroup:
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
            if isViewCategory:
                currentValue = '[self.viewInfo %s]' % property.name
            else:
                currentValue = '_%s' % property.name
            lines.append('''
- (%s)%s
{
    return %s;
}''' % (property.typeName, property.name, currentValue, ))

            if isViewCategory:
                lines.append('''
- (UIView *)set%s:(%s)value
{
    [self.viewInfo set%s:value];
    [self.superview setNeedsLayout];
    return self;
}''' % (property.UpperName(), property.typeName, property.UpperName(), ))
            else:
                lines.append('''
- (WeViewLayout *)set%s:(%s)value
{
    _%s = value;
    [self propertyChanged];
    return self;
}''' % (property.UpperName(), property.typeName, property.name, ))

    for customAccessor in customAccessors:
        # Getter
        if customAccessor.getterValue:
            if isViewCategory:
                lines.append('''
- (%s)%s
{
    return [self.viewInfo %s];
}''' % (customAccessor.typeName, customAccessor.name, customAccessor.name, ))
            else:
                lines.append('''
- (%s)%s
{
    return %s;
}''' % (customAccessor.typeName, customAccessor.name, customAccessor.getterValue, ))
        # Setter
        subsetters = []
        if customAccessor.setterStatements:
            subsetters = customAccessor.setterStatements
        else:
            for index, propertyName in enumerate(customAccessor.propertyNames()):
                valueName = 'value'
                if customAccessor.setterValues:
                    valueName += customAccessor.setterValues[index]
                subsetters.append('    [self set%s:%s];' % (UpperName(propertyName), valueName,))

        if isViewCategory:
            lines.append('''
- (UIView *)set%s:(%s)value
{
%s
    [self.superview setNeedsLayout];
    return self;
}''' % (customAccessor.UpperName(), customAccessor.typeName, '\n'.join(subsetters), ))
        else:
            lines.append('''
- (WeViewLayout *)set%s:(%s)value
{
%s
    [self propertyChanged];
    return self;
}''' % (customAccessor.UpperName(), customAccessor.typeName, '\n'.join(subsetters), ))

    lines.append('')
    lines.append('')
    block = '\n'.join(lines)

    replaceBlock(filepath, blockStartKey, blockEndKey, block)

# --------

generateAccessorsForSource(layout_propertyGroups, layout_customAccessors, WeViewLayout_mFilePath, 'Accessors Start', 'Accessors End')
generateAccessorsForSource(gridLayout_propertyGroups, gridLayout_customAccessors, WeViewGridLayout_mFilePath, 'Accessors Start', 'Accessors End')
generateAccessorsForSource(view_propertyGroups, view_customAccessors, viewCategorymFilePath, 'Accessors Start', 'Accessors End', isViewCategory=True)

# generatePropertiesForHeader(view_propertyGroups, view_customAccessors, 'UIView *', viewCategoryhFilePath, 'Properties Start', 'Properties End')
# generatePropertiesForHeader(view_propertyGroups, view_customAccessors, 'void', viewInfohFilePath, 'View Info Properties Start', 'View Info Properties End', synthesize=True)
# generatePropertiesForHeader(layout_propertyGroups, layout_customAccessors, 'WeViewLayout *', WeViewLayout_hFilePath, 'Properties Start', 'Properties End')
# generatePropertiesForHeader(gridLayout_propertyGroups, gridLayout_customAccessors, 'WeViewGridLayout *', WeViewGridLayout_hFilePath, 'Properties Start', 'Properties End')

# --------

lines = []
lines.append('')
lines.append('')
for propertyGroup in layout_propertyGroups:
    for property in propertyGroup:
        lines.append('    self.%s = layout.%s;' % (property.name, property.name, ))
lines.append('')
lines.append('')
block = '\n'.join(lines)

replaceBlock(WeViewLayout_mFilePath, 'Copy Configuration Start', 'Copy Configuration End', block)

# --------

lines = []
lines.append('')
lines.append('')
for propertyGroup in layout_propertyGroups:
    for property in propertyGroup:
        defaultValue = ''
        if property.defaultValue:
            defaultValue = property.defaultValue
        elif property.typeName == 'CGFloat':
            defaultValue = '0.f'
        elif property.typeName == 'int':
            defaultValue = '0'
        elif property.typeName == 'BOOL':
            defaultValue = 'NO'
        elif property.typeName == 'HAlign':
            defaultValue = 'H_ALIGN_CENTER'
        elif property.typeName == 'VAlign':
            defaultValue = 'V_ALIGN_CENTER'
        elif property.typeName == 'CellPositioningMode':
            defaultValue = 'CELL_POSITIONING_NORMAL'
        elif property.typeName == 'WeViewSpacing *':
            defaultValue = 'nil'
        elif property.typeName == 'VAlign':
            defaultValue = 'V_ALIGN_CENTER'
        else:
            print 'Reset layout, Unknown typeName(2):', property.typeName, property.name
        lines.append('    self.%s = %s;' % (property.name, defaultValue, ))
lines.append('')
lines.append('')
block = '\n'.join(lines)

replaceBlock(WeViewLayout_mFilePath, 'Reset Start', 'Reset End', block)

# --------


def formatMethodNameForType(typeName):
    if typeName == 'CGFloat':
        return 'FormatFloat'
    elif typeName == 'int':
        return 'FormatInt'
    elif typeName == 'BOOL':
        return 'FormatBoolean'
    elif typeName == 'HAlign':
        return 'ReprHAlign'
    elif typeName == 'VAlign':
        return 'ReprVAlign'
    elif typeName == 'CellPositioningMode':
        return 'ReprCellPositioningMode'
    elif typeName == 'WeViewSpacing *':
        return 'ReprWeViewSpacing'
    # elif property.typeName == 'CellPositioningMode':
    else:
        print 'Unknown typeName(3):', typeName


lines = []
lines.append('')
for propertyGroup in view_propertyGroups:
    for property in propertyGroup:
        if formatMethodNameForType(property.typeName):
            lines.append('''
    if (view.%s != virginView.%s)
    {
        [lines addObject:[NSString stringWithFormat:@"%s", @"set%s", %s(view.%s)]];
    }''' % ( property.name, property.name, '%@:%@', property.UpperName(), formatMethodNameForType(property.typeName), property.name, ))

lines.append('')
lines.append('    // Custom Accessors')
lines.append('')

for customAccessor in reversed(view_customAccessors):
    if customAccessor.skipCodeGenSimplification:
        continue
    if formatMethodNameForType(customAccessor.typeName):

        linePrefixes = []
        for propName in customAccessor.propertyList:
            linePrefixes.append('@"set%s%s:"' % ( propName[0].upper(), propName[1:]))
        linePrefixes = '@[' + (', '.join(linePrefixes)) + ']'

        comparisons = []
        for prop in customAccessor.propertyList[1:]:
            comparisons.append('view.%s == view.%s' % ( customAccessor.propertyList[0], prop, ) )
        comparisons = ' && '.join(comparisons)
        lines.append('''
    if ([self doDecorations:lines haveLinesWithPrefixes:%s] &&
        %s)
    {
        lines = [self removeLines:lines withPrefixes:%s];
        [lines addObject:[NSString stringWithFormat:@"%s", @"set%s", %s(view.%s)]];
    }''' % ( linePrefixes, comparisons, linePrefixes,
             '%@:%@', customAccessor.UpperName(), formatMethodNameForType(customAccessor.typeName), customAccessor.propertyList[0], ))

lines.append('')
lines.append('')

block = '\n'.join(lines)

replaceBlock(DemoCodeGeneration_mFilePath, 'Code Generation View Properties Start', 'Code Generation View Properties End', block)

# --------

lines = []
lines.append('')
for propertyGroup in layout_propertyGroups:
    for property in propertyGroup:
        if formatMethodNameForType(property.typeName):
            lines.append('''
    if (layout.%s != virginLayout.%s)
    {
        [lines addObject:[NSString stringWithFormat:@"%s", @"set%s", %s(layout.%s)]];
    }''' % ( property.name, property.name, '%@:%@', property.UpperName(), formatMethodNameForType(property.typeName), property.name, ))

lines.append('')
lines.append('    // Custom Accessors')
lines.append('')

for customAccessor in reversed(layout_customAccessors):
    if customAccessor.skipCodeGenSimplification:
        continue
    if formatMethodNameForType(customAccessor.typeName):

        linePrefixes = []
        for propName in customAccessor.propertyList:
            linePrefixes.append('@"set%s%s:"' % ( propName[0].upper(), propName[1:]))
        linePrefixes = '@[' + (', '.join(linePrefixes)) + ']'

        comparisons = []
        for prop in customAccessor.propertyList[1:]:
            comparisons.append('layout.%s == layout.%s' % ( customAccessor.propertyList[0], prop, ) )
        comparisons = ' && '.join(comparisons)
        lines.append('''
    if ([self doDecorations:lines haveLinesWithPrefixes:%s] &&
        %s)
    {
        lines = [self removeLines:lines withPrefixes:%s];
        [lines addObject:[NSString stringWithFormat:@"%s", @"set%s", %s(layout.%s)]];
    }''' % ( linePrefixes, comparisons, linePrefixes,
             '%@:%@', customAccessor.UpperName(), formatMethodNameForType(customAccessor.typeName), customAccessor.propertyList[0], ))

lines.append('')
lines.append('')
#
block = '\n'.join(lines)

replaceBlock(DemoCodeGeneration_mFilePath, 'Code Generation Layout Properties Start', 'Code Generation Layout Properties End', block)

# --------

lines = []
lines.append('')
for propertyGroup in view_propertyGroups:
    for property in propertyGroup:
        lines.append('''
- (%s)%s
{
    UIView *view = self.isWeakReference ? self.weakView : self.strongView;
    return [view %s];
}''' % (property.typeName, property.name, property.name, ))

lines.append('')
lines.append('')
block = '\n'.join(lines)

replaceBlock(viewProxyFilePath, 'Accessors Start', 'Accessors End', block)

# --------

print 'Complete.'
