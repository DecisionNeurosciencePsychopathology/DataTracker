% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{remove_ds_store}
\alias{remove_ds_store}
\title{Function to handle .DS_Store file on Mac systems.
Will delete the folder if it is the only folder in the directory
This is so that rclone can mount without unsafely using the --allow-non-empty
option on all mount attempts.}
\usage{
remove_ds_store(mnt_path)
}
\description{
Function to handle .DS_Store file on Mac systems.
Will delete the folder if it is the only folder in the directory
This is so that rclone can mount without unsafely using the --allow-non-empty
option on all mount attempts.
}
