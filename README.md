
WeView2
=======

The WeView2 library is a tool for auto layout of iOS UIs. 

* WeView2 is an alternative to [iOS's built-in Auto Layout Mechanism](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/Articles/Introduction.html).
* WeView2 builds on iOS's existing sizing and layout mechanisms.  WeView2 is compatible with any properly implemented UIViews without any modifications.
* WeView2 draws on the concepts and vocabulary used by HTML and CSS layout (ie. margins, spacing, alignment, etc.).
* WeView2 takes advantage of ARC and blocks and is compatible with iOS 5 and later.
* WeView2 is available under a permissive license (see below).


### Design philosophy

* Leverage existing understanding of HTML and CSS: container-driven, declarative layout.
* Strive to be lightweight. Stay focused on solving a single problem. Add no third-party dependencies. Play nicely with other layout mechanisms.
* Bend over backwards to allow users to write terse, readable code. 
* Avoid boilerplate by providing convenience accessors and factory methods.
* Enable chaining by having all setters and configuration methods return a reference to the receiver.
* Provide convenience accessors, factory methods etc. to make common tasks easier. 


### Why use auto layout at all?

Auto layout allows a UI to...

* Adapt to different screen sizes (ie. the iPhone 5 vs. other iPhones) (be responsive).
* Adapt to orientation changes.
* Adapt to design changes (ie. change of font size).
* Adapt to textual changes as your UI is translated into other languages.
* Adapt to dynamic content.

This becomes even more important with iOS 7, which lets users adjust text sizes outside of your app.


### Why use WeView2 instead of iOS' built-in Auto Layout?

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

Here's an example taken from Apple's sample code of how to center a button at the bottom of it's 
superview with a certain spacing using iOS Auto Layout:

```
UIButton *button; // pre-existing UIButton.
UIView *superview = button.superview;

NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:button
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:superview
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:1.0
                                                       constant:0.0];
[superview addConstraint:cn];

cn = [NSLayoutConstraint constraintWithItem:button
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:superview
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0
                                   constant:-20.0];
[superview addConstraint:cn];
```

iOS Auto Layout also supports a Visual Format Language.  Here's the sample layout using VFL:

```
    UIButton *button; // pre-existing UIButton.
    UIView *superview = button.superview;
    NSDictionary *variableMap = NSDictionaryOfVariableBindings(label, superview);
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button]-12-[superview]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:variableMap];
    
    cn = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[superview]-(<=1)-[label]"
                                                 options: NSLayoutFormatAlignAllCenterY
                                                 metrics:nil
                                                   views:variableMap];
```

WeView2's is designed to yield concise, readable code. Here's the equivalent logic using a WeView2:

```
    UIButton *button; // pre-existing UIButton.
    WeView2 *superview; // pre-existing superview of UIButton is a WeView2.
    
    [[[superview addSubviewWithCustomLayout:button]
    setContentVAlign:V_ALIGN_BOTTOM]
     setMargin:20];
```

* With iOS Auto Layout you need to worry about complications such as constraint priority, constraint sufficiency, constraint conflicts, ambiguous layout, common ancestors, etc.
* In iOS Auto Layout constraints are (and must be) specified on a per-view basis.  This doesn't work well when UIViews need to be layed out in groups.
* Some conceptually simple layouts are difficult to describe with constraints.
* Where possible, WeView2's leverages your existing understanding of how layout works with HTML/CSS.

```


### What's new in WeView2?

* WeView2 is a near-total rewrite, that should be more consistent and better handle edge cases such
  as degenerate layouts.
* WeView2 uses a category and associated objects to hang layout properties on any existing UIView,
  removing the need for subclassing, implementing a protocol, etc.  This makes WeView2 far easier to
  use.
* WeView2 has a new cell-based layout model that is easier to understand.
* WeView2 should be more consistent and better handle edge cases such as degenerate layouts.
* WeView2 offers a number of new per-view properties that allow more fine-grained control over 
   layout behavior.


### License

WeView2 is distributed under the [Apache License Version 2.0](LICENSE)

### FAQ

See the [WeView2 Frequently Asked Questions](FAQ.md).

