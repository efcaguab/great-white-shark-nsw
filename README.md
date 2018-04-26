# Great white shark reserach NSW

The code was build with replicability on mind. It uses `packrat` to manage packages and dependences and `drake` to define on the data workflow.  

The easiest way to get the code to run in your computer is:

1. Get the code. Two ways to to this
    * Download [github](https://desktop.github.com), login & clone the repository in your computer
    * Just download the code from the repo
2. Open the project in Rstudio. Wait until Rstudio installs the required packages
3. Run the code. There are three ways to do this
    * Go to the Terminal tab in Rstudio and type `make`
    * Go to the Build tab in Rstudio and click "Build All"
    * Open `main.R` and source the code

## Tides

The data provided by the NSW Office of Environment and Heritage contains water height readings from instruments deployed at different locations. 
The accuracy of these readings is influenced by noise—usually caused by the limitations on the instrument accuracy and other factors that determine water height but are not caused by tides, like swell or water being pushed by wind. 
However, During periods of high or low tide, the variation on water level caused by tides are often smaller than the variations caused by noise. 
The result is that raw data doesn't show clear peaks but a series of noisy spikes around the high or low tide marks.
Therefore, raw data must be processed such that the noise is taken out of the water height values. 
To do that we use a tidal model. 

This code fits a tidal model for each of the files in the `data/tides` directory. Files must be in ".csv"" format. 
The models are fit using the `ftide` function of the `TideHarmonics` package. It uses 114 constituents of the tides and hence a very accurate approximation to the tide levels. 

### Parameters

Parameters are set at the beginning of the `main.R` script:

* `resolution_predicted_tides`: the time resolution of the the corrected tides in hours. For example 1/6 mean tides will be calculated every (60/6) 10 mins.
* `aggregation_bin`: the length of the bins at which data is being aggregated

### Outputs

The output of the code is four csv files in the folder `data/processed`. 

* `predictions.csv`: contains tidal water height in each of the locations. The resolution of the predictions is given by the `resolution_predicted_tides` parameter. 
From this file should be OK to use code that finds the maxima and minima to infer times of high/low tide. 
* `metadata.csv`: contains information of each of the sites. 
* `high_low.csv`: contains the date-times at which high and low tides. Resolution the same as that of the predictions. Therefore is given by the parameter `resolution_predicted_tides`.
* `aggregated_tides`: contains the mean tide height for each bin defined by the `aggretation_bin` parameter (for example "1 hour") in each locations. 

Generating new tidal models for different sites or different dates is straightforward. 
Just update the csv files in `data/tides` and re-run the code as explained in the point #3 above. 
