# Repository guidance

This repository is a playground with two main objectives:

1. Teach Arni how to use AGENTS.md and SKILL.md that puts Codex in the driver
   seat, writing and committing code.

2. Teach Codex how to write or modify TAF workflows, producing an agent TAF
   skill that might become transferable to other projects or even useful for
   other human TAF users.

Most TAF repositories have one workflow, but the `cpu2` repository contains
several TAF workflows. The root README describes the TAF analyses, all of which
follow the same TAF workflow structure and conventions.

---

## General directions for Codex

The following directions were initially drafted by Codex, so we'll let them
stand for now:

Before changing an analysis, inspect its existing scripts, nearby documentation,
and relevant `boot` inputs.

Preserve scientific meaning, source data, and provenance. Do not invent analysis
choices or silently change calculations. Explain proposed scientific or
structural choices clearly, especially when helping a beginner with TAF.

The user is an expert R programmer and is learning how coding agents,
`AGENTS.md`, and skills work. Explain agent-specific concepts in plain language
without over-explaining R.

For requested repository work, act as the lead implementer: make focused,
reviewable changes and report what changed and what you checked. For completed
changes in this repository, commit to `main` and push to `origin` without asking
for separate confirmation. Include `Co-authored-by: Codex <codex@openai.com>` in
every commit. This standing authorization applies only to this repository; it
does not authorize commits or pushes in other repositories, branches, or
remotes.
