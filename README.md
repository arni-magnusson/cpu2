# Analysis of laptop processors

## Background

I have four laptop processors that I'm interested in comparing. They are Intel
processors from 2012 to 2025. From working with these laptops, I already know
that the newer ones tend to run things a bit faster, but I'd like to see actual
measurements. My main performance criterion is single-thread speed, but I'm also
interested in other technical properties and trends beyond those four
processors.

The primary goal is to satisfy my curiosity, but the insights gained from the
analysis can be useful to inform decisions for future hardware purchases.

Written in reproducible TAF format, the intention is to make it easy to run the
analysis with a different set of processors.

## Datasets

### Current laptops

The first dataset includes four processors that I have benchmarked:

|Year|Laptop              |Processor      |Cores|Base|Turbo|Watt|
|:---|:-------------------|:--------------|----:|---:|----:|---:|
|2012|Dell-Precision-M4700|Intel i7-3740QM|  4HT| 2.7|  3.7|  45|
|2020|Lenovo-P15-Gen-1    |Intel i7-10875H|  8HT| 2.3|  5.1|  45|
|2020|Dell-Precision-3560 |Intel i7-1165G7|  4HT| 2.8|  4.7|  28|
|2025|Lenovo-P1-Gen-8     |Intel u9-285H  |6+8+2| 2.9|  5.4|  45|

The laptops are all running native Debian or Ubuntu. The idle state is measured
in Balanced mode and sustained single-thread and multicore performance is
measured in Performance mode.

### My laptops

The second dataset is a historical overview of laptops that I have worked on:

|Year|Laptop                |Processor      |Cores|Turbo|Memory|Storage|
|:---|:---------------------|:--------------|----:|----:|-----:|------:|
|2003|Compaq-Presario-2108CL|AMD k7-2800    |    1|  2.1|   0.5|   0.04|
|2007|Lenovo-ThinkPad-T61   |Intel c2-T7500 |    2|  2.2|     4|    0.1|
|2012|Dell-Precision-M4700  |Intel i7-3740QM|  4HT|  3.7|    16|    0.5|
|2015|Lenovo-X1-Yoga-Gen1   |Intel i7-6600U |  2HT|  3.4|     8|    0.5|
|2017|Lenovo-X1-Yoga-Gen3   |Intel i7-8650U |  4HT|  4.2|    16|      1|
|2018|HP-Elitebook-830-G6   |Intel i5-8265U |  4HT|  3.9|     8|    0.5|
|2019|Lenovo-T14s-Gen1      |Intel i7-10510U|  4HT|  4.9|    16|      1|
|2020|Lenovo-P15-Gen1       |Intel i7-10875H|  8HT|  5.1|    32|    1.5|
|2020|Dell-Precision-3560   |Intel i7-1165G7|  4HT|  4.7|    32|      3|
|2025|Lenovo-P1-Gen8        |Intel u9-285H  |6+8+2|  5.4|    64|      2|

The dataset includes laptop features beyond the processor to show long-term
trend in memory, storage, and other laptop characteristics.

### Intel, AMD, Apple

The third and largest dataset compares a wide variety of processors from Intel,
AMD, and Apple. The dataset starts in 2000 and includes both low-powered and
high-powered processors.

## Questions

**1. [benchmark_actual](benchmark_actual)**

- How fast are the four processors, based on actual measurements from running a
  stock assessment model?

- Is the speed (model iterations per second) very different between a short job
  that takes seconds to complete and a longer job that takes minutes?

**2. [benchmark_local](benchmark_local)**

- How fast are the four processors, based on local benchmark results?

- Is the difference between single-thread and multithread performance roughly
  proportional to the number of physical cores?

- Do newer memory modules get higher scores in the memory benchmark results?

**3. [benchmark_online](benchmark_online)**

- How quickly has single-thread performance increased over the last fifteen
  years? How about the last twenty-five years?

- Have some processor generations provided massive performance improvements,
  while other generations provided negligible improvements?

- How do the trends vary between Intel, AMD, and Apple? Are some of them a year
  or more behind the others?

- Can low-powered processors provide decent single-thread performance compared
  to the high-powered processors?

- Did single-thread performance increase at a similar rate in the old days (from
  2000 to 2010) compared to the later period since 2010?

- Over the last twenty-five years, have there been periods when the performance
  of Intel and AMD processors were similar and other periods when they were
  different?

**4. [benchmark_summary](benchmark_summary)**

Comparing the results from **benchmark_actual**, **benchmark_local**, and
**benchmark_online**. The general question is how accurately do online reported
benchmark results transfer to actual performance running stock assessment
models.

- How different are the actual speed measurements from what we would expect
  based on the local synthetic benchmark results?

- How different are my local benchmark results from online averages for that
  processor?

**5. [monitor_cpumon](monitor_cpumon)**

- In idle conditions, what is the *frequency*, *temperature*, and *fan speed*
  for each processor?

- When running a stock assessment model, how does the processor *frequency*,
  *temperature*, and *fan speed* change over time?

- How different is the processor *frequency*, *temperature*, and *fan speed*
  when the sustained load is single-thread vs. multithread?

- Are some of the machines throttling, repeatedly varying the processor
  frequency up and down as it hits thermal limits?

- If there is an initial short-term peak in processor frequency followed by a
  lower stable condition, how different is the initial frequency from the
  sustained frequency, and how long does the initial boost last?

- How are the thermal and performance profiles different between the older and
  newer machines, or between high-powered and low-powered machines?

- How do the observed idle, single-thread, and multithread frequencies compare
  with the official manufacturer specifications for that processor?

- In idle and single-thread loads, are all the cores running at similar
  frequency or very different?

**6. [monitor_turbostat](monitor_turbostat)**

Similar to **monitor_cpumon** but using different processor monitoring software.
They give slightly different results and measure different variables: while
cpumon measures the frequency of each core and the fan speed, turbostat measures
processor wattage.

- In idle conditions, what is the *frequency*, *temperature*, and *wattage* for
  each processor?

- When running a stock assessment model, how does the processor *frequency*,
  *temperature*, and *wattage* change over time?

- How different is the processor *frequency*, *temperature*, and *wattage* when
  the sustained load is single-thread vs. multithread?

- Are some of the machines throttling, repeatedly varying the processor
  frequency up and down as it hits thermal limits?

- If there is an initial short-term peak in processor frequency followed by a
  lower stable condition, how different is the initial frequency from the
  sustained frequency, and how long does the initial boost last?

- How are the thermal and performance profiles different between the older and
  newer machines, or between high-powered and low-powered machines?

- How do the observed idle, single-thread, and multithread frequencies and
  wattage compare with the official manufacturer specifications for that
  processor?

**7. [my_laptops](my_laptops)**

- How do processor properties vary between the machines: frequency, number of
  cores, cache size, watts, process nm, and synthetic benchmark results?

- How do other components vary between the machines: memory, storage, display,
  and laptop size?

- How are the trends different between high-powered and low-powered machines?

- What are the temporal trends and have the changes been relatively steady over
  time?

- Has performance per watt increased steadily over the years, and is the
  efficiency similar between the high-powered and low-powered machines?

- Which variables are most closely related to single-thread performance?
