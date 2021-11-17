#' These are the utility functions for the data tracker.
#' @description
#'
#' -----------------------------------------------------------------------------
#'
#' SUMMARY:
#'
#' -----------------------------------------------------------------------------
#'
#' All functions for the Decision Neuroscience and Psychopathology Lab at the
#' University of Pittsburgh Medical Center. This is a single-file R package that
#' was developed to connect to research data data across protocols and
#' modalities and even cloud storage resources by wrapping Rclone.
#'
#' -----------------------------------------------------------------------------
#'
#' GOAL:
#'
#' -----------------------------------------------------------------------------
#'
#' The design was meant to be simple, hence the single file. Abstract functions
#' are to be built that can then be utilized to quickly access data in a
#' uniform manner across protocols. This should, hopefully, reduce ad-hoc
#' scripting and make data management easier, faster, more precise and, most
#' importantly, extensible to new tasks, protocols, and data storage.
#' Essentially, this single page should be the main resource to use and refer
#' to for data management at the DNPL.
#'
#' The only other files a user should need are:
#'
#'   1. A configuration json file
#'     This should be provided by the current maintainer(s) in a private
#'     GitHub repo.
#'     A private GitHub repo was chosen as it provides easy access for lab
#'     members by using git clone.
#'
#'   2. An rclone config file
#'     This is actually managed by rclone using the "rclone config" command.
#'     https://rclone.org/commands/rclone_config/
#'
#' -----------------------------------------------------------------------------
#'
#' MAINTAINERS:
#'
#' -----------------------------------------------------------------------------
#'
#' Current Maintainers:
#'
#'   Shane Buckley: tshanebuckley<at>gmail.com
#'
#' Previous Maintainers:
#'
#'   NA
#'
#' -----------------------------------------------------------------------------
#'
#' FUNCTION NAMING RULES:
#'
#' TODO: document all rules for function naming here.
#'
#' -----------------------------------------------------------------------------
#'
#' KEYWORDS and CONCEPTS:
#' TODO: have someone else update tasks and protocols
#'
#' -----------------------------------------------------------------------------
#'
#' PROTOCOLS:
#'   masterdemo:
#'
#'   bsocial
#'
#'   ksocial
#'
#'   explore
#'
#'   explore2
#'
#'   momentum (not implemented yet)
#'
#'   pandea (not implemented yet)
#'
#' TASKS:
#'   clock
#'
#'   trust
#'
#'   spott
#'
#' CLINICAL DATA/PROTOCOL STATUS SOURCES:
#'   redcap
#'     Database for storing participant data by identifiers.
#'     Used to track participant participation in protocols along with
#'     demographic data (Master Demographic).
#'
#'     site:
#'       https://www.project-redcap.org/
#'
#'     documentation:
#'       https://wiki.uiowa.edu/display/REDCapDocs/REDCap
#'
#'     ctsi:
#'       https://ctsi.pitt.edu/guides-tools/data-management-resources/
#'
#'     pitt:
#'       https://www.ctsiredcap.pitt.edu/redcap/
#'
#'     R SDK for data fetching:
#'       https://ouhscbbmc.github.io/REDCapR/
#'
#'     Python SDK for fetching data:
#'       https://pycap.readthedocs.io/en/latest/
#'
#'
#' RAW IMAGING DATA SOURCES/FORMATS:
#'   meson
#'     Database used before xnat to get imaging data from the MRRC.
#'
#'   xnat
#'     Current database used to get imaging data from the MRRC.
#'
#'     Python SDKs:
#'       xnatpy:
#'         https://xnat.readthedocs.io/en/latest/
#'
#'       pyxnat:
#'         https://pyxnat.github.io/pyxnat/
#'
#'     MRRC XNAT:
#'     Script used to pull data from MRRC (DNPL fork):
#'     https://github.com/DecisionNeurosciencePsychopathology/dax/blob/main/bin/Xnat_tools/Xnatdownload
#'
#'     To Install:
#'       pip install git+https://github.com/DecisionNeurosciencePsychopathology/dax.git
#'
#'     Example usage:
#'
#'       Xnatdownload -p WPC-7341 -d /volume1/bierka_root/datamesh/RAW --subj all --sess all -s all -a all --rs all --ra all
#'       (Run as a cron job, the above function downloads all xnat data for bsocial.)
#'
#' BRAIN IMAGING DATA STRUCTURE:
#'   bids
#'     Standardized format for brain imaging data.
#'
#'     BIDS main page:
#'       https://bids.neuroimaging.io/
#'     BIDS documentation:
#'       https://bids-specification.readthedocs.io/en/stable/
#'     Python SDK:
#'       documentation:
#'         https://github.com/bids-standard/pybids
#'       tutorial:
#'         https://notebook.community/INCF/pybids/examples/pybids_tutorial
#'     Conversion(heudiconv):
#'       documentation:
#'         https://heudiconv.readthedocs.io/en/latest/
#'       tutorial:
#'         https://reproducibility.stanford.edu/bids-tutorial-series-part-2a/
#'
#' IMAGING DATA PRE-PROCESSING:
#'   fmriprep
#'     Standardized preprocessing software that take BIDS-converted data as input.
#'
#'     fMRIPrep Documentation:
#'       https://fmriprep.org/en/stable/
#'
#'   clpipe:
#'     Wrapper to run fmriprep via a singularity container on a slurm cluster.
#'
#'     clpipe documentation:
#'       https://clpipe.readthedocs.io/en/latest/
#'
#'     clpipe github:
#'       https://github.com/cohenlabUNC/clpipe
#'
#'     DNPL fork:
#'       https://github.com/DecisionNeurosciencePsychopathology/clpipe
#'
#'   crc:
#'     University of Pittsburgh's HPC cluster for running slurm jobs.
#'
#'     crc documentation:
#'       https://crc.pitt.edu/
#'       (Refer to this for Globus, Slurm, and general HPC usage documentation.)
#'
#'     psychiatry visualization portal:
#'       https://crc.pitt.edu/psych
#'       (GPU-accelerated desktop interface for image visualization via FSL and AFNI.)
#'
#'   longleaf:
#'     University of North Carolina Chapel Hill's HPC cluster for running slurm jobs.
#'
#'
#' LOCAL STORAGE:
#'   bierka
#'     80TB Synology NAS backed up via tape by the OAC and to the DNPL DataTeam SharePoint.
#'     This is our long-term storage server.
#'
#'   milka
#'     40TB Synology NAS used for local scratch space for the DNPL.
#'     This is our short-term storage server.
#'     (Currently backup of Bek)
#'
#'   bek
#'     Pegasus NAS containing legacy data.
#'
#'   skinner
#'     Main SharePoint site for DNPL collaboration and behavioral data upload.
#'
#'   rclone
#'     Software that allows the syncing and mounting of cloud storage.
#'
#'     documentation:
#'       https://rclone.org/
#'
#'   minio
#'     S3 compliant data bucket software (allows mounting Bierka via rclone).
#'
#'     documentation:
#'       https://docs.min.io/docs/minio-quickstart-guide.html
#'
#'   docker
#'     Containerization software (installed on Bierka).
#'
#'     documentation:
#'       https://docs.docker.com/
#'
#'   sharepoint
#'     Pitt's chosen cloud storage provided as of 2021.
#'
#' -----------------------------------------------------------------------------
#' @examples
#' ?lab.cfg
#' @export
lab.info <- function() {
  print("Execute '?lab.info' to read about our lab.")
}

#library(dplyr)
#library(lubridate)
#library(purrrlyr)
#library(tinsel)
#library(redcapAPI)
#library(yaml)
library(tidyverse)
library(REDCapR)
library(reticulate)
library(R.utils)


# source our decorators
#tinsel::source_decoratees("decorators.R")

