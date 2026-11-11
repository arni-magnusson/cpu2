---
name: taf-workflow-helper
description: Instructions for AI agent on how to create, modify, and run TAF
             workflows.
---

# TAF

## Definition

TAF is a standard format in R for scientific workflows, using the TAF package
that is available on CRAN.

## Steps

TAF divides a workflow into four steps:

Script     | Purpose
---------- | ---------------------------------
`data.R`   | Prepare data, write CSV tables
`model.R`  | Run model
`output.R` | Extract results, write CSV tables
`report.R` | Plots and tables for report

These scripts all share the same general structure, starting with loading
packages and reading in files, then performing computations and writing out
files. They are run sequentially in alphabetical order, where each script reads
from files created in a previous step.

## The boot folder

The initial data that are used in the analysis are declared in a file called
`DATA.bib`, which is processed by the `taf.boot` function. During this boot
procedure, each data entry is processed and the TAF system then makes the data
available in the `boot/data` subfolder, where the `data.R` script will read it.

Some TAF workflows also use an optional `SOFTWARE.bib` file to declare key
software used in the analysis and the version number. It is usually not
necessary to declare R packages available on CRAN.

## Dependencies

Since reproducibility is an important objective in TAF, there is a general
preference to write workflows with minimal or no dependencies if possible. This
recommendation applies especially to AI agents, but human authors can use
whatever packages they find practical.

# Running a TAF analysis

## Boot and run

Before running the analysis, the workflow consists of a `boot` folder and the
four TAF scripts: `data.R`, `model.R`, `output.R`, and `report.R`.

To run a TAF analysis, the first step is to start R and make sure that the
current working directory is set to the location of the TAF scripts.

All TAF analyses can be run using the following commands in R:

```
library("TAF")
taf.boot()
source.all()
```

The `taf.boot` function looks for an existing `boot` folder to set up the data
and software required for the analysis. Then `source.all()` runs the `data.R`,
`model.R`, `output.R`, and `report.R` scripts in that order. The individual
scripts can also be run from the command line using the `Rscript` command.

After running the analysis, each script has created a corresponding folder,
`data.R` creating a `data` folder, etc.

# Structured scripts

## General structure

The `data.R` script has populated the `data` folder with comma-separated values
(CSV) files representing the data that are used in the analysis and the
`model.R` script produced `model` results in an arbitrary format. The purpose of
the `output.R` script is to read the results from the `model` folder and write
out CSV files representing the results that are of primary interest. Finally,
`report.R` reads in the CSV output and produces plots and formatted tables,
often with rounded numbers, which can be incorporated into a report.

It is important to note that TAF does not do any of this by itself. All the work
is performed by the R scripts that the scientist writes. Typically, a TAF script
has the following general structure, demonstrated in pseudocode:

```
# What the script does

# Before: file1.csv, file2.rds, file3.spec (previous)
# After:  file4.csv, file5.csv, file6.png (folder)

library("TAF")
library("SomePackage")
source("utilities.R")

mkdir("folder")

# Read files from previous step
dat1 <- read.taf("previous/file1.csv")
dat2 <- readRDS("previous/file2.rds")
dat3 <- importSpecial("previous/file3.spec")

# Some computations
# [...]

# Write out tables and plots
write.taf(dat4, dir="folder")
write.taf(dat5, dir="folder")
taf.png("file6")
SpecialPlot(dat6)
dev.off()
```

## Online examples

Examples of TAF workflows, including the TAF scripts, can be found online at
https://github.com/ices-taf/2015_rjm-347d and
https://github.com/ices-taf/2015_had-iceg

# Modifying an existing TAF analysis

## Check workflow integrity

The integrity of a TAF workflow can be checked as follows:

1. Run `clean.boot(force=TRUE)` and `clean()` to remove residual files from
   earlier workflow runs.

2. Run `taf.boot()` to prepare the analysis, making sure that the `boot/data`
   folder contains the files that the `data.R` script will read.

3. Run `source.all()` to run the workflow.

4. Check that all four folders (data, model, output, report) have been created
   and contain some files.

The AI agent should check workflow integrity before making any changes to the
scripts. If the check fails, the AI agent should notify the user who will
collaborate with the AI agent to find out what needs to be improved.

## Editing the TAF scripts

If a workflow passes the integrity check, the AI agent can edit the TAF scripts
if instructed by the user. Use base R, unless the user has asked that certain
packages should be used.

The AI agent should check workflow integrity while making any changes to the
scripts. If the check fails, the AI agent should try again to implement the
features requested by the user without breaking the workflow integrity. If no
solution can be found, the AI agent should notify the user who will collaborate
with the AI agent to find out what needs to be improved.
