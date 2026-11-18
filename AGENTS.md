# Convert base R plots to ggplot format

This project is about modifying existing R scripts that are part of reproducible
workflows in TAF format.

1. The project repository is at https://github.com/arni-magnusson/cpu2 and the
   local working copy is at ~/git/arni-magnusson/cpu2.

2. The work requires running R with the current version of TAF and ggplot2 that
   are available on CRAN.

3. Before starting, fetch and read these skills:
   - [taf-workflow](https://raw.githubusercontent.com/ices-taf-dev/ai/main/taf-workflow/SKILL.md)
   - [taf-ggplot](https://raw.githubusercontent.com/ices-taf-dev/ai/main/taf-ggplot/SKILL.md)

4. Use consistent style between the ggplots and search R scripts inside the
   project repository for existing ggplot code. If it exists, it means it has
   passed a human review and you should use similar style attributes when
   developing other ggplots: color palette, text size, text alignment, spacing
   around titles, etc.

5. The processor order should always be the chronological order: 3740, 10875,
   1165, 285. Newest processor at the top, oldest processor at the bottom. Use
   full laptop-processor labels arranged in two lines with a line separator,
   such as "Lenovo P1 Gen 8\nIntel u9-285H".

6. Each workflow is isolated, so TAF scripts should not read or write in other
   workflows.

7. The developer will instruct you which workflow to focus on. The work inside
   each workflow involves two steps. In the first step, you convert the plotting
   code from base R graphics to ggplot, checking TAF workflow integrity and also
   checking whether the resulting PNG files look good. In the second step, you
   work with the developer on incremental tweaks to the format until the
   developer approved the final plot format.

8. You should commit and push at two occasions: after completing the first step
   of initial conversion to ggplot and after completing the second step, when
   the developer has approved the final tweaks. The commit messages can be
   "Convert workflow_x to ggplot" and "Format tweaks" or a more specific
   description of the changes, as long as the message is concise. Your
   coauthorship should be noted in the commit message trailer.