#' Small function to get the default lab config path
#' @param cfg_env is the environment variable to the config file.
#' @return The lab config file path as a string.
#' @examples
#' lab.cfg()
#' @export
lab.cfg <- function(cfg_env=NA) {
  # if the cfg_env is unset
  if(is.na(cfg_env) == TRUE) {
    cfg_path <- Sys.getenv("DNPL")
  # otherwise
  } else {
    # use the user specified environment variable
    cfg_path <- Sys.getenv(cfg_env)
  }
  # return the config file path
  return(cfg_path)
}

#' Small function to get OS string identifier.
#' @return The system type as a string.
#' @examples
#' os.is()
#' @export
os.is <- function() {
  return(Sys.info()['sysname'][[1]])
}

#' Function to check if the remote data is mounted.
#' @param mnt_path is the directory to check as a mount point.
#' @returns
#' TRUE if the \code{mnt_point} already has a remote resource mounted.
#' FALSE if the \code{mnt_point} does not have a remote resource mounted.
#' @examples
#' is.mounted(mnt_path="/Users/bob/mnt")
#' @export
is.mounted <- function(mnt_path) {
  # if this is a mac
  if(os.is() == "Darwin") {
    # system command to check that the selected directory is mounted
    mount_str <- paste0("df | awk '{print $9}' | grep -Ex '", mnt_path, "'")
    # if this is a linux system
  } else if(os.is() == "Linux") {
    # system command to check that the selected directory is mounted
    mount_str <- paste0('mountpoint -q ', mnt_path, ' && echo "mounted"')
  }
  # get the result of checking the mount
  mount_result <- system(mount_str, intern=TRUE)
  # will return an item of length 0 if not mounted
  if(length(mount_result) == 0) {
    # return that the resource is not mounted
    return(FALSE)
  # the resource is mounted, ensure it is in good health
  } else {
    # system command to attempt a basic directory listing
    ls_result <- system(paste0('ls ', mnt_path), intern=TRUE)
    # will return an item of length 0 if ls failed
    if(length(ls_result) == 0) {
      # return that the mount is unhealthy
      return("bad mount")
      # the resource is mounted and healthy
    } else {
      # return that this is a good mount
      return(TRUE)
    }
  }
}

#' Function to unmount remote data that was mounted via rclone.
#' @param mnt_path is the directory to end a mount on.
#' @examples
#' unmnt_remote_data(mnt_path="/Users/bob/mnt")
#' @export
unmnt_remote_data <- function(mnt_path) {
  # if this is a mac
  if(os.is() == "Darwin") {
    # system command to check that the selected directory is mounted
    mount_str <- paste0('umount ', mnt_path)
    # if this is a linux system
  } else if(os.is() == "Linux") {
    # system command to check that the selected directory is mounted
    mount_str <- paste0('fusermount -u ', mnt_path)
  }
  # run the unmount
  system(mount_str, intern=TRUE)
}

#' Function to remount data: runs an unmount following by a mount.
#' @param mnt_path is the directory to try and remount.
#' @param remote_name is the name of the configured rclone remote.
#' @param remote_path is the path to the remote directory to mount locally.
#' @param attempt sets the attempt number you are on.
#' @param max_attempts sets the max number of mount attempts.
#' @param sleep number of seconds to sleep in between mount attempts.
#' @examples
#' remnt_remote_data(mnt_path="/Users/bob/mnt", "Bob_OneDrive", "Documents")
#' @export
remnt_remote_data <- function(mnt_path, remote_name, remote_path,
                              attempt=1, max_attempts=5, sleep=5) {
  # run an unmount
  unmnt_remote_data(mnt_path)
  # attempt a mount
  mnt_result <- mnt_remote_data(mnt_path, remote_name, remote_path,
                                attempt=attempt, max_attempts=max_attempts,
                                sleep=sleep)
  # return the mount result: TRUE if mounted, FALSE if the mount failed
  return(mnt_result)
}

#' Function to check that the mount succeeded or
#' increment attempt and run again.
mnt_attempt_check <- function(mnt_path, remote_name, remote_path, attempt,
                              max_attempts, trap, sleep) {
  # check the mount status
  new_mnt_status <- is.mounted(mnt_path)
  # convert "bad mount" status to FALSE
  if(new_mnt_status == "bad mount") {
    new_mnt_status = FALSE
  }
  # if the status is FALSE -> mount failed
  if(new_mnt_status == FALSE) {
    # increment the current attempt
    new_attempt = attempt + 1
    # based on the attempt max, try again
    if(new_attempt < max_attempts + 1) {
      # Note that the previous attempt failed
      print(paste0("Mount failed on attempt: ", toString(attempt), "..."))
      # sleep before next attempt
      Sys.sleep(sleep)
      # try the mount again recursively
      mnt_remote_data(mnt_path, remote_name, remote_path, new_attempt,
                      max_attempts, trap, sleep)
    # otherwise, we have already reached the max number of retries
    } else {
      # Note that the max number of mount attempts was reached
      print(paste0("Mount Failed after ", toString(max_attempts), " attempts."))
      # return FALSE to signify a failed mount
      return(FALSE)
    }
  # if the status is TRUE -> mount succeeded
  } else {
    # Note to the user the mount succeeded
    cat(paste0("Successfully mounted ", remote_name, " directory:\n",
               remote_path, "\nTo local directory:\n", mnt_path, "\n"))
    # if we want to unmount the remote after our script execution
    if(trap == TRUE) {
      # if this is a mac
      if(os.is() == "Darwin") {
        # system command to check that the selected directory is mounted
        trap_str <- paste0('trap "umount ', mnt_path, '" 1 3 9 15 19')
        # if this is a linux system
      } else if(os.is() == "Linux") {
        # system command to check that the selected directory is mounted
        trap_str <- paste0('trap "fusermount -u ', mnt_path, '" 1 3 9 15 19')
      }
      # create the trap
      system(trap_str, intern=TRUE)
    }
    # return TRUE to signify a successful mount
    return(TRUE)
  }
}

#' Small function to check that .DS_Store is the only item in a directory.
only.ds_store <- function(mnt_path) {
  # get all of the immediate children on the directory given
  all_items <- list.files(mnt_path, all.files=TRUE, include.dirs=TRUE)
  # remove the '.' and '..' items
  all_items <- all_items[!(all_items %in% c('.', '..'))]
  # If the result of the above operations yields an empty character vector
  # then we know this is an empty directory. Convert the empty vector to
  # an empty string to allow the following if-statement to execute.
  if(length(all_items) == 0) {
    all_items <- ''
  }
  # if all_items is only .DS_Store
  if(all_items == ".DS_Store") {
    return(TRUE)
  # otherwise, there are other files
  } else {
    return(FALSE)
  }
}

