SPARK Architecture, Quality Assurance and Maturity
==================================================

Development Process and Quality Assurance
-----------------------------------------

The SPARK development process and quality assurance are following the Adacore
Quality Procedures in place for all development at AdaCore. This includes:

* The use of a report tracking system;
* Mechanisms for detecting and fixing defects;
* The usage of repositories and configuration management, the use of continuous integration technology, the stringent requirements on check-ins of source changes;
* The process for implementing new functionality;
* The process for maintaining user documentation;
* Ensuring quality of sources and technical documentation;
* Preparation of releases.

As an extension to Chapter 2, section “AdaCore internal testsuite”, SPARK
contains its own testsuites:

* The SPARK main testsuite: This testsuite contains 3600 tests. These tests are specifically targeted at the SPARK software and cover typical use cases, often represented by code sent to us by customers, as well as specific features of the SPARK software.
* The ACATS testsuite in SPARK mode: A selection of the ACATS testsuite mentioned in the AdaCore Quality Procedures for the compiler is also used to test the SPARK tools.

These tests are run on various occasions (see also Chapter 2 of the Adacore Quality Procedures):

* During nightly testing, once with assertions enabled, once without (the actual SPARK product);
* After every check-in, during continuous integration;
* To test a patch before check-in using the Mailserver or continuous builder technologies.

The known-problems file associated with a specific release of SPARK specially
identifies soundness bugs, whose potential effect is to hide actual problems in
the program, under the tags "missing-check" (when a check message could be
missing) and "missing-violation" (for any other soundness issue). Such entries
always include a "detection" field for detecting the possibility of triggering
such a bug in the application of SPARK.


Structure of the SPARK Software
-------------------------------

At a high level, the tool GNATprove reads source files in the Ada programming language,
with some annotations specific to SPARK, processes them, and in the end issues
a report about errors found and proved or unproved properties. Looking more
closely at how this is achieved, one can see this high-level structure of
SPARK:

.. image:: /static/spark_structure.png


The development of the GNAT front-end and GNAT2Why components entirely follows
the procedures outlined in AdaCore Quality Procedures and the previous
section. The other components, however, are mostly developed by third parties.
Their development process and the relationship to AdaCore and Capgemini Engineering will be
outlined below.

For the nightly testing of SPARK, the GNAT and GNAT2Why components are updated
every night according to the changes made during the day by AdaCore and Capgemini Engineering
developers. The other tools, however, contain also check-ins by other persons.
We update these tools in a controlled way, and after careful testing of the
consequences. In other words, a check-in made e.g. to Z3 at some specific
date, will not be part of the SPARK package of the same day, instead it will
be integrated into SPARK after some time and after thorough testing in the
SPARK environment.

GNAT Front-end
^^^^^^^^^^^^^^

SPARK shares its front-end (parsing and semantic analysis) with the GNAT
compiler technology, which is very mature and has been used in countless
projects for the last 20 years. The GNAT front-end is developed by AdaCore and
follows the AdaCore quality procedures.

GNAT2Why
^^^^^^^^

This part of GNATprove serves two purposes:

* Implement Flow Analysis, the part of the SPARK analysis which detects uninitialized variables, and computes and checks the use of global variables and parameters.
* Translate the SPARK source code to the Why language, for further processing by the Why3 tools.  GNAT2Why is developed by AdaCore and Capgemini Engineering and follows the AdaCore quality procedures.

Because of its central role in GNATprove, and because it performs the critical
encoding of the verification rules of SPARK when applied to a given program,
this part of the tool receives special attention regarding soundness:

* Base Why3 theories used to encode Ada datatypes are realized in Coq, to rule
  out inconsistencies in the axiomatization (e.g. for bitvector or
  floating-point base theories).
* Unless the switch ``--function-sandboxing=off`` is used, the axioms generated
  by GNATprove to encode the semantics of functions in Why3 are "sandboxed", so
  that they are only applicable to contexts where the corresponding function
  is called, on the same arguments as those used in the call. This reduces the
  risk that a wrong contract could lead to an inconsistent axiom applicable
  everywhere.
* No axiom is generated for functions which might not return. This also reduces
  the risk that a wrong contract could lead to an inconsistent axiom.

A special run of the SPARK main testsuite allows to monitor statement coverage
of the testsuite over GNAT2Why source code, which is maintained above 95%, and
aiming at full statement coverage.

Addionally, through their use of the switch ``--proof-warnings`` aiming at
detecting dead code at branching points in the program and other
inconsistencies, users can protect against unsound tool behavior which would
result in similar findings. This use is traditionally called a "smoke detector"
in the scientific literature.

Why3
^^^^

This part of GNATprove takes the information in the Why language produced by GNAT2Why, translates it further into a format suitable for SMT solvers such as Z3 and cvc5, and runs these tools. The results are reported back to gnat2why.

History: Started around the year 2000 by Jean-Christophe Filliâtre as “Why” (see Jean-Christophe Filliâtre. Why: a multi-language multi-prover verification tool. Research Report 1366, LRI, Université Paris Sud, March 2003), it has undergone a number of redevelopments until its current version Why3 (since 2010).

Track record: Apart from SPARK, it is used by `Frama-C <http://frama-c.com/>`_, `Atelier B <http://www.atelierb.eu/en/>`_, and other program verification tools.

