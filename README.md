# Cisco AP HomeRacker Mount

An OpenSCAD model for mounting Cisco wireless access points to a HomeRacker bar.

The current printable part is a low-profile skeleton plate with four Cisco AIR-AP-BRACKET-1-style recessed slider/keyhole holes and a segmented HomeRacker sleeve. The center of the mount is left open for airflow and material savings; only the two sleeve segments at the ends remain, each with two lock-pin holes for mounting to a single 15 mm HomeRacker support/bar.

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
- `make render-rotation0`: render the earlier sleeve orientation STL
- `make render-rotation90`: render the alternate sleeve orientation STL
- `make render-all`: render both orientation STLs
- `make render-clips`: render the two-piece clip pair plus individual left/right clip STLs
- `make png`: create a local preview PNG for `sleeve_rotation = 90` in `renders/`
- `make build`: run the full bootstrap flow and render both full-mount orientation STLs, clip STLs, and the preview PNG
- `make clean`: remove generated render/export files

Generated renders and export files are intentionally ignored by Git.

## Model

Main source:

```text
models/cisco_ap_mount/parts/cisco_ap_homeracker_mount.scad
```

The model follows HomeRacker conventions where practical: 15 mm base units, 2 mm walls, 0.2 mm tolerance, 4 mm lock-pin holes, OpenSCAD Customizer sections, and BOSL2-style chamfered geometry.

Current fit settings from print testing:

- Full-frame mount small slider diameter: `6.6` mm
- Full-frame mount detent depth: `0.25` mm
- Two-piece clip small slider diameter: `6.42` mm
- Two-piece clip detent depth: `0.4` mm
- Plate thickness: `3` mm total, with a `1` mm top lip/recess layer
- Sleeve: `9` HomeRacker units overall, with `2` pin holes per end segment
- Sleeve orientation: `sleeve_rotation = 90` mounts the HomeRacker sleeve on the alternate rail pair; set it to `0` for the earlier orientation
- Part mode: `part_mode = 0` renders the full mount, `1` renders a two-piece pair, `2` renders the left clip, and `3` renders the right clip

The production model engraves `CISCO AP HOMERACKER`, `S6.6`, and `D0.25` into the top surface so printed parts carry their fit settings.

## Two-Piece Clips

The two-piece clip mode splits the mount into left/right clips, each carrying two Cisco AP keyholes, one HomeRacker sleeve segment, and two lock-pin holes. The pieces are intentionally labeled with side, the `CISCO AP HOMERACKER` mount name split across the rails, and their tighter standalone `S6.42 D0.4` fit settings so each loose part remains identifiable during installation.

The clips do not mechanically prevent being pinned in the wrong HomeRacker holes; if spacing is wrong, move the clip to a different hole pair and retry the AP slide fit.

## Fit Coupons

Test coupon source:

```text
models/cisco_ap_mount/test/keyhole_fit_coupon.scad
```

The coupon matrix varies the small slider diameter and detent depth so the AP fit can be tested quickly before printing the full mount. The coupon uses the same `3` mm total thickness and `1` mm top lip/recess layer as the production bracket.

## Attribution And License

This project is released under the Creative Commons Attribution-ShareAlike 4.0 International license: <https://creativecommons.org/licenses/by-sa/4.0/>.

The Cisco AP slider-hole dimensions and recessed two-layer slider-hole behavior are based on `third_party/thingiverse-5491712/AIR-AP-BRACKET-1.scad`, from Thingiverse thing 5491712, "Cisco AIR-AP-BRACKET-1" by nicba1010, published under a BSD license. See `NOTICE` for third-party attribution.
