.PHONY: check document test build install clean

check:
	R CMD check --as-cran .

document:
	Rscript -e "devtools::document()"

test:
	Rscript -e "devtools::test()"

build:
	R CMD build .

install:
	Rscript -e "devtools::install()"

clean:
	rm -rf datacore_*.tar.gz datacore.Rcheck
