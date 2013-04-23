.PHONY: all clean install build uninstall
all: build

BINDIR ?= /usr/bin

export OCAMLRUNPARAM=b

build: dist/setup
	obuild build

dist/setup: xapi-codegen.obuild
	obuild configure

install:
	install -D ./dist/build/gen_api/gen_api $(DESTDIR)/$(BINDIR)/gen_api

uninstall:
	rm -f $(DESTDIR)/$(BINDIR)/gen_api

clean:
	@obuild clean
