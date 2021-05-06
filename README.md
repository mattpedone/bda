# bda
couple of lessons for Bayesian Data Analysis course

* `doc/inst_file.md` is a short guide for the installation on different OS of R, RStudio, Git and GitHub
* in file `doc/lez-1.Rmd` there are the slides for the first lesson (9/3) about RStudio and RMarkdown
* in file `doc/lez-2.Rmd` there are the slides for the second lesson (12/3) about Git and GitHub
* `R/fnchoff.R` contains useful function for RMarkdown tutorial
* `data/reading.RData` contains the data set used in RMarkdown tutorial
* `docs/bibliography.bib` contains the bibliography needed in RMarkdown tutorial
* `docs/mkdlez1.Rmd` contains the RMarkdown tutorial

-----

* `R/fig_notes.R` is a script to reproduce figures reported in notes
* `R/mixture_mcmc.R` is a script to run two simple analysis
* `R/utils.R` contains some `R` functions that are needed in the script

-----

to create Pdfs from .Rmd use 

`pagedown::chrome_print("path_to_your_doc/myfile.Rmd")`
