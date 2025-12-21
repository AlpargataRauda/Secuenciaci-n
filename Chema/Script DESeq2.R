library(DESeq2)
library(tximport)
library(dplyr)
library(rtracklayer)
library(ggplot2)
library(EnhancedVolcano)
library(ComplexHeatmap)
library(pheatmap)
library(patchwork)
library(vsn)

# Importante: Antes de empezar a correr el script cambiar los nombres de los quant.sf por {nombre_del_simpson}_quant.sf, ejemplo: AbrahamSimpson_quant.sf

setwd("C:/Users/chema/Desktop/Master bioinformatica/Secuenciación y Ómicas de Próxima Generación/Actividad 2/mubio03_act2/")

files <- list.files(path = "Cuantificación/", 
                    pattern = ".sf", full.names = TRUE, recursive = TRUE)

temp <- files[2]
files[2] <- files[3]
files[3] <- temp

# Hacemos una lista con los archivos quant.sf para importarlos, para que los archivos estén agrupados como normopeso y sobrepeso intercambiamos a algunos componentes de los grupos.

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

condition <- c("Sobrepeso/Obeso1","Sobrepeso/Obeso1","Normopeso", "Normopeso", "Normopeso")

# Nos basamos en el excel Design.csv para escribir una lista de condiciones de cada simpson con el que estamos trabajando, como el nombre de las columnas estánescritos en orden alfabético, nuestras condiciones tienen que seguir ese orden,por lo tanto no nos sirve llamar al csv sin mas.

meta<- data.frame(condition)

rownames(meta)<- colnames(txi.salmon$counts)

# Metemos en el data.frame meta la lista de condiciones que hemos creado y el nombre de las columnas ordenadas de txi.salmon, obteniendo un data.frameque nos relaciona cada Simpson con su condicion.

dds <- DESeqDataSetFromTximport(txi.salmon, meta, ~ condition)

# Usamos este data.frame para hacer un DESeq según la variable condición para importar la información necesaria para hacer un DESeq de la lista de txi.salmon.

dds <- DESeq(dds)

res <- results(dds, contrast = c("condition", "Normopeso", "Sobrepeso/Obeso1"))

res

# Creamos 2 variables, una que guardará los resultados del DESeq y otra que guardará los mismo resultados pero contrastando con la condición de sobrepeso y normopeso.

vsd <- varianceStabilizingTransformation(dds, blind=FALSE)
rld <- rlog(dds, blind=FALSE)
head(assay(vsd), 3)

# Transformamos los valores a analizar.

ntd <- normTransform(dds)

meanSdPlot(assay(ntd))

select <- order(rowMeans(counts(dds,normalized=TRUE)),
                decreasing=TRUE)[1:20]
df <- as.data.frame(colData(dds)[,"condition"])

row.names(df) <- colnames(ntd)

pheatmap(assay(dds)[select,], cluster_rows=TRUE, show_rownames=TRUE,
         cluster_cols=FALSE, annotation_col=df)

# Seleccionamos alrededor de 20 de los genes que más diferencia tienen y los corremos el heatmap.

sig.genes <- rownames(res)[which(res$padj< 0.05)]
sig.genes


res$padj
# Para ver si hay diferencias significativas entre los individuos normopeso y sobrepeso usaremos aquellos genes cuyo p-valor ajustado sea menor a 0.05.

plotPCA(rld, intgroup="condition") + 
  ggtitle("PCA: Obesos vs Control") + 
  theme_minimal()

# PCA del grupo de Normopeso vs Sobrepeso

resOrdered <- res[order(res$padj),]
res_df <- as.data.frame(resOrdered)
res_df$Significativo <- res_df$padj < 0.05 & abs(res_df$log2FoldChange) > 1

ggplot(res_df, aes(x = log2FoldChange, y = -log10(padj))) +
  geom_point(aes(colour = Significativo), alpha = 0.6) +
  scale_color_manual(values = c("grey", "red")) +
  theme_minimal() +
  ggtitle("Volcano Plot: Genes de Obesidad") +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed")

# Volcano Plot
