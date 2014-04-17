---
permalink: TutorialOverview.html
layout: default
---

# Tutorial 1: Overview


<!-- TEMPLATE START -->

The core of **WeView 2** is the __WeView__, a UIView that offers a variety of layouts for its subviews.

Here is an example WeView that has three subviews: a UILabel, a UIImageView and a UIButton.

<video WIDTH="352" HEIGHT="280" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
 <source src="videos/video-1AC1BE13-D72E-45F5-95A3-80A8E925C210-24401-00023AED9C1B3FE7.mp4" type="video/mp4" />
 <source src="videos/video-1AC1BE13-D72E-45F5-95A3-80A8E925C210-24401-00023AED9C1B3FE7.webm" type="video/webm" />
 </video>


* **Declarative** WeViews use a declarative syntax that operates on a higher level than fixed sizes and positioning.
* **Properties**  Layout behavior is specified by setting properties on layouts and/or subviews.  In this case, the layout has 5pt __margins__ and 5pt __spacing__.  
* **Multiple Layout Types**  These three subviews use a __horizontal layout__.  **WeViews** have a variety of built-in layouts and support custom layouts as well.

## When & How Does Layout Occur?

Most importantly, layout is automated.  In most cases, you don't need any more code than shown in the example above.  Layout is triggered automatically.  

UIKit provides a mechanism for triggering layout: UIView's **needsLayout** property.  It is a simple "dirty flag" for layout.  UIKit ensures that _\[UIView layoutSubviews\]_ is eventually called whenever **needsLayout** is set.  Layout is needed in the following conditions:

- The **WeView** is resized.
- The **WeView's** layouts are modified.
- Subviews are added to or removed from the **WeView**.
- The state of one a **WeView's** subviews changes in a way that affects layout, ie. that changes that subview's desired size.

**WeView 2** automatically triggers layout in all but the last of these conditions.  In that case, you should trigger layout yourself by setting the **needsLayout** property on the WeView to YES.

Once you've added a subview to a **WeView** with a layout, you should never try to manually change its position or size.  The **WeView** will usually overrule any changes you make to the subview.

<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="TutorialInstalling.html">Tutorial 2: Installing</a></p>