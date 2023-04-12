---
title: "Checkpoint 1"
subtitle: "p7zip"
author: [Arnav Nidumolu, Atharva Kale, Pascal von Fintel, Patrick Negus]
date: "2023-04-12"
caption-justification: centering
titlepage: true
header-includes:
  - \usepackage{fvextra}
  - \DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,commandchars=\\\{\}}
---

# Checkpoint 1

## Contents:

- [Overview of the Target](#overview-of-the-target)
- [Debug Environment](#debug-environment)
- [Target Code-Base](#target-code-base)
- [Future Plans](#future-plans)

\newpage

## Overview of the Target

\newpage

## Debug Environment

### How to build the target

Pre-requisites:

1. CMake

**Step 1:**

```bash
git clone git@github.com:jinfeihan57/p7zip.git
```

We clone [jinfeihan57's repo](https://github.com/jinfeihan57/p7zip), which is a _Linux port_ for the 7zip Windows utility. The port is _fully compliant_ with the Windows equivalent, and supports all the same formats.

**Step 2:**

```bash
cp 7zip_gcc_dbg.mak p7zip/CPP/7zip/7zip_gcc.mak
```

We created a custom `Makefile` that patches the original build script to include debug flags. We copy the patch into the correct directory.

**Step 3:**

```bash
cd p7zip/CPP/7zip/Bundles/Alone2 && make -f makefile.gcc && cd -
```

We build the `7zz` tool, which is the primary binary from the project, which supports archiving and extracting the most number of formats.

**Step 4:**

```bash
PATH=$PATH:$PWD/p7zip/CPP/7zip/Bundles/Alone2/_o/bin
```

For development purposes, we update the current terminal session's `PATH` to include the path to the `7zz` binary.

### Experiment with the Target

\begin{figure}[H]
\centering
\includegraphics[width=400px]{screenshots/list-of-commands.png}
\caption{List of commands}
\end{figure}

**Simple tests**

In the `playground` directory, we have some sample files setup for basic tests.

```bash
cd playground
7zz a files.zip file1.txt file2.txt
7zz e files.zip -ofiles_extracted
```

### Target analysis

**File format**

![File format](screenshots/file_format.png){width=400}

**Mitigations**

![`checksec` mitigations](screenshots/checksec_mitigations.png){width=400}

**ROP Gadgets**

![List of ROP Gadgets](screenshots/rop_gadgets.png){width=400}

**Shared Libraries**

![List of Shared Libraries](screenshots/shared_libs.png){width=400}

**One Gadgets**

![List of One Gadgets](screenshots/one_gadgets.png){width=400}

**Function call graph**

The following can be used to analyze execution of the target and produce graphs. It requires `valgrind` and `kcachegrind` to be installed.

```bash
valgrind --callgrind-out-file=callgrind_vis2 --tool=callgrind 7zz e files.zip -ofiles_extracted
```

Use the `valgrind` command above to generate a `callgrind_vis2` file.

```bash
kcachegrind callgrind_vis2
```

Use the `kcachegrind` command to visualize the `callgrind_vis2`.

In the next two pages, we fine two function call graphs for the `archive` and `extract` subcommands.
\newpage

**Archive Command:**

![`a` subcommand](screenshots/func_call_graph1.png)

\newpage
**Extract Command:**

![`e` subcommand](screenshots/func_call_graph2.png)

\newpage

## Target Code-Base

TODO

\newpage

## Future Plans
