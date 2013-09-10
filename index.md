---
title: Index
permalink: index.html
layout: default
---

WeView
=======

The WeView library is a tool for auto layout of iOS UIs. 

* WeView is an alternative to [iOS's built-in Auto Layout Mechanism](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/Articles/Introduction.html).
* WeView builds on iOS's existing sizing and layout mechanisms.  WeView is compatible with any properly implemented UIViews without any modifications.
* WeView draws on the concepts and vocabulary used by HTML and CSS layout (ie. margins, spacing, alignment, etc.).
* WeView takes advantage of ARC and blocks and is compatible with iOS 5 and later.
* WeView is available under a permissive license (see below).


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


### Why use WeView instead of iOS' built-in Auto Layout?

* The syntax of iOS Auto Layout can be difficult to work with.
Here's an example taken from Apple's sample code of how to center a button at the bottom of it's
superview with a certain spacing using iOS Auto Layout:

{% gist 6504510 %}

iOS Auto Layout also supports a Visual Format Language.  Here's the sample layout using VFL:

{% gist 6504515 %}

WeView's is designed to yield concise, readable code. Here's the equivalent logic using a WeView:

{% gist 6504519 %}

* With iOS Auto Layout you need to worry about complications such as constraint priority, constraint sufficiency, constraint conflicts, ambiguous layout, common ancestors, etc.
* iOS Auto Layout is constraint-based.  
Constraints are a powerful but awkward way to describe layouts.
Constraints are (and must be) specified on a per-view basis.
Some conceptually simple layouts are difficult to describe with constraints.
This doesn't work well when UIViews need to be layed out in groups.


### What's new in WeView?

* WeView is a near-total rewrite, that should be more consistent and better handle edge cases such
  as degenerate layouts.
* WeView uses a category and associated objects to hang layout properties on any existing UIView,
  removing the need for subclassing, implementing a protocol, etc.  This makes WeView far easier to
  use.
* WeView has a new cell-based layout model that is easier to understand.
* WeView should be more consistent and better handle edge cases such as degenerate layouts.
* WeView offers a number of new per-view properties that allow more fine-grained control over 
   layout behavior.


### License

WeView is distributed under the [Apache License Version 2.0](LICENSE)

### FAQ

See the [WeView Frequently Asked Questions](FAQ.md).

