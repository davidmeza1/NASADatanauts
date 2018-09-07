# Here are a few methods for getting text from PDF files. Do read through 
# the instructions carefully! NOte that this code is written for Windows 7,
# slight adjustments may be needed for other OSs

# Tell R what folder contains your 1000s of PDFs
dest <- "G:/somehere/with/many/PDFs"

# make a vector of PDF file names
myfiles <- list.files(path = dest, pattern = "pdf",  full.names = TRUE)

# now there are a few options...

############### PDF (image of text format) to TXT ##########
# This is for is your PDF is an image of text, this is the case
# if you open the PDF in a PDF viewer and you cannot select
# words or lines with your cursor.

##### Wait! #####
# Before proceeding, make sure you have a copy of Tesseract
# on your computer! Details & download:
# https://code.google.com/p/tesseract-ocr/
# and a copy of ImageMagick: http://www.imagemagick.org/
# and a copy of pdftoppm on your computer! 
# Download: http://www.foolabs.com/xpdf/download.html
# And then after installing those three, restart to 
# ensure R can find them on your path. 
# And note that this process can be quite slow...

# PDF filenames can't have spaces in them for these operations
# so let's get rid of the spaces in the filenames

sapply(myfiles, FUN = function(i){
    file.rename(from = i, to =  paste0(dirname(i), "/", gsub(" ", "", basename(i))))
})

# get the PDF file names without spaces
myfiles <- list.files(path = dest, pattern = "pdf",  full.names = TRUE)

# Now we can do the OCR to the renamed PDF files. Don't worry
# if you get messages like 'Config Error: No display 
# font for...' it's nothing to worry about

lapply(files, function(i){
    # convert pdf to ppm (an image format), just pages 1-10 of the PDF
    # but you can change that easily, just remove or edit the 
    # -f 1 -l 10 bit in the line below
    shell(shQuote(paste0("pdftoppm ", i, " -f 1 -l 10 -r 600 ocrbook")))
    # convert ppm to tif ready for tesseract
    shell(shQuote(paste0("convert *.ppm ", i, ".tif")))
    # convert tif to text file
    shell(shQuote(paste0("tesseract ", i, ".tif ", i, " -l eng")))
    # delete tif file
    file.remove(paste0(i, ".tif" ))
})


# where are the txt files you just made?
dest # in this folder

# And now you're ready to do some text mining on the text files

############### PDF (text format) to TXT ###################

##### Wait! #####
# Before proceeding, make sure you have a copy of pdf2text
# on your computer! Details: https://en.wikipedia.org/wiki/Pdftotext
# Download: http://www.foolabs.com/xpdf/download.html

# If you have a PDF with text, ie you can open the PDF in a 
# PDF viewer and select text with your curser, then use these 
# lines to convert each PDF file that is named in the vector 
# into text file is created in the same directory as the PDFs
# note that my pdftotext.exe is in a different location to yours
lapply(myfiles, function(i) system(paste('"C:/Program Files/xpdf/bin64/pdftotext.exe"', paste0('"', i, '"')), wait = FALSE) )

# where are the txt files you just made?
dest # in this folder

# And now you're ready to do some text mining on the text files

############### PDF to CSV (DfR format) ####################

# or if you want DFR-style csv files...
# read txt files into R
mytxtfiles <- list.files(path = dest, pattern = "txt",  full.names = TRUE)

library(tm)
mycorpus <- Corpus(DirSource(dest, pattern = "txt"))
# warnings may appear after you run the previous line, they
# can be ignored
mycorpus <- tm_map(mycorpus,  removeNumbers)
mycorpus <- tm_map(mycorpus,  removePunctuation)
mycorpus <- tm_map(mycorpus,  stripWhitespace)
mydtm <- DocumentTermMatrix(mycorpus)
# remove some OCR weirdness
# words with more than 2 consecutive characters
mydtm <- mydtm[,!grepl("(.)\\1{2,}", mydtm$dimnames$Terms)]

# get each doc as a csv with words and counts
for(i in 1:nrow(mydtm)){
    # get word counts
    counts <- as.vector(as.matrix(mydtm[1,]))
    # get words
    words <- mydtm$dimnames$Terms
    # combine into data frame
    df <- data.frame(word = words, count = counts,stringsAsFactors = FALSE)
    # exclude words with count of zero
    df <- df[df$count != 0,]
    # write to CSV with original txt filename
    write.csv(df, paste0(mydtm$dimnames$Docs[i],".csv"), row.names = FALSE) 
}

# and now you're ready to work with the csv files

############### PDF to TXT (all text between two words) ####

## Below is about splitting the text files at certain characters
## can be skipped...

# if you just want the abstracts, we can use regex to extract that part of
# each txt file, Assumes that the abstract is always between the words 'Abstract'
# and 'Introduction'

abstracts <- lapply(mytxtfiles, function(i) {
    j <- paste0(scan(i, what = character()), collapse = " ")
    regmatches(j, gregexpr("(?<=Abstract).*?(?=Introduction)", j, perl=TRUE))
})
# Write abstracts into separate txt files...

# write abstracts as txt files 
# (or use them in the list for whatever you want to do next)
lapply(1:length(abstracts),  function(i) write.table(abstracts[i], file=paste(mytxtfiles[i], "abstract", "txt", sep="."), quote = FALSE, row.names = FALSE, col.names = FALSE, eol = " " ))

# And now you're ready to do some text mining on the txt 

# originally on http://stackoverflow.com/a/21449040/1036500