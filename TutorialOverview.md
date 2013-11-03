---
permalink: TutorialOverview.html
layout: default
---

Tutorial 1: Overview
==

<!-- TEMPLATE START -->

The core class of this library is the __WeView__.  WeView is a subclass of UIView that can position its subviews using a variety of layouts.

Let's plunge right in with an example.  Here is a WeView that has three subviews: a UILabel, a UIImageView and a UIButton.

<video WIDTH="352" HEIGHT="280" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
 <source src="videos/video-1AC1BE13-D72E-45F5-95A3-80A8E925C210-24401-00023AED9C1B3FE7.mp4" type="video/mp4" />
 <source src="videos/video-1AC1BE13-D72E-45F5-95A3-80A8E925C210-24401-00023AED9C1B3FE7.webm" type="video/webm" />
 </video>

* These three subviews use a __horizontal layout__.  
* The layout has 5pt __margins__ and 5pt __spacing__.  These properties are like their HTML/CSS equivalents.
* The configuration methods _\[setMargin:\]_ and _\[setSpacing:\]_ are __chained__.  WeView configuration methods return a reference to the receiver whenever possible to allow chaining, ie. invoking multiple methods on the same instance. Chaining reduces the need for boilerplate code. Chaining is optional. 
* The subviews are layed out at their __desired size__, ie. the size returned by _\[UIView sizeThatFits:\]_.
* __Order matters__.  The subviews are layed out in the order in which they were added to their superview.
* __It's automated__: The WeView takes care of laying out its subviews.  It is not necessary to ever resize or position of any of the subviews. In fact, their existing size and position are ignored by the WeView layout.
* Like any other UIView, layout is triggered whenever _\[UIView setNeedsLayout\]_ is called on the WeView.  This happens automically when the layout is created and resized, so this usually takes care of itself.


### Margins and Spacing

<video WIDTH="360" HEIGHT="324" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-F38F546F-397C-4F0C-9756-94114D3FA777-34104-000125DB30986218.mp4" type="video/mp4" />
<source src="videos/video-F38F546F-397C-4F0C-9756-94114D3FA777-34104-000125DB30986218.webm" type="video/webm" />
</video>

* A WeView's __desired size__ is the sum of it's subview's desired sizes plus margins, spacing, etc.
* Changing a layout's __margins__ or __spacing__ affects its WeView's desired size and how its subviews are positioned.
* You can set __margins__ with methods like _\[WeViewLayout setLeftMargin:\]_ or _\[WeViewLayout setTopMargin:\]_ or you can set multiple margins at once with methods like _\[WeViewLayout setMargin:\]_.
* You can set __spacing__ with _\[WeViewLayout setHSpacing:\]_ or _\[WeViewLayout setVSpacing:\]_ or set both at once with _\[WeViewLayout setSpacing:\]_.


### Alignment 

<video WIDTH="368" HEIGHT="384" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-C0E146FB-9E8D-4D94-9801-930842817EE7-34104-0001266CBF84E648.mp4" type="video/mp4" />
<source src="videos/video-C0E146FB-9E8D-4D94-9801-930842817EE7-34104-0001266CBF84E648.webm" type="video/webm" />
</video>

* If a WeView's layout has extra space, its contents are positioned based on __alignment__.  By default, a horizontal layout has center alignment.
* A WeView layout has separate __hAlign__ (left, center, right) and __vAlign__ (top, center, bottom) properties.
* You can set alignment with _\[WeViewLayout setHAlign:\]_ or _\[WeViewLayout setVAlign:\]_ or you can set multiple margins at once with methods like _\[UIView setMargin:\]_.

* 
### Stretch

<video WIDTH="452" HEIGHT="380" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-9FC06858-E988-4214-8998-44F639BCA133-34104-000126A323C1EB39.mp4" type="video/mp4" />
<source src="videos/video-9FC06858-E988-4214-8998-44F639BCA133-34104-000126A323C1EB39.webm" type="video/webm" />
</video>

* The _UIView+WeView category_ adds a number of properties to all UIViews that allow us to control the layout process.  
* For example, we can specify that one of the views __stretches__, ie. that it should receive any extra space in the layout.  Stretching is controlled by __hStretchWeight__ and __vStretchWeight__ properties.  
* A stretch weight of zero (the default value) indicates that the subview should not stretch.
* You can set stretch with _\[UIView setHStretchWeight:\]_ or _\[UIView setVStretchWeight:\]_ or simply _\[UIView setStretches\]_.
* Additionally, you can use _\[WeViewLayout setSpacingStretches:\]_ to indicate that the spacing should stretch to fill any available space.  That spacing will only stretch if no subview can stretch.


### Cropping


<video WIDTH="268" HEIGHT="124" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-036A3D47-789B-4CB4-B1A7-0FF87933C4DD-76443-0005E4417509FC15.mp4" type="video/mp4" />
    <source src="videos/video-036A3D47-789B-4CB4-B1A7-0FF87933C4DD-76443-0005E4417509FC15.webm" type="video/webm" />
</video>

* If the WeView's bounds are smaller than it's desired size (ie. the subviews overflow their superview), the subviews of the layout are cropped to fit (unless the __cropSubviewOverflow__ property is set to NO).

<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="TutorialIPhoneDemo.html">Tutorial 2: iPhone Demo</a></p>