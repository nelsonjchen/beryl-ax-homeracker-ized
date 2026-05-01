SCAD_FILE := models/cisco_ap_mount/parts/cisco_ap_homeracker_mount.scad
RENDER_DIR := renders
PNG_FILE := $(RENDER_DIR)/cisco_ap_homeracker_mount.png
STL_ROTATION90_FILE := $(RENDER_DIR)/cisco_ap_homeracker_mount_rotation90.stl
STL_ROTATION0_FILE := $(RENDER_DIR)/cisco_ap_homeracker_mount_rotation0.stl
STL_CLIP_PAIR_FILE := $(RENDER_DIR)/cisco_ap_homeracker_clip_pair.stl
STL_CLIP_LEFT_FILE := $(RENDER_DIR)/cisco_ap_homeracker_clip_left.stl
STL_CLIP_RIGHT_FILE := $(RENDER_DIR)/cisco_ap_homeracker_clip_right.stl
STL_FILE := $(STL_ROTATION90_FILE)
OPENSCAD_BIN := bin/openscad/openscad
OPENSCAD_APPIMAGE := bin/openscad/OpenSCAD.AppImage
OPENSCAD_MACOS := bin/openscad/OpenSCAD.app/Contents/MacOS/OpenSCAD
OPENSCADPATH := bin/openscad/libraries
OPENSCAD := $(shell if [ "$$(uname -s)" = "Darwin" ]; then command -v openscad; elif [ -x "$(OPENSCAD_MACOS)" ]; then printf '%s' "$(OPENSCAD_MACOS)"; elif [ -x "$(OPENSCAD_APPIMAGE)" ]; then printf '%s' "$(OPENSCAD_APPIMAGE)"; elif [ -x "$(OPENSCAD_BIN)" ]; then printf '%s' "$(OPENSCAD_BIN)"; else command -v openscad; fi)

.PHONY: sync install check render fallback-render render-rotation0 render-rotation90 render-all render-clip-pair render-clip-left render-clip-right render-clips png build clean

sync:
	uv sync

install:
	uv run scadm install

check:
	uv run scadm install --check

render:
	$(MAKE) render-rotation90

fallback-render: render-rotation90

render-rotation0:
	mkdir -p $(RENDER_DIR)
	OPENSCADPATH="$(OPENSCADPATH)" "$(OPENSCAD)" --hardwarnings -D 'sleeve_rotation=0' -o $(STL_ROTATION0_FILE) $(SCAD_FILE)

render-rotation90:
	mkdir -p $(RENDER_DIR)
	OPENSCADPATH="$(OPENSCADPATH)" "$(OPENSCAD)" --hardwarnings -D 'sleeve_rotation=90' -o $(STL_ROTATION90_FILE) $(SCAD_FILE)

render-all: render-rotation90 render-rotation0

render-clip-pair:
	mkdir -p $(RENDER_DIR)
	OPENSCADPATH="$(OPENSCADPATH)" "$(OPENSCAD)" --hardwarnings -D 'part_mode=1' -o $(STL_CLIP_PAIR_FILE) $(SCAD_FILE)

render-clip-left:
	mkdir -p $(RENDER_DIR)
	OPENSCADPATH="$(OPENSCADPATH)" "$(OPENSCAD)" --hardwarnings -D 'part_mode=2' -o $(STL_CLIP_LEFT_FILE) $(SCAD_FILE)

render-clip-right:
	mkdir -p $(RENDER_DIR)
	OPENSCADPATH="$(OPENSCADPATH)" "$(OPENSCAD)" --hardwarnings -D 'part_mode=3' -o $(STL_CLIP_RIGHT_FILE) $(SCAD_FILE)

render-clips: render-clip-pair render-clip-left render-clip-right

png:
	mkdir -p $(RENDER_DIR)
	OPENSCADPATH="$(OPENSCADPATH)" "$(OPENSCAD)" \
		-o $(PNG_FILE) \
		--render=true \
		--hardwarnings \
		-D 'sleeve_rotation=90' \
		--camera=0,0,18,55,0,35,190 \
		--autocenter --viewall \
		--imgsize=1400,1000 \
		--colorscheme=Tomorrow \
		$(SCAD_FILE)

build: sync install render-all render-clips png

clean:
	rm -rf $(RENDER_DIR) models/cisco_ap_mount/parts/renders
	find . -name '*.stl' -delete
	find . -name '*.3mf' -delete
