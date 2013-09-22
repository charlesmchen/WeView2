---
permalink: Tutorial2.html
layout: default
---

Next\: [Tutorial 3: Installing](TutorialInstalling.html)

Tutorial 2: iPhone Demo
==

<!-- TEMPLATE START -->

Here's another example that demonstrates a layout that is _responsive_ to changes of orientation and device:

<video WIDTH="720" HEIGHT="720" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
    <source src="videos/video-E268F6BC-4360-47CE-8EC4-36D19B2D15EF-76443-0005E485C8E73782.mp4" type="video/mp4" />
    <source src="videos/video-E268F6BC-4360-47CE-8EC4-36D19B2D15EF-76443-0005E485C8E73782.webm" type="video/webm" />
</video>

### Code 

{% gist 6489214 %}

### Discussion

* There are two WeViews in this layout: the outer _rootView_ and the inner _bodyView_.  
* The _rootView_ contains the toolbar and _bodyView_ in a __vertical layout__.
* The _bodyView_ is configured with __\[UIView setStretches\]__ which indicates to the layout that it 
should be stretched to receive any extra space in the layout.
* The _bodyView_ is also configured with __\[UIView setIgnoreDesiredSize\]__ which indicates to the layout that the __desired size__ of this view should be ignored.
* A background image is added to the _bodyView_ with a custom layout that exactly fills the _bodyView_'s bounds while retaining its aspect ratio.
* A group of three buttons is added to the _bodyView_ using a horizontal layout.  This layout has __bottom alignment__ and a 20pt __bottom margin__.
* An activity indicator is added to the _bodyView_ with its own layout.  That layout doesn't need to be configured, since the default behavior is to center subviews within their superview.
* The _bodyView_ contains three separate groups of subviews: the background, the buttons and the activity indicator.  __Each group of subviews has its own layout__.  The layouts work independently and only affect their subviews.  
* __Each layout can be configured separately__.  For example, the buttons' layout has bottom alignment, but that doesn't effect the activity indicator because it has a separate layout.
 


<!-- TEMPLATE END -->

Next\: [Tutorial 3: Installing](TutorialInstalling.html)