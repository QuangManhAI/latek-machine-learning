#!/bin/bash
cd "$(dirname "$0")"
echo "Compiling LaTeX report..."
xelatex -interaction=nonstopmode main.tex
xelatex -interaction=nonstopmode main.tex
echo "Done. Output: main.pdf"
