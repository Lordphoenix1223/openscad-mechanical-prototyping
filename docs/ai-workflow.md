# AI Workflow

## Where AI Helped

### Design review

AI was good at turning a vague "this feels off" reaction into explicit failure hypotheses:

- carriage friction risk
- weak strap routing
- unrealistic hidden-mount assumptions
- bad cost-to-print tradeoffs

### Iteration planning

AI was useful for deciding what to print next, especially when the smarter move was a tiny fit coupon instead of a full part.

### Documentation

AI sped up:

- design audits
- hardware checklists
- print request packs
- brutal self-grades after each design round

## Where AI Was Weak

- direct geometry correctness
- tolerance truth
- mechanical honesty when the underlying assumptions were wrong

That last point matters. If the prompt is naive, the output gets naive fast.

## Real Workflow

1. Change the OpenSCAD parameters or geometry.
2. Export the STL.
3. Check manifold status and bounding box in the slicer.
4. Review whether the change solved the original problem or just moved it.
5. Write down the new failure modes before printing.
