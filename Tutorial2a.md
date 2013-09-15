---
permalink: Tutorial2a.html
layout: default
---

Next\: [Tutorial 3: Test](Tutorial3.html)

Tutorial 2: Layouts
==

<!-- TEMPLATE START -->

The core class of this library is the __WeView__.  
WeView is a subclass of UIView that can position its subviews using a variety of layouts.

### Example 1

Let's plunge right in with an example.  Here is a WeView that contains a UILabel, a UIImageView and a UIButton.

![Layout Snapshot](images/snapshot-C8C60F9D-AE44-4405-B077-A3EAC0636E31-90246-0004232B38E3D685-2.png)

Here's the code:

{% gist 6489061 %}

* The three subviews use a __horizontal layout__.  
* The layout has 5pt __margins__ and 5pt __spacing__.  These properties are like their HTML/CSS equivalents.
* The configuration methods _\[setMargin:\]_ and _\[setSpacing:\]_ are __chained__.  WeView2 configuration methods return a reference to the receiver whenever possible to allow chaining, ie. invoking multiple methods on the same instance. Chaining reduces the need for boilerplate code. Chaining is optional. 
* The subviews are layed out at their __desired size__, ie. the size returned by _\[UIView sizeThatFits:\]_.
* __The key idea__: Although the WeView needs to be layed out as usual, it takes care of laying out its subviews.  It is not necessary to ever set the size or position of any of the subviews - in fact, their existing size and position are ignored by the WeView layout.

### Example 2

Here's another example:

![Layout Snapshot](images/iphone_example.png)

Here's the code:

{% gist 6489214 %}

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
 



The _bodyView_ is also configured with _\[UIView setIgnoreDesiredSize\]_ which indicates to the layout that the __desired size__ of this view should be ignored.


![Layout Snapshot](images/snapshot-397477B6-5DFF-4EFE-981D-9F1A287DA87F-81210-0003C33F3794A10F-1.png)
![Layout Snapshot](images/snapshot-397477B6-5DFF-4EFE-981D-9F1A287DA87F-81210-0003C33F3794A10F-0.png)

A WeView layou

![Layout Snapshot](images/snapshot-397477B6-5DFF-4EFE-981D-9F1A287DA87F-81210-0003C33F3794A10F-2.png)
![Layout Snapshot](images/snapshot-397477B6-5DFF-4EFE-981D-9F1A287DA87F-81210-0003C33F3794A10F-1.png)
![Layout Snapshot](images/snapshot-397477B6-5DFF-4EFE-981D-9F1A287DA87F-81210-0003C33F3794A10F-0.png)



![Layout Snapshot](images/snapshot-0-0.png)
![Layout Snapshot](images/snapshot-0-1.png)
![Layout Snapshot](images/snapshot-0-2.png)


![Layout Snapshot](images/snapshot-0-0.png)
![Layout Snapshot](images/snapshot-0-1.png)
![Layout Snapshot](images/snapshot-0-2.png)

<!-- TEMPLATE END -->

Next\: [Tutorial 3: Test](Tutorial3.html)