#!/bin/sh
# bld.sh - construct table of contents for each page

for F in `find . -name '*.md' -print`; do
  if egrep "<!-- mdtoc-start -->" $F >/dev/null; then
    # Update doc table of contents (see https://github.com/fordsfords/mdtoc).
    if which mdtoc.pl >/dev/null; then mdtoc.pl -b "" $F;
    elif [ -x ../mdtoc/mdtoc.pl ]; then ../mdtoc/mdtoc.pl -b "" $F;
    else echo "FYI: mdtoc.pl not found; Skipping doc build"; echo ""; fi
  fi
done

# Generate a PDF of the README (after its table of contents is updated).
if which pandoc >/dev/null; then pandoc README.md -o README.pdf;
elif which md2pdf.sh >/dev/null; then md2pdf.sh README.md;
else echo "FYI: neither pandoc nor md2pdf.sh found; Skipping README.pdf"; echo ""; fi
