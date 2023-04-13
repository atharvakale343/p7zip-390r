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
- [Mapping out the Target Code-Base](#mapping-out-the-target-code-base)
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

## Mapping out the Target Code-Base

TODO

The functionality of the console version of this application is straightforward. The binary accepts command line arguments (main defined in MainAr.cpp), then attempts to pass them to main2() in Main.cpp (wrapped in try block). 

main2() handles the bulk of all functionality.

It parses command line arguments beginning at line 733. Argument length is checked, arguments are converted to Unicode and pushed to a string vector. 

Arguments are first parsed into the following struct using parse1() defined in the ArchiveCommandLine.cpp.

```
struct CArcCmdLineOptions
{
  bool HelpMode;

  // bool LargePages;
  bool CaseSensitive_Change;
  bool CaseSensitive;

  bool IsInTerminal;
  bool IsStdOutTerminal;
  bool IsStdErrTerminal;
  bool StdInMode;
  bool StdOutMode;
  bool EnableHeaders;

  bool YesToAll;
  bool ShowDialog;
  bool TechMode;
  bool ShowTime;

  AString ListFields;

  int ConsoleCodePage;

  NWildcard::CCensor Censor;

  CArcCommand Command;
  UString ArchiveName;

  #ifndef _NO_CRYPTO
  bool PasswordEnabled;
  UString Password;
  #endif

  UStringVector HashMethods;
  // UString HashFilePath;

  bool AppendName;
  // UStringVector ArchivePathsSorted;
  // UStringVector ArchivePathsFullSorted;
  NWildcard::CCensor arcCensor;
  UString ArcName_for_StdInMode;

  CObjectVector<CProperty> Properties;

  CExtractOptionsBase ExtractOptions;

  CBoolPair NtSecurity;
  CBoolPair AltStreams;
  CBoolPair HardLinks;
  CBoolPair SymLinks;
  
  CBoolPair StoreOwnerId;
  CBoolPair StoreOwnerName;

  CUpdateOptions UpdateOptions;
  CHashOptions HashOptions;
  UString ArcType;
  UStringVector ExcludedArcTypes;
  
  unsigned Number_for_Out;
  unsigned Number_for_Errors;
  unsigned Number_for_Percents;
  unsigned LogLevel;

  // bool IsOutAllowed() const { return Number_for_Out != k_OutStream_disabled; }

  // Benchmark
  UInt32 NumIterations;
  bool NumIterations_Defined;
```

First arguments checked are related to showing help/copyright, and calls the ShowCopyRightAndHealth() function.

Then parse2() is called on the options struct.

ArchiveCommandLine.cpp handles a bunch of flags that can be passed, ie. SLP mode (large pages), core affinity, etc. Also contains several other methods for parsing.

Importantly, it defines the formats of arguments. Beginning on line 341, isFromExtractGroup() is defined. We see there are extract, extractFull flags. 

A scanner is defined in ExtractCallbackConsole.cpp, and this is assumably used to enumerate files in an archive?


\newpage

## Future Plans

### Fuzzing

```bash
git clone https://github.com/AFLplusplus/AFLplusplus
cd AFLplusplus
# sudo dnf -y install gcc-plugin-devel-12.2.1
# sudo dnf -y install llvm-devel
make all
sudo make install
CC=/usr/local/bin/afl-gcc-fast CXX=/usr/local/bin/afl-g++-fast make -f -B makefile.gcc
```

![Compiling with AFL Source Code Instrumentation](screenshots/compiling-with-afl.png){width=450}