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
    <source src="videos/video-86091C1C-394D-4590-A423-FE76B3F0FA69-42205-0006D4F97F73EB9E.mp4" type="video/mp4" />
    <source src="videos/video-86091C1C-394D-4590-A423-FE76B3F0FA69-42205-0006D4F97F73EB9E.webm" type="video/webm" />
</video>

### Code 

{% gist 6489214 %}

### Discussion

* There are two WeViews in this layout: the _rootView_ and the _headerView_.  
* The _rootView_ is configured with __\[UIView setStretches\]__ which indicates to the layout that it 
should be stretched to receive any extra space in the layout.
* The _rootView_ is also configured with __\[UIView setIgnoreDesiredSize\]__ which indicates to the layout that the __desired size__ of this view should be ignored.
* A background image is added to the _rootView_ with a custom layout that exactly fills the _rootView_'s bounds while retaining its aspect ratio.
* The _headerView_ is populated with a "title" UILabel and a "tag" button. This UILabel and button __use separate layouts__.
* A group of three "pillbox" buttons is added to the _rootView_ using a horizontal layout.  This layout has __bottom alignment__ and a 25pt __bottom margin__.
* An activity indicator is added to the _rootView_ with its own layout.  That layout doesn't need to be configured, since the default behavior is to center subviews within their superview.
* The _rootView_ contains four separate groups of subviews: the background image, the _headerView_, the buttons and the activity indicator.  __Each group of subviews has its own layout__.  The layouts work independently and only affect their subviews.  
* __Each layout can be configured separately__.  For example, the buttons' layout has bottom alignment, but that doesn't effect the activity indicator because it has a separate layout.
 


<!-- TEMPLATE END -->

Next\: [Tutorial 3: Installing](TutorialInstalling.html)