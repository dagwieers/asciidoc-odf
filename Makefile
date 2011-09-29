sysconfdir = /etc

.PHONY: all examples install

install:
	install -Dm0644 odt11.conf $(DESTDIR)$(sysconfdir)/asciidoc/

examples: examples/curriculum-vitae-dag-wieers.txt examples/test-odf.txt
	asciidoc -b odt11 examples/curriculum-vitae-dag-wieers.txt
	asciidoc -b odt11 examples/test-odf.txt
