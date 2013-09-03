
WeView2
=======

The WeView2 library is a tool for auto layout of iOS UIs. 

* WeView2 is an alternative to [iOS's built-in Auto Layout Mechanism](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/Articles/Introduction.html).
* WeView2 builds on iOS's existing sizing and layout mechanisms.  WeView2 is compatible with any properly implemented UIViews without any modifications.
* WeView2 draws on the concepts and vocabulary used by HTML and CSS layout (ie. margins, spacing, alignment, etc.).
* WeView2 takes advantage of ARC and blocks and requires a minimum of iOS 5.
* WeView2 is available under a permissive license (see below).


## Design philosophy

* Leverage existing understanding of HTML and CSS: container-driven, declarative layout.
* Strive to be lightweight. Stay focused on solving a single problem. Add no third-party dependencies. Play nicely with other layout mechanisms.
* Bend over backwards to allow users to write terse, readable code. 
* Avoid boilerplate by providing convenience accessors and factory methods.
* Enable chaining by having all setters and configuration methods return a reference to the receiver.
* Provide convenience accessors, factory methods etc. to make common tasks easier. 


## Why use auto layout at all?

Auto layout allows a UI to...

* Adapt to different screen sizes (ie. the iPhone 5 vs. other iPhones) (be responsive).
* Adapt to orientation changes.
* Adapt to design changes (ie. change of font size).
* Adapt to textual changes as your UI is translated into other languages.
* Adapt to dynamic content.

This becomes even more important with iOS 7, which lets users adjust text sizes outside of your app.

## Why use WeView2 instead of iOS' built-in Auto Layout?

* iOS Auto Layout is constraint-based.  
* The syntax of iOS Auto Layout can be difficult to understand:

```
+ (id)constraintWithItem:(id)view1 
attribute:(NSLayoutAttribute)attr1 
relatedBy:(NSLayoutRelation)relation 
toItem:(id)view2 
attribute:(NSLayoutAttribute)attr2
multiplier:(CGFloat)multiplier
constant:(CGFloat)c
```

* With iOS Auto Layout you need to worry about complications such as constraint priority, constraint sufficiency, constraint conflicts, ambiguous layout, common ancestors, etc.
* In iOS Auto Layout constraints are (and must be) specified on a per-view basis.  This doesn't work well when UIViews need to be layed out in groups.
* Some conceptually simple layouts are difficult to describe with constraints.

* WeView2 layout is container- and block-based.  
* Where possible, WeView2's leverages your existing understanding of how layout works with HTML/CSS.

```

## Documentation

TODO:

* Examples

# License

WeView2 is distributed under the [Apache License Version 2.0](LICENSE)

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




