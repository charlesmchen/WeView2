---
permalink: TutorialDiscussion.html
layout: default
---

# Tutorial 12: Discussion


<!-- TEMPLATE START -->

## Pixel and Point alignment

UIViews should always be pixel-aligned.  Many of them (ie. UILabel) don't render properly if they are not pixel-aligned.  WeView goes a step further and point-aligns all subviews.  We don't want layout to change between Retina and Non-Retina devices: it would only lead to subtle issues that would be easy to miss during the development process.  **WeView 2** takes care of point-alignment automatically.

## Multiple Layouts

A **WeView** can have multiple, separate layouts.  For example, it might use a vertical layout to arrange a title near its top border and a horizontal layout to place two buttons near its bottom border.  Each layout operates independently of the others and only one layout applies to any given subview.  The layouts will not conflict - in fact they should have no effect on each other whatsoever.

The desired size of a **WeView** is the maximum height and width desired by any of its layouts.

## Modifying Layouts

Usually, you only need to configure layout as you add subviews to a **WeView**.  Occasionally, you may need to alter layout at a later point in time, perhaps after the views have appeared.  This is safe, although you should generally retrigger layout by setting the __needsLayout__ property on any **WeView** whose layout will be affected.  

Re-layout can be animated using CoreAnimation.

<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="TutorialConvenience.html">Tutorial 13: Conveniences</a></p>