# SOLVCON development plan 2017 Oct

[PR 188](https://github.com/solvcon/solvcon/pull/188) enabled a fully-fledged
Euler solver in C++.  It used a shock tube problem set up in 2D for validation.
There are still many things to be added and verified, but it provides a
starting point for working on a modern C++ foundation.

In what follows quickly list what projects/tasks to be done.

## Infrastructure

* Replace distutils with cmake for building Python module.  Because of
  distutils, libmarch is restricted to exclusively header-only code.  Otherwise
  I would need to maintain two non-trivial build systems.  Using cmake to build
  Python wrapper will provide more flexibility in code organization and
  building.
* Update the wrapping code to use the latest pybind11 features and get rid of
  the deprecation warning in debug build.
* march::gas needs a lot of refactoring.
* Need mesh data reading helpers.  Wrap node, face, and cell to Python.
* Need mesh generation helpers.
* Need C++-level unit tests.

## Gas dynamics and CESE

* Figure out why the variation (coefficient of variation) in the Y direction is
  so large in the shock tube in 2D problem.  Something seems to be wrong in the
  CESE core.
* Use quadrilateral mesh to set up the shock tube problem.  Maybe this helps
  debugging the CESE core?
* Set up the shock tube problem in 3D.  Tets, hexs, pyramids, and prisms are to
  be tested.
* Work out a 1D heterogeneous grid shock tube solver for better validating the
  multi-dimensional solver.

## Navier-stokes solver

* Finally can start to plan for it.
* Think about solvers for other physics.
