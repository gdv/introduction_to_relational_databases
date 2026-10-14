# Slidev (https://sli.dev) decks: every 0X-*.md
decks=$(basename $(wildcard 0*.md))
SITE=_site

all: site

# Everything published on GitHub Pages: landing page + one static SPA per deck.
# --base ./ and hash routing let the decks work under any subpath
site: $(SITE)/index.html $(addprefix $(SITE)/,$(addsuffix /index.html,$(decks)))

$(SITE)/%/index.html: %.md pages/license.md styles/index.css
	npx slidev build $< --base ./ --router-mode hash --out $(SITE)/$*

$(SITE)/index.html: site/index.html
	mkdir -p $(SITE)
	cp $< $@

clean:
	rm -rf $(SITE)

.PHONY: all site clean
