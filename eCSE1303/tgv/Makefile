#
#   FILE: TGV postprocessing Makefile
# AUTHOR: Paul Bartholomew
#

all: pdf

py:
	emacs -Q --batch -l org tgv.org -f org-babel-tangle

plot: py
	python ./plot_tgv.py

latex: plot
	emacs -Q --batch -l org tgv.org -f org-latex-export-to-latex

pdf: latex
	pdflatex tgv.tex
	pdflatex tgv.tex

