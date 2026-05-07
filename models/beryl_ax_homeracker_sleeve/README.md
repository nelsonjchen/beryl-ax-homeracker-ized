# Beryl AX HomeRacker Sleeve

Model-local source for the GL.iNet Beryl AX HomeRacker sleeve.

The OpenSCAD part imports the Beryl AX holster STL from `reference/`, adds a
bottom-mounted 5-hole HomeRacker sleeve, reinforces the top of the channel,
projects channel clearance upward through the holster, and cuts a small
pill-shaped light window in the `+Y` side wall.

The imported holster STL is based on
[`GL-INET-BERYL-AX-HOLSTER` by `DunknDonuts`](https://makerworld.com/en/models/428474-gl-inet-beryl-ax-holster).
This model modifies that exported STL through OpenSCAD; it does not edit the
upstream Onshape source CAD.

Build from the repository root:

```sh
make build
```

Main source:

```text
models/beryl_ax_homeracker_sleeve/parts/beryl_ax_homeracker_sleeve.scad
```

Generated STLs and preview PNGs are written under `renders/` and intentionally
ignored by Git. See the repository root README for tuning parameters and release
notes.
