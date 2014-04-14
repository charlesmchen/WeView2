---
permalink: designPhilosophy.html
layout: default
---

Design Philosophy
==

<!-- TEMPLATE START -->

> Tracy: "We sailed it down the coast of Maine and back the Summer we were married.  My, she was yar..."
>
> George: "Yar?  What does that mean?"
>
> Tracy: "It means... easy to handle, quick to the helm, fast, right. Everything a boat should be, until she develops dry rot."
>
> From "The Philadelphia Story" by Philip Barry

Creating a UI auto-layout tool doesn't require much code.  There isn't any algorithmic complexity; performance isn't a concern.  The difficulty lies in coming up with an design that is easy to learn and use.  It should yield code that is easy to write and maintain. It is an API design challenge.

It is awkward to express layout using code, even when using a declarative tool like **WeView 2**.  Layout code easily devolves into spaghetti code: repetitious boilerplate with a profusion of badly-named variables.  In the interest of maintainability, **WeView 2** is tightly focused on the goal of yielding concise, expressive code.

To this end, **WeView 2** takes a number of unusual measures.

* **Chaining**.  **WeView 2** property setters like _\[setMargin:\]_ and _\[setSpacing:\]_ return a reference to the receiver whenever possible to allow chaining, ie. invoking multiple methods on the same instance. Chaining reduces the need for boilerplate code. Chaining isn't particularly idiomatic Objective-C, but it is a key mechanism for keeping layout code concise. Ultimately, chaining is optional - but if you don't use it, your code quality will suffer.
* **Redundancy**.  There are tradeoffs between the [There's More Than One Way To Do It](http://en.wikipedia.org/wiki/There's_more_than_one_way_to_do_it) design philosophy (as exemplified by Perl) and the [There's Only One Way To Do It](http://legacy.python.org/dev/peps/pep-0020/) design philosophy (as exemplified by Python). **WeView 2** comes down firmly on the "more than one way" side of the argument in the interest of yielding concise code, for example by offering factory and convenience methods.  The horizontal and vertical layouts are simplified forms of the grid layout, but are far simpler and easier to use.


### WeView 2 Design Goals

* __Strive to be lightweight__. Stay focused on solving a single problem. Add no third-party dependencies. Play nicely with other layout mechanisms.
* __Lower the learning curve__.  Keep the barrier to entry low and ensure that the library is easy to master through conceptual simplicity, comments and documentation. Leverage existing understanding of HTML and CSS: container-driven, declarative layout. Provide a demo app that let's users learn how **WeView 2** layout works in an interactive sandbox.
* __Focus on maintainability__. Bend over backwards to allow users to write terse, readable code.  
* __Optimize around the common case__. Ground the design in classic use cases. On the other hand, make no assumptions and support unanticipated usage by being extensible.
* __Prioritize developer time__. Provide convenience accessors, factory methods etc. to make common tasks easier.
* __Keep it simple__.  When in doubt, leave it out.
* __Don't Reinvent The Wheel__. **WeView 2** leverages and elaborates upon UIKit's existing layout mechanism.
* __Leverage XCode__. Take advantage of XCode's autocomplete.
* __Transparency__.  Developers need to maintain a mental model of how layout works.  Stick to a simple, understandable layout model (cell-based layout) and resist the temptation to get fancy.

And especially: Use a _Documentation-Driven Design_ process

* A good design is easy to understand.  
* A design that is easy to understand should be easy to explain using plain language.  
* It is easier to spot complexity in the documentation than in the code.
* Write the documentation as you design the API.  
* Whenever the documentation becomes complicated or involved, revisit the design.

API Design References
===

* [The Little Manual of API Design](http://www4.in.tum.de/~blanchet/api-design.pdf)
* [How to Design a Good API and Why it Matters by Joshua Bloch](http://lcsd05.cs.tamu.edu/slides/keynote.pdf)
* [API Design by Matt Gemmell](http://mattgemmell.com/2012/05/24/api-design/)

<!-- TEMPLATE END -->

<p class="nextLink">Next:  <a href="whatsNewWeView2.html">What's New in WeView v2</a></p>