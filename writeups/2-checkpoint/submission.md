---
title: "Checkpoint 2"
subtitle: "p7zip"
author: [Arnav Nidumolu, Atharva Kale, Pascal von Fintel, Patrick Negus]
date: "2023-04-06"
caption-justification: centering
titlepage: true
header-includes:
    - \usepackage{fvextra}
    - \DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,commandchars=\\\{\}}
---

# Checkpoint 2

## Contents:

- [Checkpoint 2](#checkpoint-2)
  - [Contents:](#contents)
  - [Static Analysis](#static-analysis)

\newpage

![](screenshots/afl-fuzzing.png)

![](screenshots/tsan-fuzzing.png)

![](screenshots/msan-fuzzing.png)

![](screenshots/asan-fuzzing.png)

## Static Analysis

We ran the codebase through the static analysis tool cppcheck, which tagged 1569 warnings and errors. One of the common errors flagged by cppcheck was shiftTooManyBits

![](screenshots/cppcheck-bitshift.png)

Unfortunately, when looking at the actual source code, almost all of these errors come from an innocuous function:

![](screenshots/cppcheck-bitshift-source-1.png)
![](screenshots/cppcheck-bitshift-source-2.png)

The rest, on closer inspection, are also falsely flagged as errors, such as this one:

![](screenshots/cppcheck-bitshift-cpp-2.png)
![](screenshots/cppcheck-bitshift-source-3.png)

A more promising error seems to be a possible null pointer exception:

![](screenshots/cppcheck-nullpointer.png)
![](screenshots/cppcheck-nullpointer-source-1.png)

This function is only called once, in the same file at line 415:

![](screenshots/cppcheck-nullpointer-source-2.png)

It looks like `password` gets populated in `CryptoGetTexPassword2`, looking at that function, and the subsequent call to StringToBstr, it unfortunately looks like the nullpointer is properly checked for.

![](screenshots/cppcheck-nullpointer-source-3.png)
![](screenshots/cppcheck-nullpointer-source-4.png)

