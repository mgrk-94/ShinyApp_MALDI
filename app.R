
## App & Code Creator : Marie Gorka 

## First specify the packages of interest
packages = c("shiny", "shinyWidgets", "shinyFiles", "MALDIquant", "MALDIquantForeign", "dplyr", "bslib")

## Now load or install&load all
package.check <- lapply(
    packages,
    FUN = function(x) {
        if (!require(x, character.only = TRUE)) {
            install.packages(x, dependencies = TRUE)
            library(x, character.only = TRUE)
        }
    }
)








# Define UI for data upload app ----
ui <- navbarPage(
    
    #Define a theme for your application
    theme = bslib::bs_theme(bootswatch = "darkly"),
    
    # App title ----
    "MALDI MSI Data Converter",
    
    
    
    
    #PANEL 1 with the instructions to use the app ----
    tabPanel("Instructions",
             
             fluidPage(
                 h2( "Instructions to use the .imzML Data Converter"),
                 tags$p('Please read all the following instructions in order to correctly use the app.'),
                 tags$p('Please run the app externally with "Run External".'),
                 br(),
                 
                 h4('1. Enter the app'),
                 tags$p('Click on the tab Extract Intensities on the top to access all the functionalities
                      of the application to extract intensities per pixel for your .imzML file(s).'),
                 tags$p('You can load one or several files. If you load several files, your .csv will contain 
                      all the files placed underneath one another with a commun m/z list.'),
                 tags$p('The final .csv is constructed as follow : rows are pixels and the name of the 
                      corresponding sample is placed in the first column. 
                      Columns 2 and 3 are the position of the pixels, and all the other columns are the extracted m/z values.'),
                 tags$p('For each m/z value and each pixel, an intensity value is given. 
                      You can previsualize the .csv before downloading it in the app.'),
                 br(),
                 
                 h4('2. Select the file(s) to be processed'),
                 tags$p('To select the files, click on the button "Select Files". It will gives you access to your computer folders.'),
                 tags$p('Please select only .imzML file(s) and check that the corresponding .ibd file is placed in the same folder and 
                      has the same name.'),
                 tags$p('Once the file(s) are selected, a summary of the names will appear on the right side of the app.'),
                 br(),
                 
                 h4('3. Select the binPeaks values'),
                 tags$p('binPeaks function looks for similar peaks (mass) across MassPeaks objects and equalizes their mass. 
                      The tolerance is the maximal relative deviations of a peak position (mass) to be considered as identical. 
                      It must be multiplied by 10^-6 for ppm.'),
                 tags$p('If you load several files, in this application you have the possibilities to set this value for both 
                      each single file and for the merge of all the files. If you do not want to use this parameter, just put 0.'),
                 tags$p('If you load only one file, set the value for "each file" and just put 0 for the "combined file" value.'),
                 br(),
                 
                 h4('4. Select the filterPeaks values'),
                 tags$p('filterPeaks function removes infrequently occuring peaks in a list of MassPeaks objects.
                   minFrequency is defined to remove all peaks which occur in less than minFrequency*length(l) MassPeaks objects.
                   It is a relative threshold.'),
                 tags$p('If you load several files, in this application you have the possibilities to set this value for both 
                      each single file and for the merge of all the files. If you do not want to use this parameter, just put 0.'),
                 tags$p('If you load only one file, set the value for "each file" and just put 0 for the "combined file" value.'),
                 br(),
                 
                 h4('5. Extract the intensities'),
                 tags$p('Click on the button "Extract Intensities" to process your file(s).
                      The progress bar will indicate when the calculations are completed.'),
                 tags$p('At the end of the process, a summary of the final .csv will appear on the right side of the app.'),
                 br(),
                 
                 h4('6. Enter a name for your final .csv file'),
                 tags$p('Delete the default name "data-date" and enter a name of your choice. Please keep the .csv extension.'),
                 br(),
                 
                 h4('7. Save your .csv'),
                 tags$p('Click on the button "Dowload" to dowload your .csv.
                      The progress bar will indicate when the dowload is complete.'),
                 tags$p('Your file will be saved in the same folder where the application is stored.'),
                 br(),
             )),
    
    
    
    
    
    
    
    
    
    
    #PANEL 2
    # Sidebar layout with input and output definitions ----
    
    tabPanel("Extract intensities",
             
             sidebarLayout(
                 
                 # Sidebar panel for inputs ----
                 sidebarPanel(
                     # Input: Select a file ----
                     # fileInput("file", "Choose imzML and associated ibd Files",
                     #           multiple = TRUE,
                     #           accept = c(".imzML", ".ibd"),
                     #           placeholder = "No file selected"),
                     
                     
                     shinyFilesButton("file", "Select files", "Please select file(s)", multiple = TRUE, viewtype = "detail",
                                      style="color: #fff; background-color: #e95420; border-color: #c34113;
                                border-radius: 10px;border-width: 2px"),
                     
                     tags$p('The file selection button allows the user to select one or several .imzML
            files.'),
                     
                     
                     # Horizontal line ----
                     tags$hr(), 
                     
                     
                     # Input: Select binpeaks tolerance ----
                     
                     tags$p('binPeaks function looks for similar peaks (mass) across MassPeaks objects and equalizes their mass. 
            The tolerance is the maximal relative deviations of a peak position (mass) to be considered as identical. 
            It must be multiplied by 10^-6 for ppm.'),
                     
                     tags$p('Enter a number or use the arrows.'),
                     
                     numericInput("binpeaks1", "binPeaks Tolerance for each file",
                                  0, min = 0, max = 1, step = 0.00001),
                     
                     
                     
                     # Input: Select binpeaks tolerance ----
                     numericInput("binpeaks2", "binPeaks Tolerance for the combined file",
                                  0, min = 0, max = 1, step = 0.000001),
                     
                     tags$p('filterPeaks function removes infrequently occuring peaks in a list of MassPeaks objects.
                   minFrequency is defined to remove all peaks which occur in less than minFrequency*length(l) MassPeaks objects.
                   It is a relative threshold.'),
                     
                     tags$p('Enter a number or use the arrows.'),
                     
                     # Input: Select filterpeaks min frequency ----
                     numericInput("filterpeaks1", "filterPeaks Min Frequency for each file",
                                  0, min = 0, max = 1, step = 0.000001),
                     
                     
                     # Input: Select filterpeaks min frequency ----
                     numericInput("filterpeaks2", "filterPeaks Min Frequency for the combined file",
                                  0, min = 0, max = 1, step = 0.000001),
                     
                     
                     #Button to process the data
                     actionButton("button1", "Extract intensities",
                                  style="color: #fff; background-color: #e95420; border-color: #c34113;
                                border-radius: 10px;border-width: 2px"),
                     shinyWidgets::progressBar(id = "pb", value = 0, display_pct = TRUE),
                     # Horizontal line ----
                     tags$hr(),
                     
                     
                     # Input a name for the final treated csv
                     textInput("filename", "Choose a name for the final file", value = paste0("data-", Sys.Date(),".csv")),
                     
                     # Horizontal line ----
                     tags$hr(), 
                     
                     tags$p('Click on the download button to save your final .csv file'),
                     
                     #Download the final file
                     downloadButton("download", "Download",
                                    style="color: #fff; background-color: #e95420; border-color: #c34113;
                                border-radius: 10px;border-width: 2px"),
                     shinyWidgets::progressBar(id = "dn", value = 0, display_pct = TRUE),
                     tags$p('If you run the app with "Run in Window" a dialog box will appear at the end of the download. Just close it without
                   action. To avoid this issue run the app with "Run External".')
                     
                     
                 ),
                 # Main panel for displaying outputs ----
                 mainPanel(
                     
                     # Output: Data file ----
                     tableOutput("filenumber"),
                     
                     verbatimTextOutput("path"),
                     
                     # Horizontal line ----
                     tags$hr(),
                     
                     tableOutput("contents1"),
                     
                     verbatimTextOutput("contents2"),
                     
                     tableOutput("finaldata")
                     
                     
                 )
             )
    )
    
    
    
)








## First specify the packages of interest
packages = c("shiny", "shinyWidgets", "shinyFiles", "MALDIquant", "MALDIquantForeign", "dplyr", "bslib")

## Now load or install&load all
package.check <- lapply(
    packages,
    FUN = function(x) {
        if (!require(x, character.only = TRUE)) {
            install.packages(x, dependencies = TRUE)
            library(x, character.only = TRUE)
        }
    }
)






server <- function(input, output, session) {
    
    data <- data.frame()
    
    volumes <- c(Home = fs::path_home(), "R Installation" = R.home(), getVolumes()())
    shinyFileChoose(input, "file", roots = volumes, session = session)
    
    
    
    
    
    ## print to console to see how the value of the shinyFiles 
    ## button changes after clicking and selection
    observe({
        cat("\ninput$file value:\n\n")
        print(input$file)
    })
    
    
    
    
    
    output$filenumber <- renderPrint({
        
        if (is.integer(input$file)) {
            cat("")
        } else {
            cat("You have selected", length(parseFilePaths(volumes, file())$datapath), ".imzML files.")
        }
    })
    
    
    
    
    output$path <- renderPrint({
        
        if (is.integer(input$file)) {
            cat("Please select files")
        } else {
            input$file
        }
    })
    
    
    file <- reactive(input$file)
    
    
    
    output$contents1 <- renderPrint({
        
        if (is.integer(input$file)) {
            cat("")
        } else {
            cat("The path of your files are :")
        }
    })
    
    output$contents2 <- renderPrint({
        
        if (is.integer(input$file)) {
            cat("")
        } else {
            as.character(parseFilePaths(volumes, file())$datapath)
        }
    })
    
    
    
    
    #______________________________________________________________
    
    
    
    datamerge <- eventReactive(input$button1, {
        
        
        
        dataTemp.Merge <- list()
        
        
        for (i in  1 : length(parseFilePaths(volumes, file())$datapath))
        {
            dataTemp <- importImzMl( parseFilePaths(volumes, file())$datapath[i], verbose = TRUE, centroided = TRUE )
            dataTemp2 <- binPeaks( dataTemp, method = "strict", tolerance = input$binpeaks1 )
            dataTemp3 <- filterPeaks(dataTemp2, minFrequency = input$filterpeaks1)
            dataTemp.Merge <- c( dataTemp.Merge, dataTemp3  )
        }
        
        shinyWidgets::updateProgressBar(session = session, id = "pb", value = 0) 
        
        for (i in 1:10) {
            
            updateProgressBar(session = session, id = "pb", value = 100/10*i)
            removeUI('#text', immediate = T)
            insertUI('#placeholder', ui = tags$p(id = 'text', paste('iteration:', i)), immediate = T)
            Sys.sleep(1)
            
        }
        
        
        dataTemp.Peaks <- binPeaks( dataTemp.Merge, method = "strict", tolerance = input$binpeaks2 )
        dataTemp.Peaks2 <- filterPeaks(dataTemp.Peaks, minFrequency = input$filterpeaks2 )
        dataTemp.Peaks.Final <- dataTemp.Peaks2
        positions <- lapply( dataTemp.Peaks.Final, function(x) x@metaData$imaging$pos )
        positions<- data.frame( do.call( rbind, positions ) )
        sample <- lapply(dataTemp.Peaks.Final, function(x)metaData(x)$file)
        sample <- data.frame( do.call (rbind, sample )  )
        intensity <- intensityMatrix( dataTemp.Peaks.Final )
        fm2 <- data.frame( sample, positions, intensity )
        fm2[is.na( fm2 )] <- 0
        colnames(fm2)[1] <- "Sample"
        colnames(fm2)[4:length(fm2)] <- as.character(gsub("X","",colnames(fm2)[4:length(fm2)]))
        data <- fm2
    })
    
    
    output$finaldata <- renderTable(
        {
            datamerge()[1:10,1:10]
        }
    ) 
    
    
    
    #______________________________________________________________  
    
    output$download <- downloadHandler(
        
        filename = function(){
            paste(input$filename)
        },
        
        
        content = function(file) {
            
            shinyWidgets::updateProgressBar(session = session, id = "pb", value = 0) 
            
            for (i in 1:10) {
                
                updateProgressBar(session = session, id = "dn", value = 100/10*i)
                removeUI('#text', immediate = T)
                insertUI('#placeholder', ui = tags$p(id = 'text', paste('iteration:', i)), immediate = T)
                Sys.sleep(1)
                
            }
            
            write.csv(datamerge(), file = input$filename, row.names = FALSE)
        }
    )
    
    
    #______________________________________________________________   
    
    
}








# Run the application 
shinyApp(ui = ui, server = server)
