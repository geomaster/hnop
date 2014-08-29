# Needed for some bashisms ({} expansion)
SHELL=/bin/bash

default: prereqs release

# Flags
SASSFLAGS=-I external/sass
WGETFLAGS=-nv
PHPFLAGS=-n
PHPFLAGS_DEBUG=
PHPFLAGS_RELEASE=
PHPARGS_DEBUG=debug
PHPARGS_RELEASE=release

# Utilities
BASH_STARTRED=echo -ne '\e[00;31m'
BASH_ENDRED=echo -ne '\e[00m'
BASH_STARTGREEN=echo -ne '\e[00;32m'
BASH_ENDGREEN=$(BASH_ENDRED)

# Some prereqs
SCSSPARTIALS=$(shell find scss/ -type f -name '_*.scss')

# All source files
IMAGEFILES=$(shell find assets/images/ -type f)
FONTFILES=$(shell find assets/fonts/ -type f)
JSFILES=$(shell find js/ -type f -name '*.js')
JSLIBS=ember jquery handlebars
SCSSFILES=$(filter-out $(SCSSPARTIALS),$(shell find scss/ -type f -name '*.scss'))
PHPFILES=$(shell find html/ -type f -name '*.php')
ASSETS=$(IMAGEFILES) $(FONTFILES)

# Source dependencies
DEPS=$(ASSETS) $(JSFILES) $(SCSSFILES) $(HTMLFILES)

# All output files
OUTIMAGEFILES=$(patsubst assets/images/%,images/%,$(IMAGEFILES))
OUTFONTFILES=$(patsubst assets/fonts/%,fonts/%,$(FONTFILES))
OUTJSFILES=$(JSFILES) js/handlebars/templates.js
OUTJSLIBFILES=$(patsubst %,js/libs/%.js,$(JSLIBS))
OUTCSSFILES=$(patsubst scss/%.scss,css/%.css,$(SCSSFILES))
OUTHTMLFILES=$(patsubst html/%.php,%.html,$(PHPFILES))
OUTASSETS=$(OUTIMAGEFILES) $(OUTFONTFILES)
OUTMINJS=js/app.min.js

# Output files
OUTFILES_COMMON=$(OUTIMAGEFILES) $(OUTCSSFILES) $(OUTHTMLFILES) $(OUTJSLIBFILES) $(OUTASSETS)
OUTFILES_DEBUG=$(patsubst %,build-debug/%,$(OUTFILES_COMMON) $(OUTJSFILES) $(OUTJSLIBFILES))
OUTFILES_RELEASE=$(patsubst %,build-release/%,$(OUTFILES_COMMON) $(OUTMINJS) $(OUTJSLIBFILES))

debug: $(OUTFILES_DEBUG)

release: $(OUTFILES_RELEASE)

prereqs: prereqs-warning dirs jsc unsemantic handlebars jquery ember

prereqs-warning:
	@$(BASH_STARTRED); \
	printf %"s\n" \
	     "I will now download the necessary libraries and place them into the source" \
	     "tree. Make sure that you are doing this over a connection where you trust all" \
	     "of the computers. If not, please connect to a secure VPN or devise a .wgetrc or" \
	     "export variables to make sure wget connects through a secure HTTPS/TLS+SOCKS" \
	     "proxy. After you have done that, run \`make clean prereqs' to reacquire them."; \
	$(BASH_ENDRED);

dirs:
	scripts/mkdirino.bash external external/sass external/js external/tools \
	                      external/js/{debug,release} build-{debug,release} \
	                      build-{debug,release}/{css,js,images,fonts} \
	                      build-{debug,release}/js/{libs,handlebars}

jsc: external/tools/closurecompiler

unsemantic: external/sass/unsemantic

handlebars: external/js/debug/handlebars.js external/js/release/handlebars.js

jquery: external/js/debug/jquery.js external/js/release/jquery.js

ember: external/js/debug/ember.js external/js/release/ember.js

external/js/debug/ember.js:
	@$(BASH_STARTGREEN) && echo 'Getting Ember.js (debug version)...' && $(BASH_ENDGREEN);
	wget $(WGETFLAGS) http://builds.emberjs.com/tags/v1.7.0/ember.js -O external/js/debug/ember.js

