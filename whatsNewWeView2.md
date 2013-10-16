---
permalink: whatsNewWeView2.html
layout: default
---

What's New in WeView 2
==

<!-- TEMPLATE START -->

* WeView is a near-total rewrite, that should be more consistent and better handle edge cases such
  as degenerate layouts.
* WeView uses a category and associated objects to hang layout properties on any existing UIView,
  removing the need for subclassing, implementing a protocol, etc.  This makes WeView far easier to
  use.
* WeView has a new cell-based layout model that is easier to understand.
* WeView should be more consistent and better handle edge cases such as degenerate layouts.
* WeView offers a number of new per-view properties that allow more fine-grained control over 
   layout behavior.

### Migrating from WeViews to WeView 2

* Use the _WeView_ class instead of the _WePanel_ class.  
* We've streamlined the class structure.  Many of the old view classes are no longer necessary. Many of the old layouts have been combined or renamed.
* We've combined _layers_ and _layouts_.  There are no _layers_ in WeView 2.
* Many of the features (such as _stretch_) have been completely redesigned.  
* See the documentation

<!-- TEMPLATE END -->

Next\: [License](License.html)