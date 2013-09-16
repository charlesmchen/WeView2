---
permalink: Tutorial1.html
layout: default
---

Next\: [Tutorial 2: iPhone Demo](Tutorial2.html)

Tutorial 1: Simple Demo
==

<!-- TEMPLATE START -->

The core class of this library is the __WeView__.  WeView is a subclass of UIView that can position its subviews using a variety of layouts.

Let's plunge right in with an example.  Here is a WeView that has three subviews: a UILabel, a UIImageView and a UIButton.

![Layout Snapshot](images/snapshot-C8C60F9D-AE44-4405-B077-A3EAC0636E31-90246-0004232B38E3D685-2.png)

Here's the code:

{% gist 6573950 %}


* These three subviews use a __horizontal layout__.  
* The layout has 5pt __margins__ and 5pt __spacing__.  These properties are like their HTML/CSS equivalents.
* The configuration methods _\[setMargin:\]_ and _\[setSpacing:\]_ are __chained__.  WeView2 configuration methods return a reference to the receiver whenever possible to allow chaining, ie. invoking multiple methods on the same instance. Chaining reduces the need for boilerplate code. Chaining is optional. 
* The subviews are layed out at their __desired size__, ie. the size returned by _\[UIView sizeThatFits:\]_.
* __Order matters__.  The subviews are layed out in the order in which they were added to their superview.
* __The key idea__: Although the WeView needs to be layed out as usual, it takes care of laying out its subviews.  It is not necessary to ever set the size or position of any of the subviews - in fact, their existing size and position are ignored by the WeView layout.


Margins and Spacing
===

<video WIDTH="288" HEIGHT="112" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-E5A4D704-7DA1-4BF8-A049-F5458EDF8B4E-76443-0005E3631CEDDA90.mp4" type="video/mp4" />
    <source src="videos/video-E5A4D704-7DA1-4BF8-A049-F5458EDF8B4E-76443-0005E3631CEDDA90.webm" type="video/webm" />
</video>

* A WeView's __desired size__ is the sum of it's subview's desired sizes plus margins, spacing, etc.
* Changing a layout's __margins__ or __spacing__ affects its WeView's desired size and how its subviews are positioned.
* You can set __margins__ with methods like _\[WeViewLayout setLeftMargin:\]_ or _\[WeViewLayout setTopMargin:\]_ or you can set multiple margins at once with methods like _\[WeViewLayout setMargin:\]_.
* You can set __spacing__ with _\[WeViewLayout setHSpacing:\]_ or _\[WeViewLayout setVSpacing:\]_ or set both at once with _\[WeViewLayout setSpacing:\]_.


Alignment 
===

<video WIDTH="380" HEIGHT="176" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-408A68F3-4E9A-4617-BF0B-138C8DC3C9C7-76443-0005E3B3D9B61AEF.mp4" type="video/mp4" />
    <source src="videos/video-408A68F3-4E9A-4617-BF0B-138C8DC3C9C7-76443-0005E3B3D9B61AEF.webm" type="video/webm" />
</video>

* If a WeView is resized, its contents are automatically re-layed out.  If any of its subviews are themeselves WeViews, they are also layed out.
* If a WeView's layout has extra space, its contents are positioned based on __alignment__.  By default, a horizontal layout has center alignment.
* A WeView layout has separate __hAlign__ (left, center, right) and __vAlign__ (top, center, bottom) properties.
* You can set alignment with _\[WeViewLayout setHAlign:\]_ or _\[WeViewLayout setVAlign:\]_ or you can set multiple margins at once with methods like _\[UIView setMargin:\]_.

{% gist 6573942 %}


Stretch
===

<video WIDTH="432" HEIGHT="256" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/videovideo-E96286B9-A865-4D1A-A76F-3CCD927011F2-76443-0005E3BFD3FAA3EE.mp4" type="video/mp4" />
    <source src="videos/video-E96286B9-A865-4D1A-A76F-3CCD927011F2-76443-0005E3BFD3FAA3EE.webm" type="video/webm" />
</video>

* The UIView+WeView category adds a number of properties to all UIViews that allow us to control the layout process.  
* For example, we can specify that one of the views __stretches__, ie. that it should receive any extra space in the layout.  Stretching is controlled by __hStretchWeight__ and __vStretchWeight__ properties.  
* A stretch weight of zero (the default value) indicates that the subview should not stretch.
* You can set stretch with _\[UIView setHStretchWeight:\]_ or _\[UIView setVStretchWeight:\]_ or simply _\[UIView setStretches\]_.

{% gist 6573957 %}


Overflow and cropping
===

<video WIDTH="268" HEIGHT="124" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-036A3D47-789B-4CB4-B1A7-0FF87933C4DD-76443-0005E4417509FC15.mp4" type="video/mp4" />
    <source src="videos/video-036A3D47-789B-4CB4-B1A7-0FF87933C4DD-76443-0005E4417509FC15.webm" type="video/webm" />
</video>

* If the WeView's bounds are smaller than it's desired size (ie. the subviews overflow their superview), the subviews of the layout are cropped to fit (unless the __cropSubviewOverflow__ property is set to NO).

<!-- TEMPLATE END -->

Next\: [Tutorial 2: iPhone Demo](Tutorial2.html)