---
permalink: whyWeView2.html
layout: default
---

Prev\: [Why Auto Layout?](whyAutolayout.html)

Next\: [What's new in WeView 2](whatsNewWeView2.html)

<!-- TEMPLATE START -->

### Why use WeView instead of iOS' built-in Auto Layout?

* The syntax of iOS Auto Layout can be difficult to work with.
Here's an example taken from Apple's sample code of how to center a button at the bottom of it's
superview with a certain spacing using iOS Auto Layout:

{% gist 6504510 %}

iOS Auto Layout also supports a Visual Format Language.  Here's the sample layout using VFL:

{% gist 6504515 %}

WeView's is designed to yield concise, readable code. Here's the equivalent logic using a WeView:

{% gist 6504519 %}

* With iOS Auto Layout you need to worry about complications such as constraint priority, constraint sufficiency, constraint conflicts, ambiguous layout, common ancestors, etc.
* iOS Auto Layout is constraint-based.  
Constraints are a powerful but awkward way to describe layouts.
Constraints are (and must be) specified on a per-view basis.
Some conceptually simple layouts are difficult to describe with constraints.
This doesn't work well when UIViews need to be layed out in groups.

<!-- TEMPLATE END -->

Prev\: [Why Auto Layout?](whyAutolayout.html)

Next\: [What's new in WeView 2](whatsNewWeView2.html)