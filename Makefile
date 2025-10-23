all: pdf #html

mds=$(wildcard *.md)

%.pdf : %.md
	pandoc -t beamer --from markdown+grid_tables -V theme:metropolis --listings  -V aspectratio:169 -V themeoptions:titleformat=smallcaps --pdf-engine lualatex  $< -o $@

%.html : %.md
	pandoc -t revealjs --standalone --self-contained -V revealjs-url=./reveal.js -V theme=moon $< -o $@


pdfs=$(mds:.md=.pdf)

# html: $(mds:.md=.html)

pdf: $(pdfs)
