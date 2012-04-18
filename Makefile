version = 0.1

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
	-[[ -e $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp ]] && rm -ir $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp
	-ln -sf $(shell pwd)/backends/odp/ $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp
	@echo "= Linking odt backend"
	rm -ir $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp
	-[[ -e $(DESTDIR)$(sysconfdir)/asciidoc/backends/odt ]] && rm -ir $(DESTDIR)$(sysconfdir)/asciidoc/backends/odt
	@echo "= Linking cv theme"
	rm -ir $(DESTDIR)$(sysconfdir)/asciidoc/themes/cv
	-[[ -e $(DESTDIR)$(sysconfdir)/asciidoc/themes/cv ]] && rm -ir $(DESTDIR)$(sysconfdir)/asciidoc/themes/cv
	@echo "= Installing hp theme"
	-[[ -e $(DESTDIR)$(sysconfdir)/asciidoc/themes/hp ]] && rm -ir $(DESTDIR)$(sysconfdir)/asciidoc/themes/hp
	-ln -sf $(shell pwd)/themes/hp/ $(DESTDIR)$(sysconfdir)/asciidoc/themes/hp
	@echo "= Installing code filter"
	-[[ -e $(DESTDIR)$(sysconfdir)/asciidoc/filters/code ]] && rm -ir $(DESTDIR)$(sysconfdir)/asciidoc/filters/code
	-ln -sf $(shell pwd)/filters/code/ $(DESTDIR)$(sysconfdir)/asciidoc/filters/code

install:
	@echo "= Installing odp backend"
	install -Dp -m0644 backends/odp/odp.conf $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp/odp.conf
	install -Dp -m0644 backends/odp/asciidoc.odp.styles $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp/asciidoc.odp.styles
	install -Dp -m0644 backends/odp/asciidoc.otp $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp/asciidoc.otp
	install -Dp -m0644 backends/odp/a2x-backend.py $(DESTDIR)$(sysconfdir)/asciidoc/backends/odp/a2x-backend.py
	@echo "= Installing odt backend"
	install -Dp -m0644 backends/odt/odt.conf $(DESTDIR)$(sysconfdir)/asciidoc/backends/odt/odt.conf
	install -Dp -m0644 backends/odt/asciidoc.odt.styles $(DESTDIR)$(sysconfdir)/asciidoc/backends/odt/asciidoc.odt.styles
	install -Dp -m0644 backends/odt/asciidoc.ott $(DESTDIR)$(sysconfdir)/asciidoc/backends/odt/asciidoc.ott
	install -Dp -m0644 backends/odt/a2x-backend.py $(DESTDIR)$(sysconfdir)/asciidoc/backends/odt/a2x-backend.py
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
	-xmllint --noout --relaxng relaxng/OpenDocument-v1.2-os-schema.rng examples/README.fodt
#	-jing -i relaxng/OpenDocument-v1.2-os-schema.rng examples/README.fodt
	asciidoc -b odt -a theme=cv -a newline=\\n examples/curriculum-vitae-dag-wieers.txt
	-xmllint --noout --relaxng relaxng/OpenDocument-v1.2-os-schema.rng examples/curriculum-vitae-dag-wieers.fodt
#	-jing -i relaxng/OpenDocument-v1.2-os-schema.rng examples/curriculum-vitae-dag-wieers.fodt
	asciidoc -b odp examples/rear-presentation.txt
	-xmllint --noout --relaxng relaxng/OpenDocument-v1.2-os-schema.rng examples/rear-presentation.fodp
#	-jing -i relaxng/OpenDocument-v1.2-os-schema.rng examples/curriculum-vitae-dag-wieers.fodt

%.fodt: %.txt
	asciidoc -b xhtml11 -a iconsdir=$(datadir)/asciidoc/images/icons -o $(patsubst %.fodt, %.html, $@) $<
	asciidoc -b odt -a newline=\\n -a iconsdir=$(datadir)/asciidoc/images/icons -o $@ $<
	-xmllint --noout --relaxng relaxng/OpenDocument-v1.2-os-schema.rng $@
#	-jing -i relaxng/OpenDocument-v1.2-os-schema.rng $@
test: examples

templates:
	@echo "= Write minimal ODT"
	cd minimal-odf; \
	echo -n 'application/vnd.oasis.opendocument.text' >mimetype; \
	echo '<office:document-styles office:version="1.2" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:rpt="http://openoffice.org/2005/report" xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:grddl="http://www.w3.org/2003/g/data-view#" xmlns:tableooo="http://openoffice.org/2009/table" xmlns:field="urn:openoffice:names:experimental:ooo-ms-interop:xmlns:field:1.0" xmlns:formx="urn:openoffice:names:experimental:ooxml-odf-interop:xmlns:form:1.0" xmlns:css3t="http://www.w3.org/TR/css3-text/">' >styles.xml; \
	cat ../backends/odt/asciidoc.odt.styles >>styles.xml; \
	echo '</office:document-styles>' >>styles.xml; \
	rm -rf ../backends/odt/asciidoc.ott; \
	zip -X -r ../backends/odt/asciidoc.ott mimetype *
	@echo "= Write minimal ODP"
	cd minimal-odf; \
	echo -n 'application/vnd.oasis.opendocument.presentation' >mimetype; \
	echo '<office:document-styles office:version="1.2" xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:rpt="http://openoffice.org/2005/report" xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:grddl="http://www.w3.org/2003/g/data-view#" xmlns:tableooo="http://openoffice.org/2009/table" xmlns:field="urn:openoffice:names:experimental:ooo-ms-interop:xmlns:field:1.0" xmlns:formx="urn:openoffice:names:experimental:ooxml-odf-interop:xmlns:form:1.0" xmlns:css3t="http://www.w3.org/TR/css3-text/">' >>styles.xml; \
	cat ../backends/odp/asciidoc.odp.styles >>styles.xml; \
	echo '</office:document-styles>' >>styles.xml; \
	rm -rf ../backends/odp/asciidoc.otp; \
	zip -X -r ../backends/odp/asciidoc.otp mimetype *

zip: templates
	cd backends; for backend in *; do pushd $$backend >/dev/null; rm ../../$$backend-backend-$(version).zip; zip ../../$$backend-backend-$(version).zip *; popd >/dev/null; done
	cd themes; for theme in *; do pushd $$theme >/dev/null; rm ../../$$theme-theme-$(version).zip; zip ../../$$theme-theme-$(version).zip *; popd >/dev/null; done
	cd filters; for filter in *; do pushd $$filter >/dev/null; rm ../../$$filter-filter-$(version).zip; zip ../../$$filter-filter-$(version).zip *; popd >/dev/null; done

clean:
	rm -f examples/*.fodt examples/*.html
