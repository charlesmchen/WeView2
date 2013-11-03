---
permalink: ExtrasDesiredSize.html
layout: default
---

Extras 1: Desired Size
==

<!-- TEMPLATE START -->


### Manipulating Desired Sizes

WeViews offer a variety of ways to manipulate the _desired size_ of a subview.

	// This adjustment can be used to manipulate the desired width of a view.
	- (UIView *)setDesiredWidthAdjustment:(CGFloat)value;
	
	// This adjustment can be used to manipulate the desired height of a view.
	- (UIView *)setDesiredHeightAdjustment:(CGFloat)value;
	
	// Sets both of the desiredWidthAdjustment and desiredHeightAdjustment properties.
	- (UIView *)setDesiredSizeAdjustment:(CGSize)value;

The _desired size adjustment_ properties let you add a fixed (positive or negative) adjustment to the desired width and/or height of the view.

For example, UIButtons have a useful _contentEdgeInsets_ property that functions like _padding_.  UILabels do not have a similar property, but by setting a _desired size adjustment_, we can add padding to a UILabel.



<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="designPhilosophy.html">Design Philosophy</a></p>