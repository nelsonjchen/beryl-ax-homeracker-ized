SCAD_FILE := models/cisco_ap_mount/parts/cisco_ap_homeracker_mount.scad
RENDER_DIR := renders
PNG_FILE := $(RENDER_DIR)/cisco_ap_homeracker_mount.png
STL_FILE := $(RENDER_DIR)/cisco_ap_homeracker_mount.stl
OPENSCAD_BIN := bin/openscad/openscad
OPENSCAD_APPIMAGE := bin/openscad/OpenSCAD.AppImage
OPENSCAD_MACOS := bin/openscad/OpenSCAD.app/Contents/MacOS/OpenSCAD
OPENSCADPATH := bin/openscad/libraries

.PHONY: sync install check render fallback-render png build clean

sync:
	uv sync

install:
	uv run scadm install

check:
	uv run scadm install --check

render:
	if [ "$$(uname -s)" = "Darwin" ]; then \
		$(MAKE) fallback-render; \
	else \
		uv run scadm render $(SCAD_FILE) || $(MAKE) fallback-render; \
	fi

fallback-render:
	mkdir -p $(RENDER_DIR)
	OPENSCADPATH="$(OPENSCADPATH)" "$$( \
		if [ "$$(uname -s)" = "Darwin" ]; then command -v openscad; \
		elif [ -x "$(OPENSCAD_MACOS)" ]; then printf '%s' "$(OPENSCAD_MACOS)"; \
		elif [ -x "$(OPENSCAD_APPIMAGE)" ]; then printf '%s' "$(OPENSCAD_APPIMAGE)"; \
		elif [ -x "$(OPENSCAD_BIN)" ]; then printf '%s' "$(OPENSCAD_BIN)"; \
		else command -v openscad; fi \
	)" --hardwarnings -o $(STL_FILE) $(SCAD_FILE)

png:
	mkdir -p $(RENDER_DIR)
	OPENSCADPATH="$(OPENSCADPATH)" "$$( \
		if [ "$$(uname -s)" = "Darwin" ]; then command -v openscad; \
		elif [ -x "$(OPENSCAD_MACOS)" ]; then printf '%s' "$(OPENSCAD_MACOS)"; \
		elif [ -x "$(OPENSCAD_APPIMAGE)" ]; then printf '%s' "$(OPENSCAD_APPIMAGE)"; \
		elif [ -x "$(OPENSCAD_BIN)" ]; then printf '%s' "$(OPENSCAD_BIN)"; \
		else command -v openscad; fi \
	)" \
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
	rm -rf $(RENDER_DIR) models/cisco_ap_mount/parts/renders
	find . -name '*.stl' -delete
	find . -name '*.3mf' -delete
