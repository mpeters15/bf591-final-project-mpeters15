sample_information <- tabPanel("Sample Information",
                               br(),
                               sidebarLayout(
                                 sidebarPanel(
                                   fileInput(
                                     "p1_fileinput_sample_information",
                                     "Load sample information matrix:",
                                     accept = ".csv",
                                     placeholder = "metadata.csv"
                                   ),
                                 ),
                                 mainPanel(
                                   tabsetPanel(
                                     tabPanel(
                                       "Table Summary",
                                       br(),
                                       htmlOutput("p1_htmloutput_rows"),
                                       htmlOutput("p1_htmloutput_cols"),
                                       dataTableOutput("p1_datatableoutput_sample_information_summary")
                                     ),
                                     tabPanel(
                                       "Data Table",
                                       br(),
                                       dataTableOutput("p1_datatableoutput_sample_information_data")
                                     ),
                                     tabPanel(
                                       "Histogram Plots",
                                       br(),
                                       sidebarLayout(
                                         sidebarPanel(
                                           radioButtons(
                                             "p1_radio_sample_information",
                                             label = "Choose a column to plot:",
                                             choices = c("Upload a file to see choices"),
                                           ),
                                           submitButton("Plot", width = '100%')
                                         ),
                                         mainPanel(
                                          plotOutput("p1_plotoutput_sample_information")
                                        ),
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                              )