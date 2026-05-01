# Cisco AP HomeRacker Mount

An OpenSCAD model for mounting Cisco wireless access points to a HomeRacker bar.

The first printable part is a low-profile plate with four Cisco AIR-AP-BRACKET-1-style slider/keyhole holes, ventilation holes for AP cooling, and a U-shaped sleeve that slides over a single 15 mm HomeRacker support/bar. Lock-pin holes in the sleeve let the part be pinned into the rack.

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
- `make render`: validate the SCAD model by rendering to STL through scadm
- `make png`: create a local preview PNG in `renders/`
- `make build`: run the full bootstrap and render flow
- `make clean`: remove generated render/export files

Generated renders and export files are intentionally ignored by Git.

## Model

Main source:

```text
models/cisco_ap_mount/parts/cisco_ap_homeracker_mount.scad
```

The model follows HomeRacker conventions where practical: 15 mm base units, 2 mm walls, 0.2 mm tolerance, 4 mm lock-pin holes, OpenSCAD Customizer sections, and BOSL2-style chamfered geometry.

## Attribution And License

This project is released under the Creative Commons Attribution-ShareAlike 4.0 International license: <https://creativecommons.org/licenses/by-sa/4.0/>.

The Cisco AP slider-hole dimensions and recessed two-layer slider-hole behavior are based on `third_party/thingiverse-5491712/AIR-AP-BRACKET-1.scad`, from Thingiverse thing 5491712, "Cisco AIR-AP-BRACKET-1" by nicba1010, published under a BSD license. See `NOTICE` for third-party attribution.
