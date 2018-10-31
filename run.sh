#!/bin/bash
#
#        FILE: run.sh
#      AUTHOR: Paul Bartholomew <paul.bartholomew08@imperial.ac.uk>
# DESCRIPTION: Shell script to run post-processing notebooks, for example
#                ./run.sh ./eCSE1002/non-boussinesq.org
#

emacs ${1} -Q --batch -f org-latex-export-to-pdf --kill

