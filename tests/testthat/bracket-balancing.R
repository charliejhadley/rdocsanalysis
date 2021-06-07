# Try https://stackoverflow.com/questions/546433/regular-expression-to-match-balanced-parentheses

library("tidyverse")

some_text <- "some text(text here(possible text)text(possible text(more text)))end text"


regmatches(some_text, regexpr("\\((?:[^()]+|(?R))*+\\)", some_text, perl=TRUE))

rd_like_text <- "\\description{stufff} \\examples{foobar %>% tube() }"

pattern <- "\\{(?:[^{}]*|(?R))*\\}"

regmatches(rd_like_text, gregexpr(pattern, rd_like_text, perl = TRUE))

.libPaths()

"dat"

example_read_file <- "~/Ap"

split_rd_file <- regmatches(example_read_file, gregexpr(pattern, example_read_file, perl = TRUE))[[1]]


process_rd_page
