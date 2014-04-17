---
permalink: TutorialTerminology.html
layout: default
---

# Tutorial 3: Terminology


<!-- TEMPLATE START -->

## View Hierarchy

Layout takes place in the context of a **View Hierarchy**, but generally we only need to concern ourselves with the relationships between a single parent view and its children at a time.  

If your layout logic doesn't have this kind of locality, there is probably a better approach.  

## Superview & Subviews

In the context of layout, we call a parent view the **superview** and its children the **subviews**.  When using **WeView 2**, the superview will generally be a **WeView**.  Subviews can be any kind of UIView.

Subviews don't need to extend any class or implement any interface to work with **WeView 2**.

## Widgets vs. Containers

We also distinguish between **widgets** - the visible elements of the interface, ie. buttons and labels - and **containers**, mostly invisible views that we use to structure and layout other views.  In HTML, DIVs are usually used as **containers**; in UIKit, plain UIViews are often used.  The core of **WeView 2** is the **WeView** container class.

We refer to a given container's subviews collectively as its **contents**.

## Measurement and Arrangement

There are two complementary aspects of layout: **measurement** and **arrangement**.  **Measurement** is the process of determining what size each view should be - perhaps in the abstract, or perhaps in the context of specific amount of space.  **Arrangement** is the process of actually sizing and positioning views and always takes place in the context of a specific space.  

In UIKit, **measurement** centers around the _\[UIView sizeThatFits:\]_ method and **arrangement** is driven by the _\[UIView layoutSubviews\]_ method.

## Desired Size

In terms of **measurement**, many views have a specific size they want to have.  Ie. a button might want to be the size of its icon and a UILabel might want to be the size of its text, as rendered with its font.  UIKit refers to this as a view's **desired size**.  (When using **WeView 2**, we can safely ignore the related concept of **intrinsic size**.)  A view's **desired size** corresponds to the size returned by _\[UIView sizeThatFits:\]_.  

Note that the **desired size** of a view can depend on the argument passed to that method and is a surprisingly complicated concept.  

More information can be found in the [Sizing](TutorialDesiredSize.html) section of the tutorial.

## Frame and Bounds

UIViews use two coordinate systems.  A UIView's **frame** specifies its size and position in the coordinate system of its parent.  A UIView's **bounds** specifies its size and position in its own local coordinate system.  Layout of **subviews** always takes place in the coordinate system of the **superview** and therefore manipulates the subviews' frames.  Changes to a view's frame affects the bounds and vice versa.  UIView properties (ie. frame) and WeView properties (ie. spacing) are expressed in points, not pixels. On a Retina device, a point is 2 pixels.

<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="TutorialBasics.html">Tutorial 4: Basics</a></p>