#####################################################################
#         ROTINA PARA BAIXAR DADOS DE OCORRÊNCIA DO GBIF E          # 
#         CONFERENCIA DE SINÔNIMOS NO SITE DO FLORA 2020            #
#####################################################################

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

#Obtendo coordenadas da espécie/grupo de interesse
tapirira = dismo::gbif("Tapirira guianensis")

#selecionando as colunas
tapirira.sel = mani[,c("species","lon","lat", "municipality", "adm1")]

#excluíndo os registros sem coordenadas
tapirira.sel = na.exclude(tapirira.sel)

tapirira.sel

head(tapirira.sel)

rm_accent(tapirira.sel$municipality)

filt(tapirira.sel)

