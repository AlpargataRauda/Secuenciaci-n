# Actividad Grupal: Análisis de expresión diferencial de genes relacionados con la obesidad mediante RNA-seq

**Asignatura:** Secuenciación y Ómicas de Próxima Generación 
**Máster:** Bioinformática y Bioestadística  
**Grupo:** 10
**Jesús Javier Amat Pamies, José Antonio Celada Guerrero, Fátima Goiri Presmanes, José María Sevilla Avendaño y Judit del Valle Molina**

## Contexto y Objetivos
El objetivo principal de esta actividad ha sido caracterizar la base molecular de un fenotipo de obesidad mediante técnicas de **RNA-seq** buscando variantes de expresión génica que expliquen la alteración en la **homeostasis energética** de los sujetos afectados (obesidad) frente a los normopeso (controles).

La finalidad última es proponer una estrategia de **Nutrición de Precisión**, identificando si el origen del fenotipo es ambiental o genético.

## Diseño del Estudio
Se ha trabajado con 5 muestras biológicas clasificadas en dos condiciones:
* **Grupo Obeso:** AbrahamSimpson, HomerSimpson.
* **Grupo Control:** BartSimpson, LisaSimpson, MaggieSimpson.

## Flujo de Trabajo (Pipeline)

El análisis se ha estructurado en dos fases, combinando el procesamiento en línea de comandos y el análisis estadístico en R.

### 1. Pre-procesamiento y Cuantificación (Bash)
* **Control de Calidad:** Se filtraron las lecturas crudas eliminando aquellas con un *Phred Score* bajo (< Q20) para asegurar la fiabilidad de los datos.
* **Alineamiento y Conteo:** Utilizamos **Salmon** para realizar una cuantificación libre de alineamiento (*alignment-free*), configurando 30 *bootstraps* para estimar la varianza técnica de las muestras.

### 2. Análisis Estadístico y Reducción Dimensional (R)
* **Integración:** Los datos se importaron a nivel de gen mediante `tximport`.
* **Modelo Diferencial:** Se ajustó un modelo lineal generalizado con **DESeq2** (Wald test) para comparar las condiciones, aplicando un filtrado de significancia (p-adj < 0.05).
* **Exploración:** Se aplicaron métodos de reducción dimensional (PCA) sobre los datos transformados con `rlog` para visualizar la agrupación de los **dietotipos** o perfiles de expresión.

## Resultados Clave

El análisis de expresión diferencial ha permitido aislar una firma molecular clara en el grupo obeso:
1.   Se detectó una infraexpresión severa del gen de la leptina (**LEP**) junto con una sobreexpresión compensatoria de su receptor (**LEPR**).
2.   El gen **NTRK2** (receptor TrkB), esencial para la sensación de saciedad en el hipotálamo, aparece silenciado.
3.   El *Heatmap* de los Top 10 genes y el *Volcano Plot* confirman que estos genes son los principales responsables de la varianza biológica entre los grupos.

## Conclusiones
Los resultados apuntan a una **obesidad monogénica** causada por la rotura del eje Adiposo-Cerebral. Los sujetos carecen de los mecanismos moleculares para regular la ingesta.

## Estructura del Repositorio
* **`docs/`**: Documentación del proyecto y guías de referencia.
* **`fastqc_raw/`**: Informes de calidad (*FastQC*) generados a partir de las lecturas crudas.
* **`results/`**: Resultados del análisis, incluyendo tablas de genes diferenciales (`.csv`) y las gráficas generadas (PCA, Heatmap, Volcano Plot).
* **`scripts/`**: Código fuente en R para el análisis diferencial (DESeq2) y scripts de Bash para el pre-procesamiento.
