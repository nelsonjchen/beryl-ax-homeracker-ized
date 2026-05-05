SCAD_FILE := models/beryl_ax_homeracker_sleeve/parts/beryl_ax_homeracker_sleeve.scad
RENDER_DIR := renders
PNG_FILE := $(RENDER_DIR)/beryl_ax_homeracker_sleeve.png
STL_FILE := $(RENDER_DIR)/beryl_ax_homeracker_sleeve.stl
OPENSCAD_BIN := bin/openscad/openscad
OPENSCAD_APPIMAGE := bin/openscad/OpenSCAD.AppImage
OPENSCAD_MACOS := bin/openscad/OpenSCAD.app/Contents/MacOS/OpenSCAD
OPENSCADPATH := bin/openscad/libraries
OPENSCAD := $(shell if [ "$$(uname -s)" = "Darwin" ]; then command -v openscad; elif [ -x "$(OPENSCAD_MACOS)" ]; then printf '%s' "$(OPENSCAD_MACOS)"; elif [ -x "$(OPENSCAD_APPIMAGE)" ]; then printf '%s' "$(OPENSCAD_APPIMAGE)"; elif [ -x "$(OPENSCAD_BIN)" ]; then printf '%s' "$(OPENSCAD_BIN)"; else command -v openscad; fi)

.PHONY: sync install check render fallback-render png build clean

sync:
	uv sync

install:
	uv run scadm install

check:
	uv run scadm install --check

render:
	mkdir -p $(RENDER_DIR)
	OPENSCADPATH="$(OPENSCADPATH)" "$(OPENSCAD)" --hardwarnings -o $(STL_FILE) $(SCAD_FILE)

fallback-render: render

png:
	mkdir -p $(RENDER_DIR)
	OPENSCADPATH="$(OPENSCADPATH)" "$(OPENSCAD)" \
		-o $(PNG_FILE) \
		--render=true \
		--hardwarnings \
		--camera=0,0,18,55,0,35,190 \
		--autocenter --viewall \
		--imgsize=1400,1000 \
		--colorscheme=Tomorrow \
		$(SCAD_FILE)

build: sync install render png

clean:
	rm -rf $(RENDER_DIR) models/beryl_ax_homeracker_sleeve/parts/renders
	find models -name '*.stl' -delete
	find models -name '*.3mf' -delete
