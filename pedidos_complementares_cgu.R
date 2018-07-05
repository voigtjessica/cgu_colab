# Baixar as planilhas, ver quantos pedidos eu preciso a mais, 
# Ver se o protocolo é diferente e se respeita o RES, depois subir.

library(googlesheets)
library(tidyverse)
library(tidyr)
library(janitor)
library(xlsx)
library(googledrive)

gs_ls() 

lucas_sheet <- gs_title("lucas_cgu")
lucas_cgu <- gs_read(lucas_sheet) %>%
  mutate(protocolo = as.character(protocolo))

liz_sheet <- gs_title("lizandra_cgu")
liz_cgu <- gs_read(liz_sheet) %>%
  mutate(protocolo = as.character(protocolo))

ana_sheet <- gs_title("ana_cgu")
ana_cgu <- gs_read(ana_sheet)  %>%
  mutate(protocolo = as.character(protocolo))

jose_cgu <- gs_title("jose_cgu_1206")
jose_cgu <- gs_read(jose_cgu) 

jose_cgu <- jose_cgu %>%
  mutate(protocolo = as.character(protocolo))

comp_ana_cgu <- ana_cgu %>%
filter(!grepl("&lt", resposta ),
       !grepl("p&gt", resposta),
       !grepl("span style=", resposta),
       !grepl("&quot", resposta),
       !grepl("line-height:", resposta), 
       !grepl("&gt", resposta),
       !grepl("&amp", resposta),
       !grepl("span&gt", resposta),
       !grepl("p class=", resposta),
       !grepl("MsoNormal", resposta), 
       !grepl("text-align", resposta),
       !grepl("nbsp", resposta), 
       !grepl("<br>", resposta))

comp_lucas_cgu <- lucas_cgu %>%
  filter(!grepl("&lt", resposta ),
         !grepl("p&gt", resposta),
         !grepl("span style=", resposta),
         !grepl("&quot", resposta),
         !grepl("line-height:", resposta), 
         !grepl("&gt", resposta),
         !grepl("&amp", resposta),
         !grepl("span&gt", resposta),
         !grepl("p class=", resposta),
         !grepl("MsoNormal", resposta), 
         !grepl("text-align", resposta),
         !grepl("nbsp", resposta), 
         !grepl("<br>", resposta)) %>%
  mutate(responsavel = "Lucas")

comp_jose_cgu <- jose_cgu %>%
  filter(!grepl("&lt", resposta ),
         !grepl("p&gt", resposta),
         !grepl("span style=", resposta),
         !grepl("&quot", resposta),
         !grepl("line-height:", resposta), 
         !grepl("&gt", resposta),
         !grepl("&amp", resposta),
         !grepl("span&gt", resposta),
         !grepl("p class=", resposta),
         !grepl("MsoNormal", resposta), 
         !grepl("text-align", resposta),
         !grepl("nbsp", resposta), 
         !grepl("<br>", resposta))

comp_liz_cgu <- liz_cgu %>%
  filter(!grepl("&lt", resposta ),
         !grepl("p&gt", resposta),
         !grepl("span style=", resposta),
         !grepl("&quot", resposta),
         !grepl("line-height:", resposta), 
         !grepl("&gt", resposta),
         !grepl("&amp", resposta),
         !grepl("span&gt", resposta),
         !grepl("p class=", resposta),
         !grepl("MsoNormal", resposta), 
         !grepl("text-align", resposta),
         !grepl("nbsp", resposta), 
         !grepl("<br>", resposta))

res_comp <- comp_ana_cgu %>%
  bind_rows(comp_jose_cgu, comp_liz_cgu, comp_lucas_cgu) %>%
  select(tipo_destino, responsavel) %>%
  group_by(tipo_destino, responsavel) %>%
  summarise(pedidos_prontos = n()) %>%
  spread(responsavel, pedidos_prontos) %>%
  clean_names() %>%
  left_join(res1, by = c("tipo_destino" = "destino1")) %>%
  mutate(ana_restante = ana.y - ana.x,
         lucas_restante = lucas.y - lucas.x,
         lucas_restante = ifelse(lucas_restante < 0, 0, lucas_restante),
         jose_restante = jose.y - jose.x,
         jose_restante = ifelse(is.na(jose_restante), 0, jose_restante),
         lizandra_restante = liz - lizandra,
         total_restante = (ana_restante +
                             lucas_restante +
                             lizandra_restante +
                             jose_restante),
         total_restante = ifelse(is.na(total_restante), 0, total_restante)) %>%
         select(tipo_destino, total, amostra_ampliada, amostra_simples, ana_restante,
         lucas_restante, lizandra_restante, jose_restante,total_restante)


# Vou gerar uma nova amostra ampliada para dar anti-join em tudo e ai
# gerar as planilhas complementares

load("base_cgu_completa.Rdata")

base_cgu_completa1 <- base_cgu_completa %>%
  mutate(destino1 = ifelse(grepl("Ag[êe]ncia|CVM", destino), "agencia", destino),
         destino1 = ifelse(grepl("Banco|Caixa|BB", destino), "bancos", destino1),
         destino1 = ifelse(grepl("Pesquisas", destino), "Institutos de pesquisas", destino1),
         destino1 = ifelse(grepl("Universidade", destino), "universidades", destino1),
         destino1 = ifelse(grepl("Museu", destino), "museus", destino1),
         destino1 = ifelse(grepl("Empresa|BR[ÁA]S|Companhia|FURNAS|S.A.|Ltda", destino),
                           "estatal", destino1),
         destino1 = ifelse(grepl("Instituto Federal|Centro Federal|CP II", destino), "escolas técnicas e CPII", destino1),
         destino1 = ifelse(grepl("Hospital|Maternidade", destino), "hospitais", destino1),
         destino1 = ifelse(grepl("Instituto", destino), "institutos", destino1),
         destino1 = ifelse(grepl("Centro de Tecnolo", destino), "centros de tecnologia", destino1),
         destino1 = ifelse(grepl("Superintendência", destino), "superintendencias", destino1))

