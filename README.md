# Ruckus AP HomeRacker Mount

An OpenSCAD model for mounting Ruckus wireless access points to a HomeRacker bar.

This repo is being rebuilt from the earlier Cisco AP mount. The current printable
part is only the segmented HomeRacker sleeve: two sleeve sections sized around a
15 mm HomeRacker support/bar, each with two 4 mm lock-pin holes. The Ruckus
AP-facing geometry will be derived later from the STL reference in `reference/`.

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
- `make render`: render the default `sleeve_rotation = 90` STL
- `make render-rotation0`: render the sleeve in the original rail orientation
- `make render-rotation90`: render the sleeve in the alternate rail orientation
- `make render-prototype`: render the current Ruckus-prong prototype mount
- `make render-all`: render both orientation STLs
- `make png`: create a local preview PNG for `sleeve_rotation = 90` in `renders/`
- `make png-views`: render reference, prototype, and overlay inspection PNGs
- `make build`: run the full bootstrap flow and render sleeve/prototype STLs plus inspection PNGs
- `make clean`: remove generated render/export files

Generated renders and export files are intentionally ignored by Git.

## Model

Main source:

```text
models/ruckus_ap_mount/parts/ruckus_ap_homeracker_sleeve.scad
```

The model follows HomeRacker conventions where practical: 15 mm base units,
2 mm walls, 0.2 mm tolerance, 4 mm lock-pin holes, and OpenSCAD Customizer
sections.

Current sleeve settings:

- Sleeve: one centered HomeRacker island by default, with `2` lock-pin positions
- Sleeve roof: flush with the sleeve outer wall width and island length to reduce support
- Sleeve orientation: `sleeve_rotation = 90` mounts the sleeve on the alternate rail pair; set it to `0` for the original orientation
- Ruckus interface orientation: `ruckus_interface_rotation = 90` turns the prong pair perpendicular to the sleeve island
- Ruckus strip: a straight, flat `4.4` mm thick bar under the prongs
- Ruckus strip vertical offset: `ruckus_mount_z = -3` sinks the strip through the sleeve roof thickness
- Ruckus gussets: full-width triangular drop webs enabled by default, with the sloped face held to a `30` degree printable angle and lower edge reaching global `z = 0`
- STL reference overlay: use `part_mode = 2` for sleeve plus reference, or `part_mode = 4` for prototype plus reference
- Ruckus prong centers, measured from the STL: `84.7` mm apart
- Ruckus prong shaft: `4` mm diameter by `2.1` mm exposed height after folding the raised bridge into the strip
- Ruckus prong cap, measured from the STL: `6.7` mm diameter by `3.5` mm tall
- Ruckus reference mesh bounding box: about `93 x 24 x 10` mm

## Attribution And License

This project is released under the Creative Commons Attribution-ShareAlike 4.0 International license: <https://creativecommons.org/licenses/by-sa/4.0/>.

This repository was bootstrapped from an earlier Cisco AP HomeRacker mount.
The historical Cisco AIR-AP-BRACKET-1 attribution is retained in `NOTICE` and
`third_party/thingiverse-5491712/`.
