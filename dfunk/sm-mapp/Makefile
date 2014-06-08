FILE = mapp

MAKE = make
LATEX = pdflatex

PHOLDR = ../intropholdr
POLICY = ../policy

all: $(FILE).pdf

$(FILE).pdf: dfunkintropholdr.pdf dfunktpolicy.pdf
	$(LATEX) $(FILE).tex

dfunkintropholdr.pdf:
	$(MAKE) -C $(PHOLDR) all

dfunktpolicy.pdf:
	$(MAKE) -C $(POLICY) all


clean: 
	rm -f *.aux *.log *.toc *synctex.gz $(FILE).pdf && \
	$(MAKE) -C $(PHOLDR) clean && \
	$(MAKE) -C $(POLICY) clean

