library(tidyverse)
library(xml2)
# devtools::install_github("DavisVaughan/furrr")
# library(furrr)

# definice funkcí
source("R/func.R", encoding = "UTF-8")

# stahnout dumpy z data.smlouvy.gov.cz
# uložit do path.dumps
path.dump <- path.expand("~/RS/") # $(User)/Documents/RS/
if(!dir.exists(path.dump)) {
  dir.create(path.dump)}
source("R/metadata_download.R", encoding = "UTF-8")

# process dumps
dumps <- list.files(path = path.expand("~/RS/"), pattern = "^dump_\\d{4}_\\d{2}.xml$", full.names = F)
# parse.dump("test.xml") # testovací
# TODO Parsovat jen nové (chybějící v "/output/smlouvy/")
walk(dumps, parse.dump) # 1 dump = 1h #TODO future_walk + pův. způsob extrakce
output <- getwd()
output <- paste0(output, "/output/smlouvy/")
parsed <- list.files(path = output, pattern = "^dump_\\d{4}_\\d{2}.xml.rds$", full.names = F)
(znovu <- setdiff(paste0(dumps, ".rds"), parsed))
