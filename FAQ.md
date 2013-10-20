---
permalink: FAQ.html
layout: default
---

FAQ
==

<!-- TEMPLATE START -->

* __Q: When I try to build WeView, I get build errors like this: "Undefined symbols for architecture ...: "_CTFontCreateWithName","__

You may have accidentally added the demo app to your project.  The demo app uses the CoreText iOS framework.  You only need to add the "WeView" folder to your project.

* __Q: Does WeView support sub-pixel layout?__

__No.__  Many UIViews (ie. UILabels) don't render properly if they are not pixel-aligned.  WeView goes a step further and only supports point-alignment ( _not_ pixel-alignment).  This simplifies the development process by ensuring that layouts are consistent on retina and non-retina devices.


<!-- TEMPLATE END -->

Next\: [Bugs & Feature Requests](Issues.html)