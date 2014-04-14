---
permalink: TutorialIPhoneDemo.html
layout: default
---

# Tutorial 12: Example


<!-- TEMPLATE START -->

Here's an example whose layout is _responsive_ to changes of orientation and device:

<video WIDTH="700" HEIGHT="720" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-B2B0C11D-E1A1-4CAE-B4B4-D043D5989B4E-40400-0001287E815CD5CB.mp4" type="video/mp4" />
<source src="videos/video-B2B0C11D-E1A1-4CAE-B4B4-D043D5989B4E-40400-0001287E815CD5CB.webm" type="video/webm" />
</video>

### Getting Started

We'll use one WeView (the _rootView_) to layout the contents of the screen.

{% gist 7295271 %}

### The Activity Indicator

We'll start with the easiest element of the layout, the activity indicator.

* We add the activity indicator to the _rootView_ with _\[addSubviewWithCustomLayout:\]_.  This method can be used for any subviews that are laid out alone.
* In this case, we don't need to need configure the layout or the subview.  The default behavior is to center-align the subview at its desired size.

{% gist 7295479 %}

### The Header

* We'll use a separate WeView for the header, the _headerView_.
* The headerView is populated with a "title" UILabel and a "tag" button.
* The UILabel and button use separate layouts; the label is center-aligned (the default behavior) and the tag button is right-aligned.
* The headerView is added to the rootView with top alignment.
* We call _setHStretches_ on the headerView so that it stretches horizontally, extending to the edges of the screen.

{% gist 7294435 %}

### The Pillbox Buttons

* We add the pillbox buttons in a _horizontal layout_.
* We configure the buttons' layout with bottom alignment.

{% gist 7295582 %}

### The Background

The background image is the trickiest part of the layout.

If we simply wanted to stretch the background image's UIImageView to fill the screen, we could simply:

* Configure the UIImageView with _\[setStretches\]_, so that it would stretch vertically and horizontally.
* Configure the UIImageView with _\[setIgnoreDesiredSize\]_, so that its size was based solely on the available space in the layout and add it to the rootView in its own layout.

{% gist 7295674 %}

![Layout Snapshot](images/snapshot-E4B61D65-B3B3-431B-A0F5-6707A8113EE9-32015-0002538CDA5194E7.png)

But simply stretching the image to fill the screen distorts its content.  We want to preserve the aspect ratio of the image as we stretch it, although this will cause the image to extend offscreen and be cropped.

![Layout Snapshot](images/snapshot-443C9E3D-08D9-4ED3-B247-306EAE2C7189-32015-0002538DD232DFAF.png)

Therefore, we wrap the the background image in a separate WeView and add the UIImageView using _\[addSubviewWithFillLayoutWAspectRatio\]_.

{% gist 7295668 %}

### The Final Code

{% gist 6489214 %}


<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="DemoApp.html">Demo App</a></p>