Build up the interface for march::gas and refactor

`march::gas` barely works (not very reliably yet, referring to https://github.com/solvcon/solvcon/commit/e9390772c4b97de6d6ebc9a0842c9fa4214cf8de checked in in Oct 2017).  Its interface needs clean-up.

All `march::gas::Solver` members are exposed in a flat structure and it should be changed to be hierarchical:

* `m_block` and `m_cecnd` (mesh)
* `m_param`
* `m_state`
* `m_sol` (solution)
* `m_sup` (supplmental data)
* `m_qty` (derived physical quantities)

When updating the solver interface, the anchor along with the managing hook and case need to update the calling code.  I hope the (Python) change may be limited in `solvcon.parcel.gasplus`, and `gasplus` may become very different from other parcels.  I guess much of the anchor code may be changed.

In particular, I'll try to wrap `march::gas::Solver` to replace `solvcon.parcel.gasplus.solver.GasPlusSolver` and thus decouple it from `solvcon.solver.MeshSolver`.  It is very likely its parallelism will be broken.  But it doesn't matter since the parallelism hasn't been tested at all for the new solver.