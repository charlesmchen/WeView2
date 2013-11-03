---
permalink: TutorialStretch.html
layout: default
---

Tutorial 8: Stretch
==

<!-- TEMPLATE START -->

_Stretch_ is a per-subview property. It has a few roles in WeView.  Put simply, subviews can "stretch" to receive extra space in their layout.


### Vertical Stretch in a Horizontal Layout

<video WIDTH="356" HEIGHT="324" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-9DAFBBF5-5099-4CCF-8A41-F7DCAB5E2E1C-30497-00024594CE3DD371.mp4" type="video/mp4" />
<source src="videos/video-9DAFBBF5-5099-4CCF-8A41-F7DCAB5E2E1C-30497-00024594CE3DD371.webm" type="video/webm" />
</video>

Here we set one UILabel to vertically stretch.  Since it stretches _vertically_ in a _horizontal_ layout, its stretch _does not_ effect the layout of the other subviews.  

The stretch affects the vertical size of the subviews's _layout cell_ (See: [Layout Model](TutorialLayoutModel.html)), _and_ the subview stretches vertically to fill its layout cell.


### Horizontal Stretch in a Horizontal Layout

<video WIDTH="356" HEIGHT="324" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-C3956C04-2100-4C64-8958-4EEB97CE381D-30497-00024592468344C2.mp4" type="video/mp4" />
<source src="videos/video-C3956C04-2100-4C64-8958-4EEB97CE381D-30497-00024592468344C2.webm" type="video/webm" />
</video>

Here we set one UILabel to horizontally stretch.  Since it stretches _horizontally_ in a _horizontal_ layout, its stretch _does_ effect the layout of the other subviews.

Again, the subview's horizontal stretch affects the size of its _layout cell_.


### When More Than One Subview Stretches...

 <video WIDTH="356" HEIGHT="324" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
 <source src="videos/video-E3D6C0C3-99D0-4244-8DE3-AFAC08EACF50-30497-000246034A91B250.mp4" type="video/mp4" />
 <source src="videos/video-E3D6C0C3-99D0-4244-8DE3-AFAC08EACF50-30497-000246034A91B250.webm" type="video/webm" />
 </video>

When more than one subview stretches horizontally in a horizontal layout, they _share any extra space_ in the layout equally between them.

Note that they _do not have the same width_; they each receive an _equal amount of extra space_.  If we wanted them to have the same width we would a) make sure they had the same stretch weight and b) call _\[UIView setIgnoreDesiredSize\]_ on both views, so that their sizes were based purely on their stretch weight and not on their desired size.

### Stretch Weight

<video WIDTH="356" HEIGHT="324" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-195620C4-BBD3-4CAC-95F3-9A5C4CD02BB3-30497-0002460DBE426621.mp4" type="video/mp4" />
<source src="videos/video-195620C4-BBD3-4CAC-95F3-9A5C4CD02BB3-30497-0002460DBE426621.webm" type="video/webm" />
</video>

Usually it is sufficient to set whether or not subviews stretch.  However, we can also control how they stretch by setting their _stretch weight_.  

In this example, the second label has an hStretchWeight of 1.0 and the first label is shown with hStretchWeights of 0.0, 1.0, 2.0, 3.0 and 4.0.  Extra space is divided between the stretching subview in proportion to their weights.


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