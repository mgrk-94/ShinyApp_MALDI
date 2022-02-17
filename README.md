# ShinyMALDI
Shiny App to treat imzml files

Instructions to use the .imzML Data Converter
Please read all the following instructions in order to correctly use the app.
Please run the app externally with "Run External".



1. Enter the app
Click on the tab Extract Intensities on the top to access all the functionalities of the application to extract intensities per pixel for your .imzML file(s).
You can load one or several files. If you load several files, your .csv will contain all the files placed underneath one another with a commun m/z list.
The final .csv is constructed as follow : rows are pixels and the name of the corresponding sample is placed in the first column. Columns 2 and 3 are the position of the pixels, and all the other columns are the extracted m/z values.
For each m/z value and each pixel, an intensity value is given. You can previsualize the .csv before downloading it in the app.



2. Select the file(s) to be processed
To select the files, click on the button "Select Files". It will gives you access to your computer folders.
Please select only .imzML file(s) and check that the corresponding .ibd file is placed in the same folder and has the same name.
Once the file(s) are selected, a summary of the names will appear on the right side of the app.



3. Select the binPeaks values
binPeaks function looks for similar peaks (mass) across MassPeaks objects and equalizes their mass. The tolerance is the maximal relative deviations of a peak position (mass) to be considered as identical. It must be multiplied by 10^-6 for ppm.
If you load several files, in this application you have the possibilities to set this value for both each single file and for the merge of all the files. If you do not want to use this parameter, just put 0.
If you load only one file, set the value for "each file" and just put 0 for the "combined file" value.



4. Select the filterPeaks values
filterPeaks function removes infrequently occuring peaks in a list of MassPeaks objects. minFrequency is defined to remove all peaks which occur in less than minFrequency*length(l) MassPeaks objects. It is a relative threshold.
If you load several files, in this application you have the possibilities to set this value for both each single file and for the merge of all the files. If you do not want to use this parameter, just put 0.
If you load only one file, set the value for "each file" and just put 0 for the "combined file" value.



5. Extract the intensities
Click on the button "Extract Intensities" to process your file(s). The progress bar will indicate when the calculations are completed.
At the end of the process, a summary of the final .csv will appear on the right side of the app.



6. Enter a name for your final .csv file
Delete the default name "data-date" and enter a name of your choice. Please keep the .csv extension.



7. Save your .csv
Click on the button "Dowload" to dowload your .csv. The progress bar will indicate when the dowload is complete.
Your file will be saved in the same folder where the application is stored.
