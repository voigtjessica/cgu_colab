library(XML)
library(tm)
library(SnowballC)
library(dplyr)
library(seqinr)
library(RTextTools)
library(topicmodels)
library(data.table)
library(devtools)
#devtools::install_github("sfirke/janitor")
library(janitor)
# devtools::install_github("mgaldino/tbaep")
library(tbaep)
library(googlesheets)
library(purrr)

setwd("C:\\Users\\jvoig\\OneDrive\\Documentos\\colab_tb")

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
  mutate(destino1 = ifelse(total < 150, "outros", destino1))


x <- base_cgu_completa1 %>%
  group_by(destino1) %>%
  summarise(p=n())
setwd("C:\\Users\\mgaldino\\2018\\Achados e Pedidos\\LDa Executivo")
load("base_cgu_completa_v2.Rdata")

res <- base_cgu_completa1 %>%
  group_by(destino1) %>%
  summarise(total = n(),
            amostra_simples = round(total*0.0387551, 0),
            amostra_ampliada = round(total*0.05382653, 0))

View(res)

# 

res %>%
  summarise(sum(total), sum(amostra_simples))

amosta_simples <- res$amostra_simples
amostra_ampliada <- res$amostra_ampliada

gerar_planilha_1 <- function(base, amostra) {
  stopifnot(require(purrr))
  
  minha_amostra <- base %>%
    split(.$destino1) %>%
    map2(amostra, sample_n)
  
  reultado <- bind_rows(minha_amostra)
  
}

amostra_ampliada_final <- gerar_planilha_1(base_cgu_completa1, amostra_ampliada)

x <- amostra_ampliada_final %>%
  group_by(destino1)%>%
  summarise(p=n()) %>%
  left_join(res, by=c("destino1")) %>%
  select(destino1, p, amostra_ampliada)

amostra_simples_final <- gerar_planilha_1(amostra_ampliada_final, amosta_simples)


x <- amostra_simples_final %>%
  group_by(destino1)%>%
  summarise(p=n()) %>%
  left_join(res, by=c("destino1")) %>%
  select(destino1, p, amostra_simples)

#Deu certo =D
# Agora vou gerar a amostra complementar:
# Amostra_ampliada = Amostra_simples + Amostra_comp

amostra_comp_final <- amostra_ampliada_final %>%
  anti_join(amostra_simples_final, by="protocolo")

#Done. Vou salvar os arquivos para não dar problema:

setwd("C:\\Users\\jvoig\\OneDrive\\Documentos\\cgu_colab")
save(amostra_ampliada_final, file="amostra_ampliada_final.Rdata")
save(amostra_simples_final, file="amostra_simples_final.Rdata")
save(amostra_comp_final, file="amostra_comp_final.Rdata")
