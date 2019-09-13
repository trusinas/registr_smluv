# pomocná funkce - parsing souborů se smlouvou, dodatky atd.
get.soubory <- function(x) {
  soubory <- xml_find_all(x, "d1:prilohy/d1:priloha/d1:nazevSouboru") %>% 
    xml_text()
}

# DF s url smluv a příloh
parse.dump <- function(file) {
  path <- path.expand("~/RS/")
  output <- getwd()
  output <- paste0(output, "/output/smlouvy/")
  data <- paste0(path, file) %>% 
    read_xml()
  data %>% 
    xml_ns()
  zaznamy <- data %>% 
    xml_find_all("/d1:dump/d1:zaznam")
  vse <- zaznamy %>% {
    tibble(idSmlouvy = xml_find_first(., "d1:identifikator/d1:idSmlouvy"),
           idVerze = xml_find_first(., "d1:identifikator/d1:idVerze"),
           ico.ovm = xml_find_first(., "d1:smlouva/d1:subjekt/d1:ico"),
           dodavatel = xml_find_first(., "d1:smlouva/d1:smluvniStrana/d1:nazev"), # QUESTION: může být více?
           ico.dodavatel = xml_find_first(., "d1:smlouva/d1:smluvniStrana/d1:ico"), # QUESTION: může být více?
           predmet = xml_find_first(., "d1:smlouva/d1:predmet"),
           datum = xml_find_first(., "d1:smlouva/d1:datumUzavreni"),
           hodnotaBezDph = xml_find_first(., "d1:smlouva/d1:hodnotaBezDph"),
           hodnotaVcetneDph = xml_find_first(., "d1:smlouva/d1:hodnotaVcetneDph"),
           platny.zaznam = xml_find_first(., "d1:platnyZaznam"),
           odkaz = xml_find_first(., "d1:odkaz"),
           soubory = map(., get.soubory) # TODO Pomalé!! Předělat na pův. verzi z R/pokusy/smlouvy.R
    )
  } %>% 
    mutate_at(c("idSmlouvy", "idVerze", "ico.ovm", "dodavatel", "ico.dodavatel", "predmet", "datum", "hodnotaBezDph", "hodnotaVcetneDph", "platny.zaznam", "odkaz"), xml_text)
  write_rds(vse, paste0(output, paste0(file, ".rds")))
  rm(data, vse, zaznamy)
}
# TODO DOPLNIT:
# Útvar / Odbor
