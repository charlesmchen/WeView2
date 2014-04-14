---
permalink: TutorialLayouts.html
layout: default
---

# Tutorial 7: The Layouts


<!-- TEMPLATE START -->

WeView Layouts have two responsibilities:

* Laying out the contents of (some of) the subviews of a WeView.
* Helping that WeView determine its desired size.  

WeView supports the following layouts:

## The Horizontal layout

<video WIDTH="584" HEIGHT="96" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-16CDA2D1-C93D-4592-961F-70070A6BFE94-95164-000693963F118B5A.mp4" type="video/mp4" />
    <source src="videos/video-16CDA2D1-C93D-4592-961F-70070A6BFE94-95164-000693963F118B5A.webm" type="video/webm" />
</video>

The Horizontal layout (shown here with top, center and bottom vertical alignment) lays out its subviews horizontally, left-to-right.

You can build 95% of most UIs using just the horizontal and vertical layouts.

{% gist 6576309 %}

## The Vertical Layout

<video WIDTH="184" HEIGHT="292" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-3508A3A7-5F9C-4CE6-9761-3A052B464BF1-95164-0006939E2698041E.mp4" type="video/mp4" />
    <source src="videos/video-3508A3A7-5F9C-4CE6-9761-3A052B464BF1-95164-0006939E2698041E.webm" type="video/webm" />
</video>

The Vertical layout (shown here with left, center and right horizontal alignment) lays out its subviews horizontally, top-to-bottom.

{% gist 6576312 %}

## The Stack Layout

<video WIDTH="184" HEIGHT="96" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-1D33CEE1-B9CD-44FF-A0CC-9DC09AC47E86-95164-000693A4BC594F85.mp4" type="video/mp4" />
    <source src="videos/video-1D33CEE1-B9CD-44FF-A0CC-9DC09AC47E86-95164-000693A4BC594F85.webm" type="video/webm" />
</video>

The Stack layout (shown here with a variety of alignments) lays out its subviews on top of each other in a stack.  Useful for positioning single subviews.

{% gist 6576334 %}

## The Flow Layout

<video WIDTH="600" HEIGHT="264" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-EEED3A95-6951-4DBD-9178-7F7732A98A07-95164-000693B0756B7483.mp4" type="video/mp4" />
    <source src="videos/video-EEED3A95-6951-4DBD-9178-7F7732A98A07-95164-000693B0756B7483.webm" type="video/webm" />
</video>

The Flow layout (shown here with left & v-center alignment at a variety of sizes) lays out its subviews in a text-like flow, in horizontal lines that wrap at the edge of the superview.

{% gist 6603480 %}

## The Block-based Layout

The Block-based layout can be used for unusual layouts.

{% gist 6576364 %}

## Misc.

* There is also a __Grid__ layout in the works.

* You can also create your own layout by subclassing WeViewLayout.  

<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="TutorialDesiredSize.html">Tutorial 8: Sizing</a></p>