sysconfdir = /etc

.PHONY: all examples install

install:
	install -Dp -m0644 odt12.conf $(DESTDIR)$(sysconfdir)/asciidoc/
	install -Dp -m0644 stylesheets/asciidoc.odt12.styles $(DESTDIR)$(sysconfdir)/asciidoc/stylesheets/
	install -Dp -m0644 themes/cv/cv.odt12.styles $(DESTDIR)$(sysconfdir)/asciidoc/themes/cv/

examples: examples/curriculum-vitae-dag-wieers.txt examples/test-odf.txt
	asciidoc -b odt12 examples/curriculum-vitae-dag-wieers.txt
	asciidoc -b odt12 examples/test-odf.txt
	asciidoc -b odt12 -a icons -a iconsdir=/usr/share/asciidoc/images/icons examples/asciidoc.txt

test: examples
