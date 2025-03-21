#!/bin/sh

tex_file="thesis-proposal.tex"
bibtex_file="literature.bib"
csl_file="ieee.csl"
output_file="README.md"

# compile latex
pdflatex -pdf -halt-on-error "$tex_file"
if [ $? = 0 ] ; then
  bibtex "${tex_file%.tex}"
  if [ $? != 0 ] ; then
    echo "Processing of Bibtex file for Latex file $tex_file failed."
    exit 1
  fi
  pdflatex -pdf -halt-on-error "$tex_file"
  pdflatex -pdf -halt-on-error "$tex_file"
else 
  echo "Compilation of Latex file $tex_file failed."
  exit 1
fi

# convert to markdown
# debug: --verbose --log="pandoc.log"
pandoc --bibliography="$bibtex_file" --csl="$csl_file" -s "$tex_file" -t markdown_strict --citeproc --webtex --natbib > "$output_file"
