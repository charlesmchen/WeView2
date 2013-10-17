---
permalink: designPhilosophy.html
layout: default
---

Design Philosophy
==

<!-- TEMPLATE START -->

* _Strive to be lightweight_. Stay focused on solving a single problem. Add no third-party dependencies. Play nicely with other layout mechanisms. Leverage existing understanding of HTML and CSS: container-driven, declarative layout.
* _Lower the learning curve_.  Keep the barrier to entry low and ensure that the library is easy to master through conceptual simplicity, comments and documentation.
* _Focus on maintainability_. Bend over backwards to allow users to write terse, readable code.  Avoid boilerplate by providing convenience accessors and factory methods. Enable chaining by having all setters and configuration methods return a reference to the receiver. 
* _Optimize around the Common Case_. Ground the design in the classic use cases. Still, make no assumptions and support unanticipated usage, ie. be extensible.
* _Prioritize developer time_. Provide convenience accessors, factory methods etc. to make common tasks easier. 
* _Keep it simple_. WeView v2's design embraces simplicity so that it is easy to understand and work with. When in doubt, leave it out.
* _Leverage XCode_. Take advantage of XCode's autocomplete.

And especially: Use a _Documentation-Driven Design_ process

* Write the documentation as you design the API.  
* The design should be easy to explain (ie. document).
* If you can't easily explain it using plain language, you haven't thought it through.
* Whenever the documentation becomes complicated, consider simplifying the design.

API Design References
===

* [The Little Manual of API Design](http://www4.in.tum.de/~blanchet/api-design.pdf)
* [How to Design a Good API and Why it Matters by Joshua Bloch](http://lcsd05.cs.tamu.edu/slides/keynote.pdf)
* [API Design by Matt Gemmell](http://mattgemmell.com/2012/05/24/api-design/)

<!-- TEMPLATE END -->

Next\: [What's New in WeView v2](whatsNewWeView2.html)