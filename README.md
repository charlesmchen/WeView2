WeView2
=======

The WeView2 library is a tool for auto layout of iOS UIs. 

* WeView2 is an alternative to [iOS's built-in Auto Layout Mechanism](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/Articles/Introduction.html).
* WeView2 builds on iOS's existing sizing and layout mechanisms.  WeView2 is compatible with any properly implemented UIViews without any modifications.
* WeView2 draws on the concepts and vocabulary used by HTML and CSS layout (ie. margins, spacing, alignment, etc.).
* WeView2 uses ARC.


# Design philosophy

* Adopt the strongest elements of HTML and CSS, with declarative layout and styling.
* Enable chaining by having all setters and configuration methods return a reference to the receiver.
* Avoid boilerplate by providing convenience accessors and factory methods.
* Strive to be lightweight. Stay focused on solving a single problem. Add no third-party dependencies. Play nicely with other UIViews and layout mechanisms.


# Why use auto layout at all?

With auto layout, UIs can:

* Adapt to different screen sizes (ie. the iPhone 5 vs. other iPhones) (be responsive).
* Adapt to orientation changes.
* Adapt to design changes (ie. change of font size).
* Adapt to textual changes as your UI is translated into other languages.
* Adapt to dynamic content.

This becomes even more important with iOS 7, which lets users adjust text sizes outside of your app.

# Why use WeView2 instead of iOS' built-in Auto Layout?

* iOS' built-in Auto Layout is constraint-based.  
* The syntax of iOS' built-in Auto Layout can be difficult to understand:

```
+ (id)constraintWithItem:(id)view1 
attribute:(NSLayoutAttribute)attr1 
relatedBy:(NSLayoutRelation)relation 
toItem:(id)view2 
attribute:(NSLayoutAttribute)attr2
multiplier:(CGFloat)multiplier
constant:(CGFloat)c
```

* You need to worry about complications such as constraint priority, constraint sufficiency, constraint conflicts, ambiguous layout, common ancestors, etc.

* In iOS' built-in Auto Layout, constraints are specified on a per-view basis.

* Some conceptually simple layouts are difficult to describe with constraints.

* WeView2 layout is container- and block-based.  
* Where possible, WeView2's leverages your existing understanding of how layout works with HTML/CSS.


Users interfaces that use auto-layout adapt to changes.  
For a UILabel, for example, this might mean: 

* changing the font or font size
* translating the text into another language.
* adjusting the margins.

Many iOS developers and designers enjoy working with Interface Builder (ie. xibs and nibs), which 
allows them to design UIs visually.

Using WeView2 involves (at least partially) creating your UI
programatically.  Although this requires




*

It is available under a permmissive license (see below).

WeView2 is nearly total rewrite of the WeView library.


// TODO: Discuss semantics of [UIView sizeThatFits:(CGSize)size].
// Functions like a "minimum size" in some sense - if the view wants to insist upon a minimum
// size, the return value can exceed the size parameter.
// Functions like a "maximum size" in some sense - the return value can be smaller than the
// size parameter.
// Also allows a view to describe how large it will be in a given context, ie. with a wrapping
// UILabel whose height depends on its width.
//
// TODO: Discuss pixel-, subpixel-, and point- alignment.
//
// TODO: Discuss container alignment vs. subview alignment.
//
// TODO: Discuss what happens when subviews insist upon exceeding axis or cross size of container.

// TODO: Add asserts in the setters.
// TODO: hAlign and vAlign control how subviews of the view are aligned within the view, not the
// alignment of the view itself.



# License

WeView2 is distributed under the [Apache License Version 2.0](LICENSE)


# Move to another page.

# Concepts

# UIKit Sizing

[UIView sizeThatFits:(CGSize)size](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIView_Class/UIView/UIView.html#//apple_ref/occ/instm/UIView/sizeThatFits:)
returns the "desired" size of that view.  

For some views that value is fixed.  A UIImageView, for example, returns the size of its image.

For other views the behavior is more complicated.  

As of iOS 6, UIViews have an [UIView intrinsicContentSize] method that is used by iOS's built-in
Auto Layout.  This method is _NOT_ used by WeView2.



