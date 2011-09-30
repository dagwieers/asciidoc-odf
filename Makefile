sysconfdir = /etc

.PHONY: all examples install

install:
	install -Dp -m0644 odt11.conf $(DESTDIR)$(sysconfdir)/asciidoc/
	install -Dp -m0644 styles/asciidoc.odt11.styles $(DESTDIR)$(sysconfdir)/asciidoc/styles/
	install -Dp -m0644 themes/cv/cv.odt11.styles $(DESTDIR)$(sysconfdir)/asciidoc/themes/cv/

examples: examples/curriculum-vitae-dag-wieers.txt examples/test-odf.txt
	asciidoc -b odt11 examples/curriculum-vitae-dag-wieers.txt
	asciidoc -b odt11 examples/test-odf.txt

test: examples