#' Function to handle .DS_Store file on Mac systems.
#' Will delete the folder if it is the only folder in the directory
#' This is so that rclone can mount without unsafely using the --allow-non-empty
#' option on all mount attempts.
remove_ds_store <- function(mnt_path) {
  # check that the .DS_Store file is the only file in the directory
  if(only.ds_store(mnt_path) == TRUE) {
    # Note to the user that this file is being removed
    print(".DS_Store is the only file in this directory.
          Deleting it in order to mount data.")
    # remove the file
    unlink(paste0(mnt_path, '/.DS_Store'), recursive=TRUE)
  }
}

#' Function to mount remote data using rclone.
#' @description
#' This can be used to mount SharePoint or any other cloud resource as if
#' the data existed on your local machine.
#' This uses rclone, ensure it is available.
#' rclone: https://rclone.org/commands/rclone_mount/
#' Mac OS Warning: While the files will mount and be accessible,
#' it has been seen where the Finder does not appropriately update
#' to display your remote folders and file. They do, however,
#' become accessible via terminal for normal operations like
#' cat, ls, cd, etc. Macs also require the deletion of .DS_Store folder
#' in order to attempt remounts as mount paths need to be empty.
#' @param mnt_path is the directory to try and remount.
#' @param remote_name is the name of the configured rclone remote.
#' @param remote_path is the path to the remote directory to mount locally.
#' @param attempt sets the attempt number you are on.
#' @param max_attempts sets the max number of mount attempts.
#' @param trap if set to TRUE, the mount will not persist after the session.
#' @param sleep number of seconds to sleep in between mount attempts.
#' @examples
#' mnt_remote_data(mnt_path="/Users/bob/mnt", "Bob_OneDrive", "Documents")
#' @export
mnt_remote_data <- function(mnt_path, remote_name, remote_path, attempt=1,
                            max_attempts=5, trap=FALSE, sleep=5) {
  # Note the attempt number to user
  print(paste0("Attempt ", toString(attempt)))
  # if this is a mac
  if(os.is() == "Darwin") {
    # system command to check that the selected directory is mounted
    mount_str <- paste0('rclone cmount ', remote_name, ':', remote_path, ' ',
                        mnt_path, ' --daemon --vfs-cache-mode full')
    # if this is a linux system
  } else if(os.is() == "Linux") {
    # system command to check that the selected directory is mounted
    mount_str <- paste0('rclone mount ', remote_name, ':', remote_path, ' ',
                        mnt_path, ' --daemon --vfs-cache-mode full')
  }
  # get the mount status
  mnt_status <- is.mounted(mnt_path)
  # if the mount path is not mounted
  if(mnt_status == FALSE) {
    # attempt to mount the data
    tryCatch({
      # handle for mounting on Mac system (.DS_Store file)
      if(os.is() == "Darwin") {
        # removes the file if it is the only file in the directory
        remove_ds_store(mnt_path)
      }
      # run the mount
      system(mount_str, intern=TRUE)
    # if the mount fails
    }, error = function(e){
      # print the error
      print(e)
    # ensure our mount succeeded or retry
    }, finally = {
      # run the function to ensure we have mounted our resource
      # will also run another attempt if one is needed and
      # max attempts not reached
      final_check <- mnt_attempt_check(mnt_path, remote_name, remote_path,
                                       attempt, max_attempts, trap=trap)
      # return the status of our final check
      return(final_check)
    })
  # if this was a bad mount
  } else if(mnt_status == 'bad mount'){
    # attempt a remount
    tryCatch({
      # try remount, trapm explicity set to FALSE, should only be called on
      # final check
      remnt_result <- remnt_remote_data(mnt_path, remote_name, remote_path,
                                        attempt=attempt,
                                        max_attempts=max_attempts, trap=FALSE)
      # return the result
      return(remnt_result)
    # if the remount fails
    }, error = function(e){
      # print the error
      print(e)
    # ensure our mount succeeded or retry
    }, finally = {
      # run the function to ensure we have mounted our resource
      # will also run another attempt if one is needed and
      # max attempts not reached
      final_check <- mnt_attempt_check(mnt_path, remote_name, remote_path,
                                       attempt, max_attempts, trap=trap)
      # return the status of our final check
      return(final_check)
    })
  # if the data was already mounted
  } else {
    # log that the data was mounted to user
    print("Remote data storage was already mounted.")
    # return TRUE to signify that the mount was successful
    return(TRUE)
  }
}

#' Function to check that rclone is installed.
#' @return Boolean representing if rclone is installed or not.
#' @examples
#' rclone.installed()
#' @export
rclone.installed <- function() {
  # try running the base rclone command
  tryCatch({
    # run the command
    rclone_installed <- system("rclone > /dev/null 2>&0")
    # if the value is 1
    if(rclone_installed == 1) {
      # let the user know that rclone is installed
      print("Rclone already installed.")
      # return TRUE
      return(TRUE)
    # otherwise, not installed
    } else {
      # let the user know that rclone is not installed
      print("Rclone not installed.")
      # return FALSE
      return(FALSE)
    }
  # otherwise, return that rclone is not installed
  }, error = function(e) {
    # let the user know that rclone is not installed
    print("Rclone not installed.")
    # return FALSE
    return(FALSE)
  })
}

#' #' Convenience function to install Rclone
#' install_rclone <- function(module=FALSE) {
#'   # check that rclone is installed
#'   is_installed <- rclone.installed()
#'   # if rclone is not installed
#'   if(is_installed == FALSE) {
#'     # if doing a root user install
#'     if(module == FALSE) {
#'       install_str <- "curl https://rclone.org/install.sh | sudo bash"
#'         # otherwise, assume loading as a module
#'     } else {
#'       install_str <- "module load rclone"
#'     }
#'     # command to run on the system
#'     system(install_str, intern=TRUE)
#'   }
#' }

#' Function to create a REDCapR project from json input for master demographic.
#' @return Returns an object to pull Master Demographic data with.
#' @param cfg_path is the path to the lab's json configuration file.
#' @examples
#' get_masterdemo(cfg_path='/bgfs/adombrovski/lab_resources/dnpl.json')
#' @export
get_masterdemo <- function(cfg_path) {
  # get the token for the protocol
  rc_tkn <- jsonlite::fromJSON(cfg_path)$master_demo
  # get the url from the protocol
  rc_url <- jsonlite::fromJSON(cfg_path)$url
  # create the REDCapR project
  rc_proj <- REDCapR::redcap_project$new(redcap_uri=rc_url, token=rc_tkn)
  # return the project
  return(rc_proj)
}

#' Function to create a REDCapR project from json input.
#' @return Returns an object to pull REDCap project data with.
#' @param cfg_path is the path to the lab's json configuration file.
#' @param protocol is the project we want data from.
#' @examples
#' get_project(cfg_path='/bgfs/adombrovski/lab_resources/dnpl.json',
#'     protocol='bsocial')
#' @export
get_project <- function(cfg_path, protocol) {
  # get the token for the protocol
  rc_tkn <- jsonlite::fromJSON(cfg_path)$protocols[[protocol]]$token
  # get the url from the protocol
  rc_url <- jsonlite::fromJSON(cfg_path)$protocols[[protocol]]$url
  # create the REDCapR project
  rc_proj <- REDCapR::redcap_project$new(redcap_uri=rc_url, token=rc_tkn)
  # return the project
  return(rc_proj)
}

#' Wrapper function to source and execute a function for grabbing task data
#' from REDCap.
#' @description
#' This funtion will first attempt to execute a default data fetching for the
#' protocol given that should be named:
#'   get_<protocol>_task_data()
#'
#'   Example:
#'     get_bsocial_task_data()
#'
#' If this general function fails, a specific one for that task will be used,
#' which should be name:
#'   get_<protocol>_<task>_data()
#'
#'   Example:
#'     get_explore2_clock_data()
#'
#' NOTE: This needs updated to allow selection from user input fields and
#' events instead of only those specified in the lab config file.
#'
#' @param data a REDCapR data object
#' @param protocol is the project we want data from.
#' @param task is the specific task we want data for.
#' @param fields are REDCap data fields we want to pull. (Default is all fields)
#' @param events are REDCap events we want to pull. (Default is all events)
#' @param cfg is the path to the lab's json configuration file. (Required)
#' @returns The selected REDCap data.
#' @examples
#' get_redcap_data(data=bs, protocol='bsocial', task='trust', fields=cfg,
#' events=cfg, cfg='/bgfs/adombrovski/lab_resources/dnpl.json')
#' @export
get_redcap_data <- function(data, protocol, task, fields=NA, events=NA,
                            cfg=NA) {
  # source the script from within the current path
  #source(paste0('protocols/', protocol, '.R'))
  # if fields are not given, but a config path is
  if(is.string(fields)){
    # get the fields required for the data fetch from json
    fields <- jsonlite::fromJSON(fields)$protocols[[protocol]]$fields
  }
  # if events are not given, but a config path is
  if(is.string(events)){
    # get the fields required for the data fetch from json
    events <- jsonlite::fromJSON(events)$protocols[[protocol]]$events
  }
  # fetch the data
  data <- data$read(fields=fields, events=events)$data
  # run the function
  # First try should be assuming that a task name is given,
  # Notes that the task has a specific run case
  tryCatch(
    expr = {
      # executes 'get_<protocol name>_<task name>_redcap(data=data)'
      task_data <- eval(parse(text=paste0('get_', protocol, '_', task,
                                          '_redcap(data=data, cfg=cfg)')))
      # return the task data
      return(task_data)
    },
    error = function(e) {
      # executes 'get_<protocol name>_task_redcap(data=data, task=task)'
      task_data <- eval(parse(text=paste0('get_', protocol,
                                '_task_redcap(data=data, task=task, cfg=cfg)')))
      # return the task data
      return(task_data)
    }
  )
}

#' Function to get the biological sex.
update_sex <- function(gen) {
  # split the string and select the first element
  sex <- strsplit(gen,'')[[1]][[1]]
  # return the first element
  return(sex)
}

#' Function to update the ethnicity.
update_ethn <- function(in_int) {
  # convert NA to -1 to allow int conversion
  if(is.na(in_int)) {
    in_int <- -1
  }
  if (in_int == 1) {
    return('H_L')
  } else if (in_int == 2) {
    return('Not_HL')
  } else {
    return('Not_Given')
  }
}

#' Function to set the lethality.
set_leth <- function(df) {
  # iterating through the rows
  for(this_row in 1:nrow(df)) {
    # if the group is ATT
    if (df[this_row, 'group'] == 'ATT') {
      # then overwrite the group value with the lethality value
      df[this_row, 'group'] = df[this_row, 'lethality']
      # handle for Protect team's naming convention
    } else if (df[this_row, 'group'] %in% c('IDE', 'DEP', 'DNA')) {
      df[this_row, 'group'] = 'NON'
    }
    # set everything its uppercase form
    df[this_row, 'group'] = toupper(toString(df[this_row, 'group']))
  }
  # return the updated row
  return(df)
}

#' Function to handle NA in edu data.
clean_edu <- function(df) {
  # iterating through the rows
  for(this_row in 1:nrow(df)) {
    # if the group is ATT
    if (is.na(df[this_row, 'edu'])) {
      # then set the edu to -1
      df[this_row, 'edu'] = -1
    }
  }
  # return the updated row
  return(df)
}

#' Function to validate that master demo is up to date with the protocol
validate_masterdemo_updated <- function(master_demo, protocol, protocol_name) {
  # check that the length of master demo and the protocol dataframe match
  # after accounting for participant status
  md_positive_status_only <- master_demo %>%
    filter(get(paste0('registration_ptcstat___', protocol)) == 1)
  ### TODO ###
  # Update this to check correct protocol if need be for processing
}

#' Function to try binding the master demo to the protocol data
validate_masterdemo_premerge <- function(master_demo, protocol, protocol_name) {
  tryCatch({
    # check that the number in master demo match the protocol
    md_ids <- master_demo$registration_redcapid
    prot_ids <- protocol$registration_redcapid
    # check if in master demo, but not the protocol
    in_md_not_protocol <- setdiff(md_ids, prot_ids)
    #unique(md_ids[! md_ids %in% prot_ids])
    cat("Subjects in Master Demo: \n")
    cat(toString(md_ids))
    cat("\n")
    # check if in protocol, but not master demo
    in_protocol_not_md <- setdiff(prot_ids, md_ids)
    #unique(prot_ids[! prot_ids %in% md_ids])
    cat("Subjects in this Protocol: \n")
    cat(toString(prot_ids))
    cat("\n")
    # Note the number of difference
    cat("Number of mismatched participants: \n")
    cat(toString(length(in_md_not_protocol) + length(in_protocol_not_md)))
    cat("\n")
    # if the sum of these sets is > 0
    if(length(in_md_not_protocol) + length(in_protocol_not_md) > 0) {
      # Note to the user that this is a problem
      cat("Master Demo and Protocol dataframes do NOT match.")
      # if exists in md and not protocol
      if(length(in_md_not_protocol) > 0) {
        cat("These subjects exist in Master Demo, but not the Protocol: \n")
        cat(in_md_not_protocol)
        cat('\n')
        cat("These subjects exist in your Protocol:\n")
        cat(protocol$registration_redcapid)
        cat('\n')
      }
      # if exists in protocol and not md
      if(length(in_protocol_not_md) > 0) {
        cat("These subjects exist in Protocol, but not the Master Demo: \n")
        cat(in_protocol_not_md)
        cat('\n')
        cat("These subjects exist in Master Demo:\n")
        cat(master_demo$registration_redcapid)
        cat('\n')
      }
      # exit the run
      exit()
    }
    # check that master demo is updated
    md_ids_not_updated <- master_demo %>%
      # Filter our ptcstat -> If they are scanned, they must already
      # be consented for this study.
      filter(get(paste0('registration_ptcstat___', protocol_name)) == 1) %>%
      '$'("registration_redcapid") %>% unlist
    # check if in protocol, but registered consented in master demo
    in_protocol_not_updated_md <- setdiff(prot_ids, md_ids_not_updated)
    # if there are subjects that need updated
    if(length(in_protocol_not_updated_md) > 0) {
      # Note a warning to the user
      cat("These subjects need their status updated in Master Demographic: \n")
      # list the participants
      cat(in_protocol_not_updated_md)
      cat('\n')
      cat("
          NOTE: it is possible these subjects have been consented in an old
          study, but are not yet consented in the new study if this is
          combined data.")
      cat('\n\n')
    }
    # Note the successful validation
    cat("Master Demo and Protocol DB have been validated to merge.\n")
    # otherwise, has been validated, return the data to the pipeline
    return(master_demo)
  }, error = function(e) {
    # Report the error to the user
    print(e)
    #cat('\n')
    # Note to the user the discrepancy
    cat("Master Demo and your Protocol could not be verified.\n")
    # exit the run
    exit()
  })
}

#' Function to grab data from master demo and merge.
#' @param md is a Master Demographic REDCapR object.
#' @param task_data the dataframe returned from REDCapR data object request.
#' @param protocol is the project we want data from.
#' @param other_fields a vector of extra fields to get from Master Demo.
#' @returns The selected Master Demo data merged with task/protocol data.
#' @examples
#' get_md_data(md=master_demo, task_data=bsocial_trust, protocol='bsocial')
#' @export
get_md_data <- function(md, task_data, protocol, other_fields=c()) {
  # fields to grab from redcap
  my_fields = c('registration_redcapid',
                'registration_lethality',
                'registration_ptcstat',
                'registration_group',
                'registration_dob',
                'registration_race',
                'registration_gender',
                'registration_edu',
                'registration_hispanic')
  # append any extra fields to fetch
  my_fields <- append(my_fields, other_fields)
  ## UNCOMMENT THE BELOW CODE TO SAVE MD RESULTS TO GLOBAL FOR DEBUGGING ##
  # md_info_global <<- md$read(fields=my_fields,
  #                    records=task_data$registration_redcapid)$data
  # wrangle the data
  md_info <- md$read(fields=my_fields,
                     records=task_data$registration_redcapid)$data %>%
    validate_masterdemo_premerge(protocol=task_data, protocol_name=protocol) %>%
    #filter(get(paste0('registration_ptcstat___', protocol)) == 1) %>%
    filter(registration_redcapid %in% task_data$registration_redcapid) %>%
    rename(AI_AN = registration_race___1, # rename race
           Asian = registration_race___2,
           Black_AA = registration_race___3,
           NH_PI = registration_race___4,
           White = registration_race___5,
           Not_Given = registration_race___999,
           lethality = registration_lethality,
           id = registration_redcapid, # rename other variables
           group = registration_group,
           ethnicity = registration_hispanic,
           gender = registration_gender,
           edu = registration_edu,
           dob = registration_dob) %>%
    # select the wanted variables
    select(AI_AN, Asian, Black_AA, NH_PI, White, Not_Given,
          lethality, id, group, ethnicity, gender, edu, dob) %>%
    #print() %>%
    #update the ethnicity
    mutate(ethnicity = sapply(ethnicity, update_ethn)) %>%
    set_leth %>% # update the lethality
    clean_edu %>% # fix the edu
    cbind(task_data) %>% # merge by subject id
    # get the age at scan in years
    mutate(age_at_scan = interval(dob, scan_date) %/% years(1)) %>%
    mutate(gender = sapply(gender, update_sex)) %>% # set the biological sex
    select(-lethality, -contains('scan_tasks___')) # drop unneeded columns
  # return the wrangled data
  return(md_info)
}

#' Function to grab data and merge it with master demo.
#' @param cfg is the path to the lab's json configuration file. (Required)
#' @param protocol is the project we want data from.
#' @param task is the specific task we want data for.
#' @param other_fields a vector of extra fields to get from Master Demo.
#' @returns The selected Master Demo data merged with task/protocol data.
#' @examples
#' get_merged_data(md=master_demo, task_data=bsocial_trust, protocol='bsocial')
#' @export
get_merged_data <- function(cfg, protocol, task, other_fields=c()) {
  # load a project for master demo
  md <- get_masterdemo(cfg=cfg)
  # load a project for the protocol
  rc_project <- get_project(cfg=cfg, protocol=protocol)
  # grab the protocol's task data
  task_data <- get_redcap_data(data=rc_project, protocol=protocol,
                             task=task, fields=cfg, events=cfg, cfg=cfg)
  # merge with master demo
  merged <- get_md_data(md=md, task_data=task_data, protocol=protocol,
                        other_fields=other_fields)
  # return the merged data
  return(merged)
}

#' Function to get the percent hispanic/latino.
get_perc_hl <- function(data, group=NA) {
  #print(group)
  # applying to a dataframe
  if(is.na(group)){
    num_HL <- data %>%
      filter(ethnicity == 'H_L') %>%
      summarize(n = n()) %>% '[['(1)
  # applying to a group of a dataframe
  } else {
    # get the number of HL
    num_HL <- data %>% filter(group == group[[1]]) %>%
      filter(ethnicity == 'H_L') %>%
      summarize(n = n()) %>% '[['(1)
  }
  # get the total
  num_tot <- data %>% summarize(n = n()) %>% '[['(1)
  # get the percentage
  perc_hl = round((num_HL/num_tot)*100, 2)
  # return the percentage
  return(perc_hl)
}

#' Function to get the percent female.
get_perc_f <- function(data, group=NA) {
  #print(group)
  # applying to a dataframe
  if(is.na(group)){
    num_F <- data %>%
      filter(gender == 'F') %>%
      summarize(n = n()) %>% '[['(1)
    # applying to a group of a dataframe
  } else {
    # get the number of HL
    num_F <- data %>% filter(group == group[[1]]) %>%
      filter(gender == 'F') %>%
      summarize(n = n()) %>% '[['(1)
  }
  # get the total
  num_tot <- data %>% summarize(n = n()) %>% '[['(1)
  # get the percentage
  perc_f = round((num_F/num_tot)*100, 2)
  # return the percentage
  return(perc_f)
}

#' Small function to get the groups for a protocol.
get_groups <- function(cfg_path, protocol) {
  # try to getv the groups
  tryCatch({
    # use jsonlite to grab the groups from the cfg file
    project_groups <- jsonlite::fromJSON(cfg_path)$protocols[[protocol]]$groups
    # returns the groups
    return(project_groups)
  # if the groups not found
  }, error = function(e) {
    # defualt to returning an NA
    return(NA)
  })
}

#' Function to run the demographic stats.
#' @return Returns a dataframe of the demographic data summary stats.
#' @param merged_df is a merged dataframe of Master Demo and a Project.
#' @param defined_groups a vector of strings identifying our groups.
#' @examples
#' get_demo(merged_df=my_df, defined_groups=c('HL', 'LL', 'HC', 'NON'))
#' @export
get_demo <- function(merged_df, defined_groups=NA) {
  # if no groups are defined
  if(anyNA(defined_groups)) {
    defined_groups <- unique(merged_df['group'])[[1]]
  }
  merged_df <- as_tibble(merged_df)
  # get the total stats
  scanned <- merged_df %>%
    mutate(perc_HL = get_perc_hl(cur_data())) %>%
    mutate(perc_F = get_perc_f(cur_data())) %>%
    summarise(N = n(), # run the summary
              AI_AN = sum(AI_AN),
              Asian = sum(Asian),
              Black_AA = sum(Black_AA),
              NH_PI = sum(NH_PI),
              White = sum(White),
              perc_HL = unique(perc_HL),
              perc_F = unique(perc_F),
              Mean_Age = round(mean(age_at_scan), 1),
              Stdev_Age = round(sd(age_at_scan), 3),
              Mean_Edu = round(mean(edu[edu != -1]), 1),
              Stdev_Edu = round(sd(edu[edu != -1]), 3)) %>%
    mutate(group = "SCANNED") # add a group of SCANNED
  # get the  stats
  total <- merged_df %>%
    filter(group %in% defined_groups) %>% # drop any improper groups
    mutate(perc_HL = get_perc_hl(cur_data())) %>%
    mutate(perc_F = get_perc_f(cur_data())) %>%
    summarise(N = n(), # run the summary
              AI_AN = sum(AI_AN),
              Asian = sum(Asian),
              Black_AA = sum(Black_AA),
              NH_PI = sum(NH_PI),
              White = sum(White),
              perc_HL = unique(perc_HL),
              perc_F = unique(perc_F),
              Mean_Age = round(mean(age_at_scan), 1),
              Stdev_Age = round(sd(age_at_scan), 3),
              Mean_Edu = round(mean(edu[edu != -1]), 1),
              Stdev_Edu = round(sd(edu[edu != -1]), 3)) %>%
    mutate(group = "TOTAL") # add a group of TOTAL
  # get the stats by group
  groups <- merged_df %>%
    filter(group %in% defined_groups) %>% # drop any improper groups
    group_by(group) %>% # split by group
    mutate(perc_HL = get_perc_hl(cur_data(), cur_group())) %>%
    mutate(perc_F = get_perc_f(cur_data(), cur_group())) %>%
    summarise(N = n(), # run the summary
              AI_AN = sum(AI_AN),
              Asian = sum(Asian),
              Black_AA = sum(Black_AA),
              NH_PI = sum(NH_PI),
              White = sum(White),
              perc_HL = unique(perc_HL),
              perc_F = unique(perc_F),
              Mean_Age = round(mean(age_at_scan), 1),
              Stdev_Age = round(sd(age_at_scan), 3),
              Mean_Edu = round(mean(edu[edu != -1]), 1),
              Stdev_Edu = round(sd(edu[edu != -1]), 3))
  # combine the total and by group
  demo_data <- rbind(total, scanned, groups)
  # return the demographic data
  return(demo_data)
}

# #' Function to run any extra data checking and merging with master demo.
# extra_checks <- function() {
#
# }

#' Wrapper function to check
#' @description
#' This funtion will attempt to execute a check for the data of the given
#' modality that should be named:
#'   have_<modality>_data()
#'
#'   Example:
#'     have_behavior_data()
#'
#' @return Returns a dataframe of the modality of data requested.
#' @param cfg is the path to the lab's json configuration file. (Required)
#' @param modality is the modality of data to check (example: behavior)
#' @param local_root is the root directory to start checking from.
#' @param data_path is the path from the local_root to the data.
#' @param my_required is a subset of the requirements from cfg.
#' @param drop_failed will drop subjects without data if set to TRUE.
#' @examples
#' have_data(cfg='/Volumes/bierka_root/datamesh/behav/redcap3.json',
#' modality='behavior', protocol='bsocial', task='trust', local_root='/Volumes',
#' my_required = c("edat_scan", "text_scan"), drop_failed=TRUE)
#' @export
have_data <- function(cfg, modality, local_root='', data_path=NA,
                      my_required=NA, drop_failed=FALSE, ...) {
  # run the function
  # First try should be assuming that a task name is given,
  # Notes that the task has a specific run case
  tryCatch(
    expr = {
      # get the total list of arguments from the ... argument
      in_args <- c(as.list(environment()), list(...))
      # drop modality from our arguments
      in_args[["modality"]] <- NULL
      # drop drop_failed from our arguments
      in_args[["drop_failed"]] <- NULL
      print(in_args)
      # get the execution string
      call_func <- paste0('have_', modality, '_data')
      print(call_func)
      # executes 'have_<modality>_data()'
      checked_data <- do.call(what=call_func, args=in_args)
      # if orig_ids is given and no NAs exist in the given list
      if(drop_failed == TRUE) {
        # drop these ids from the returned data
        # NOTE: This assumes that the returned result must be a dataframe/tibble
        # Note this to the user
        print(paste0("Dropping participants without ", modality, " data."))
        # NOTE: ids must be a column called '<modality>_pass'
        checked_data <- checked_data %>% filter(get(paste0(modality, '_pass'))
                                                == TRUE)
      }
      # return the data check
      return(checked_data)
    },
    error = function(e){
      # Note to the user that
      print("Failed to check the ", modality, " data for this run.")
      # return the input data
      return(data)
    }
  )
}

#' Function to run the master demo data pull for a task/protocol.
#' @description
#' Function that can be used to mount remote data if needed, run a
#' demographic report, and chose how the result is saved. Will return
#' NA if return_data and return_demo are not TRUE. Otherwise will return a list
#' with either or both the data and demographic results.
#' @return Based on return_data and return_demo inputs.
#' @param cfg is the path to the lab's json configuration file. (Required)
#' @param protocol is the project we want data from.
#' @param task is the specific task we want data for.
#' @param other_fields a vector of extra fields to get from Master Demo.
#' @param mnt_path is the directory to try and remount.
#' @param remote_name is the name of the configured rclone remote.
#' @param remote_path is the path to the remote directory to mount locally.
#' @param attempt sets the attempt number you are on.
#' @param max_attempts sets the max number of mount attempts.
#' @param trap if set to TRUE, the mount will not persist after the session.
#' @param save if set to TRUE, will save the results as csvs.
#' @param load_env if set to TRUE, will load the data to the global env.
#' @param include_timestamp will add a timestamp to the saved output.
#' @param return_data if set to TRUE will return the resultant dataframe.
#' @param return_demo if set to TRUE will return the resultant demographic.
#' @examples
#' run_demographic_report(cfg="/Volumes/bierka_root/datamesh/behav/redcap3.json",
#' protocol="bsocial", task="trust", load_env=TRUE)
#' @export
run_demographic_report <- function(cfg, protocol, task, other_fields=c(),
                                   out_dir=getwd(), load_env=FALSE,
                                   mnt_path=NA, remote_name=NA, remote_path=NA,
                                   max_attempts=5,trap=FALSE,
                                   save=FALSE, include_timestamp=FALSE,
                                   return_data=FALSE, return_demo=FALSE, ...) {
  # mount remote data if need be
  # will only run if all 3 varaiables are set
  if (!(is.na(mnt_path)) || !(is.na(remote_path)) || !(is.na(remote_name))) {
    mnt_result <- mnt_remote_data(mnt_path=mnt_path, remote_name=remote_path,
                                  remote_path=remote_path, attempt=1,
                                  max_attempts=max_attempts, trap=trap)
    # if the mount failed
    if(mnt_result == FALSE) {
      # Note to the user that this is not running due to failed mount
      print("Not running demographic report due to failed mount.")
      # return NA
      return(NA)
    }
  }
  # get protocol data merged with master demo
  data <- get_merged_data(cfg, protocol, task, other_fields=other_fields)
  # get a basic timestamp
  tm_stamp <- get_time_stamp(include_timestamp)
  # save the aggregate csv if set to
  if(save == TRUE) {
    # get the output path
    full_out_path_data <- paste0(out_dir, '/', tm_stamp, protcol, '_', task,
                            '_data.csv')
    # save the file
    write.csv(data, full_out_path_data)
  }
  # load into the R environment if set to
  if(load_env == TRUE) {
    # get the variable to dave the data to
    data_var <- paste0(protocol, '_', task, '_data')
    # create the variable in the global scope
    assign(data_var, data, envir = .GlobalEnv)
  }
  # initialize a return list
  return_list <- list()
  # if returning the data
  if(return_data == TRUE) {
    return_list[['data']] <- data
  }
  # get the appropriate groups for the protocol
  proj_groups <- get_groups(cfg_path=cfg, protocol=protocol)
  # get the demographic report
  data <- get_demo(merged_df=data, defined_groups=proj_groups)
  # save the demo if set to
  if(save == TRUE) {
    # get the output path
    full_out_path_data <- paste0(out_dir, '/', tm_stamp, protcol, '_', task,
                                 '_demo.csv')
    # save the file
    write.csv(data, full_out_path_data)
  }
  # load into the R environment if set to
  if(load_env == TRUE) {
    # get the variable to dave the data to
    data_var <- paste0(protocol, '_', task, '_demo')
    # create the variable in the global scope
    assign(data_var, data, envir = .GlobalEnv)
  }
  # if returning the demo
  if(return_data == TRUE) {
    return_list[['demo']] <- data
  }
  # do some clean up of the list, drop NAs
  return_list <- return_list[!is.na(return_list)]
  # if the resultant list if empty
  if(is_empty(return_list) == TRUE) {
    # then just return NA
    return(NA)
  }
  # return the return list
  return(return_list)
}

#' Function to run the backup of an entire REDCap data dictionary.
#' @description
#' Goal of this is to pull all fields for all records and export this
#' as a single csv. Similar to the download csv functionality of
#' the REDCap UI. Uses the REDCapR tool to accomplish the download.
#' @return An output csv that backs up REDCap data.
#' @param cfg is the path to the lab's json configuration file. (Required)
#' @param protocol is the project we want data from.
#' @param out_dir is the directory to save the output to (Defaults to current)
#' @param mnt_path is the directory to try and remount.
#' @param remote_name is the name of the configured rclone remote.
#' @param remote_path is the path to the remote directory to mount locally.
#' @param attempt sets the attempt number you are on.
#' @param max_attempts sets the max number of mount attempts.
#' @param trap if set to TRUE, the mount will not persist after the session.
#' @param include_timestamp will add a timestamp to the saved output.
#' @examples
#' backup_redcap(cfg="/Volumes/bierka_root/datamesh/behav/redcap3.json",
#' protocol="bsocial", out_dir="/Users/dnplserv/Desktop",
#' include_timestamp=TRUE)
#' @export
backup_redcap <- function(cfg, protocol, out_dir=getwd(), mnt_path=NA,
                          remote_name=NA, remote_path=NA,
                          max_attempts=5, trap=FALSE,
                          include_timestamp=FALSE) {
  # mount remote data if need be
  # will only run if all 3 varaiables are set
  if (!(is.na(mnt_path)) || !(is.na(remote_path)) || !(is.na(remote_name))) {
    mnt_result <- mnt_remote_data(mnt_path=mnt_path, remote_name=remote_path,
                                  remote_path=remote_path, attempt=1,
                                  max_attempts=max_attempts, trap=trap)
    # if the mount failed
    if(mnt_result == FALSE) {
      # Note to the user that this is not running due to failed mount
      print("Not running REDCap backup due to failed mount.")
    }
  }
  # if backing up master demo
  if(protocol == "master_demo") {
    # get the redcap master demo project from the config data
    rc_proj <- get_masterdemo(cfg)
  # otherwise, asume we are backing up a standard protocol
  } else {
    # get the redcap project from the config data
    rc_proj <- get_project(cfg, protocol)
  }
  # run the data fetch
  rc_data <- rc_proj$read()$data
  # get a timestamp for the output csv
  tm_stamp <- get_time_stamp(include_timestamp)
  # get the full path of where to save the data to
  full_out_path <- paste0(out_dir, '/', tm_stamp, "redcap_backup.csv")
  # save the csv
  write.csv(rc_data, full_out_path)
}

#' Function to make a simple timestamp or return an empty string.
#' @description
#' Designed to return a timestamp as a string. Allows the input variable to
#' be set to an empty string so that you can always use this as part of a paste
#' command (in which an empty string will not modify the output string).
#' @return a timestamp for the curret moment as a string.
#' @param bool_in if set to FALSE, returns an empty string.
#' @examples
#' get_time_stamp()
#' @export
get_time_stamp <- function(bool_in=TRUE) {
  # if we want a timestamp
  if(bool_in == TRUE) {
    # use lubridate 'now' function to get a timestamp
    tm_stamp <- paste0(str_replace_all(as.Date(now()), '-', '_'), '_')
    # if we do not want a timestamp
  } else {
    # set the timestamp to an empty string for empty concatenation
    tm_stamp <- ''
  }
  # return the timestamp
  return(tm_stamp)
}

#' Function to get the required data for a task.
get_task_completion_requirements <- function(cfg, task, modality=NA) {
  # if modality is not specified
  if(is.na(modality)) {
    # get all requirements
    required <- jsonlite::fromJSON(cfg)$tasks[[task]]$required
  # otherwise, grab all of the required data
  } else {
    # get that modality's requirements
    required <- jsonlite::fromJSON(cfg)$tasks[[task]]$required[[modality]]
  }
  # return theb required data
  return(required)
}

#' Function to get the regex to identify real participant ids of a protocol.
get_real_id_regex <- function(cfg, protocol) {
  # grab this item from the config file
  id_regex <- jsonlite::fromJSON(cfg)$protocols[[protocol]]$ids
  # return the regex
  return(id_regex)
}

#' Function to get the ids from a directory of subject data.
get_subj_ids_from_dir <- function(cfg, protocol, data_path) {
  # get the regex for subject ids for the protocol
  id_regex <- get_real_id_regex(cfg, protocol)
  # get directories
  all_dirs <- list.dirs(data_path, recursive=FALSE)
  # get the basenames -> ids
  all_dirs <- sapply(all_dirs, basename)
  # set the ids as the names
  names(all_dirs) <- all_dirs
  # run the regex
  subjs <- as_tibble(all_dirs) %>%
    mutate(id=value) %>% # add a new column of the ids
    mutate(match = str_detect(id, regex(id_regex))) %>% # run the regex
    filter(match == TRUE) %>% # drop anything that does not match
    select(id) # keep only the subject id column
  # return the subject id dataframe
  return(subjs)
}

#' Function to get the path to data given by cfg
get_data_path_cfg <- function(cfg, protocol, kword, type=NA) {
  # if a type is not given
  if(!is.na(type)) {
    # grab this item from the config file
    data_path <-
      jsonlite::fromJSON(cfg)$protocols[[protocol]] %>% # access the cfg data
      '[['(type) %>% # access the data type
      '[['(kword) # access the data identifying keyword
    # return the data path
    return(data_path)
  # otherwise, just grab the data by its keyword
  } else {
    # grab this item from the config file
    data_path <-
      jsonlite::fromJSON(cfg)$protocols[[protocol]] %>% # access config file
      '[['(kword) # access the data identifying keyword
    # return the data path
    return(data_path)
  }
}

#' Function to get the path to data.
get_data_path <- function(cfg, protocol, task, kword, local_root='',
                                     type=NA, data_path=NA) {
  # run two attempts to get the data
  tryCatch({
    # if the data_path is not given
    if(is.na(data_path) == TRUE) {
      # first try to get the data path from the cfg
      cfg_data_path <- get_data_path_cfg(cfg=cfg, protocol=protocol,
                                         kword=kword, type=type)
      # get the full path
      full_data_path <- paste0(local_root, '/', cfg_data_path)
    # otherwise, use the data_path given
    } else {
      # get the path to the data
      full_data_path <- paste0(local_root, '/', data_path)
    }
    # if this path does not exist
    if(dir.exists(full_data_path) == FALSE) {
      # Report to user that the cfg path was not found
      print("Using path from your config file failed.")
      print("This path did not exist:")
      print(full_data_path)
      cat("\n")
      exit()
    }
  # otherwise, try the default <task>_<protocol> behavior
  }, error = function(e) {
    # Report the error to the user
    #print(e)
    print(paste0("Unable to find the data for the ", task,
                 " task from the ", protocol, " protocol."))
  })
  # return the full data path
  return(full_data_path)
}

#' Function to check if all values in a row are true across an entire dataframe.
all_rows_true <- function(input_tibble, col_name) {
  # initialize a list to hold the responses
  bool_list <- list()
  # iterate over each of the input tibble
  for(i in 1:nrow(input_tibble)) {
    #print(input_tibble[i,][1])
    # values are TRUE if all values are TRUE or FALSE otherwise
    bool_list <- append(bool_list, all(input_tibble[i,]))
  }
  # add the bool_list to the tibble as a new column
  output_tibble <- input_tibble %>%
    mutate("{col_name}" := unlist(bool_list))
  # return the tibble
  return(output_tibble)
}

#' Function to check all data requirements.
#' Simply iterates over the requirements and applies the changes
#' to the given id tibble based on the data-checking functions.
check_all_data <- function(ids, required_list, modality=NA, col_suffix=NA,
                           my_required=NA) {
  # initialize the return datafram for this function
  ids_and_check <- ids
  #required_list_global <<- required_list
  # if selecting a subset of criteria
  if(!anyNA(my_required)) {
    # get the requirements selected tp check
    selected_required_list <- required_list %>%
      as_tibble() %>% # convert to a tibble
      select(my_required) %>% # run the selection
      as.list()
  # otherwise, select all
  } else {
    selected_required_list <- required_list
  }
  # index counter
  cur_req <- 1
  # iterate through the required_list
  for(requirement in selected_required_list) {
    # get the requirement name
    req_name <- names(selected_required_list)[[cur_req]]
    # run the requirement
    ids_and_check <- ids_and_check %>% mutate("{req_name}" :=
                    get_id_path_grepl_count(full_path, requirement)) %>%
      # check that the min number of matches was found
      mutate("{paste0(req_name, '_min')}" :=
               get(req_name) >= requirement$min) %>%
      # check that the max has not been met
      mutate("{paste0(req_name, '_max')}" :=
               get(req_name) <= requirement$max)
    # increment the index
    cur_req <- cur_req + 1
    #print(cur_req)
  }
  # print(ids_and_check[18:20,])
  # get a tibble of only the min and max argument
  min_and_max <- ids_and_check %>%
    select(matches('min$|max$')) #%>%
  # get the column name for the final check on this modality
  # if a modality is given
  if(!is.na(modality)) {
    # use the modality in the column name
    col_name <- paste0(modality, "_all_true")
    # otherwise, just call the column "all_true
  } else {
    col_name <- "all_true"
  }
  # if a column suffix is given
  if (!is.na(col_suffix)) {
    # replace all_true with the given suffix
    col_name <- str_replace(col_name, "all_true", col_suffix)
  }
  # set _pass for the requirement to signify we found all
  # expected data for this requirement (TRUE if data found)
  min_and_max <-
    # add a column that identifies if we hit our min/max range
    all_rows_true(min_and_max, col_name=col_name) %>%
    # return only that new column
    select(col_name)
  # add the _pass column to the final output
  ids_and_check <- ids_and_check %>% add_column(min_and_max)
  # return the tibble
  return(ids_and_check)
}

# #' Function to check if the we are within the min and max match count for
# #' all file checks.
# check_match_count <- function() {
#
# }

# #' Function to check if a directory has the correct range of files.
# check_file_count <- function() {
#
# }

#' Function to check that a subject has data for a set of ids.
#' @description
#' Requirements are min, max, grep, keywords, exclude, and
#' file_count. Min and max are the min and max number of matches
#' for a particular data check (set to -1 if not checking). The
#' grep argument is a grep string to match over. Keywords and
#' exclude are sub strings that must be included or must be ignored
#' in the grep match, respectively. Finally, file_count is the number
#' of file if the result is a directory (set to 0 if it is a file).
#' @return a tibble with a variable that if the data exists for each id.
#' @param ids is a tibble with a column named "id".
#' @param requirements is a list as described in the description.
#' @export
check_id_path_data <- function(ids, requirement) {
  # get the requirement name
  req_name <- names(requirement)
  # get a boolean for each id as to whether the requirement was met or not
  meet_requirement <- ids %>% # load the id tibble
    # get the number of matches
    mutate("{req_name}" :=
             get_id_path_grepl_count(ids, requirement$grep))
  #############################################
  # Will need to come back here and add
  # logic to check if dir or file and
  # process file count.
  #############################################
  # return the tibble
  return(meet_requirement)
}

#' Function to get the number of matches if id paths to a grepl
get_id_path_grepl_count <- function(full_path, requirement) {
  # id_tibble[1,2][[1]]
  #print(full_path)
  # nested function to get the count
  get_count <- function(single_full_path, requirement) {
    # create a grepl-usbale string from the kwords input
    #kwords <- paste0('*', requirement$kwords, '*')
    kwords <- requirement$kwords
    # create a grepl-usbale string from the exclude input
    #exclude <- paste0('*', requirement$exclude, '*')
    exclude <- requirement$exclude
    # initialize the return variable
    count_result <- list.files(single_full_path)
    # if keywords are given
    if(!is_empty(requirement$kwords)) {
      # run the keyword check
      count_result  <<-
        sapply(kwords, grep,
               count_result, value=TRUE)
    }
    # if exclude words are given
    if(!is_empty(requirement$exclude)) {
      # run the exclude check
      count_result <-
        sapply(exclude, grep,
               count_result, value=TRUE, invert=TRUE)
    }
    # get the count
    count_result <-
      # modify the below line to use the previous input
      #grepl(requirement$grep, list.files((single_full_path))) %>% # OLD INPUT
      grepl(requirement$grep, count_result) %>%
      as_tibble %>% # convert to a tibble
      filter(value == TRUE) %>% # only keep TRUE values
      summarise(n = n()) %>% '[['(1) # get the number of TRUE values
    # return the count
    return(count_result)
  }
  # get the number of matches in the file system
  num_matches <- sapply(full_path, get_count, requirement)
  # return the count
  return(num_matches)
}

#' Function to check for existence of behavioral data.
#' Assumes that data is stored in a directory identified as
#' <task>_<protocol>. This checks for a simple existence of the
#' subject ID as a directory under <task>_<protocol> and then
#' uses grep to check for the required files. This required at least
#' one match to each file. This will return a dataframe of the
#' subjects and whether or not they have complete behavioral data.
have_behavior_data <- function(cfg, protocol, task, local_root='',
                                data_path=NA, my_required=NA) {
  print(data_path)
  print(local_root)
  # get the required data
  required <- get_task_completion_requirements(cfg=cfg, task=task,
                                               modality="behavior")
  # get the path to the data
  full_data_path <- get_data_path(cfg, protocol, task, local_root=local_root,
                                  kword=task, type='behav_paths',
                                  data_path=data_path)
  # get the list of subjects in that path as a datatable
  subjs <- get_subj_ids_from_dir(cfg, protocol, full_data_path)
  # get append the full paths as part of the tibble
  ids_and_paths <- subjs %>%
    mutate(full_path = paste0(full_data_path, '/', id)) #%>% # get full paths
  # run the grep check across the ids
  #have_required_data <- ids_and_paths %>%
  #  mutate(check_all_data(required_list=required))
  have_required_data <- check_all_data(ids=ids_and_paths,
                                       required_list=required,
                                       modality="behavior",
                                       col_suffix="pass",
                                       my_required=my_required)
  # get the subjects that are missing behavioral data
  missing <- have_required_data %>%
    filter(behavior_pass == FALSE) %>% select(id) %>% '[['(1)
  # print that these subjects did not have complete behavioral data
  print("The following subjects are missing behavioral data:")
  print(missing)
  # return the dataframe of ids with behavioral data
  return(have_required_data)
}

#' Function to check for existence of legacy scanning data.
get_meson_data <- function(cfg, protocol, task, local_root='',
                           data_path=NA) {

}

#' Function to check for existence of xnat scanning data.
#' Specifically, this will be data downloaded with the DNPL's
#' fork of DAX.
get_dax_data <- function(cfg, protocol, task, local_root='', data_path=NA) {

}

#' Function that checks for existence of xnat scanning data and then
#' checks meson data for anything not found.
get_dax_meson_data <- function(cfg, protocol, task,  local_root='',
                               xnat_path=NA, meson_path=NA) {

}

#' Function to filter the bsocial scan data by task.
get_bsocial_task_redcap <- function(data, task, ...) {
  bs_scan_info <- data %>%
    filter(!is.na(scan_date)) %>% # get subjects with scan dates
    select('registration_redcapid', 'scan_date', paste0('scan_tasks___',
                                          task)) %>% # get the exact task wanted
    filter(get(paste0('scan_tasks___', task)) == 1) # select items equal to 1
  # return the dataframe
  return(bs_scan_info)
}

#' Function to filter the explore scan data by task.
get_explore_task_redcap <- function(data, task, ...) {
  exp_scan_info <- data %>%
    filter(scan_protocol == 'e1') %>% # get the subjects in explore from protect
    filter(!is.na(scan_date)) %>% # get subjects with scan dates
    select('registration_redcapid', 'scan_date',
           paste0('scan_exploretasks___', task)) %>% # get the exact task wanted
    filter(get(paste0('scan_exploretasks___', task)
    ) == 1) %>% # select only items equal to 1
    group_by(registration_redcapid) %>%
    filter(n()==1) # for some reason we need to drop duplicate entries
  # return the dataframe
  return(exp_scan_info)
}

#' Function to filter the explore2 scan data by task.
get_explore2_task_redcap <- function(data, task, ...) {
  exp2_scan_info <- data %>%
    filter(scan_protocol == 'e2') %>% # get the subjects in explore from protect
    filter(!is.na(scan_date)) %>% # get subjects with scan dates
    select('registration_redcapid', 'scan_date',
           paste0('scan_exploretasks___', task)) %>% # get the exact task wanted
    filter(get(paste0('scan_exploretasks___', task)
    ) == 1) %>% # select only items equal to 1
    group_by(registration_redcapid) %>%
    filter(n()==1) # for some reason we need to drop duplicate entries
  # return the dataframe
  return(exp2_scan_info)
}

#' Function to filter explore2 scan data for clock, requires merge with explore.
get_explore2_clock_redcap <- function(data, cfg, ...) {
  # NOTE: functions from the main script are used since they will already be
  # sourced into the global environment at this point
  # source the explore task function
  source("protocols/explore.R")
  # create an explore1 project
  exp1_proj <- get_project(cfg_path=cfg, protocol="explore")
  # get the explore1 fields
  fields <- jsonlite::fromJSON(cfg)$protocols[["explore"]]$fields
  # fetch the exp1 clock data
  exp1_data <- exp1_proj$read(fields=fields)$data
  # get the explore1 clock data
  exp1 <- get_explore_task_redcap(data=exp1_data, task='clock')
  # use the base function to grab the explore2 clock data
  exp2 <- get_explore2_task_redcap(data, task="clock")
  # rename the scan dates for each protocol
  exp1 <- exp1 %>% rename(exp1_scan_date = scan_date)
  exp2 <- exp2 %>% rename(exp2_scan_date = scan_date)
  # convert any dates from exp2 not in exp1 with Jan 1, 1000
  exp1[setdiff(names(exp2), names(exp1))] <- ymd(10000101)
  # convert any dates from exp1 not in exp2 with Jan 1, 1000
  exp2[setdiff(names(exp1), names(exp2))] <- ymd(10000101)
  # merge the clock1 and clock2 data
  data <- rbind(exp1,exp2)
  # set scan date to the most recent scan date between exp1 and exp2
  data <- data %>% mutate(scan_date = max(exp1_scan_date, exp2_scan_date))
  # return the data
  return(data)
}


