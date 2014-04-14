---
permalink: TutorialLayoutProperties.html
layout: default
---

Layout Properties
==

<!-- TEMPLATE START -->

### Margins and Spacing

<video WIDTH="360" HEIGHT="324" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-F38F546F-397C-4F0C-9756-94114D3FA777-34104-000125DB30986218.mp4" type="video/mp4" />
<source src="videos/video-F38F546F-397C-4F0C-9756-94114D3FA777-34104-000125DB30986218.webm" type="video/webm" />
</video>

__Margins__ and __spacing__ work like their HTML/CSS equivalents.  

* **Spacing** controls the space between subviews.
* **Margins** control the space between the contents of the subview and its bounds.
* **Container size depends on the size of its contents their layouts**. A WeView's _desired size_ is the sum of it's subview's desired sizes plus margins, spacing, etc. Changing a layout's _margins_ or _spacing_ affects its WeView's desired size and how its subviews are positioned.
* **Convenience methods offer many ways to set the same properties.** You can set _margins_ with methods like _\[WeViewLayout setLeftMargin:\]_ or _\[WeViewLayout setTopMargin:\]_ or you can set multiple margins at once with methods like _\[WeViewLayout setHMargin:\]_ (which sets the left and right margins) or _\[WeViewLayout setMargin:\]_ (which sets all of the margins: top, bottom, left and right). You can set _spacing_ with _\[WeViewLayout setHSpacing:\]_ or _\[WeViewLayout setVSpacing:\]_ or set both at once with _\[WeViewLayout setSpacing:\]_.

### Alignment

<video WIDTH="368" HEIGHT="384" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-C0E146FB-9E8D-4D94-9801-930842817EE7-34104-0001266CBF84E648.mp4" type="video/mp4" />
<source src="videos/video-C0E146FB-9E8D-4D94-9801-930842817EE7-34104-0001266CBF84E648.webm" type="video/webm" />
</video>

* **Content Alignment** If a WeView's layout has extra space, its contents are positioned based on **alignment**.  A WeView layout has separate **hAlign** (left, center, right) and **vAlign** (top, center, bottom) properties.  By default, layouts have center alignment.
* **Convenience methods**. You can set alignment with _\[WeViewLayout setHAlign:\]_ or _\[WeViewLayout setVAlign:\]_ or you can set multiple margins at once with methods like _\[UIView setMargin:\]_.

### Stretch

<video WIDTH="452" HEIGHT="380" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-9FC06858-E988-4214-8998-44F639BCA133-34104-000126A323C1EB39.mp4" type="video/mp4" />
<source src="videos/video-9FC06858-E988-4214-8998-44F639BCA133-34104-000126A323C1EB39.webm" type="video/webm" />
</video>

* The _UIView+WeView category_ adds a number of properties to all UIViews that allow us to control the layout process.  
* For example, we can specify that one of the views _stretches_, ie. that it should receive any extra space in the layout.  Stretching is controlled by _hStretchWeight_ and _vStretchWeight_ properties.  
* A stretch weight of zero (the default value) indicates that the subview should not stretch.
* You can set stretch with _\[UIView setHStretchWeight:\]_ or _\[UIView setVStretchWeight:\]_ or simply _\[UIView setStretches\]_.
* Additionally, you can use _\[WeViewLayout setSpacingStretches:\]_ to indicate that the spacing should stretch to fill any available space.  That spacing will only stretch if no subview can stretch.


### Cropping


<video WIDTH="268" HEIGHT="124" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-036A3D47-789B-4CB4-B1A7-0FF87933C4DD-76443-0005E4417509FC15.mp4" type="video/mp4" />
    <source src="videos/video-036A3D47-789B-4CB4-B1A7-0FF87933C4DD-76443-0005E4417509FC15.webm" type="video/webm" />
</video>

* If the WeView's bounds are smaller than it's desired size (ie. the subviews overflow their superview), the subviews of the layout are cropped to fit (unless the _cropSubviewOverflow_ property is set to NO).

<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="TutorialLayouts.html">Tutorial 7: The Layouts</a></p>