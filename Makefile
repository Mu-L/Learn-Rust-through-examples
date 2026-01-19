# Makefile for building localized mdBook outputs
.PHONY: build-en build-zh build-all serve-en serve-zh clean

build-en:
	cd en && mdbook build
	rm -rf book/en
	mkdir -p book
	cp -r en/book book/en

build-zh:
	cd zh && mdbook build
	rm -rf book/zh
	mkdir -p book
	cp -r zh/book book/zh

build-all: build-en build-zh

serve-en:
	cd en && mdbook serve

serve-zh:
	cd zh && mdbook serve

clean:
	rm -rf en/book zh/book book/en book/zh
