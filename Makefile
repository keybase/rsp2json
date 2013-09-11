
ICED=node_modules/.bin/iced

FILES = lib/parser.js \
	lib/engine.js \
	lib/scanner.js \
	lib/main.js

default: $(FILES)
all: $(FILES)

lib/%.js: src/%.iced
	$(ICED) -I node -c -o lib $<

