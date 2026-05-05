# Beryl AX HomeRacker Sleeve

An OpenSCAD model for adapting a GL.iNet Beryl AX holster to a HomeRacker bar.

This repo is being rebuilt around the Beryl AX holster STL in `reference/`.
The current OpenSCAD source is intentionally blank except for importing that STL,
so the model can be carved and wrapped with HomeRacker-compatible geometry in
small passes.

## Tooling

This repo uses `uv` for Python tooling and `scadm` for OpenSCAD setup, dependency installation, flattening, and render validation.

```sh
make sync
make install
make render
make png
```

Useful targets:

- `make sync`: install Python tooling into `.venv/`
- `make install`: install OpenSCAD and SCAD dependencies through `uv run scadm install`
- `make check`: check the scadm-managed OpenSCAD/dependency install
- `make render`: render the imported Beryl AX holster STL through OpenSCAD
- `make png`: create a local preview PNG in `renders/`
- `make build`: run the full bootstrap flow and render the STL plus preview PNG
- `make clean`: remove generated render/export files

Generated renders and export files are intentionally ignored by Git.

## Model

Main source:

```text
models/beryl_ax_homeracker_sleeve/parts/beryl_ax_homeracker_sleeve.scad
```

The model will follow HomeRacker conventions where practical: 15 mm base units,
2 mm walls, 0.2 mm tolerance, 4 mm lock-pin holes, and OpenSCAD Customizer
sections. For now, the source exposes only STL import transform controls:
`reference_alpha`, `reference_scale`, `reference_translate`, and
`reference_rotate`.

Current source scaffold:

- Imports `reference/GL-INET-BERYL-AX-HOLSTER.stl`
- Provides transform controls for aligning the imported mesh
- Leaves all subtractive cuts and HomeRacker sleeve geometry for follow-up edits

## Attribution And License

This project is released under the Creative Commons Attribution-ShareAlike 4.0 International license: <https://creativecommons.org/licenses/by-sa/4.0/>.

This repository was bootstrapped from an earlier Cisco AP HomeRacker mount.
The historical Cisco AIR-AP-BRACKET-1 attribution is retained in `NOTICE` and
`third_party/thingiverse-5491712/`.
