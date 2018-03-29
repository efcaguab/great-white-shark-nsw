# Great white shark reserach NSW

The code was build with replicability on mind. It uses `packrat` to manage packages and dependences and `drake` to define on the data workflow.  

The easiest way to get the code to run in your computer is:

1. Download github for mac
2. Clone the repository in your computer
3. Open the project in Rstudio. Wait until Rstudio installs the required packages
4. Run the code. There are three ways to do this
  a) Go to the Terminal tab in Rstudio and type `make`
  b) Go to the Build tab in Rstudio and click "Build All"
  c) Open `main.R` and source the code

## Tides

The data provided by the NSW Office of Environment and Heritage contains water height readings from instruments deployed at different locations. 
The accuracy of these readings is influenced by noise—usually caused by the limitations on the instrument accuracy and other factors that determine water height but are not caused by tides, like swell or water being pushed by wind. 
However, During periods of high or low tide, the variation on water level caused by tides are often smaller than the variations caused by noise. 
The result is that raw data doesn't show clear peaks but a series of noisy spikes around the high or low tide marks.
Therefore, raw data must be processed such that the noise is taken out of the water height values. 
To do that we use a tidal model. 

This code fits a tidal model for each of the files in the `data/tides` directory. Files must be in ".csv"" format. 
The models are fit using the `ftide` function of the `TideHarmonics` package. It uses 114 constituents of the tides and hence a very accurate approximation to the tide levels. 
The output of the code is two csv files in the folder `data/processed`. 
First, `predictions.csv` file contains tidal water height every 15 minutes in each of the locations. 
From this file should be OK to use code that finds the maxima and minima to infer times of high/low tide. 
Second, the `metadata.csv` file contains information of each of the sites. 

Generating new tidal models for different sites or different dates is straightforward. 
Just update the csv files in `data/tides` and re-run the code as explained in the point #4 above. 
