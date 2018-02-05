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
#         - vERIFICAR SE AS COORDENADAS ESTÃO INVERTIDAS (lon e lat)  #
#                                                                     #
#                 versão 1.1.3                                        #
#######################################################################

#Elaborado por:
#Diogo S. B. Rocha (diogosbr@gmail.com) 

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
plot(wrld_simpl, add=T)

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

#indica quais são os registros que as cooredenas estão fora do municipio informado  e registros fora do Brasil
exemplo.filt = filt(exemplo.sel)

#os 6 primeiros registros 
head(exemplo.filt)

#verificando status 
table(exemplo.filt$status)


#Verificar se as coordenas estão invertidas

#------------em construção------------#

