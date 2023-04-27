differential_expression <- tabPanel("Differential Expression",
                                    br(),
                                    sidebarLayout(
                                      sidebarPanel(
                                        fileInput(
                                          "p3_fileinput_differential_expression_results",
                                          "Load differential expression analysis results:",
                                          accept = ".csv",
                                          placeholder = "deseq2_analysis.csv",
                                        ),
                                      ),
                                      mainPanel(
                                        tabsetPanel(
                                          tabPanel(
                                            "Differential Expression Results Table",
                                            br(),
                                            dataTableOutput("p3_datatableoutput_differential_expression_results"),
                                          ),
                                          tabPanel("Analyses",
                                                   br(),
                                                   sidebarLayout(
                                                     sidebarPanel(
                                                       markdown("<b>Generate a volcano plot</b>"),
                                                       radioButtons(
                                                         "p3_radio_x_axis",
                                                         "Select an x-axis column:",
                                                         choices = c(
                                                           "baseMean",
                                                           "log2FoldChange",
                                                           "lfcSE",
                                                           "stat",
                                                           "pvalue",
                                                           "padj"
                                                         ),
                                                         selected = "log2FoldChange",
                                                       ),
                                                       radioButtons(
                                                         "p3_radio_y_axis",
                                                         "Select a y-axis column:",
                                                         choices = c(
                                                           "baseMean",
                                                           "log2FoldChange",
                                                           "lfcSE",
                                                           "stat",
                                                           "pvalue",
                                                           "padj"
                                                         ),
                                                         selected = "padj",
                                                       ),
                                                       colourInput("p3_colorinput_base_point", 
                                                                   label = "Base point color:", "#0073b7"),
                                                       colourInput("p3_colorinput_highlight_point", 
                                                                   label = "Highlight point color:", "#f39c12"),
                                                       sliderInput(
                                                         inputId = "p3_sliderinput_padj",
                                                         min = -100,
                                                         max = 0,
                                                         label = "Select the magnitude of the p-adjusted coloring:",
                                                         value = -10,
                                                         step = 1,
                                                       ),
                                                       submitButton("Plot", width = '100%', ),
                                                     ),
                                                     mainPanel(
                                                       plotOutput("p3_plotoutput_volcano"),
                                                     ),
                                                   ), 
                                          ),
                                        ), 
                                      ), 
                                    ),
)