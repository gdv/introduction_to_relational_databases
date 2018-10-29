all: pdf #html

mds=$(wildcard *.md)

%.pdf : %.md
	pandoc -t beamer --from markdown+grid_tables -V theme:metropolis --listings  -V themeoptions:titleformat=smallcaps --pdf-engine xelatex  $< -o $@
	test -d ~/B121/intro-DB/$@ || mkdir -p ~/B121/intro-DB/$@
	rsync -avc  $@  ~/B121/intro-DB/$@/

%.html : %.md
	pandoc -t revealjs --standalone --self-contained -V revealjs-url=./reveal.js -V theme=moon $< -o $@


pdfs=$(mds:.md=.pdf)

# html: $(mds:.md=.html)

pdf: $(pdfs)

release: $(pdfs)
	for f in *.pdf; do rsync -avc --delete $f ~/B121/intro-DB/$f/ ; done
