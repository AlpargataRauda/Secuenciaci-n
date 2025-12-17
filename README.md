# Secuenciación

Versión linux

Requisitos previos: Tener instalado conda para linux en la consola wsl.

## #1 Me pongo en mi directorio de trabajo con:

cd /mnt/c/Users/chema/Desktop/Master bioinformatica/Secuenciación y Ómicas de Próxima Generación/Actividad 2/mubio03_act2

## #2 Aquí creo mi entorno con los programas fastqc fastp y multiqc para usarlos en este entorno usando:

conda create -n actividad2 -c bioconda -c conda-forge -c defaults -c r fastqc fastp multiqc bwa samtools=1.19 unicycler htslib openjdk=17 bandage quast qualimap prokka

## #3 Y nos metemos al entorno con: 

conda activate actividad2

## #4 Creamos las carpetas /Quality/Raw,/Quality/Filtered y la carpeta /Trimmed usando el código:
  
mkdir -p Quality/Raw Quality/Filtered Trimmed

## #5 Nos disponemos a hacer el control de calidad de las secuencias y metemos el resultado en la carpeta /Quality/Raw, para ello seleccionamos los ficheros fastq.gz que hay en la carpeta Fastqs y usamos el código:

fastqc TallerGrupal_Ficheros/Fastqs/*fastq.gz -o Quality/Raw -t 32

## #6 Para hacer el control de calidad mediante el programa fastq usamos el siguiente código y metemos el resultado en /Trimmed. Para ello necesitamos los archivos R1 y R2 de cada Simpson, y como adaptador usaremos la opción --adapter_fasta y usaremos el archivo Referencia.fasta que tenemos en la carpeta del TallerGrupal_Ficheros. (se puede hacer por bucle uno a uno pero de momento no se como hacer esto en linux)

fastp --in1 TallerGrupal_Ficheros/Fastqs/AbrahamSimpson_R1.fastq.gz --in2 TallerGrupal_Ficheros/Fastqs/AbrahamSimpson_R2.fastq.gz --out1 Trimmed/AbrahamSimpson_R1_filtered.fastq.gz --out2 Trimmed/AbrahamSimpson_R2_filtered.fastq.gz --adapter_fasta TallerGrupal_Ficheros/Referencia.fasta --cut_front --cut_tail --cut_window_size 12 --cut_mean_quality 20 --length_required 35 --json Trimmed/AbrahamSimpson.json --html Trimmed/AbrahamSimpson.html --thread 32

fastp --in1 TallerGrupal_Ficheros/Fastqs/HomerSimpson_R1.fastq.gz --in2 TallerGrupal_Ficheros/Fastqs/HomerSimpson_R2.fastq.gz --out1 Trimmed/HomerSimpson_R1_filtered.fastq.gz --out2 Trimmed/HomerSimpson_R2_filtered.fastq.gz --adapter_fasta TallerGrupal_Ficheros/Referencia.fasta --cut_front --cut_tail --cut_window_size 12 --cut_mean_quality 20 --length_required 35 --json Trimmed/HomerSimpson.json --html Trimmed/HomerSimpson.html --thread 32

fastp --in1 TallerGrupal_Ficheros/Fastqs/BartSimpson_R1.fastq.gz --in2 TallerGrupal_Ficheros/Fastqs/BartSimpson_R2.fastq.gz --out1 Trimmed/BartSimpson_R1_filtered.fastq.gz --out2 Trimmed/BartSimpson_R2_filtered.fastq.gz --adapter_fasta TallerGrupal_Ficheros/Referencia.fasta --cut_front --cut_tail --cut_window_size 12 --cut_mean_quality 20 --length_required 35 --json Trimmed/BartSimpson.json --html Trimmed/BartSimpson.html --thread 32

fastp --in1 TallerGrupal_Ficheros/Fastqs/LisaSimpson_R1.fastq.gz --in2 TallerGrupal_Ficheros/Fastqs/LisaSimpson_R2.fastq.gz --out1 Trimmed/LisaSimpson_R1_filtered.fastq.gz --out2 Trimmed/LisaSimpson_R2_filtered.fastq.gz --adapter_fasta TallerGrupal_Ficheros/Referencia.fasta --cut_front --cut_tail --cut_window_size 12 --cut_mean_quality 20 --length_required 35 --json Trimmed/LisaSimpson.json --html Trimmed/LisaSimpson.html --thread 32

fastp --in1 TallerGrupal_Ficheros/Fastqs/MaggieSimpson_R1.fastq.gz --in2 TallerGrupal_Ficheros/Fastqs/MaggieSimpson_R2.fastq.gz --out1 Trimmed/MaggieSimpson_R1_filtered.fastq.gz --out2 Trimmed/MaggieSimpson_R2_filtered.fastq.gz --adapter_fasta TallerGrupal_Ficheros/Referencia.fasta --cut_front --cut_tail --cut_window_size 12 --cut_mean_quality 20 --length_required 35 --json Trimmed/MaggieSimpson.json --html Trimmed/MaggieSimpson.html --thread 32

## #7 Una vez tenemos los archivos filtrados mediante fastp, usamos de nuevo fastqc para guardar en Quality/Filtered/ los archivos filtrados.

fastqc Trimmed/*fastq.gz -o Quality/Filtered/ --threads 32

## #8 Ahora podemos usar multiqc para analizar todo lo que hemos estado haciendo hasta ahora en la carpeta en la que nos encontramos (mubio03_act2), incluyendo las carpetas que tenemos dentro de esta.

multiqc .

## #9 Instalamos salmon usando el codigo:

conda install bioconda::salmon

## #10 Saldremos del entorno virtual con un:

conda deactivate

## #11 Nos aseguraremos que la versión de salmon es la correcta, la correcta es la 1.10, usaremos:

salmon --version

## #12 Una vez tengamos la versión correcta de salmon, crearemos un nuevo entorno virtual que permita usar también las herramientas de salmon con:

conda create -n actividad2.1 -c bioconda -c conda-forge -c defaults -c r fastqc fastp multiqc bwa salmon samtools=1.19 unicycler htslib openjdk=17 bandage quast qualimap prokka

## #13 Activamos el entorno:

conda activate actividad2.1

## #14 Creamos las carpetas Cuantificación e Indexado/ con:

mkdir Cuantificación/ Indexado/

## #15 Primero nos encargaremos de hacer un index con:

salmon index -t TallerGrupal_Ficheros/Referencia.fasta -i Indexado/
  
## #16 Despues nos haremos la pseudocuantificación de cada personaje uno a uno con:
  
salmon quant -i Indexado/ -l A -1 Trimmed/AbrahamSimpson_R1_filtered.fastq.gz -2 Trimmed/AbrahamSimpson_R2_filtered.fastq.gz -o Cuantificación/AbrahamSimpson_quantified

salmon quant -i Indexado/ -l A -1 Trimmed/HomerSimpson_R1_filtered.fastq.gz -2 Trimmed/HomerSimpson_R2_filtered.fastq.gz -o Cuantificación/HomerSimpson_quantified

salmon quant -i Indexado/ -l A -1 Trimmed/BartSimpson_R1_filtered.fastq.gz -2 Trimmed/BartSimpson_R2_filtered.fastq.gz -o Cuantificación/BartSimpson_quantified

salmon quant -i Indexado/ -l A -1 Trimmed/LisaSimpson_R1_filtered.fastq.gz -2 Trimmed/LisaSimpson_R2_filtered.fastq.gz -o Cuantificación/LisaSimpson_quantified

salmon quant -i Indexado/ -l A -1 Trimmed/MaggieSimpson_R1_filtered.fastq.gz -2 Trimmed/MaggieSimpson_R2_filtered.fastq.gz -o Cuantificación/MaggieSimpson_quantified

## #17 Instalamos DEseq2 en Rstudio usando el código (ojo, hay que tener instalado previamente BiocManager): 

BiocManager::install("DESeq2")
