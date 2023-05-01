# bf591-final-project-mpeters15
R Shiny application for BF591 final project

# Application URL
The application can be accessed at http://mpeters15.shinyapps.io/bf591-final-project-mpeters15

# Repository contents
```
├── app.R
├── data
├── README.md
├── src
│   ├── server.R
│   ├── ui
│   │   ├── counts_matrix.R
│   │   ├── differential_expression.R
│   │   ├── gene_expression.R
│   │   └── sample_information.R
│   └── ui.R
└── utils
    ├── helper_functions.R
    └── stage_data.R
```

`app.R` contains code needed to start the application.

`./src/ui/` contains code for the tabs used in the application.

`./src/ui.R` sets up the UI element of the application.

`./src/server.R` sets up the server element of the application.

`./utils/helper_functions.R` holds functions used by elements in `server.R`.

`./utils/stage_data.R` prepares the data needed for this application.


# Data sources
## Post-mortem Huntington’s Disease prefrontal cortex compared with neurologically healthy controls

This dataset profiled gene expression with RNASeq in post-mortem human dorsolateral prefrontal cortex from patients who died from Huntington’s Disease and age- and sex-matched neurologically healthy controls.

### Citations
- Labadorf A, Hoss AG, Lagomarsino V, Latourelle JC et al. RNA Sequence Analysis of Human Huntington Disease Brain Reveals an Extensive Increase in Inflammatory and Developmental Gene Expression. PLoS One 2015;10(12):e0143563. PMID: 26636579
- Labadorf A, Choi SH, Myers RH. Evidence for a Pan-Neurodegenerative Disease Response in Huntington's and Parkinson's Disease Expression Profiles. Front Mol Neurosci 2017;10:430. PMID: 29375298
- Agus F, Crespo D, Myers RH, Labadorf A. The caudate nucleus undergoes dramatic and unique transcriptional changes in human prodromal Huntington's disease brain. BMC Med Genomics 2019 Oct 16;12(1):137. PMID: 31619230

### Data downloads
| Supplementary File                                                | Download Link                                                                                                                                                |
|-------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| GSE64810_series_matrix.txt.gz                                     | [(ftp)](https://ftp.ncbi.nlm.nih.gov/geo/series/GSE64nnn/GSE64810/matrix/GSE64810_series_matrix.txt.gz)                                                               |
| GSE64810_mlhd_DESeq2_diffexp_DESeq2_outlier_trimmed_adjust.txt.gz | [(ftp)](https://ftp.ncbi.nlm.nih.gov/geo/series/GSE64nnn/GSE64810/suppl/GSE64810_mlhd_DESeq2_norm_counts_adjust.txt.gz) |
| GSE64810_mlhd_DESeq2_norm_counts_adjust.txt.gz                    | [(ftp)](https://ftp.ncbi.nlm.nih.gov/geo/series/GSE64nnn/GSE64810/suppl/GSE64810_mlhd_DESeq2_diffexp_DESeq2_outlier_trimmed_adjust.txt.gz)                        |

# Data processing
While you can run the following code to download and process all necessary data files, the processed files will be provided in the `./data/` directory.
To run the processing script, run:
```
Rscript utils/stage_data.R
```

# Running the app
To start the app, run:
```
Rscript app.R
```

---

# BF591 - R for Biological Sciences [Checklist](https://bu-bioinfo.github.io/r-for-biological-sciences/final-project.html#required-components)

## Required Components

### Sample Information Exploration

The distinct values and distributions of sample information are important to understand before conducting analysis of corresponding sample data. This component allows the user to load and examine a sample information matrix.

**Inputs**:

- [x] Sample information matrix in CSV format

**Shiny Functionalities**:

- [x] Tab with a summary of the table that includes a summary of the number of rows and columns, and type and values in each column
- [x] Tab with a data table displaying the sample information, with sortable columns
- [x] Tab with histograms, density plots, or violin plots of continuous variables.

### Counts Matrix Exploration

Exploring and visualizing counts matrices can aid in selecting gene count
filtering strategies and understanding counts data structure. This component
allows the user to choose different gene filtering thresholds and assess their
effects using diagnostic plots of the counts matrix.

**Inputs**:

- [x] Normalized counts matrix, by some method or other, in CSV format
* Input controls that filter out genes based on their statistical properties:
  - [x] Slider to include genes with at least X percentile of variance
  - [x] Slider to include genes with at least X samples that are non-zero

**Shiny Functionalities**:

* Tab with text or a table summarizing the effect of the filtering, including:
  - [x] number of samples
  - [x] total number of genes
  - [x] number and % of genes passing current filter
  - [x] number and % of genes not passing current filter
* Tab with diagnostic scatter plots, where genes passing filters are marked in
a darker color, and genes filtered out are lighter:
  - [x] median count vs variance (consider log scale for plot)
  - [x] median count vs number of zeros
- [x] Tab with a clustered heatmap of counts remaining after filtering
  - consider enabling log-transforming counts for visualization
  - [x] be sure to include a color bar in the legend
- [x] Tab with a scatter plot of principal component analysis projections. You may either:
  - [x] allow the user to select which principal components to plot in a scatter
  plot (e.g. PC1 vs PC2)
  - allow the user to plot the top $N$ principal components as a beeswarm plot
  - [x] be sure to include the % variance explained by each component in the plot
  labels

### Differential Expression

Differential expression identifies which genes, if any, are implicated in a
specific biological comparison. This component allows the user to load and
explore a differential expression dataset.

**Inputs**:

* Results of a differential expression analysis in CSV format.
  - [x] If results are already made available, you may use those
  - Otherwise perform a differential expression analysis using DESeq2, limma, or
    edgeR from the provided counts file

**Shiny Functionalities**:

- [x] Tab with sortable table displaying differential expression results
  - [x] Optional: enable gene name search functionality to filter rows of table
- [x] Tab with content similar to that described in [Assignment 7]

### Visualization of Individual Gene Expression(s)

Visualizing individual gene counts is sometimes useful for examining or
verifying patterns identified by differential expression analysis. There are
many different ways of visualizing counts for a single gene. This app allows
counts from an arbitrary gene to be selected and visualized broken out by a
desired sample information variable.

**Input**:

- [x] Normalized counts matrix, by some method or other, in CSV format
- [x] Sample information matrix in CSV format
- [x] Input control that allows the user to choose one of the categorical fields
found in the sample information matrix file
- [x] Input control that allows the user to choose one of the genes found in the
counts matrix (hint: try implementing a [search box](https://stackoverflow.com/questions/47336114/searchbox-in-r-shiny))
- [x] Input control allowing the user to select one of bar plot, boxplot, 
violin plot, or beeswarm plot
- [x] A button that makes the thing go

**Shiny Functionalities**:

- [x] Content displaying a plot of the selected type with the normalized gene counts
for the selected gene split out by the categorical variable chosen
