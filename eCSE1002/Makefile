#
#        FILE: Makefile
#      AUTHOR: Paul Bartholomew <paul.bartholomew08@imperial.ac.uk>
# DESCRIPTION: Makefile for postprocessing data related to eCSE1002 project.
#

#
# CASE to postprocess
# - Defaults to Taylor-Green Vortex
# 
#
CASE = tgv

#
# Desired operation
# - Defaults to build pdf
# - Change by using different targets
#
EOP = org-latex-export-to-pdf

# Target-specific EOPs
pdf: EOP = org-latex-export-to-pdf
tangle: EOP = org-babel-tangle

# Targets
all: pdf
pdf: build
tangle: build
run: tangle
	sh $(CASE)/postproc.sh

build:
	emacs $(CASE)/*.org -Q --batch -f $(EOP) --kill

