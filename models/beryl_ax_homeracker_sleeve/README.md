# Beryl AX HomeRacker Sleeve

Model-local source for the GL.iNet Beryl AX HomeRacker sleeve.

The OpenSCAD part imports the Beryl AX holster STL from `reference/`, adds a
bottom-mounted 5-hole HomeRacker sleeve, reinforces the top of the channel,
projects channel clearance upward through the holster, and cuts a small
pill-shaped light window in the `+Y` side wall.

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
