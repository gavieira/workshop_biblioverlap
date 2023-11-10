################## biblioverlap workshop - CLI #########################

##Carregando pacotes
library(biblioverlap)
library(dplyr)


##Checando a documentação da função principal do pacote
?biblioverlap


##Importando os datasets para dentro do R
biochemistry <- read.csv('lens_data/biochemistry-br-22.csv', sep = ',', check.names = FALSE)
genetics <- read.csv('lens_data/genetics-br-22.csv', sep = ',', check.names = FALSE)
zoology <- read.csv('lens_data/zoology-br-22.csv', sep = ',', check.names = FALSE)


##Gerando a lista (nomeada) que servirá de entrada para a função principal
db_list <- list(Biochemistry = biochemistry,
                Genetics = genetics,
                Zoology = zoology)


##Lista de nomes das colunas para estabelecer sobreposição
column_names <- list(DI = 'DOI',
                        TI = 'Title',
                        PY = 'Publication Year',
                        AU = 'Author/s',
                        SO = 'Source Title')


##Identificando documentos sobrepostos
results <- biblioverlap(db_list, matching_fields = column_names)


##Checando o conteúdo dos resultados
View(results$db_list)
View(results$db_list$Biochemistry)
View(results$summary)


##Gráficos
plot_matching_summary(results$summary)
plot_venn(results$db_list)
plot_upset(results$db_list)


##Usando outros campos para fazer gráficos de sobreposição de documentos
#Docs em acesso aberto
open_access <- lapply(results$db_list, function(db) {
  filter(db, `Is Open Access` == 'true')
})
plot_venn(open_access)

#Docs com 10 ou mais citações
i10_docs <- lapply(results$db_list, function(db) {
  filter(db, `Citing Works Count` >= 10)
})
plot_venn(i10_docs)

#Preprints
preprints <- lapply(results$db_list, function(db) {
  filter(db, `Publication Type` == 'preprint')
})
plot_venn(preprints)
