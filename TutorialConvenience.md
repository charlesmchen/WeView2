---
permalink: TutorialConvenience.html
layout: default
---

Tutorial 11: Conveniences
==

<!-- TEMPLATE START -->

The _UIView+WeView_ category adds a number of convenience methods to all UIViews.

These methods allow you to write more concise, expressive code.

### Origin Accessors

	- (CGPoint)origin;
	- (void)setOrigin:(CGPoint)origin;
	- (CGFloat)x;
	- (void)setX:(CGFloat)value;
	- (CGFloat)y;
	- (void)setY:(CGFloat)value;

The origin accessors make left-aligning two views as easy as:

	view1.x = view2.x;

Without these accessors, you'd have to do something like this:

	CGRect view1Frame = view1.frame;
	view1Frame.origin.x = view2.frame.origin.x;
	view1.frame = view1Frame;

Note that this assumes that both views have the same superview, ie. that their origins are in the same coordinate system.


### Size Accessors

	- (CGSize)size;
	- (void)setSize:(CGSize)size;
	- (CGFloat)width;
	- (void)setWidth:(CGFloat)value;
	- (CGFloat)height;
	- (void)setHeight:(CGFloat)value;

### Right and Bottom Accessors

	- (CGFloat)right;
	- (void)setRight:(CGFloat)value;
	- (CGFloat)bottom;
	- (void)setBottom:(CGFloat)value;

The _right_ property is the view's x position + the view's width, ie. the right edge of the view.  Likewise, the _bottom_ property is the view's y + height.

To place two views side-by-side, you might do something like this:

	view2.x = view1.right;

### Center Accessors

	- (CGFloat)hCenter;
	- (void)setHCenter:(CGFloat)value;
	- (CGFloat)vCenter;
	- (void)setVCenter:(CGFloat)value;

The _hCenter_ and _vCenter_ properties let you horizontally center-align two views like this:

	view1.hCenter = view2.hCenter;




<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="TutorialIPhoneDemo.html">Tutorial 12: Example</a></p>