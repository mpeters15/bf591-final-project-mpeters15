gene_expression <- tabPanel("Visualization of Individual Gene Expression",
                            br(),
                            sidebarLayout(
                              sidebarPanel(
                                fileInput(
                                  "p4_fileinput_normalized_counts_data",
                                  "Upload normalized count matrix data:",
                                  accept = ".csv",
                                  placeholder = "normalized_counts_matrix.csv",
                                ),
                                fileInput(
                                  "p4_fileinput_sample_information",
                                  "Upload sample information data:",
                                  accept = ".csv",
                                  placeholder = "metadata.csv",
                                ),
                                radioButtons("p4_radio_categorical_column",
                                             "Select a categorical column to plot:",
                                             choices = "Upload files to see choices",
                                ),
                                selectizeInput(
                                  # Credit for dropdown search: https://www.listendata.com/2021/09/shiny-search-bar-with-suggestions.html
                                  inputId = "p4_selectizeinput_gene_search",
                                  label = "Choose a gene name to plot:",
                                  multiple = FALSE,
                                  choices = "",
                                  options = list(
                                    create = FALSE,
                                    placeholder = "",
                                    maxItems = '1',
                                    onDropdownOpen = I(
                                      "function($dropdown) {if (!this.lastQuery.length) {this.close(); this.settings.openOnFocus = false;}}"
                                    ),
                                    onType = I("function (str) {if (str === \"\") {this.close();}}")
                                  )
                                ),
                                radioButtons(
                                  "p4_radio_plot_type",
                                  "Select the type of plot to view:",
                                  choices = c("bar plot",
                                              "box plot",
                                              "violin plot",
                                              "beeswarm plot"
                                  ),
                                ),
                                submitButton("Plot", width = '100%')
                              ),
                              mainPanel(
                                textOutput("p4_textoutput_gene_selection"),
                                plotOutput("p4_plotoutput_chosen_plot"),
                              ),
                            ),
                          )