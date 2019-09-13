library(tidyverse)
library(xml2)
library(rvest)  

# velikost dumpů
url <- "https://data.smlouvy.gov.cz/"
data <- url %>% 
  read_xml()
data %>% 
  xml_ns()
odkazy <- data %>% 
  xml_find_all("/d1:index/d1:dump/d1:odkaz") %>% 
  xml_text()
cele.mesice <- data %>% 
  xml_find_all("/d1:index/d1:dump/d1:dokoncenyMesic") %>% 
  xml_text()
size <- data %>% 
  xml_find_all("/d1:index/d1:dump/d1:velikostDumpu") %>% 
  xml_text()
df <- data.frame(cele.mesice, odkazy, size = as.integer(size), stringsAsFactors = F)
cat("Velikost publikovaných dumpů celkem:", sum(df$size)/(10^3)^3, "GB\n") #GB
# stahovat jen dokončené měsíce
# stahovat jen, co nově přibylo (není ve složce)
stazeno <- list.files(path = path.dump, pattern = "^dump_\\d{4}_\\d{2}.xml$", full.names = F)
stazeno <- paste0("https://data.smlouvy.gov.cz/", stazeno)
df <- df %>% 
  filter(cele.mesice == 1) %>% 
  filter(!odkazy %in% stazeno)
cat("Bude staženo:", sum(df$size)/(10^3)^3, "GB\n") #GB
walk2(df$odkazy, paste0(path.dump, str_extract(df$odkazy, "dump.*xml")),
      download.file, mode = "wb")
rm(cele.mesice, data,df, odkazy, path.dump, size, stazeno, url)
