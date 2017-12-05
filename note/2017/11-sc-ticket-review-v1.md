# Collaboration

* Available platforms for collaboration:
  * [Github](https://github.com/solvcon/): main repository
  * [Travis-CI](https://travis-ci.org/solvcon/solvcon): free, public, but slow test runner
  * [Slack](https://solvcon.slack.com/): professional team collaboration system
  * [Gitter](https://gitter.im/solvcon/): public, free-to-join support channels
  * [Gitlab](https://gitlab.com/solvcon/): I am still experimenting it.  Its container-enabled CI looks promising.
  * A private [telegram](https://telegram.org/) chat group (ask @yungyuc or @tai271828 to access it)
  * (old) [Hipchat](https://solvcon.hipchat.com/): another profession team collaboration system.  I haven't touched it for a while.
* Publicity
  * https://twitter.com/solvcon (but not active at all :-)
* Options result in confusion, but sometimes power.  What are the best tools for the tiny team to use?  The key and only objective is efficiency for coding, running calculations, problem solving, and publishing.
  * In short, how to write code better and faster.

# Physics

## Euler Equations

- `march::gas` needs a lot of refactoring.
- [#125](https://github.com/solvcon/solvcon/issues/125) Develop noslip wall boundary condition treatment for parcel/gasplus
- [#108](https://github.com/solvcon/solvcon/issues/108) Add verification in examples/gas/run_gas_obrf.sh

### One-Dimensional Shock-Tube Problem Setup

- [#138](https://github.com/solvcon/solvcon/issues/138) build a solid 1D Sod tube test case
- [#128](https://github.com/solvcon/solvcon/issues/128) tune the Sod tube driven script and validate the result
- [#113](https://github.com/solvcon/solvcon/issues/113) make the iteration animation
- Work out a 1D heterogeneous grid shock tube solver for better validating the multi-dimensional solver.

### Multi-Dimensional Shock-Tube Problem Setup

- Explore the 2D setup
  - Figure out why the variation (coefficient of variation) in the Y direction is so large in the shock tube in 2D problem.  Something seems to be wrong in the CESE core.
  - Use quadrilateral mesh to set up the shock tube problem in 2D.  Maybe this helps debugging the CESE core?
- [#127](https://github.com/solvcon/solvcon/issues/127) create unit tests for 3D Sod tube example
  - Set up the shock tube problem in 3D.  Tets, hexs, pyramids, and prisms are to be tested.

## Navier-Stokes Equations

- [#15](https://github.com/solvcon/solvcon/issues/15) Implement Navier-Stokes solver
  - Do it with `solvcon.parcel.gasplus` (C++11-based CESE implementation)

## Other Physics

- [#91](https://github.com/solvcon/solvcon/issues/91) Arrange an aeroacoustic simulation in examples
- [#86](https://github.com/solvcon/solvcon/issues/86) Implement initial condition and boundary conditions for viscoelasticity

# Mesh

- Need mesh data reading helpers.  Wrap node, face, and cell to Python.
- Need mesh generation helpers.
- [#133](https://github.com/solvcon/solvcon/issues/133) The mesh IO registry should be available in the top solvcon name space
- [#126](https://github.com/solvcon/solvcon/issues/126) Develop an traverser of mesh element
- [#72](https://github.com/solvcon/solvcon/issues/72) Only load a portion of a mesh
- [#71](https://github.com/solvcon/solvcon/issues/71) Saving a subset of the mesh for VTK
- [#66](https://github.com/solvcon/solvcon/issues/66) Rename solvcon.io into solvcon.inout
- [#56](https://github.com/solvcon/solvcon/issues/56) Graph partitioner (for domain decomposition) has no unit test
- [#33](https://github.com/solvcon/solvcon/issues/33) Speed up domain splitting
- [#32](https://github.com/solvcon/solvcon/issues/32) Optionally use symbolic link in splitting

# Infrastructure and Build

* Normalize code style.
* Interactive computing / Jupyter integration
* GCE/GKE deployment and development environment
* AWS (not active; maybe I should drop its support)
  * [#131](https://github.com/solvcon/solvcon/issues/131) solvcon.cloud is seriously outdated
* Restart
  * [#80](https://github.com/solvcon/solvcon/issues/80) Restart wont't work on large meshes
  * [#70](https://github.com/solvcon/solvcon/issues/70) Change values at restart
  * [#37](https://github.com/solvcon/solvcon/issues/37) Consolidate restart

# Documentation

- [#194](https://github.com/solvcon/solvcon/issues/194) Enable type hinting in Sphinx autodoc

# Testing

- Need C++-level unit tests.

# Miscellaneous

- [#102](https://github.com/solvcon/solvcon/issues/102) Need to enhance a solver-level message reporting facility, maybe with a verbosity selection
- [#94](https://github.com/solvcon/solvcon/issues/94) RPC doesn't work for solvcon.{MeshSolver,MeshCase}
- [#55](https://github.com/solvcon/solvcon/issues/55) solvcon.helper.iswin() seems not very useful
- [#11](https://github.com/solvcon/solvcon/issues/11) Implement cell to point data algorithm