% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{lab.info}
\alias{lab.info}
\title{These are the utility functions for the data tracker.}
\usage{
lab.info()
}
\description{
-----------------------------------------------------------------------------

SUMMARY:

-----------------------------------------------------------------------------

All functions for the Decision Neuroscience and Psychopathology Lab at the
University of Pittsburgh Medical Center. This is a single-file R package that
was developed to connect to research data data across protocols and
modalities and even cloud storage resources by wrapping Rclone.

-----------------------------------------------------------------------------

GOAL:

-----------------------------------------------------------------------------

The design was meant to be simple, hence the single file. Abstract functions
are to be built that can then be utilized to quickly access data in a
uniform manner across protocols. This should, hopefully, reduce ad-hoc
scripting and make data management easier, faster, more precise and, most
importantly, extensible to new tasks, protocols, and data storage.
Essentially, this single page should be the main resource to use and refer
to for data management at the DNPL.

The only other files a user should need are:

  1. A configuration json file
    This should be provided by the current maintainer(s) in a private
    GitHub repo.
    A private GitHub repo was chosen as it provides easy access for lab
    members by using git clone.

  2. An rclone config file
    This is actually managed by rclone using the "rclone config" command.
    https://rclone.org/commands/rclone_config/

-----------------------------------------------------------------------------

MAINTAINERS:

-----------------------------------------------------------------------------

Current Maintainers:

  Shane Buckley: tshanebuckley<at>gmail.com

Previous Maintainers:

  NA

-----------------------------------------------------------------------------

FUNCTION NAMING RULES:

TODO: document all rules for function naming here.

-----------------------------------------------------------------------------

KEYWORDS and CONCEPTS:
TODO: have someone else update tasks and protocols

-----------------------------------------------------------------------------

PROTOCOLS:
  masterdemo:

  bsocial

  ksocial

  explore

  explore2

  momentum (not implemented yet)

  pandea (not implemented yet)

TASKS:
  clock

  trust

  spott

CLINICAL DATA/PROTOCOL STATUS SOURCES:
  redcap
    Database for storing participant data by identifiers.
    Used to track participant participation in protocols along with
    demographic data (Master Demographic).

    site:
      https://www.project-redcap.org/

    documentation:
      https://wiki.uiowa.edu/display/REDCapDocs/REDCap

    ctsi:
      https://ctsi.pitt.edu/guides-tools/data-management-resources/

    pitt:
      https://www.ctsiredcap.pitt.edu/redcap/

    R SDK for data fetching:
      https://ouhscbbmc.github.io/REDCapR/

    Python SDK for fetching data:
      https://pycap.readthedocs.io/en/latest/


RAW IMAGING DATA SOURCES/FORMATS:
  meson
    Database used before xnat to get imaging data from the MRRC.

  xnat
    Current database used to get imaging data from the MRRC.

    Python SDKs:
      xnatpy:
        https://xnat.readthedocs.io/en/latest/

      pyxnat:
        https://pyxnat.github.io/pyxnat/

    MRRC XNAT:
    Script used to pull data from MRRC (DNPL fork):
    https://github.com/DecisionNeurosciencePsychopathology/dax/blob/main/bin/Xnat_tools/Xnatdownload

    To Install:
      pip install git+https://github.com/DecisionNeurosciencePsychopathology/dax.git

    Example usage:

      Xnatdownload -p WPC-7341 -d /volume1/bierka_root/datamesh/RAW --subj all --sess all -s all -a all --rs all --ra all
      (Run as a cron job, the above function downloads all xnat data for bsocial.)

BRAIN IMAGING DATA STRUCTURE:
  bids
    Standardized format for brain imaging data.

    BIDS main page:
      https://bids.neuroimaging.io/
    BIDS documentation:
      https://bids-specification.readthedocs.io/en/stable/
    Python SDK:
      documentation:
        https://github.com/bids-standard/pybids
      tutorial:
        https://notebook.community/INCF/pybids/examples/pybids_tutorial
    Conversion(heudiconv):
      documentation:
        https://heudiconv.readthedocs.io/en/latest/
      tutorial:
        https://reproducibility.stanford.edu/bids-tutorial-series-part-2a/

IMAGING DATA PRE-PROCESSING:
  fmriprep
    Standardized preprocessing software that take BIDS-converted data as input.

    fMRIPrep Documentation:
      https://fmriprep.org/en/stable/

  clpipe:
    Wrapper to run fmriprep via a singularity container on a slurm cluster.

    clpipe documentation:
      https://clpipe.readthedocs.io/en/latest/

    clpipe github:
      https://github.com/cohenlabUNC/clpipe

    DNPL fork:
      https://github.com/DecisionNeurosciencePsychopathology/clpipe

  crc:
    University of Pittsburgh's HPC cluster for running slurm jobs.

    crc documentation:
      https://crc.pitt.edu/
      (Refer to this for Globus, Slurm, and general HPC usage documentation.)

    psychiatry visualization portal:
      https://crc.pitt.edu/psych
      (GPU-accelerated desktop interface for image visualization via FSL and AFNI.)

  longleaf:
    University of North Carolina Chapel Hill's HPC cluster for running slurm jobs.


LOCAL STORAGE:
  bierka
    80TB Synology NAS backed up via tape by the OAC and to the DNPL DataTeam SharePoint.
    This is our long-term storage server.

  milka
    40TB Synology NAS used for local scratch space for the DNPL.
    This is our short-term storage server.
    (Currently backup of Bek)

  bek
    Pegasus NAS containing legacy data.

  skinner
    Main SharePoint site for DNPL collaboration and behavioral data upload.

  rclone
    Software that allows the syncing and mounting of cloud storage.

    documentation:
      https://rclone.org/

  minio
    S3 compliant data bucket software (allows mounting Bierka via rclone).

    documentation:
      https://docs.min.io/docs/minio-quickstart-guide.html

  docker
    Containerization software (installed on Bierka).

    documentation:
      https://docs.docker.com/

  sharepoint
    Pitt's chosen cloud storage provided as of 2021.

-----------------------------------------------------------------------------
}
\examples{
?lab.cfg
}
