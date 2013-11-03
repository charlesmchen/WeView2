---
permalink: Tutorial2.html
layout: default
---

Tutorial 2: iPhone Demo
==

<!-- TEMPLATE START -->

Here's an example whose layout is _responsive_ to changes of orientation and device:

<video WIDTH="700" HEIGHT="720" AUTOPLAY="true" controls="true" LOOP="true" class="embedded_video" >
<source src="videos/video-B2B0C11D-E1A1-4CAE-B4B4-D043D5989B4E-40400-0001287E815CD5CB.mp4" type="video/mp4" />
<source src="videos/video-B2B0C11D-E1A1-4CAE-B4B4-D043D5989B4E-40400-0001287E815CD5CB.webm" type="video/webm" />
</video>

### Code 

{% gist 6489214 %}

### Discussion

* Using WeView is a lot like using HTML to layout a webpage.  You decompose the design (typically using a _box model_) into rectangular subregions which you construct out of WeViews.  In this sense, _WeViews are like HTML divs_.
* There are two WeViews in this layout: the _rootView_ and the _headerView_.  
* A background image is added to the _rootView_.  
* The background image is configured with __\[UIView setStretches\]__ which indicates to the layout that it should be stretched to fill the layout.
* The background image is also configured with __\[UIView setIgnoreDesiredSize\]__ which indicates to the layout that the __desired size__ of this view should be ignored.
* Lastly, the background image's layout is configured with a special _cellPositioning_ that indicates the background view's aspect ratio should be preserved.  Otherwise, stretching the image would distort it.
* The _headerView_ is populated with a "title" UILabel and a "tag" button. This UILabel and button __use separate layouts__.
* A group of three "pillbox" buttons is added to the _rootView_ using a horizontal layout.  This layout has __bottom alignment__ and a 25pt __bottom margin__.
* An activity indicator is added to the _rootView_ with its own layout.  That layout doesn't need to be configured, since the default behavior is to center subviews within their superview.
* The _rootView_ contains four separate groups of subviews: the background image, the _headerView_, the buttons and the activity indicator.  __Each group of subviews has its own layout__.  The layouts work independently and only affect their subviews.  
* __Each layout can be configured separately__.  For example, the buttons' layout has bottom alignment, but that doesn't effect the activity indicator because it has a separate layout.
 


<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="TutorialInstalling.html">Tutorial 3: Installing</a></p>