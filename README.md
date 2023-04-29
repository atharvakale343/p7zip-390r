# 390r-debugging-setup

-   Link to `p7zip` repository: https://github.com/jinfeihan57/p7zip

## Build target

```bash
# Clone target and update Makefile with debugging flags
git clone git@github.com:jinfeihan57/p7zip.git
cp 7zip_gcc_dbg.mak p7zip/CPP/7zip/7zip_gcc.mak

# Compile target and update path
cd p7zip/CPP/7zip/Bundles/Alone2 && make -f makefile.gcc && cd -
PATH=$PATH:$PWD/p7zip/CPP/7zip/Bundles/Alone2/_o/bin

# For fuzzing, use the compiled target
cp 7zz_fuzz p7zip/CPP/7zip/Bundles/Alone2/_o/bin
```

## Run target

### List of commands

```bash
7zz -h
```

### Simple tests

```bash
cd playground
7zz a files.zip file1.txt file2.txt
7zz e files.zip -ofiles_extracted
```

## Target analysis

### File format

![File format](screenshots/file_format.png)

### Mitigations

![Checksec mitigations](screenshots/checksec_mitigations.png)

### ROP Gadgets

![List of ROP Gadgets](screenshots/rop_gadgets.png)

### One Gadgets

![List of One Gadgets](screenshots/one_gadgets.png)

### Function call graph

The following can be used to analyze execution of the target and produce graphs. It requires `valgrind` and `kcachegrind` to be installed.

```bash
valgrind --callgrind-out-file=callgrind_vis2 --tool=callgrind 7zz e files.zip -ofiles_extracted
kcachegrind callgrind_vis2
```

Below are two call graphs produced for the archive and extract commands:

![Zip files](screenshots/func_call_graph1.png)

![Extract files](screenshots/func_call_graph2.png)

## Fuzzing

### Installing AFL++

Install [american-fuzzy-lop-clang](https://github.com/AFLplusplus/AFLplusplus).

### ALF++ with Docker

```bash
docker pull aflplusplus/aflplusplus
docker run -ti -v .:/src aflplusplus/aflplusplus
```

### Using AFL compiled target

```bash
7zz_fuzz -h
```

Note: move 7zz_fuzz to the same directory as 7zz

### Fuzzing with dictionaries on Docker

```bash
cd /src/fuzzing
afl-fuzz -i seeds_dir -o output_dir -- ../p7zip/CPP/7zip/Bundles/Alone2/_o/bin/7zz_fuzz a sample.zip @@
```

### Fuzzing with inputs on Local

```bash
mkcd fuzzing
AFL_SKIP_CPUFREQ=1 AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 afl-fuzz -i input_dir -o output_dir -- ../p7zip/CPP/7zip/Bundles/Alone2/_o/bin/7zz_fuzz e @@
```

## Code Analysis

### CodeQL

-   Installing CodeQL

```bash
cd codeql-playground
wget https://github.com/github/codeql-cli-binaries/releases/download/v2.13.0/codeql-linux64.zip
unzip codeql-linux64.zip
PATH=$PATH:$PWD/codeql
```

-   Creating a codeql database for p7zip

```bash
cd p7zip/CPP/7zip/Bundles/Alone2
codeql database create ../../../../../codeql-playground/analysis-db.codeql -l cpp -c "make -B -f makefile.gcc" --overwrite
cd -
```

-   Analyzing database with codeql

```bash
codeql pack download codeql/cpp-queries
codeql database analyze analysis-db.codeql --format CSV --output analysis.csv
```

### Joern

-   Installation requires `JDK`

```bash
curl -L "https://github.com/joernio/joern/releases/latest/download/joern-install.sh" -o joern-install.sh
chmod u+x joern-install.sh
./joern-install.sh --interactive
```

-   Basic tests

```joern
importCode(inputPath="../p7zip/CPP", projectName="p7zip-dbg")
```
