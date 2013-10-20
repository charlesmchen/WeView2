---
permalink: whyWeView2.html
layout: default
---

Why use WeView v2?
==

<!-- TEMPLATE START -->

The strongest case for using WeView is to compare it with iOS Auto Layout.

![Layout Snapshot](images/snapshot-5B46EB1B-30D4-4FAE-8BC7-D76FA3BBE6CA-34104-00011AA1BCCB403A.png)

* The syntax of iOS Auto Layout can be difficult to work with. _Here's a simple comparison_, based on Apple's sample code demonstrating how to center a button at the bottom of it's superview with 20pt spacing using _iOS Auto Layout_:

{% gist 6504510 %}

iOS Auto Layout also supports a _Visual Format Language_.  Here's the same layout using _VFL_:

{% gist 6504515 %}

Here's the equivalent logic using a _WeView_:

{% gist 6504519 %}

_WeView v2 is designed to yield concise, expressive and maintainable code_	.  The benefits of the syntax only become more clear as layouts become more complex.

* iOS Auto Layout is constraint-based.  _Constraints are a powerful but awkward way to describe layouts_. 
* iOS Auto Layout constraints specify a view's position (x, y) and size (width, height) which is very fine-grained.  WeView works in terms of higher-level concepts like alignment, margins and spacing.
* iOS Auto Layout constraints are specified on a per-view basis. WeView lets you lay out views in groups.
* With iOS Auto Layout you need to worry about complications such as _constraint priority, constraint sufficiency, constraint conflicts, ambiguous layout, common ancestors_, etc.  It is easy to run afoul of them and these concerns complicate refactoring and redesign.  None of those problems apply to WeView v2.

### Why not to use WeView v2

* iOS Auto Layout has the advantage of being integrated into Interface Builder.  The support for iOS Auto Layout in Interface Builder has dramatically improved in Xcode 5.  _Bear in mind that WeView v2 can only be used programmatically_.

### Other Alternatives:

* [ReactiveCocoaLayout](https://github.com/ReactiveCocoa/ReactiveCocoaLayout) is another alternative to iOS Auto Layout built on [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa).  


<!-- TEMPLATE END -->

Next\: [Tutorial 1: Overview](Tutorial1.html)