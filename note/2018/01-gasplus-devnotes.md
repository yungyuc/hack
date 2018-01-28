# 2018/1/28

I'd like to make `libmarch` a pure C++ library that has a `pybind11` extension to Python, and SOLVON use the Python extension to operate the C++ code.  Some code should be conveniently implemented in Python.  It turns out a clean cut between C++ and Python will take more efforts than I thought.

My recent challenge is the `PyObject` lifecycle when the object's ownership is transferred to C++.  When the `PyObject` reference is lost in the Python side, like https://github.com/pybind/pybind11/issues/1145 described, the `shared_ptr` is still there with nothing left to be called in Python.  This problem is observed for Python-derived polymorphic classes.

Before I can come up with a real workaround, I am using a Python list to keep the Python objects alive.  I'd probably try to hold the `PyObject` in the `shared_ptr`-controlled C++ object, but I need to figure out how to avoid the cyclic referencing between the `PyObject` and the `shared_ptr`.

After figuring it out, I can then apply the `CommonAnchor` trick for `march::gas::Solver` for dimension-agnostic Python solver.  At that time I should be able to move `solvcon.parcel.gas.solver.GasPlusSolver` into C++, although the message-passing doesn't work yet.