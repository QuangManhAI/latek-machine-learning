#!/bin/bash
cd "$(dirname "$0")"
echo "Compiling LaTeX report..."
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
echo "Done. Output: main.pdf"
