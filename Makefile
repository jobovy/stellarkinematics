RM=/bin/rm -vf
.SECONDARY: radec_fig.ps lb_fig.ps

all: ms.pdf

%.pdf: %.ps
	ps2pdf -dMaxSubsetPct=100 -dCompatibilityLevel=1.2 -dSubsetFonts=true -dEmbedAllFonts=true $<

%.ps: %.dvi
	dvips -t letter $< -o

ms.pdf: ms.tex stellarkinematics.tex
	pdflatex $<
	pdflatex $<
	- bash -c " ( grep undefined $*.log && pdflatex $< ) || echo noRerun "
	- bash -c " ( grep undefined $*.log && pdflatex $< ) || echo noRerun "
	- bash -c " ( grep undefined $*.log && pdflatex $< ) || echo noRerun "

%.eps: %.ps
	cp $< $(@)_tmp
	echo "1,\$$s/%%BoundingBox: 0 0 612 792/%%BoundingBox: 154 508 299 675/g" > $(@)_edcmd
	echo "w" >> $(@)_edcmd
	ed $< < $(@)_edcmd
	cp $< $@
	cp $(@)_tmp $< 
	rm $(@)_edcmd $(@)_tmp

%.dvi: %.tex
	latex $<
	latex $<
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "

.PHONY: clean spotless

clean:
	$(RM) *.dvi *.aux *.log *.lof *.toc *.lot

spotless: clean
	$(RM) ms.pdf