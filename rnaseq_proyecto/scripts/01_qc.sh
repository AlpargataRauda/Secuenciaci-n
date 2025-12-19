#!/bin/bash

# Activar el entorno de trabajo
conda activate rnaseq_env

echo "Ejecutando FastQC..."
fastqc data/raw/*.fastq.gz -o results/qc/

echo "Ejecutando MultiQC..."
multiqc results/qc/ -o results/qc/

echo "QC completado."

