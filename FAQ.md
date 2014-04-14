---
permalink: FAQ.html
layout: default
---

FAQ
==

<!-- TEMPLATE START -->

* __Q: When I try to build WeView, I get build errors like this: "Undefined symbols for architecture ...: "_CTFontCreateWithName","__

You may have accidentally added the demo app to your project.  The demo app uses the CoreText iOS framework.  You only need to add the "WeView" folder to your project.


* __Q: How do I remove subviews from a WeView?__

Subviews are removed as normal, using _\[UIView removeFromSuperview\]_.  The subview's layout is updated or disposed of automatically.



<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="Issues.html">Bugs &amp; Feature Requests</a></p>