base_cgu_completa1 <- base_cgu_completa1 %>%
  group_by(destino1) %>%
  mutate(total= n()) %>%
  ungroup() %>%
  mutate(destino1 = ifelse(grepl("Laboratório", destino), "laboratorios", destino1),
         destino1 = ifelse(grepl("Ministério", destino) & total < 300, "Ministérios menores", destino1),
         destino1 = ifelse(grepl("Secretaria de", destino) & total < 300, "Secretarias menores", destino1),
         destino1 = ifelse(grepl("Fundação", destino) & total < 300, "Fundações menores", destino1)) %>%
  group_by(destino1) %>%
  mutate(total= n()) %>%
  ungroup() %>%
  mutate(destino1 = ifelse(total < 150, "outros", destino1)) %>%
  rename(tipo_destino = destino1)

base_cgu_completa2 <- base_cgu_completa1 %>%
  anti_join(liz_cgu, by="protocolo") %>%
  anti_join(lucas_cgu, by="protocolo") %>%
  anti_join(jose_cgu, by="protocolo") %>%
  anti_join(ana_cgu, by="protocolo") %>%
  filter(!grepl("&lt", resposta ),
         !grepl("p&gt", resposta),
         !grepl("span style=", resposta),
         !grepl("&quot", resposta),
         !grepl("line-height:", resposta), 
         !grepl("&gt", resposta),
         !grepl("&amp", resposta),
         !grepl("span&gt", resposta),
         !grepl("p class=", resposta),
         !grepl("MsoNormal", resposta), 
         !grepl("text-align", resposta),
         !grepl("nbsp", resposta), 
         !grepl("<br>", resposta))

## Planilhas dos colegas

gerar_planilha_2 <- function(base, amostra) {
  stopifnot(require(purrr))
  
  minha_amostra <- base %>%
    split(.$tipo_destino) %>%
    map2(amostra, sample_n)
  
  reultado <- bind_rows(minha_amostra)
  
}

# As amostras nào podem ter zeros.

am_lucas <- res_comp$lucas_restante
lucas_cgu2 <- gerar_planilha_2(base_cgu_completa2,am_lucas )

base_3 <- base_cgu_completa2 %>%
  anti_join(lucas_cgu2, by="protocolo") 

am_liz <- res_comp$lizandra_restante
lizandra_cgu2 <- gerar_planilha_2(base_3, am_liz)

base_4 <- base_3 %>%
  anti_join(lizandra_cgu2, by="protocolo") 

am_ana <- res_comp$ana_restante
ana_cgu2 <- gerar_planilha_2(base_4, am_ana)

base_5 <- base_4 %>%
  anti_join(ana_cgu2, by="protocolo")

am_jose <- res_comp$jose_restante
jose_cgu2 <- gerar_planilha_2(base_5, am_jose)

setwd("C:\\Users\\jvoig\\OneDrive\\Documentos\\cgu_colab")

save(ana_cgu2, file="ana_cgu2.Rdata")
save(lizandra_cgu2, file="lizandra_cgu2.Rdata")
save(lucas_cgu2, file="lucas_cgu2.Rdata")
save(jose_cgu2, file="jose_cgu2.Rdata")

write.xlsx(as.data.frame(lizandra_cgu2), 
           file="lizandra_cgu2.xlsx", sheetName="lizandra_cgu2",
           col.names=TRUE, row.names=FALSE, append=FALSE, showNA=FALSE)

gs_ls() 

lizandra_sheet <- drive_upload("lizandra_cgu2.xlsx",
                               path="~/TB/achados e pedidos/Bases_classificação/COLAB/Lizandra Aguiar Pinto de Oliveira/",
                               name = "lizandra_cgu2",
                               type = "spreadsheet")

write.xlsx(as.data.frame(ana_cgu2), 
           file="ana_cgu2.xlsx", sheetName="ana_cgu2",
           col.names=TRUE, row.names=FALSE, append=FALSE, showNA=FALSE)

ana_sheet <- drive_upload("ana_cgu2.xlsx",
                               path="~/TB/achados e pedidos/Bases_classificação/COLAB/Ana Alini Lins/",
                               name = "ana_cgu2",
                               type = "spreadsheet")

write.xlsx(as.data.frame(lucas_cgu2), 
           file="lucas_cgu2.xlsx", sheetName="lucas_cgu2",
           col.names=TRUE, row.names=FALSE, append=FALSE, showNA=FALSE)

lucas_sheet <- drive_upload("lucas_cgu2.xlsx",
                            path="~/TB/achados e pedidos/Bases_classificação/COLAB/Lucas Alves/",
                            name = "lucas_cgu2",
                            type = "spreadsheet")

write.xlsx(as.data.frame(jose_cgu2), 
           file="jose_cgu2.xlsx", sheetName="jose_cgu2",
           col.names=TRUE, row.names=FALSE, append=FALSE, showNA=FALSE)

jose_sheet <- drive_upload("jose_cgu2.xlsx",
                           path="~/TB/achados e pedidos/Bases_classificação/COLAB/Jose Vitor da Silva",
                           name = "jose_cgu2",
                           type = "spreadsheet")
