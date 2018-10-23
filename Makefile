all: pdf #html

mds=$(wildcard *.md)

%.pdf : %.md
	pandoc -t beamer --from markdown+grid_tables -V theme:metropolis --listings  -V themeoptions:titleformat=smallcaps --pdf-engine xelatex  $< -o $@

%.html : %.md
	pandoc -t revealjs --standalone --self-contained -V revealjs-url=./reveal.js -V theme=moon $< -o $@


pdfs=$(mds:.md=.pdf)

# html: $(mds:.md=.html)

pdf: $(pdfs)

release: pdf
	rsync -avc $(pdfs) ~/B121/intro-DB