Relationship with AdaCore/Capgemini Engineering: The Inria team around Why3 has strong ties with AdaCore and Capgemini Engineering. A number of research projects have been and are being carried out in collaboration with this team. This includes the `Hi-Lite project <http://www.open-do.org/projects/hi-lite/>`_, which led to the current version of SPARK based on Why3, a follow-up project `SOPRANO <http://soprano-project.fr/>`_, then a joint laboratory `ProofInUse <https://www.adacore.com/proofinuse>`_ which evolved in the `ProofInUse consortium <https://proofinuse.gitlabpages.inria.fr/>`_. In addition, while Why3 is mainly developed at Inria, AdaCore and Capgemini Engineering have made important contributions to the technology, such as the so-called fast-WP, a more efficient implementation of the main algorithm of Why3, and the why3server, a more scalable method of running external tools such as SMT solvers.

* Main developers: `Inria research institute <http://toccata.lri.fr/>`_
* Main website: http://why3.lri.fr
* Version Management: Git
* License: Open Source, LGPL 2.1
* Public mailing-list: why3-club@lists.gforge.inria.fr
* Bug tracking: https://gforge.inria.fr/tracker/?group_id=2990

Alt-Ergo
^^^^^^^^

History: Started around the year 2005 at Inria by Sylvain Conchon and Evelyne
Contejean as “Ergo” (see CC(X): Efficiently combining equality and solvable
theories without canonizers. Sylvain Conchon, Évelyne Contejean, and Johannes
Kanig. SMT Workshop, 2007). Starting from 2013, developed and distributed
mainly by `OCamlPro <https://alt-ergo.ocamlpro.com/>`_. Since then, OCamlPro
issues every year a private release and a public release (lagging one year
behind the private release).  SPARK uses the public release of Alt-Ergo.

Track record: Apart from SPARK, it is used by `Frama-C <http://frama-c.com/>`_ and `Atelier B <http://www.atelierb.eu/en/>`_. In particular, used by Airbus for the qualification DO-178C of an aircraft [10].

Relationship with AdaCore/Capgemini Engineering: AdaCore and OCamlPro have collaborated in the
`SOPRANO <http://soprano-project.fr/>`_ project. AdaCore has contributed some minor
changes to Alt-Ergo, including a deterministic resource limiting switch.

* Main developers: `OCamlPro <https://alt-ergo.ocamlpro.com/>`_
* Main website: https://alt-ergo.ocamlpro.com/
* Version Management: Git
* License: CeCill-C (GPL compatible)
* Public mailing-list: alt-ergo-users@lists.gforge.inria.fr
* Bug tracking: https://github.com/OCamlPro/alt-ergo/issues

Z3
^^

History: Started around the year 2007 at Microsoft Research by Leonardo de
Moura and Nikolaj Bjørner (see Leonardo de Moura and Nikolaj Bjørner.
Efficient E-Matching for SMT solvers. In Automated Deduction - CADE-21, 21st
International Conference on Automated Deduction, Bremen, Germany, July 17-20,
2007, Proceedings, volume 4603 of Lecture Notes in Computer Science, pages
183-198. Springer, 2007). Released to open source under a very permissive
license in 2015.

Track record: Apart from SPARK, used by `Dafny
<https://www.microsoft.com/en-us/research/project/dafny-a-language-and-program-verifier-for-functional-correctness/>`_
and `PEX
<https://www.microsoft.com/en-us/research/project/pex-and-moles-isolation-and-white-box-unit-testing-for-net/>`_
projects inside Microsoft. Has won the `SMT competition
<http://smtcomp.sourceforge.net>`_ several times in several categories.

Relationship with AdaCore/Capgemini Engineering: AdaCore and Capgemini Engineering have provided bug
reports, feature requests and small fixes to the Z3 team, in particular
related to a deterministic resource limiting switch.

* Main developers: `Microsoft <https://z3.codeplex.com/>`_
* Main website: https://github.com/Z3Prover/z3
* Version Management: Git
* License: MIT License
* Stackoverflow community: http://stackoverflow.com/questions/tagged/z3
* Bug tracking: https://github.com/Z3Prover/z3/issues/

cvc5
^^^^

History: cvc5 is the fifth version of the CVC prover family. It has `evolved from the CVC4 prover <https://cs.stanford.edu/~gkremer/static/2022-tacas-cvc5.pdf>`_,  whose development started in 2012.

Track record: Very good results in various `SMT competitions <http://smtcomp.sourceforge.net>`_. Used in `TNO tool <http://torxakis.esi.nl/>`_.

Relationship with AdaCore/Capgemini Engineering: AdaCore and Capgemini Engineering have provided bug reports, feature requests and small fixes to the cvc5 team, in particular related to a deterministic resource limiting switch. AdaCore is a founding member of `Centaur (the Center for Automated Reasoning at Stanford University) <https://centaur.stanford.edu/affiliates_and_sponsors.html>`_ which is a main contributor to cvc5.

* Main developers: New York University
* Main website: https://cvc5.github.io/
* Version Management: Git
* License: Modified BSD License
* Discussions: https://github.com/cvc5/cvc5/discussions
* Bug tracking: https://github.com/cvc5/cvc5/issues


COLIBRI
^^^^^^^

History: COLIBRI is a library (COnstraint LIBrary for veRIfication) developed at CEA LIST and used for verification or test data generation purposes since 2000, using the techniques of constraint programming. The variety of types and constraints provided by COLIBRI makes it possible to use it in many testing and formal methods tools at CEA LIST.

Track record: Winner (2018) and Runner-up (2019) in the quantifier-free floating-point division of the `SMT competition <http://smtcomp.sourceforge.net>`_.

Relationship with AdaCore/Capgemini Engineering: AdaCore and CEA collaborate together to improve COLIBRI.

* Main developers: CEA
* Version Management: Git
