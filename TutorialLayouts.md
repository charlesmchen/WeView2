---
permalink: TutorialLayouts.html
layout: default
---

Next\: [Design Philosophy](designPhilosophy.html)

Tutorial 4: The Layouts
==

<!-- TEMPLATE START -->

WeView supports the following layouts:


<video WIDTH="584" HEIGHT="96" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-16CDA2D1-C93D-4592-961F-70070A6BFE94-95164-000693963F118B5A.mp4" type="video/mp4" />
    <source src="videos/video-16CDA2D1-C93D-4592-961F-70070A6BFE94-95164-000693963F118B5A.webm" type="video/webm" />
</video>

* The __Horizontal__ layout.  Lays out its subviews horizontally, left-to-right.

{% gist 6576309 %}


<video WIDTH="184" HEIGHT="292" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-3508A3A7-5F9C-4CE6-9761-3A052B464BF1-95164-0006939E2698041E.mp4" type="video/mp4" />
    <source src="videos/video-3508A3A7-5F9C-4CE6-9761-3A052B464BF1-95164-0006939E2698041E.webm" type="video/webm" />
</video>

* The __Vertical__ layout.  Lays out its subviews horizontally, top-to-bottom.

{% gist 6576312 %}


<video WIDTH="184" HEIGHT="96" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-1D33CEE1-B9CD-44FF-A0CC-9DC09AC47E86-95164-000693A4BC594F85.mp4" type="video/mp4" />
    <source src="videos/video-1D33CEE1-B9CD-44FF-A0CC-9DC09AC47E86-95164-000693A4BC594F85.webm" type="video/webm" />
</video>

* The __Stack__ layout.  Lays out its subviews on top of each other in a stack.  Useful for positioning single subviews.

{% gist 6576334 %}


<video WIDTH="600" HEIGHT="264" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-EEED3A95-6951-4DBD-9178-7F7732A98A07-95164-000693B0756B7483.mp4" type="video/mp4" />
    <source src="videos/video-EEED3A95-6951-4DBD-9178-7F7732A98A07-95164-000693B0756B7483.webm" type="video/webm" />
</video>

* The __Flow__ layout.  Lays out its subviews so that they wrap like text flow.

{% gist 6603480 %}

* The __Block-based__ layout.  Block-based layouts can be used for unusual layouts. Note that the WeView's desired size will not reflect any subviews associated with block-based layouts.

{% gist 6576364 %}

* There is also a __Grid__ layout in the works.

* You can also create your own layout by subclassing WeViewLayout.  

<!-- TEMPLATE END -->

Next\: [Design Philosophy](designPhilosophy.html)