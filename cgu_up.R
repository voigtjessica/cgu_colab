#CGU-UP

#Vou puxar tudo da CGU um nivel acima e salvar no próprio HD externo

# Tutorial: https://www.r-bloggers.com/copying-files-with-r/
# Outro arquivo que eu faço algo parecido: cgu_split


#pasta ministérios:

pasta_fonte <- "F:/e-SIC - anexos - Julho de 2015 e abril de 2017"
ministerios <- list.files(pasta_fonte) 

#olhe dentro da pasta ministerios e me traga o que há dentro de cada um dele: 

for(i in seq_along(ministerios)){ 
  print(i)
  pasta_ministerios <- paste(pasta_fonte, ministerios[i], sep="/")
  pasta_protocolos <- list.files(pasta_ministerios)
  
  for(p in seq_along(pasta_protocolos)) { 
    
    pasta_a_copiar <- paste(pasta_ministerios, pasta_protocolos[p], sep="/" )
    
    pasta_destino <- paste("C:/Users/jvoig/Documents/arquivos_ftp", pasta_protocolos[p], sep="/")
    #cria o diretório se ele não existe:
    
    ifelse(!dir.exists(pasta_destino), 
           dir.create(pasta_destino, recursive=TRUE), FALSE)
    
    # Copia o que está dentro da pasta do protocolo e cola na pasta destino:
    arquivos <- list.files(pasta_a_copiar)
    
    file.copy(file.path(pasta_a_copiar,arquivos)
              , pasta_destino, overwrite = F)
    
  }}


# Deu certo, to emocionada