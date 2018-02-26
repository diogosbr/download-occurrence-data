#####################################################################
#         ROTINA PARA BAIXAR DADOS DE OCORRÊNCIA DO GBIF E          # 
#         CONFERENCIA DE SINÔNIMOS NO SITE DO FLORA 2020            #
#####################################################################

#######################################################################
#                                                                     #
#         ROTINA PARA:                                                #
#         - BAIXAR DADOS DE OCORRÊNCIA DO GBIF;                       # 
#         - CONFERENCIA DE SINÔNIMOS NO SITE DO FLORA 2020            #
#         - VERIFICAR PONTOS FORA DO MUNICÍPIO DE COLETA;             #
#         - VERIFICAR SE AS COORDENADAS ESTÃO INVERTIDAS (lon e lat)  #
#                                                                     #
#                 versão 1.1.4                                        #
#######################################################################

#Elaborado por:
#Diogo S. B. Rocha (diogosbr@gmail.com) 
#26/02/2018


#instalando pacotes, se for necessário
packages = c("dismo", "raster", "maptools", "flora", "devtools")
for (p in setdiff(packages, installed.packages()[, "Package"])) { install.packages(p, dependencies = T)}


#baixar dados de ocorrência do GBIF pelo pacote dismo
species=dismo::gbif("Euterpe edulis")

#verificar quais dados a espécie tem
names(species)

#selecionando as colunas de interesse
species.sel=species[,c("species","lon","lat", "municipality", "adm1")]

#excluíndo os registros que não tem longitude e latitude
species.sel=na.exclude(species.sel)

#número de registros com coordenadas
dim(species.sel)[1]

#visualizando os 10 primeiro registros
head(species.sel,10)

#plotando os registros para visualização
raster::plot(dismo::gbif("Euterpe edulis", sp = T), col = "red", pch = 19)
data(wrld_simpl, package = "maptools")
raster::plot(wrld_simpl, add=T)

#conferindo no Flora 2020
#uma espécie
flora::get.taxa(unique(species.sel$species))

#várias espécies 
ex=c("Manilkara maxima", "Eutepe edulis", "Caesalpinea echinata")
ex.res=flora::get.taxa(ex)

head(ex.res)


#############
## Filtros ##
#############

#instalando pacote 'spfilt' 
devtools::install_github("diogosbr/spfilt")

#carregando pacote
require(spfilt)

#Carregando a planilha com os registros
# Planilha de exeplo pode ser encontrada em https://github.com/diogosbr/download-occurrence-data/blob/master/exemplo.csv
exemplo = read.table("https://raw.githubusercontent.com/diogosbr/download-occurrence-data/master/exemplo.csv", h = T, sep = ";")

#verificando os nomes das colunas
names(exemplo)

#excluíndo os registros sem coordenadas
exemplo.sel = na.exclude(exemplo)

#visualizando os 6 primeiros registros 
head(exemplo.sel)

#indica quais são os registros que as cooredenas estão fora do municipio informado, registros fora do Brasil e se lon e lat estão invertidas
exemplo.filt = filt(exemplo.sel)

#os 6 primeiros registros 
head(exemplo.filt)

#verificando status 
table(exemplo.filt$status)

#selecionando apenas os registros com staus Ok e as colunas de lon e lat
filtrados = exemplo.filt[exemplo.filt$status=="Ok",c('lon','lat')]

#plotando os registros para visualização
raster::plot(filtrados, col = "red", pch = 19)
data(wrld_simpl, package = "maptools")
raster::plot(wrld_simpl, add=T)



#####EXCLUIR ????

##--------##
## Extra ##
##-------##
#buscar status de ameaça indicado pelo CNCFlora

#lendo uma lista de espécies 
ex=c("Manilkara maxima", "Eutepe edulis", "Caesalpinea echinata")

ex.res=flora::get.taxa(ex)[, c("scientific.name", "threat.status")]

head(ex.res)