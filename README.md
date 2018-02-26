## download occurrence data; data cleaning
Script to download occurrence data and apply data cleaning

## Developer ##


- [Diogo S. B Rocha](https://github.com/diogosbr)

## Installation ##
Install dependent packages 


```#instalando pacotes, se for necessário
packages = c("dismo", "raster", "maptools", "flora", "devtools")
for (p in setdiff(packages, installed.packages()[, "Package"])) { install.packages(p, dependencies = T)} #instalando pacote 'spfilt' 
devtools::install_github("diogosbr/spfilt") #carregando pacote
require(spfilt)
```

##Usage
### Baixar registros no GBIF ###

baixar dados de ocorrência do GBIF pelo pacote dismo
`species=dismo::gbif("Euterpe edulis")`

verificar quais dados a espécie
`names(species)`

selecionando as colunas de interesse
`species.sel=species[,c("species","lon","lat", "municipality", "adm1")]`

excluindo os registros que não tem longitude e latitude
`species.sel=na.exclude(species.sel)`

número de registros com coordenadas
`dim(species.sel)[1]`

visualizando os 10 primeiro registros
`head(species.sel,10)`

plotando os registros para visualização
```raster::plot(dismo::gbif("Euterpe edulis", sp = T), col = "red", pch = 19)
data(wrld_simpl, package = "maptools")
plot(wrld_simpl, add=T)```

### Verificar nomes no site FLORA 2020 ###

uma espécie
`flora::get.taxa(unique(species.sel$species))`

várias espécies 
```ex=c("Manilkara maxima", "Eutepe edulis", "Caesalpinea echinata")
ex.res=flora::get.taxa(ex)
head(ex.res)```

### Verificar coordenadas ###
Planilha de exemplo pode ser encontrada em https://github.com/diogosbr/download-occurrence-data/blob/master/exemplo.csv

Carregando a planilha com os registros

```exemplo = read.table("https://raw.githubusercontent.com/diogosbr/download-occurrence-data/master/exemplo.csv", h = T, sep = ";") ```

verificando os nomes das colunas

`names(exemplo)`

excluíndo os registros sem coordenadas

`exemplo.sel = na.exclude(exemplo)`

visualizando os 6 primeiros registros 

```head(exemplo.sel)```

indica quais são os registros que as cooredenas estão fora do municipio informado  e registros fora do Brasil
`exemplo.filt = filt(exemplo.sel)`

os 6 primeiros registros
```head(exemplo.filt)```




