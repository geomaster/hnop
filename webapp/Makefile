# Needed for some bashisms ({} expansion)
SHELL=/bin/bash

default: release

# All source files
IMAGEFILES=$(shell find assets/images/ -type f)
FONTFILES=$(shell find assets/fonts/ -type f)
JSFILES=$(shell find js/ -type f -name '*.js')
JSLIBS=
JSLIBFILES=$(patsubst %.js,external/js/%.js,$(JSLIBS))
SCSSFILES=$(shell find scss/ -type f -name '*.scss')
HTMLFILES=$(shell find html/ -type f -name '*.html')
ASSETS=$(IMAGEFILES) $(FONTFILES)

# Source dependencies
DEPS=$(ASSETS) $(JSFILES) $(SCSSFILES) $(HTMLFILES)

# All output files
OUTIMAGEFILES=$(patsubst assets/images/%,images/%,$(IMAGEFILES))
OUTFONTFILES=$(patsubst assets/fonts/%,fonts/%,$(FONTFILES))
OUTJSFILES=$(JSFILES)
OUTJSLIBFILES=$(patsubst external/js/%,js/lib/%,$(JSLIBFILES))
OUTCSSFILES=$(patsubst scss/%.scss,css/%.css,$(SCSSFILES))
OUTHTMLFILES=$(patsubst html/%.html,%.html,$(HTMLFILES))
OUTASSETS=$(OUTIMAGEFILES) $(OUTFONTFILES)
OUTMINJS=js/app.min.js

# Output files
OUTFILES_COMMON=$(OUTIMAGEFILES) $(OUTCSSFILES) $(OUTHTMLFILES) $(OUTJSLIBFILES) $(OUTASSETS)
OUTFILES_DEBUG=$(patsubst %,build-debug/%,$(OUTFILES_COMMON) $(OUTJSFILES))
OUTFILES_RELEASE=$(patsubst %,build-release/%,$(OUTFILES_COMMON) $(OUTMINJS))

debug: $(OUTFILES_DEBUG)

release: $(OUTFILES_RELEASE)

prereqs: dirs jsc unsemantic

dirs:
	scripts/mkdirino.bash external external/sass external/js external/tools \
	                      build-{debug,release} build-{debug,release}/{css,js,images,fonts} \
						  build-{debug,release}/js/libs

jsc: external/tools/closurecompiler

unsemantic: external/sass/unsemantic

external/sass/unsemantic:
	scripts/mkdirino.bash temp external/sass/unsemantic; \
	cd temp; \
	wget https://github.com/nathansmith/unsemantic/archive/master.zip -O unsemantic.zip; \
	unzip unsemantic.zip; \
	mv unsemantic-master/assets/sass/* ../external/sass/unsemantic; \
	cd .. && rm -rf temp; 
		
external/tools/closurecompiler:
	scripts/mkdirino.bash temp external/tools/closurecompiler; \
	cd temp; \
	wget -O compiler.zip https://dl.google.com/closure-compiler/compiler-latest.zip; \
	unzip compiler.zip -d ../external/tools/closurecompiler; \
	cd .. && rm -rf temp; 

build-debug/css/%.css: scss/%.scss
	sass -t expanded $< $@

build-debug/js/%.js: js/%.js
	cp $< $@

build-release/css/%.css: scss/%.scss
	sass -t compressed $< $@

build-release/$(OUTMINJS): $(JSFILES)
	scripts/jsc.bash $(JSFILES) --js_output_file $@

build-debug/js/lib/%.js: external/js/%.js
	cp %< %@

build-debug/images/%.png build-release/images/%.png: assets/images/%.png
	pngcrush $< $@

build-debug/images/% build-release/images/%: assets/images/%
	cp $< $@

build-debug/fonts/%.ttf build-release/fonts/%: assets/fonts/%
	cp $< $@
	
build-debug/%.html build-release/%.html: html/%.html
	cp $< $@

clean:
	scripts/clean.bash build-{debug,release}
	rm -rf external/{closurecompiler,js,sass}/*

.PHONY: prereqs debug release clean jsc
