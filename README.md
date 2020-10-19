# Replicate Black and Woodward (Working Paper, 2020): The value of long and short term changes in water quality

This repository allows users to reproduce the results of Black and Woodward (Working Paper, 2020). Working paper available upon request; please direct working paper requests to [black.michael@tamu.edu](mailto:black.michael@tamu.edu). In the working paper, we estimate a demand model of recreation as a function of water quality that varies over time, *and* water quality that varies only over space.

Please note this repo does not contain any data. Data are available upon request; please direct data requests to [black.michael@tamu.edu](mailto:black.michael@tamu.edu).

Conditional on receiving the data files, every table and figure can be replicated.

We suggest the following folder structure for your replication:
| Level 1 Folders | Level 2 Folders | Level 3 Files |
|--- | --- | --- | 
| Build | Input | (All data files housed here) |
|  | Output | (All datasets built appear here) |
|  | Temp | (Temporary folder) |
|  | Code | Create Survey Data.do |
|  | | Get Income Data.do | 
|  | | Install OSRMTIME.do |
|  | | Calculate Travel Distances.do |
|  | | Create Fishing Locations.do |
|  | | Create Water Quality Data.do |
|  | | Specify Water Quality Data.do |
|  | | Adding USGS Water Quality data.R |
|  | | Create final dataset.do |
| Analysis | Output | (Output appears here)
|  | Code | Final Conditional Logit.do |
|  | | Final WTP Bootstrap.do |
|  | Temp | (Temporary folder) |

#### Replication Approach:
1. Build all files in the Build/Code folder
2. Estimate all model versions and WTP across anglers using "Analysis/Code/Final Conditional Logit.do"
3. Estimate bootstrapped WTP confidence intervals using "Analysis/Code/Final WTP Bootstrap.do"