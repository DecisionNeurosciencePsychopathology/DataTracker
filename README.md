# DataTracker

## Requirements
Install Rclone
```bash
curl https://rclone.org/install.sh | sudo bash
```
Note: you may need do a manual install of Rclone if the script does not work,
and you may need to update Fuse or give Rclone permission. If you cannot do this 
yourself, request help from the Data Team.

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

## Example for setting up the DNPL Lab using GitHub credentials
```r
# load the DataTracker library
library(DataTracker)
# NOTE: create a GitHub account and get a token before doing this part.
DNPLsetup(<your username>, <your token>, use_local_cfg=TRUE)
```

## Example for Checking Behavioral Data (showing easier implementation)
```r
# load the DataTracker library
library(DataTracker)
# NOTE: you need to run DNPLsetup() before running the following.

# mount Skinner
mount_Skinner()
# run a behavioral data check
h <- have_data(cfg=lab.cfg(), modality='behavior', protocol='bsocial', task='trust', 
  local_root=path.expand('~'), my_required = c("edat_scan", "text_scan"), drop_failed=TRUE)
# view your resultant dataframe
h
```

## Example for Checking Behavioral Data (showing lower-level implementation)
```r
# load the DataTracker library
library(DataTracker)
# get the lab's config file path
lab_cfg <- lab.cfg()
# view the config path
lab_cfg
# mount a remote data resource
mnt_remote_data("/ihome/adombrovski/tsb31/Bierka", "Bierka", "")
# running a behavioral data check
h <- have_data(cfg=lab_cfg, modality='behavior', protocol='bsocial', task='trust', 
  local_root='/ihome/adombrovski/tsb31/Bierka/datamesh/behav', 
  my_required = c("edat_scan", "text_scan"), drop_failed=TRUE)
## Or if you want to use a personalized config file
# h <- have_data(cfg='/ihome/adombrovski/tsb31/Bierka/datamesh/behav/redcap3.json', modality='behavior', 
#  protocol='bsocial', task='trust', local_root='/ihome/adombrovski/tsb31/Bierka', 
#  my_required = c("edat_scan", "text_scan"), drop_failed=TRUE, data_path='datamesh/behav/trust_bsocial')
## Or if you want to explicity define the data path ##
# h <- have_data(cfg='/ihome/adombrovski/tsb31/Bierka/datamesh/behav/redcap3.json', modality='behavior', 
#  protocol='bsocial', task='trust', local_root='/ihome/adombrovski/tsb31/Bierka', 
#  my_required = c("edat_scan", "text_scan"), drop_failed=TRUE)
# unmount the remote resource
unmnt_remote_data("/ihome/adombrovski/tsb31/Bierka")
# view your resultant dataframe
h
```

## Example for running a demographic report for Bsocial Trust
```r
# run the initial demographic
run_demographic_report(cfg="/Volumes/bierka_root/datamesh/behav/redcap3.json", protocol="bsocial", task="trust", load_env=TRUE)
# get the behavioral data check
h <- have_data(cfg='/Volumes/bierka_root/datamesh/behav/redcap3.json', modality='behavior', protocol='bsocial', task='trust', local_root='/Volumes/bierka_root', my_required = c("edat_scan", "text_scan"), drop_failed=TRUE)
# drop those without data from the initial demographic
trust_bsocial_w_behav <- bsocial_trust_data %>% filter(id %in% h$id)
# report the subjects without behavioral data
print("These ids either did not have behavioral data or did not match as a real subject id.")
print(setdiff(bsocial_trust_data$id, trust_bsocial_w_behav$id))
# generate the demographic data for those with behavioral data
behav_demo_trust_bsocial <- get_demo(trust_bsocial_w_behav, defined_groups=c('HL', 'LL', 'HC', 'NON'))
```

## For other developers
It is recommended that you clone this repo and make updates unique to your lab.
