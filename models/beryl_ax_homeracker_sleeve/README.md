# Beryl AX HomeRacker Sleeve

This model is being rebuilt for a GL.iNet Beryl AX HomeRacker sleeve.

The current source imports the Beryl AX holster STL from `reference/` at
millimeter scale and grafts a centered HomeRacker sleeve onto the bottom.
The sleeve has matching lock-pin holes through the side walls and roof.
The sleeve top has a 2.8 mm reinforcement frame around the channel opening.
The HomeRacker channel clearance is also projected upward through the holster.
A small pill-shaped window is cut into the `+Y` side wall to expose device light.
Subtractive cleanup cuts can be added in later passes.

Build from the repository root:

```sh
make build
```

Preview PNGs and exported STLs are generated under `renders/` and intentionally
ignored by Git.
