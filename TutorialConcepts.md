---
permalink: TutorialConcepts.html
layout: default
---

Tutorial 4: Concepts
==

<!-- TEMPLATE START -->

When a WeView lays out out its subviews, there are three kinds of actors in play:

* The __superview__, which is always a _WeView_.  It has a collection of layouts which it uses to lay out its subviews.
* The __subviews__, which can be any kind of _UIView_.  Thanks to the _UIView+WeView_ category, each subview's layout behavior can be controlled using properties that specify how it stretches, its desired size, etc.
* The __layouts__, which are a subclass of _WeViewLayout_.

* A given WeView can have __multiple layouts__.  It might use one layout to center a "title" UILabel at the top of its bounds and another layout to position a "share" UIButton in the bottom-right corner.
* Subviews are associated with a __layout__ when they are added to the WeView.
* Most WeViews will only use a single layout.  

### Mechanics

* WeView uses UIKit's built-in mechanisms for coordinating layout: _\[UIView setNeedsLayout\]_ and _\[UIView layoutSubviews\]_.
* Layout is automatically triggered when a UIView's size is changed.

### UIKit Fundamentals

* A UIView has separate __frame__ and __bounds__ properties.  
* The __frame__ represents the UIView's position (frame.origin) and size (frame.size) of the view within its superview's coordinate system.
* The __bounds__ represents the UIView's position (bounds.origin) and size (bounds.size) of the view within the UIView's own coordinate system.
* Changes to the __frame__ effect the __bounds__ and vice versa.
* WeView layout generally uses the __frame__ property.
* __frame__ values are expressed in _points_, not _pixels_.  On a Retina device, a _point_ is 2 _pixels_.
* The z-order Subviews reflects the order in which they were added to their superview.  That is, if two subviews overlap, the subview added first will be rendered behind the subview added second.


<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="TutorialLayouts.html">Tutorial 5: The Layouts</a></p>
