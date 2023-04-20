# bf591-final-project-mpeters15
R Shiny application for BF591 final project

# Application URL
The application can be accessed at 

# Video demonstration
A demonstration of the application can be accessed at 

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

`./utils/stage_data.R.R` prepares the data needed for this application.


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
