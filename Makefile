bindir = /usr/bin
datadir = /usr/share
sysconfdir = /etc

.PHONY: all examples install

all:
	@echo "Nothing to do."

install:
	install -Dp -m0644 odt.conf $(DESTDIR)$(sysconfdir)/asciidoc/odt.conf
	install -Dp -m0644 stylesheets/asciidoc.odt.styles $(DESTDIR)$(sysconfdir)/asciidoc/stylesheets/asciidoc.odt.styles
	install -Dp -m0644 themes/cv/cv.odt.styles $(DESTDIR)$(sysconfdir)/asciidoc/themes/cv/cv.odt.styles
	install -Dp -m0755 filters/line_break.py $(DESTDIR)$(sysconfdir)/asciidoc/filters/line_break.py
	install -Dp -m0755 filters/code/code-filter.py $(DESTDIR)$(sysconfdir)/asciidoc/filters/code/code-filter.py
	install -Dp -m0644 filters/source/source-highlight-filter.conf $(DESTDIR)/asciidoc/filters/source/source-highlight-filter.conf
	echo "Please add \"odt = odt.outlang\" to $(datadir)/source-highlight/outlang.map"
	install -Dp -m0644 filters/source/odt.outlang $(DESTDIR)$(datadir)/source-highlight/odt.outlang
	install -Dp -m0755 packaged/a2x.py $(DESTDIR)$(bindir)/a2x.py
	install -Dp -m0644 packaged/a2x.conf $(DESTDIR)$(sysconfdir)/asciidoc/backends/odt/a2x.conf

examples: examples/curriculum-vitae-dag-wieers.txt examples/test-odf.txt
	asciidoc -b odt -a iconsdir=$(datadir)/asciidoc/images/icons -o examples/README.fodt README.asciidoc
	asciidoc -b odt -a iconsdir=$(datadir)/asciidoc/images/icons examples/test-odf.txt
	asciidoc -b odt -a theme=cv examples/curriculum-vitae-dag-wieers.txt
	asciidoc -b odt -a iconsdir=$(datadir)/asciidoc/images/icons examples/asciidoc.txt

test: examples
