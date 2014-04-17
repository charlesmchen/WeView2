---
permalink: TutorialBasics.html
layout: default
---

# Tutorial 4: Basics


<!-- TEMPLATE START -->

**WeView 2** provides a container (The **WeView** class) that offers a variety of layouts for its subviews.

Normally, when working with UIKit there is only the **superview** and its **subviews**, and subviews are added directly to their superview using _\[UIView addSubview:\]_.  

**WeView 2** introduces **layouts**, which a **WeView** superview uses to lay out \(ie. measure and arrange\) its subviews.  We add subviews to a **WeView** using a method that specifies the layout to apply to those subviews.

Typically, we only configure layout then, as subviews are added to a **WeView**.

## A Simple Example

Here is an example WeView that has three subviews: a UILabel, a UIImageView and a UIButton.

<video WIDTH="352" HEIGHT="280" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
 <source src="videos/video-1AC1BE13-D72E-45F5-95A3-80A8E925C210-24401-00023AED9C1B3FE7.mp4" type="video/mp4" />
 <source src="videos/video-1AC1BE13-D72E-45F5-95A3-80A8E925C210-24401-00023AED9C1B3FE7.webm" type="video/webm" />
 </video>


* **Layout Types**  These three subviews use a __horizontal layout__.  **WeViews** have a variety of built-in layouts and supports custom layouts as well.
* **New "addSubview\(s\)" methods**  _\[addSubviewsWithHorizontalLayout\]_ creates the new layout, adds the subviews to the WeView, and associates the layout with those subviews.  
* **Per-subview layouts** The layout only applies to the subviews passed as arguments to that method.
* **Layout properties** The layout has 5pt __margins__ and 5pt __spacing__.  
* **Subview properties** Some properties, such as __stretch__, __cell alignment__ and __desired size__ adjustment are set on subviews.  These properties are added to all UIViews using the  _UIView+WeView category_.
* **Convenience methods** There are usually many ways to set layout and subview properties, including built-in _UIView_ properties like its frame.  For example, you can set _margins_ individually with methods like _\[WeViewLayout setLeftMargin:\]_ or _\[WeViewLayout setTopMargin:\]_ or you can set multiple margins at once with methods like _\[WeViewLayout setHMargin:\]_ (which sets the left and right margins) or _\[WeViewLayout setMargin:\]_ (which sets all of the margins: top, bottom, left and right).
* **Chaining**  The configuration methods _\[setMargin:\]_ and _\[setSpacing:\]_ are chained.  WeView configuration methods return a reference to the receiver whenever possible to allow chaining, ie. invoking multiple methods on the same instance.
* **Auto-sizing**  The subviews are layed out at their __desired size__, ie. the size returned by _\[UIView sizeThatFits:\]_.
* __Order matters__  The subviews are layed out in the order in which they were added to their superview.
* __Automated Layout__ The WeView takes care of laying out its subviews.  It is not necessary to ever resize or position of any of the subviews. In fact, their existing size and position are ignored by the WeView layout.  

<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="TutorialLayoutModel.html">Tutorial 5: Layout Model</a></p>