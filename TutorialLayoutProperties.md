---
permalink: TutorialLayoutProperties.html
layout: default
---

# Tutorial 6: Layout Properties


<!-- TEMPLATE START -->

## Margins and Spacing

<video WIDTH="360" HEIGHT="324" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-F38F546F-397C-4F0C-9756-94114D3FA777-34104-000125DB30986218.mp4" type="video/mp4" />
<source src="videos/video-F38F546F-397C-4F0C-9756-94114D3FA777-34104-000125DB30986218.webm" type="video/webm" />
</video>

__Margins__ and __spacing__ work like their HTML/CSS equivalents.  

* **Spacing** controls the space between subviews.
* **Margins** control the space between the contents of the **WeView** (ie. its subviews) and its edges.
* **Defaults** By default, layouts have no margins or spacing.
* **Convenience methods** You can set _margins_ with methods like _\[WeViewLayout setLeftMargin:\]_ or _\[WeViewLayout setTopMargin:\]_ or you can set multiple margins at once with methods like _\[WeViewLayout setHMargin:\]_ (which sets the left and right margins) or _\[WeViewLayout setMargin:\]_ (which sets all of the margins: top, bottom, left and right). You can set _spacing_ with _\[WeViewLayout setHSpacing:\]_ or _\[WeViewLayout setVSpacing:\]_ or set both at once with _\[WeViewLayout setSpacing:\]_.

## Alignment

<video WIDTH="368" HEIGHT="384" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-C0E146FB-9E8D-4D94-9801-930842817EE7-34104-0001266CBF84E648.mp4" type="video/mp4" />
<source src="videos/video-C0E146FB-9E8D-4D94-9801-930842817EE7-34104-0001266CBF84E648.webm" type="video/webm" />
</video>

* **Layout alignment** If a WeView's layout has extra space, its contents are positioned based on **alignment**.  A WeView layout has separate **hAlign** (left, center, right) and **vAlign** (top, center, bottom) properties.  
* **Defaults** By default, layouts have center alignment.
* **Convenience methods**. You can set alignment with _\[WeViewLayout setHAlign:\]_ or _\[WeViewLayout setVAlign:\]_ or you can set multiple margins at once with methods like _\[UIView setMargin:\]_.

Don't confuse **Layout Alignment** with **Cell Alignment**.  **Layout Alignment** is a layout property and determines how a layout's subviews as a whole are aligned within the **WeView's** bounds.  **Cell Alignment** is a subview property and determines how a subview is aligned within its layout cell.  See the [Layout Model section of the tutorial](TutorialLayoutModel.html).


## Cropping

<video WIDTH="268" HEIGHT="124" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-036A3D47-789B-4CB4-B1A7-0FF87933C4DD-76443-0005E4417509FC15.mp4" type="video/mp4" />
    <source src="videos/video-036A3D47-789B-4CB4-B1A7-0FF87933C4DD-76443-0005E4417509FC15.webm" type="video/webm" />
</video>

**Layout Alignment** and  **Subview Stretch** apply when there is extra space in the **WeView's** bounds for layout.  There can also be a shortage of space.  In this case **Subview Stretch** also applies.  However, if the subviews cannot be stretched to fit inside a **WeView**, layouts can also optionally crop their subviews to fit inside their bounds.  The _cropSubviewOverflow_ layout property controls this behavior.  

However, layouts generally should not have a shortage of space so you usually don't need to worry about this.

<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="TutorialSubviewProperties.html">Tutorial 7: Subview Properties</a></p>