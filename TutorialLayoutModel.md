---
permalink: TutorialLayoutModel.html
layout: default
---

# Tutorial 5: Layout Model


<!-- TEMPLATE START -->

WeView uses a **cell-based** layout model.  Layouts arrange their subviews by dividing the superview's bounds into **cells**.  

The layout process works like this:

* A layout creates one cell for each subview, whose size reflects the desired size of that subview.
* The cells are laid out according to the layout type (in a row, a stack, a grid, etc.).
* If there is extra space in the layout, the cells are stretched to occupy it, if possible.
* The cells are aligned within the **WeView**'s bounds.
* If the subviews don't fit within the **WeView**'s bounds, they may be cropped.
* Lastly, subviews are positioned within their cell.

A **WeView** might have multiple layouts.  Each layout operates independently of the others and only one layout applies to any given subview.

## An Example

Here is a horizontal layout with three UILabels:

<video WIDTH="360" HEIGHT="284" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-46BD45C3-CA8B-4D9D-B7B3-08B828CDC640-27646-00023DDF172A5492.mp4" type="video/mp4" />
<source src="videos/video-46BD45C3-CA8B-4D9D-B7B3-08B828CDC640-27646-00023DDF172A5492.webm" type="video/webm" />
</video>

I've assigned a background color to each UILabel so that its frame (ie. size and position) is clear.

Each subview has its own cell in the layout.  In the animation above, the subviews are stretched to fill their cells to emphasize the difference between a subview and its cell.

* The labels use different font sizes, so they each have a different height.  Each of the cells, however, have the same height.  
* The spaces between and around the cells reflect the layout's _spacing_ and _margin_ properties.
* The layout's _hAlign_ and _vAlign_ properties default to _center alignment_, so the subviews are centered within their cells.

## Alignment

In our first example, the WeView was shown at its _desired size_, ie. just large enough to exactly fit its subviews.  Let's see what happens if that WeView is larger than its _desired size_.

<video WIDTH="380" HEIGHT="380" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-871E04EA-3AC3-4180-BDEC-56C88298247A-28150-00023EDACA25A175.mp4" type="video/mp4" />
<source src="videos/video-871E04EA-3AC3-4180-BDEC-56C88298247A-28150-00023EDACA25A175.webm" type="video/webm" />
</video>

* The layout's hAlign and vAlign properties default to _center alignment_, so the layout cells are centered within the superview's bounds _and_ the subviews are centered within their cells.

## Layout Alignment vs. Cell Alignment

Here's the same WeView if we use _top_ and _right alignment_.

<video WIDTH="380" HEIGHT="404" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-1A31F38D-3BFF-4B0C-A491-5250FB71F061-28150-00023EDF739EC382.mp4" type="video/mp4" />
<source src="videos/video-1A31F38D-3BFF-4B0C-A491-5250FB71F061-28150-00023EDF739EC382.webm" type="video/webm" />
</video>

Note that the layout cells are top- and right-aligned within the superview's bounds _and_ the subviews are top- and right-aligned within their layout cells.  The alignment of the subviews within their cells (or _cell alignment_) defaults to the _layout's alignment_ unless we set an explicit _cell alignment_ for a given subview.

We might want the labels to be top-aligned as a group within their superview (ie. the alignment property of the layout) but to be bottom-aligned with respect to each other (ie. the cellAlignment property of each subview).

<video WIDTH="380" HEIGHT="420" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-7F504DEE-5941-48B1-B8CE-A4DDE80B90DC-28150-00023EE54101B012.mp4" type="video/mp4" />
<source src="videos/video-7F504DEE-5941-48B1-B8CE-A4DDE80B90DC-28150-00023EE54101B012.webm" type="video/webm" />
</video>

## Custom Cell Alignment

Here we use _center vertical cell alignment_.

<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="TutorialLayoutProperties.html">Tutorial 6: Layout Properties</a></p>