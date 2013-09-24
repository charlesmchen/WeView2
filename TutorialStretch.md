---
permalink: TutorialStretch.html
layout: default
---

Next\: [Tutorial 9: Conveniences](TutorialConvenience.html)

Tutorial 8: Stretch
==

<!-- TEMPLATE START -->

_Stretch_ is a per-subview property. It has a few roles in WeView.  Put simply, subviews can "stretch" to receive extra space in their layout.


### Vertical Stretch in a Horizontal Layout

<video WIDTH="400" HEIGHT="152" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-9ABCF1F2-A327-4C9A-A13E-25EC9E666F1F-14185-0006A073D25D55DE.mp4" type="video/mp4" />
    <source src="videos/video-9ABCF1F2-A327-4C9A-A13E-25EC9E666F1F-14185-0006A073D25D55DE.webm" type="video/webm" />
</video>

Here is a UILabel shown with and without vertical stretch.  Since it stretches _vertically_ in a _horizontal_ layout, its stretch _does not_ effect the layout of the other subviews.  

The subview uses all of the vertical space within its _layout cell_ (See: [Layout Model](TutorialLayoutModel.html)).

{% gist 6618909 %}


### Horizontal Stretch in a Horizontal Layout

<video WIDTH="400" HEIGHT="152" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-A5C00D90-5687-4FCC-B1A8-8B67F1E6D742-14185-0006A0767357299A.mp4" type="video/mp4" />
    <source src="videos/video-A5C00D90-5687-4FCC-B1A8-8B67F1E6D742-14185-0006A0767357299A.webm" type="video/webm" />
</video>

Here is the same UILabel shown with and without horizontal stretch.  Since it stretches _horizontally_ in a _horizontal_ layout, its stretch _does_ effect the layout of the other subviews.

The subview's horizontal stretch affects the size of its _layout cell_.

{% gist 6618913 %}


### When More Than One Subview Stretches...

<video WIDTH="400" HEIGHT="152" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-308F14F1-4EED-4322-A938-5438B0214F0E-14185-0006A0C8DDA3AB6E.mp4" type="video/mp4" />
    <source src="videos/video-308F14F1-4EED-4322-A938-5438B0214F0E-14185-0006A0C8DDA3AB6E.webm" type="video/webm" />
</video>

When more than one subview stretches horizontally in a horizontal layout, they _share any extra space_ in the layout equally between them.

Note that they _do not have the same width_; they each receive an _equal amount of extra space_.

{% gist 6619043 %}


### Stretch Weight

<video WIDTH="400" HEIGHT="152" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-D48DFCA9-6095-42CD-81AA-77CDF1D053C1-14185-0006A1A248E1701E.mp4" type="video/mp4" />
    <source src="videos/video-D48DFCA9-6095-42CD-81AA-77CDF1D053C1-14185-0006A1A248E1701E.webm" type="video/webm" />
</video>

Usually it is sufficient to set whether or not subviews stretch.  However, we can also control how they stretch by setting their _stretch weight_.  

In this example, the second label has an hStretchWeight of 1.0 and the first label is shown with hStretchWeights of 0.0, 1.0, 2.0, 3.0 and 4.0.  Extra space is divided between the stretching subview in proportion to their weights.

{% gist 6619029 %}


### Stretch Properties and Accessors

The _UIView+WeView_ category adds two stretch-related properties to all UIViews:

	- (UIView *)setHStretchWeight:(CGFloat)value;
	- (UIView *)setVStretchWeight:(CGFloat)value;

The _UIView+WeView_ category also adds a few convenience accessors:

	- (UIView *)setHStretches; // A convenience accessor that sets hStretchWeight = 1.f.
	- (UIView *)setVStretches; // A convenience accessor that sets vStretchWeight = 1.f.
	- (UIView *)setStretches; // A convenience accessor that sets hStretchWeight = 1.f and vStretchWeight = 1.f.

Typically, we just want to indicate which subviews stretch and which don't.  These convenience accessors set stretch to a default non-zero value.

### Ignoring Desired Size

As noted above, usually layouts will begin by laying out their subviews at their _desired sizes_ and then divide any extra space between stretching subviews if necessary.  Sometimes it is convenient to ignore the desired size of subviews.

<video WIDTH="292" HEIGHT="300" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-B0203939-DBF5-4EDA-9DC3-D76E58FD7522-19015-0006A36CDD754484.mp4" type="video/mp4" />
    <source src="videos/video-B0203939-DBF5-4EDA-9DC3-D76E58FD7522-19015-0006A36CDD754484.webm" type="video/webm" />
</video>

It this example, we have a UILabel and a UIScrollView in a vertical layout.  The UIScrollView contains a UIImageView with an image much larger than the available space. The title's height should reflect it's _desired size_ and the UIScrollView should get the rest of the height, regardless of its desired size.  We therefore invoke _\[UIView setIgnoreDesiredSize\]_ on the UIScrollView.

{% gist 6619176 %}


<!-- TEMPLATE END -->

Next\: [Tutorial 9: Conveniences](TutorialConvenience.html)