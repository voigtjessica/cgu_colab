# dando matches no judiciário

library(dplyr)
library(googlesheets)
library(googledrive)

# Objetivos: 
# Pegar os arquivos dos judiciarios
# Substituir os protocolos que tem revisão pelos revisados
# Verificar as datas e consertar.

gs_ls() 

modelo_sheet <- gs_title("jud_final_11062018")
modelo <- gs_read(modelo_sheet)

# jose_jud_sheet <- gs_title("jose_judiciariov2")
# jose_jud <- gs_read(jose_jud_sheet)
# jose_jud_rev_sheet <- gs_title("jose_revisão_judiciário")
# jose_jud_rev <- gs_read(jose_jud_rev_sheet)
# 
# ana_jud_sheet <- gs_title("ana_judiciariov2")
# ana_jud <- gs_read(ana_jud_sheet)
# ana_jud_rev_sheet<- gs_title("ana_revisão_judiciário")
# ana_jud_rev <- gs_read(ana_jud_rev_sheet)
# 
# lucas_jud_sheet <- gs_title("lucas_judiciariov2")
# lucas_jud <- gs_read(lucas_jud_sheet)
# lucas_jud_rev_sheet <- gs_title("lucas_revisão_judiciário")
# lucas_jud_rev <- gs_read(lucas_jud_rev_sheet)
# 
# liz_jud_sheet <- gs_title("lizandra_judiciariov2")
# liz_jud <- gs_read(liz_jud_sheet)
# liz_jud_rev_sheet <- gs_title("lizandra_judNA_revisao")
# liz_jud_rev <- gs_read(liz_jud_rev_sheet)

# Ok importado, vamos juntar os protocolos e substituir o que foi corrigido

# test_equal_var <- function(base1, base2) {
#   
#   x <- names(base1)
#   y <- names(base2)
#   n <- length(x)
#   k <- length(y)
#   
#   teste_nome_igual_x <- numeric()
#   teste_nome_igual_y <- numeric()
#   
#   for ( i in 1:n) {
#     teste_nome_igual_x[i] <- x[i] %in% y
#   }
#   
#   for ( i in 1:k) {
#     teste_nome_igual_y[i] <- y[i] %in% x
#   }
#   resp_x <- paste(x[!as.logical(teste_nome_igual_x)], collapse = ", ")
#   resp_y <- paste(y[!as.logical(teste_nome_igual_y)], collapse = ", ")
#   
#   print(paste("as variáveis em x que não estão em y, são:", resp_x,
#               ". E as variáveris de y que não estão em x, são:", resp_y,
#               sep=" "))
#   
# }
# 
# test_equal_var(ana_jud, jose_jud)
# test_equal_var(liz_jud, jose_jud)
# test_equal_var(lucas_jud, jose_jud)
# 
# ana_rev_fix <- ana_jud_rev %>%
#   select(protocolo, 
#          'novo assunto', 
#          'novo outros', 
#          'base de dados', visto, duplicado, 'complementação') %>%
#   mutate(visto = as.character(visto),
#          duplicado = as.character(duplicado),
#          'complementação' = as.character('complementação'))
# 
# ana_fix <- ana_jud %>%
#   rename(nao_e_pedido_de_informacao = nao_e_pedido_de_info,
#          pedido_pasta_do_anexo_pedido = pasta_do_anexo_pedido,
#          anexo_com_extensao_pedido = nome_do_anexo_pedido,
#          anexo_com_extensao_resposta = nome_do_anexo_resposta,
#          pasta_do_anexo_recurso_1 = pasta_anexo_recurso_1, 
#          anexo_com_extensao_recurso_1 = nome_anexo_recurso_1, 
#          pasta_do_anexo_resposta_recurso_1 = pasta_anexo_resposta_recurso_1, 
#          anexo_com_extensao_resposta_recurso_1 = nome_anexo_resposta_recurso_1, 
#          pasta_do_anexo_recurso_2 = pasta_anexo_recurso_2, 
#          anexo_com_extensao_recurso_2 = nome_anexo_recurso_2) %>%
#   mutate(revisado = NA,
#          protocolo = as.character(protocolo),
#          resposta_recurso_1  = as.character(resposta_recurso_1),
#          data_recurso_1 = NA, # só tem uma entrada de character
#          data_recurso_1 = as.Date(data_recurso_1),
#          data_resposta_recurso_1  = as.Date(data_resposta_recurso_1 ),
#          pasta_do_anexo_recurso_1 = as.character(pasta_do_anexo_recurso_1),
#          resposta_recurso_1 = as.character(resposta_recurso_1),
#          data_resposta_recurso_1 = as.Date(data_resposta_recurso_1),
#          pasta_do_anexo_resposta_recurso_1 = as.character(pasta_do_anexo_resposta_recurso_1),
#          anexo_com_extensao_resposta_recurso_1 = as.character(anexo_com_extensao_resposta_recurso_1),
#          recurso_2 = as.character(recurso_2),
         #data_recurso_2 = as.Date(data_recurso_2),
         #pasta_do_anexo_recurso_2 = as.character(pasta_do_anexo_recurso_2),
         #anexo_com_extensao_recurso_2 = as.character(anexo_com_extensao_recurso_2),
         #resposta_recurso_2 = as.character(resposta_recurso_2),
         #data_resposta_recurso_2 = as.Date(data_resposta_recurso_2),
         #pasta_anexo_resposta_recurso_2 = as.character(pasta_anexo_resposta_recurso_2),
         #nome_anexo_resposta_recurso_2 = as.character(nome_anexo_resposta_recurso_2),
         #revisado = as.character(revisado),
         #pedido_pasta_do_anexo_pedido = as.character(pedido_pasta_do_anexo_pedido),
         #anexo_com_extensao_pedido = as.character(anexo_com_extensao_pedido),
         #       pasta_do_anexo_recurso_1 = as.character(pasta_do_anexo_recurso_1)) %>%
  #   left_join(ana_rev_fix,protocolo)



# test_equal_var(ana_fix, ana_jud_rev)
