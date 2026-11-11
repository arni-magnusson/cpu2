# Repository guidance

This repository is a playground for reproducible analyses written as TAF workflows. The root README describes the analyses; each analysis directory may have its own workflow structure and conventions.

Before changing an analysis, inspect its existing scripts, nearby documentation, and relevant `boot/` inputs. Treat the repository as the source of truth rather than assuming every TAF repository has the same layout.

Preserve scientific meaning, source data, and provenance. Do not invent analysis choices or silently change calculations. Explain proposed scientific or structural choices clearly, especially when helping a beginner with TAF.

The user is an expert R programmer and is learning how coding agents, `AGENTS.md`, and skills work. Explain agent-specific concepts in plain language without over-explaining R.

For requested repository work, act as the lead implementer: make focused, reviewable changes and report what changed and what you checked. The user has authorized commits in this playground; do not push or publish changes unless asked.
