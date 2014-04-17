---
permalink: TutorialSubviewProperties.html
layout: default
---

# Tutorial 7: Subview Properties


<!-- TEMPLATE START -->

**WeView 2** adds a number of properties to all UIViews that can be used to control their layout.  

These properties are stored using [Associated Objects](http://nshipster.com/associated-objects/), so subviews don't need to extend any class or implement any interface.

These properties are added using the [UIView+WeView](https://github.com/charlesmchen/WeView2/blob/master/WeView/UIView%2BWeView.h) category.

## Stretch

<video WIDTH="452" HEIGHT="380" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-9FC06858-E988-4214-8998-44F639BCA133-34104-000126A323C1EB39.mp4" type="video/mp4" />
<source src="videos/video-9FC06858-E988-4214-8998-44F639BCA133-34104-000126A323C1EB39.webm" type="video/webm" />
</video>

The stretch properties can be used to control whether or not the subview has a fixed size or whether it can stretch to fill any extra space in its superview's bounds.  

* **Properties** Stretch is controlled by _hStretchWeight_ and _vStretchWeight_ properties.  
* A stretch weight of zero (the default value) indicates that the subview should not stretch.
* **Defaults** By default, subviews do not stretch.

Most of the time, you won't need to specify a specific stretch weight and can simply use of the following convenience methods:

    - (UIView *)setHStretches;
    - (UIView *)setVStretches;
    - (UIView *)setStretches;

See the [Stretch section of the tutorial](TutorialStretch.html).

## Sizing

The sizing properties can be used to control the subview's size.  See the [Sizing section of the tutorial](TutorialDesiredSize.html).

## Cell Alignment

The cell alignment properties can be used to control the alignment of the subview within its layout cell.  See the [Layout Model section of the tutorial](TutorialLayoutModel.html).

<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="TutorialLayouts.html">Tutorial 8: The Layouts</a></p>