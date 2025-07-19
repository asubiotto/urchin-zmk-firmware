.PHONY: build
build:
	docker run -it --rm --security-opt label=disable --workdir /zmk-urchin -v $(shell pwd):/zmk-urchin zmkfirmware/zmk-build-arm:stable /bin/bash -c 'CMAKE_PREFIX_PATH=/zmk-urchin/zephyr:$$CMAKE_PREFIX_PATH west build -d ./build/left -p -b "nice_nano_v2" -s /zmk-urchin/zmk/app -- -DSHIELD="urchin_left" -DZMK_CONFIG="/zmk-urchin/config" -DZMK_EXTRA_MODULES="/zmk-urchin/urchin-zmk-module"'
	cp build/left/zephyr/zmk.uf2 build/urchin_left.uf2
	docker run -it --rm --security-opt label=disable --workdir /zmk-urchin -v $(shell pwd):/zmk-urchin zmkfirmware/zmk-build-arm:stable /bin/bash -c 'CMAKE_PREFIX_PATH=/zmk-urchin/zephyr:$$CMAKE_PREFIX_PATH west build -d ./build/right -p -b "nice_nano_v2" -s /zmk-urchin/zmk/app -- -DSHIELD="urchin_right" -DZMK_CONFIG="/zmk-urchin/config" -DZMK_EXTRA_MODULES="/zmk-urchin/urchin-zmk-module"'
	cp build/right/zephyr/zmk.uf2 build/urchin_right.uf2
	docker run -it --rm --security-opt label=disable --workdir /zmk-urchin -v $(shell pwd):/zmk-urchin zmkfirmware/zmk-build-arm:stable /bin/bash -c 'CMAKE_PREFIX_PATH=/zmk-urchin/zephyr:$$CMAKE_PREFIX_PATH west build -d ./build/settings_reset -p -b "nice_nano_v2" -s /zmk-urchin/zmk/app -- -DSHIELD="settings_reset" -DZMK_CONFIG="/zmk-urchin/config" -DZMK_EXTRA_MODULES="/zmk-urchin/urchin-zmk-module"'
	cp build/settings_reset/zephyr/zmk.uf2 build/urchin_settings_reset.uf2

.PHONY: flashleft
flashleft:
	cp build/urchin_left.uf2 /Volumes/NICENANO/urchin_left.uf2

.PHONY: flashright
flashright:
	cp build/urchin_right.uf2 /Volumes/NICENANO/urchin_right.uf2

.PHONY: flashreset
flashreset:
	cp build/urchin_settings_reset.uf2 /Volumes/NICENANO/urchin_settings_reset.uf2
