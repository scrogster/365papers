all: *.png

*.png: 365papers.R
	Rscript 365papers.R
	rm Rplots.pdf

clean:
	rm *.png

