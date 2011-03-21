RM=/bin/rm -vf

all: ms.pdf

%.pdf: %.ps
	ps2pdf -dMaxSubsetPct=100 -dCompatibilityLevel=1.2 -dSubsetFonts=true -dEmbedAllFonts=true $<

%.ps: %.dvi
	dvips -t letter $< -o

ms.dvi: ms.tex stellarkinematics.tex
	latex $<
	latex $<
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "
	- bash -c " ( grep undefined $*.log && latex $< ) || echo noRerun "

#%.eps: %.ps
#	cp $< $(@)_tmp
#	echo "1,\$$s/%%BoundingBox: 27 195 585 596/%%BoundingBox: 30 358 337 562/g" > $(@)_edcmd
#	echo "w" >> $(@)_edcmd
#	ed $< < $(@)_edcmd
#	cp $< $@
#	cp $(@)_tmp $< 
#	rm $(@)_edcmd $(@)_tmp

%.dvi: %.tex

.PHONY: clean spotless

clean:
	$(RM) *.dvi *.aux *.log *.lof *.toc *.lot

spotless: clean
	$(RM) ms.pdf