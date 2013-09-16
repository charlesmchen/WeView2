---
permalink: TutorialLayouts.html
layout: default
---

Next\: [Design Philosophy](designPhilosophy.html)

Tutorial 4: The Layouts
==

<!-- TEMPLATE START -->

<video WIDTH="268" HEIGHT="156" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-89E293B4-D0CE-4617-BE78-A8304A1598BA-88818-0005FC1B2CFA50CB.mp4" type="video/mp4" />
    <source src="videos/video-89E293B4-D0CE-4617-BE78-A8304A1598BA-88818-0005FC1B2CFA50CB.webm" type="video/webm" />
</video>

There are currently four layouts:

* The __Horizontal__ layout.  Lays out its subviews horizontally, left-to-right.

{% gist 6576309 %}

* The __Vertical__ layout.  Lays out its subviews horizontally, top-to-bottom.

{% gist 6576312 %}

* The __Stack__ layout.  Lays out its subviews on top of each other in a stack.  Useful for positioning single subviews.

{% gist 6576334 %}

* The __Block-based__ layout.  Block-based layouts can be used for unusual layouts. Note that the WeView's desired size will not reflect any subviews associated with block-based layouts.

{% gist 6576364 %}

There is also a __Grid__ layout and a __Flow__ layout in the works.

<!-- TEMPLATE END -->

Next\: [Design Philosophy](designPhilosophy.html)