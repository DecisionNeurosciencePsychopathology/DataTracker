# DataTracker

## To Install this package
```r
library(devtools)
install_github('DecisionNeurosciencePsychopathology/DataTracker')
```

## Where is the lab's config file?
```r
lab.cfg()
```
(This will return the path to the lab's config file.)

## For useful information
```r
?lab.info
```
(Hit 'q' to exit the documentation while in console.)

## Example
```r
# load tidyverse
library(tidyverse)
# load the DataTracker library
library(DataTracker)
# get the lab's config file path
lab_cfg <- lab.cfg()
# view the config path
lab_cfg
# mount a remote data resource
mnt_remote_data("/ihome/adombrovski/tsb31/Bierka", "Bierka", "")
# run a behavioral data check
h <- have_data(cfg='/ihome/adombrovski/tsb31/Bierka/datamesh/behav/redcap3.json', modality='behavior', 
protocol='bsocial', task='trust', data_path='/ihome/adombrovski/tsb31/Bierka/behav', 
my_required = c("edat_scan", "text_scan"), drop_failed=TRUE)
# unmount the remote resource
unmnt_remote_data("/ihome/adombrovski/tsb31/Bierka")
# view your resultant dataframe
h
```

## For other developers
It is recommended that you clone this repo and make updates unique to your lab.
