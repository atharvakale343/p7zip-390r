PYFILES = $(wildcard src/*.py)
SC = $(wildcard screenshots/*.png)

INPUT_MD = submission.md
OUTPUT_TEX = submission.tex
OUTPUT_PDF = Kale_Atharva_p2w.pdf
ZIP_CMD = zip -FSr -j submission.zip src/* $(OUTPUT_PDF) screenshots/Kale_Atharvap1c2.png

OUTPUT_PDF_PDFLATEX = $(patsubst %.tex,%.pdf,$(OUTPUT_TEX))
UNAME := $(shell uname)

OPEN := open
ifeq ($(UNAME), Linux)
OPEN = xdg-open
endif
ifeq ($(UNAME), Darwin)
OPEN = open
endif

all: $(INPUT_MD) $(PYFILES) $(SC)
	pandoc -s --template eisvogel --listings -H disable_float.tex -V colorlinks=true -V linkcolor=blue -V urlcolor=blue -o $(OUTPUT_PDF) $(INPUT_MD)
	$(OPEN) $(OUTPUT_PDF)
	$(ZIP_CMD)

fast: $(INPUT_MD) $(PYFILES) $(SC)
	pandoc -s --template eisvogel --listings -H disable_float.tex -V colorlinks=true -V linkcolor=blue -V urlcolor=blue -o $(OUTPUT_TEX) $(INPUT_MD)
	pdflatex $(OUTPUT_TEX)
	mv $(OUTPUT_PDF_PDFLATEX) $(OUTPUT_PDF)
	$(OPEN) $(OUTPUT_PDF)
	$(ZIP_CMD)
	rm *.aux *.log $(OUTPUT_TEX)

