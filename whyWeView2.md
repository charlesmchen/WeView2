---
permalink: whyWeView2.html
layout: default
---

Next\: [Tutorial 1: Simple Demo](Tutorial1.html)

Why use WeView 2?
==

<!-- TEMPLATE START -->

* The syntax of iOS Auto Layout can be difficult to work with. _Here's a simple comparison_, based on Apple's sample code demonstrating how to center a button at the bottom of it's superview with a certain spacing using _iOS Auto Layout_:

{% gist 6504510 %}

iOS Auto Layout also supports a _Visual Format Language_.  Here's the sample layout using _VFL_:

{% gist 6504515 %}

Here's the equivalent logic using a _WeView_:

{% gist 6504519 %}

_WeView 2 is designed to yield concise, expressive and maintainable code_	.  The benefits of the syntax only become more clear as layouts become more complex.

* iOS Auto Layout is constraint-based.  _Constraints are a powerful but awkward way to describe layouts_. Constraints are (and must be) specified on a per-view basis. Some conceptually simple layouts are difficult to describe with constraints. This doesn't work well when UIViews need to be layed out in groups.
* With iOS Auto Layout you need to worry about complications such as constraint priority, constraint sufficiency, constraint conflicts, ambiguous layout, common ancestors, etc. None of those problems apply to WeView 2.
* iOS Auto Layout has the advantage of being integrated into Interface Builder.  _WeView 2 can only be used programmatically_.

<!-- TEMPLATE END -->

Next\: [Tutorial 1: Simple Demo](Tutorial1.html)