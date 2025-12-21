#!/bin/bash
# Script: 02_trimming.sh
# Descripción: Limpieza con fastp para el Grupo 10

mkdir -p results/cleaned_data results/fastp_reports

echo "Iniciando limpieza de lecturas con fastp..."

# Bucle para procesar cada muestra
for file in data/*_R1.fastq.gz; do
    base=$(basename $file "_R1.fastq.gz")
    echo "Procesando: $base"

    fastp \
    --in1 data/${base}_R1.fastq.gz \
    --in2 data/${base}_R2.fastq.gz \
    --out1 results/cleaned_data/${base}_R1_clean.fastq.gz \
    --out2 results/cleaned_data/${base}_R2_clean.fastq.gz \
    --html results/fastp_reports/${base}_fastp.html \
    --json results/fastp_reports/${base}_fastp.json \
    --detect_adapter_for_pe \
    --qualified_quality_phred 20 \
    --length_required 35 \
    --thread 4
done

echo "Limpieza finalizada"
