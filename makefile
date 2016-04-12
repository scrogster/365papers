all: *.png

*.png: 365papers.R
	Rscript 365papers.R
	rm Rplots.pdf
	touch README.md
	touch 365papers.R

clean:
	rm *.png

