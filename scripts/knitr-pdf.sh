#!/bin/bash

# knit R or Rmd file to pdf
if [[ ! -r $1 ]]; then
    echo -e "\n File does not exist \n"
    return
fi

# create temporary rscript
tempscript=`mktemp /tmp/knitscript.XXXXX` || exit 1
echo "library(rmarkdown); rmarkdown::render('"${1}"', 'pdf_document')" >> $tempscript

cat $tempscript
Rscript $tempscript

