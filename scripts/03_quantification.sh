#!/bin/bash
# Script: 03_quantification.sh
# Descripción: Cuantificación de expresión con Salmon

mkdir -p results/salmon_quant

echo "Iniciando cuantificación con Salmon..."

for file in results/cleaned_data/*_R1_clean.fastq.gz; do
   
    
    filename=$(basename $file)
    base=${filename%_R1_clean.fastq.gz}
    
    echo "Cuantificando muestra: $base"
    
    salmon quant \
    -i references/salmon_index \
    -l A \
    -1 results/cleaned_data/${base}_R1_clean.fastq.gz \
    -2 results/cleaned_data/${base}_R2_clean.fastq.gz \
    -p 4 \
    --validateMappings \
    -o results/salmon_quant/${base}_quant
    
done

echo "Resultados en results/salmon_quant"
