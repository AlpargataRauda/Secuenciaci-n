library(DESeq2)
library(tximport)
library(dplyr)
library(rtracklayer)

files <- list.files(path = "Cuantificación/", 
                    pattern = ".sf", full.names = TRUE, recursive = TRUE)

files

# Hacemos una lista con los archivos quant.sf para importarlos.

tx2gene <- read.table("TallerGrupal_Ficheros/Transcrito_a_Gen.tsv")

tx2gene<- as.data.frame(tx2gene)

# Importamos el archivo Transcrito_a_Gen.tvs del fichero TallerGrupal_Ficherso

txi.salmon <- tximport(files, type = "salmon", tx2gene = tx2gene)

# Usando el archivo Transcrito_a_Gen.tvs que nos relaciona los transcritos y los genes, y usando los archivos quant.sf que muestran el número de lecturas, longitud y abundancia de dichos transcritos crearemos una lista de data.frames que relacione el número de lecturas, abundancia y longitud de cada gen.

files <- stringr::str_split(files, pattern = "/", simplify = TRUE)
  
files[,3] <- files[,3] %>% stringr::str_replace("_quant.sf", "")

# Una vez hemos usado la variable files para relacionar transcritos y genes usamos esta variable para cambiar el nombre de las columnas de los data.framesde la lista txi.salmon de forma ordenada, en nuestro caso tras cortar por las "/"vemos que la 3a columna corresponde con los nombres de los simpson a estudiar.

Simpsons <- files[,3]
colnames(txi.salmon$counts) <- Simpsons
colnames(txi.salmon$abundance) <- Simpsons
colnames(txi.salmon$length) <- Simpsons

# Cambiamos el nombre a las columnas

condition <- c("Sobrepeso/Obeso1", "Normopeso", "Sobrepeso/Obeso1", "Normopeso", "Normopeso")

# Nos basamos en el excel Design.csv para escribir una lista de condiciones de cada simpson con el que estamos trabajando, como el nombre de las columnas estánescritos en orden alfabético, nuestras condiciones tienen que seguir ese orden,por lo tanto no nos sirve llamar al csv sin mas.

meta<- data.frame(condition)

rownames(meta)<- colnames(txi.salmon$counts)

# Metemos en el data.frame meta la lista de condiciones que hemos creado y el nombre de las columnas ordenadas de txi.salmon, obteniendo un data.frameque nos relaciona cada Simpson con su condicion.

dds <- DESeqDataSetFromTximport(txi.salmon, meta, ~ condition)

# Usamos este data.frame para hacer un DESeq según la variable condición para importar la información necesaria para hacer un DESeq de la lista de txi.salmon.

dds$condition <- relevel(dds$condition, ref = "Sobrepeso/Obeso1")

dds <- DESeq(dds)

res <- results(dds, contrast = c("condition", "Sobrepeso/Obeso1", "Normopeso"))

res

# Usando como factor de referencia la condicion de Sobrepeso, haremos el DESeq delos datos obtenidos de salmon, indicaremos que nos haga un contraste con las condiciones, la condicion de Sobrepeso y la condición de Normopeso.
