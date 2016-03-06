all: cumulative.png 

cumulative.png: 365papers.R
	Rscript 365papers.R
	rm Rplots.pdf

