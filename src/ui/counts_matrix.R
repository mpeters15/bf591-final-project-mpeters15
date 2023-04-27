counts_matrix <- tabPanel("Counts Matrix",
                          br(),
                          sidebarLayout(
                            sidebarPanel(
                              fileInput(
                                "p2_fileinput_normalized_counts_matrix",
                                "Load normalized counts matrix:",
                                accept = ".csv",
                                placeholder = "normalized_counts_matrix.csv",
                              ),
                              sliderInput(
                                "p2_slider_percentile_variance",
                                "Select genes with at least X percentile of variance:",
                                min = 0,
                                max = 100,
                                value = 50,
                                step = 1,
                              ),
                              sliderInput(
                                "p2_slider_nonzero_gene_samples",
                                "Select genes with at least X samples that are non-zero:",
                                min = 1,
                                max = 2,
                                value = 2,
                                step = 1,
                              ),
                              submitButton("Run", width = '100%'),
                            ),
                            mainPanel(
                              tabsetPanel(
                                tabPanel(
                                  "Post-Filtering Summary",
                                  br(),
                                  htmlOutput("p2_htmloutput_sample_size"),
                                  dataTableOutput("p2_datatableoutput_filter_summary"),
                                ),
                                tabPanel(
                                  "Diagnostic Scatter Plots",
                                  br(),
                                  mainPanel(
                                    plotOutput("p2_plotoutput_median_count_vs_variance"),
                                    br(),
                                    plotOutput("p2_plotoutput_median_count_vs_number_of_zeros"),
                                  ),
                                ),
                                tabPanel(
                                  "Clustered Heatmap",
                                  br(),
                                  mainPanel(
                                    plotOutput("p2_plotoutput_heatmap"), 
                                  ),
                                  # ),
                                ),
                                tabPanel(
                                  "PCA Projections Scatter Plot",
                                  br(),
                                  sidebarLayout(
                                    sidebarPanel(
                                      radioButtons(
                                        "p2_radio_principal_component_1",
                                        "Select Principal Component (X):",
                                        choices = 1:10,
                                        selected = 1,
                                      ),
                                      radioButtons(
                                        "p2_radio_principal_component_2",
                                        "Select Principal Component (Y):",
                                        choices = 1:10,
                                        selected = 2,
                                      ),
                                      markdown("Click Run to re-generate the plot."),
                                    ),
                                    mainPanel(
                                      plotOutput("p2_plotoutput_scatter_pca"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )