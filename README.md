# *The Material Origins of Place-Based Affective Polarization in Canada* Replication Code

This repository contains scripts and documentation for replicating the analyses and visualizations for Bradley Wood-MacLean's MA thesis titled "The Material Origins of Place-Based Affective Polarization in Canada." This thesis was authored solely by Bradley Wood-MacLean. 
The workflow is organized into numbered scripts that should be run in sequence.

## Files

| File Name | Description |
|-----------|-------------|
| **BWM_Replication_Cleaning_1.Rmd** | [Cleans and preprocesses raw survey and index data.] |
| **BWM_Replication_Google_Maps_2.R** | [Generates Google Maps cultural data using the Places API.] |
| **BWM_Replication_Regressions_3.Rmd** | [Runs regression analyses on cleaned datasets and reproduces all non-STM related figures and tables.] |
| **BWM_Replication_STM_4.Rmd** | [Conducts Structural Topic Modeling (STM) on text data.] |
| **README.md** | This file. |

## Usage

1. Start with **BWM_Replication_Cleaning_1.Rmd** to clean and prepare the data.
2. Proceed to **BWM_Replication_Google_Maps_2.R** google maps data generation then return to file 1.
3. Use **BWM_Replication_Regressions_3.Rmd** to run LMM analyses.
4. Finish with **BWM_Replication_STM_4.Rmd** to analyze text data using STM.

## Copyright Disclaimer

The survey data is proprietary and cannot be released publicly at this time. See bibliography in body of the main text for links to objective measures datasets. 

## Author

Bradley Wood-MacLean, MA Candidate, Department of Political Science, University of British Columbia
