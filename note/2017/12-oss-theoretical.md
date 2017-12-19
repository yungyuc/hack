# Open Source for Continuum Model Development and Its Computing

Allow me to take a note here regarding open source for science.  This is for some basic ideas that are rarely discussed among scientists, especially theorists.

Computer programs define a framework for processing information.  In theory, it's that simple.  One doesn't need to know quantum mechanics before using computers for theoretical work.

What it really takes is to adopt right tools and acquire right skills.  Like how digital computers help in various industries, they'll automate the creative-less tasks, aid researchers spend less time for them, and eventually turn them into creative work.  We write programs, and computers accomplish the work.

Calculating partial differential equations (PDEs) is one of the fields known to be greatly enabled by digital computers and their ever-increasing power.  Being "first-principle" in the continuum regime, the constitutive relationship is of utmost importance in the simulation.  Developing a constitutive model is classic theoretical work, but we aren't surprised that digital computers may play a role.  For example, symbolic calculation saves a lot of pencils and papers for tedious error-checking.

That's just one point.  A constitutive model is most useful when it is plugged into a code.  What if the code is so easy to be changed and verified that even when the model is incomplete, we'll see the results of the "numerical experiments"?  A good theorist certainly doesn't rely on the "experiments."  But if the code can handily show the results, many mistakes may be cleaned up in their infancy.  Not to say some numerical or implementation issues that may only be revealed in calculated results.

I argue the beautiful world only exists with an open-source software development model.  Here is why.

## Software Evolves

Like life, a code may die if it is not changed or becomes unchangeable.  An execution flow may work when a code deals with a single constitutive model, but generalization is needed when the team would like to explore new possibilities or fix the deficiency in the earlier work.  A popular practice in a lab, though definitely unacceptable in a software shop, is to close the old project and derive a new one.  That produces two codes.  One's dead while the other reborn.

What's the problem?  It's too difficult to realign the two code bases.  How can one be sure the old results may be reproduced with the newer version?  In a software shop it's usually covered by regression tests.  But that implies the new code actually _is_ the old code.

PDE calculations call for application of complex numerical methods, and almost always high-performance computing (HPC).  Without accessing the source code, it's hopeless to understand what it does and make proper adjustments, for both behaviors and performance.

## Documentation Diverges

The rich knowledge in the physics, mathematics, numerics, and computation for PDE calculations make it extremely difficult to document what the software does.  It's commonplace that the theoretical background can be described with no less than hundreds of pages, and takes a degree program for one to learn it.  It is unrealistic to expect a single document may explain what the code does.  The document needs to complement the code for people to efficiently collaborate.

To some extent, the document needs to cross-reference the code, and vise versa, to show the ideas clearly.  Workarounds are needed if the software isn't made in an open-source way.

## Reproducibility

In software, nothing is impossible.  The only constraint is our imagination, which is in turn constrained by the complexity that our mind can handle.

It's the complexity that causes all kinds of problems.  "In theory," everything should follow the equations.  But in the real world, even the compilation order may make the results differ, not to say optimization flags, floating-point round-off, system libraries, etc., and the complexity lying in the physics itself.

Everything needs to be done in a hierarchical, segregational way, to clamp the system with reasonable efforts.  If we get a development team of 1,000 developers, it doesn't matter to do it in an open or close way.  But if there're only a handful of them, pragmatism counts.  By exposing the source code to any potential collaborator, there's much less friction.

## Limitation

Open source doesn't answer everything.  For uncompromisable security, oftentimes something needs to be hidden.  And we simply can't open-source things not belonging to us, like copyrighted publication.  There are also cases that we protect some information for a period of critical time, and put it in the open-source realm a while later.  However, I don't find a lot of such exceptions.  Most of the time, open source is very productive, be it code development or paper writing.

Open source has been successful for computer science and information technology for decades.  Is there any reason, other than inertia, to stop us from applying it to science?  It is my deep hope that everyone who's serious about computing doesn't need to deal with unnecessary silos created by close source code.