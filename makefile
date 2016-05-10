all: *.png

REAMDME.md: *.png
	touch README.md	

*.png: 365papers.R
	Rscript 365papers.R
	rm Rplots.pdf
	touch 365papers.R

clean:
	rm *.png

