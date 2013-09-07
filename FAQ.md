
WeView2 FAQ
===========

This document has yet to be written.


### Documentation

TODO:

* Examples

## About

WeView2 is complete rewrite of the WeViews library.


# TODO: Move the concepts section to another page.

# Concepts

## Creating UIs programmatically.

Using WeView2 involves (at least partially) creating your UI
programatically.  Although this requires...


## UIKit Sizing

[UIView sizeThatFits:(CGSize)size](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIView_Class/UIView/UIView.html#//apple_ref/occ/instm/UIView/sizeThatFits:)
returns the "desired" size of that view.  

For some views that value is fixed.  A UIImageView, for example, returns the size of its image.

For other views the behavior is more complicated.  

As of iOS 6, UIViews have an [UIView intrinsicContentSize] method that is used by iOS's built-in
Auto Layout.  This method is _NOT_ used by WeView2.

## Sub-pixel alignment.

Sub-pixel alignment is not supported.
Many UIViews (such as UILabel) can look blurry when they are not pixel aligned.
WeView2 layouts go one step further and always point-align views, 
so that views will lay out in a consistent way on Retina and non-Retina devices.

Details

* TODO: Discuss semantics of [UIView sizeThatFits:(CGSize)size].

 Functions like a "minimum size" in some sense - if the view wants to insist upon a minimum
 size, the return value can exceed the size parameter.
 Functions like a "maximum size" in some sense - the return value can be smaller than the
 size parameter.

 Also allows a view to describe how large it will be in a given context, ie. with a wrapping
 UILabel whose height depends on its width.

// TODO: Discuss container alignment vs. subview alignment.

// TODO: Discuss what happens when subviews insist upon exceeding axis or cross size of container.

* TODO: Add asserts in the setters.

* TODO: Add comments to the headers and methods of the source.

* TODO: hAlign and vAlign control how subviews of the view are aligned within the view, not the
 alignment of the view itself.

* TODO: Describe layout process.

* TODO: Describe associated objects.

* TODO: Describe each parameter and how they work.

* TODO: Describe how layout properties can supercede view properties.




