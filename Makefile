bindir = /usr/bin
datadir = /usr/share
sysconfdir = /etc

txttargets = $(shell echo examples/*.txt)
fodttargets = $(patsubst %.txt, %.fodt, $(txttargets))

.PHONY: all examples install

all:
	@echo "Nothing to do."

link:
	@echo "= Linking odp backend"
	mkdir -p $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp/
	ln -sf $(shell pwd)/backends/odp/odp.conf $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp/odp.conf
	ln -sf $(shell pwd)/backends/odp/asciidoc.odp.styles $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp/asciidoc.odp.styles
	ln -sf $(shell pwd)/backends/odp/a2x-odp.py $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp/a2x-odp.py
	@echo "= Linking odt backend"
	mkdir -p $(DESTDIR)$(sysconfdir)/asciidoc/backends/odt/
	ln -sf $(shell pwd)/backends/odt/odt.conf $(DESTDIR)$(sysconfdir)/asciidoc/backends/odt/odt.conf
	ln -sf $(shell pwd)/backends/odt/asciidoc.odt.styles $(DESTDIR)$(sysconfdir)/asciidoc/backends/odt/asciidoc.odt.styles
	ln -sf $(shell pwd)/backends/odt/a2x-odt.py $(DESTDIR)$(sysconfdir)/asciidoc/backends/odt/a2x-odt.py
	@echo "= Linking cv theme"
	mkdir -p $(DESTDIR)$(sysconfdir)/asciidoc/themes/cv/
	ln -sf $(shell pwd)/themes/cv/cv.odt.styles $(DESTDIR)$(sysconfdir)/asciidoc/themes/cv/cv.odt.styles
	@echo "= Installing hp theme"
	mkdir -p $(DESTDIR)$(sysconfdir)/asciidoc/themes/hp/
	ln -sf $(shell pwd)/themes/hp/hp.odt.styles $(DESTDIR)$(sysconfdir)/asciidoc/themes/hp/hp.odt.styles
	@echo "= Installing code filter"
	mkdir -p $(DESTDIR)$(sysconfdir)/asciidoc/filters/code/
	ln -sf $(shell pwd)/filters/code/code-filter.py $(DESTDIR)$(sysconfdir)/asciidoc/filters/code/code-filter.py

install:
	@echo "= Installing odp backend"
	install -Dp -m0644 backends/odp/odp.conf $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp/odp.conf
	install -Dp -m0644 backends/odp/asciidoc.odp.styles $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp/asciidoc.odp.styles
	install -Dp -m0644 backends/odp/a2x-odp.py $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp/a2x-odp.py
	@echo "= Installing odt backend"
	install -Dp -m0644 backends/odt/odt.conf $(DESTDIR)$(sysconfdir)/asciidoc/backends/odt/odt.conf
	install -Dp -m0644 backends/odt/asciidoc.odt.styles $(DESTDIR)$(sysconfdir)/asciidoc/backends/odt/asciidoc.odt.styles
	install -Dp -m0644 backends/odt/a2x-odt.py $(DESTDIR)$(sysconfdir)/asciidoc/backends/odt/a2x-odt.py
	@echo "= Installing cv theme"
	install -Dp -m0644 themes/cv/cv.odt.styles $(DESTDIR)$(sysconfdir)/asciidoc/themes/cv/cv.odt.styles
	@echo "= Installing hp theme"
	install -Dp -m0644 themes/hp/hp.odt.styles $(DESTDIR)$(sysconfdir)/asciidoc/themes/hp/hp.odt.styles
	@echo "=Installing code filter"
	install -Dp -m0755 filters/code/code-filter.py $(DESTDIR)$(sysconfdir)/asciidoc/filters/code/code-filter.py
### Old cruft
#	install -Dp -m0755 filters/line_break.py $(DESTDIR)$(sysconfdir)/asciidoc/filters/line_break.py
#	install -Dp -m0644 filters/source/source-highlight-filter.conf $(DESTDIR)/asciidoc/filters/source/source-highlight-filter.conf
#	echo "Please add \"odf = odf.outlang\" to $(datadir)/source-highlight/outlang.map"
#	install -Dp -m0644 filters/source/odf.outlang $(DESTDIR)$(datadir)/source-highlight/odf.outlang
#	install -Dp -m0755 packaged/a2x.py $(DESTDIR)$(bindir)/a2x.py

examples: $(fodttargets) odt.conf
	asciidoc -b odt -a newline=\\n -a iconsdir=$(datadir)/asciidoc/images/icons -o examples/README.fodt README.asciidoc
	-xmllint --noout --relaxng relaxng/OpenDocument-v1.2-cs01-schema.rng examples/README.fodt
#	-jing -i relaxng/OpenDocument-v1.2-cs01-schema.rng examples/README.fodt
	asciidoc -b odt -a theme=cv -a newline=\\n examples/curriculum-vitae-dag-wieers.txt
	-xmllint --noout --relaxng relaxng/OpenDocument-v1.2-cs01-schema.rng examples/curriculum-vitae-dag-wieers.fodt
#	-jing -i relaxng/OpenDocument-v1.2-cs01-schema.rng examples/curriculum-vitae-dag-wieers.fodt
	asciidoc -b odp examples/rear-presentation.txt
	-xmllint --noout --relaxng relaxng/OpenDocument-v1.2-cs01-schema.rng examples/rear-presentation.fodp
#	-jing -i relaxng/OpenDocument-v1.2-cs01-schema.rng examples/curriculum-vitae-dag-wieers.fodt

%.fodt: %.txt
	asciidoc -b xhtml11 -a iconsdir=$(datadir)/asciidoc/images/icons -o $(patsubst %.fodt, %.html, $@) $<
	asciidoc -b odt -a newline=\\n -a iconsdir=$(datadir)/asciidoc/images/icons -o $@ $<
	-xmllint --noout --relaxng relaxng/OpenDocument-v1.2-cs01-schema.rng $@
#	-jing -i relaxng/OpenDocument-v1.2-cs01-schema.rng $@

test: examples

zip:
	cd backends; for backend in *; do pushd $$backend >/dev/null; zip ../../$$backend-backend *; popd >/dev/null; done
	cd themes; for theme in *; do pushd $$theme >/dev/null; zip ../../$$theme-theme *; popd >/dev/null; done
	cd filters; for filter in *; do pushd $$filter >/dev/null; zip ../../$$filter-filter *; popd >/dev/null; done

clean:
	rm -f examples/*.fodt examples/*.html
