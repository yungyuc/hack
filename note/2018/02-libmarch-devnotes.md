# 2018/2/4

Implementation of `solvcon.parcel.gasplus.solver.GasPlusSolver` is moved to C++ with [PR #198](https://github.com/solvcon/solvcon/pull/198) (and it resolves [issue #197](https://github.com/solvcon/solvcon/issues/197)).  Having the porting work done, I am ready to add new features to `libmarch`.  Some old features, like 3D solution, generic CESE solver, message-passing, are considered as "new", because they either don't have existing C/Cython code to be ported to C++, or it's already ported (like the case for the 3D code, which is the same as the 2D code, though not tested).  They need new C++ code in the `libmarch` (or the hybrid of `libmarch`+`SOLVCON`) code base, just like a new feature does.

To move forward, `SOLVCON`/`libmarch` will follow two research projects: granular flow [[Lee17][Lee17]] and sonic jet in supersonic cross flow [[VanLerberghe00][VanLerberghe00]].  To facilitate the projects, I need to work out the following:

1. 3D Euler solver: [#127](https://github.com/solvcon/solvcon/issues/127).  Test 3D shock tube.  I expect to uncover bugs slipped through the 2D tests.
2. Navier-Stokes solver: [#15](https://github.com/solvcon/solvcon/issues/15).  Augment `march::gas`.
3. A C++ class library for the CESE method.  Maybe it'll be called `march::cese` and `march::gas` becomes its extension.
4. The granular flow solver should extend `march::cese`.  Maybe call it `march::gran`.
5. Develop `march::mpass` for message-passing parallelism.  It needs to allow extension in Python, so the existing `SOLVCON` message-passing helper would work.

[Lee17]: https://link.aps.org/doi/10.1103/PhysRevE.96.062909 "K. Lee and F. Yang, “Relaxation-type nonlocal inertial-number rheology for dry granular flows,” Phys. Rev. E, vol. 96, no. 6, p. 062909, Dec. 2017."
[VanLerberghe00]: https://doi.org/10.2514/2.984 "W. M. VanLerberghe, J. G. Santiago, J. C. Dutton, and R. P. Lucht, “Mixing of a Sonic Transverse Jet Injected into a Supersonic Flow,” AIAA Journal, vol. 38, no. 3, pp. 470–479, 2000."