external/js/release/ember.js:
	@$(BASH_STARTGREEN) && echo 'Getting Ember.js (production version)...' && $(BASH_ENDGREEN);
	wget $(WGETFLAGS) http://builds.emberjs.com/tags/v1.7.0/ember.min.js -O external/js/release/ember.js

external/js/debug/jquery.js:
	@$(BASH_STARTGREEN) && echo 'Getting jQuery (debug version)...' && $(BASH_ENDGREEN);
	wget $(WGETFLAGS) https://code.jquery.com/jquery-2.1.1.js -O external/js/debug/jquery.js

external/js/release/jquery.js:
	@$(BASH_STARTGREEN) && echo 'Getting jQuery... (production version)' && $(BASH_ENDGREEN);
	wget $(WGETFLAGS) https://code.jquery.com/jquery-2.1.1.min.js -O external/js/release/jquery.js

external/js/debug/handlebars.js:
	@$(BASH_STARTGREEN) && echo 'Getting Handlebars.js... (debug version)' && $(BASH_ENDGREEN);
	wget $(WGETFLAGS) http://builds.handlebarsjs.com.s3.amazonaws.com/handlebars-v1.3.0.js -O external/js/debug/handlebars.js

external/js/release/handlebars.js:
	@$(BASH_STARTGREEN) && echo 'Getting Handlebars.js... (production version)' && $(BASH_ENDGREEN);
	wget $(WGETFLAGS) http://builds.handlebarsjs.com.s3.amazonaws.com/handlebars.runtime-v1.3.0.js -O external/js/release/handlebars.js

external/sass/unsemantic:
	@$(BASH_STARTGREEN) && echo 'Getting Unsemantic...' && $(BASH_ENDGREEN);
	scripts/mkdirino.bash temp external/sass/unsemantic; \
	cd temp; \
	wget $(WGETFLAGS) https://github.com/nathansmith/unsemantic/archive/master.zip -O unsemantic.zip; \
	unzip -q unsemantic.zip; \
	mv unsemantic-master/assets/sass/* ../external/sass/unsemantic; \
	cd .. && rm -rf temp; 
		
external/tools/closurecompiler:
	@$(BASH_STARTGREEN) && echo 'Getting Google Closure Compiler...' && $(BASH_ENDGREEN);
	scripts/mkdirino.bash temp external/tools/closurecompiler; \
	cd temp; \
	wget $(WGETFLAGS) -O compiler.zip https://dl.google.com/closure-compiler/compiler-latest.zip; \
	unzip compiler.zip -d ../external/tools/closurecompiler; \
	cd .. && rm -rf temp; 

build-debug/css/%.css: scss/%.scss
	sass -t expanded $(SASSFLAGS) $< $@

build-debug/js/%.js: js/%.js
	cp $< $@

build-release/css/%.css: scss/%.scss
	sass -t compressed $(SASSFLAGS) $< $@

build-release/$(OUTMINJS): $(JSFILES)
	scripts/jsc.bash $(JSFILES) --js_output_file $@

build-debug/js/libs/%.js: external/js/debug/%.js
	cp $< $@

build-release/js/libs/%.js: external/js/release/%.js
	cp $< $@

build-debug/images/%.png build-release/images/%.png: assets/images/%.png
	pngcrush $< $@

build-debug/images/% build-release/images/%: assets/images/%
	cp $< $@

build-debug/fonts/% build-release/fonts/%: assets/fonts/%
	cp $< $@
	
build-debug/%.html: html/%.php
	php $(PHPFLAGS) $(PHPFLAGS_DEBUG) -f $< $(PHPARGS_DEBUG) >$@
	
build-release/%.html: html/%.php
	php $(PHPFLAGS) $(PHPFLAGS_RELEASE) -f $< $(PHPARGS_RELEASE) >$@

build-debug/js/handlebars/templates.js build-release/js/handlebars/templates.js: templates/*.handlebars
	ember-precompile -b templates/ $^ -f $@

clean:
	scripts/clean.bash build-{debug,release}

clean-prereqs:
	rm -rf external/{tools,js,sass}

.PHONY: prereqs debug release clean clean-prereqs ember handlebars jsc
