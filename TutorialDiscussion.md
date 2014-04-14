---
permalink: TutorialDiscussion.html
layout: default
---

Discussion
==

<!-- TEMPLATE START -->

### Pixel and Point alignment

UIViews should always be pixel-aligned.  Many of them (ie. UILabel) don't render properly if they are not pixel-aligned.  WeView goes a step further and point-aligns all subviews.  We don't want layout to change between Retina and Non-Retina devices: it would only lead to subtle issues that would be easy to miss during the development process.  **WeView 2** takes care of point-alignment automatically.


<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="TutorialConvenience.html">Tutorial 11: Conveniences</a></p>