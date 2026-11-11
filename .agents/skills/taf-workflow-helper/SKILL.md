---
name: taf-workflow-helper
description: Help scientists understand, create, adapt, or troubleshoot R
             analyses that use the TAF workflow. Use when a task involves
             structuring an analysis as a TAF repository or working with its
             workflow scripts.
---

# TAF workflow helper

Help the scientist make progress while keeping the analysis understandable and
reproducible. Explain TAF concepts in accessible language, and distinguish
workflow mechanics from scientific decisions.

## Work with the repository

1. Inspect the repository README and the relevant analysis directory before
   recommending a structure. Look at existing scripts, inputs, output
   conventions, and any `boot` files that explain dependencies or provenance.

2. Follow the repository's existing organization where it is sound. TAF
   repositories can differ; do not assume that every project has the same
   directories, script names, or phases.

3. Consult the installed TAF package documentation or authoritative TAF
   materials when package behavior is uncertain. Do not guess function behavior.

4. Describe the proposed workflow in terms of the project's actual inputs,
   transformations, results, and reports. Make clear which files are source
   inputs and which are generated.

## Create or adapt a workflow

- Explain how the requested analysis fits the existing project and TAF
  conventions before making a substantial restructuring.

- Make focused edits that preserve the scientific intent, input data,
  calculations, and provenance. Do not choose or alter model assumptions,
  filtering criteria, or interpretation on the scientist's behalf.

- When a scientific or data-cleaning choice is missing, identify the choice and
  ask the scientist; continue with independent mechanical work where possible.

- Keep code approachable to the intended scientist. Explain unfamiliar TAF
  mechanics without treating the user as a novice R programmer.

- When adding or moving workflow stages, update relevant comments and
  documentation so the inputs and generated outputs remain clear.

## Run and troubleshoot

- Diagnose errors from their actual messages and the project's files. Separate
  setup problems, missing inputs, workflow-code problems, and scientific
  questions.

- Before running a workflow, inspect its boot/setup files and understand which
  generated directories or files it may replace. Use the project's documented
  invocation; a common way to run the complete workflow from its directory is
  `library(TAF); taf.boot(); source.all()`.

- Use `source.taf(script)` when the task is to run one specified TAF script
  rather than the complete workflow.

- Report what ran and what succeeded or failed. Do not claim an analysis is
  reproducible or validated solely because its scripts look like a TAF workflow.
