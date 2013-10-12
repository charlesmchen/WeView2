---
permalink: TutorialConcepts.html
layout: default
---

Next\: [Tutorial 5: The Layouts](TutorialLayouts.html)

Tutorial 4: Concepts
==

<!-- TEMPLATE START -->

When a WeView layouts out it's subviews, there are three kinds of actors in play:

* The __superview__ (which is always a _WeView_).  It maintains a list of layouts and which subviews they apply to.
* The __subviews__ (which can be any _UIView_).  Thanks to the _UIView+WeView_ category, each subview's layout behavior can be controlled using properties that control how it stretches, its desired size, etc.
* The __layouts__ (which are a subclass of _WeViewLayout_). 

* A given WeView can have __multiple layouts__.  It might use one layout to center a "title" UILabel at the top of its bounds and another layout to position a "share" UIButton in the bottom-right corner.
* Every WeView has one __default layout__.  It applies to any subviews not associated with a __custom layout__.
* Subviews are usually associated with a __custom layout__ when they are added to the WeView.
* Most WeViews will only use a single layout.  It doesn't matter whether this is a custom or default layout.

As usual when working with UIKit:

* A UIView has separate __frame__ and __bounds__ properties.  
* The __frame__ represents the UIView's position (frame.origin) and size (frame.size) of the view within its superview's coordinate system.
* The __bounds__ represents the UIView's position (bounds.origin) and size (bounds.size) of the view within the UIView's own coordinate system.
* Changes to the __frame__ effect the __bounds__ and vice versa.
* WeView layout generally uses the __frame__ property.
* __frame__ values are expressed in _points_, not _pixels_.  On a Retina device, a _point_ is 2 _pixels_.

### Mechanics

* WeView uses UIKit's built-in mechanisms for coordinating layout: _\[UIView setNeedsLayout\]_ and _\[UIView layoutSubviews\]_.


<!-- TEMPLATE END -->

Next\: [Tutorial 5: The Layouts](TutorialLayouts.html)