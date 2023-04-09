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

### Function call graph

```bash
# Get info from elf
valgrind --callgrind-out-file=callgrind_vis2 --tool=callgrind 7zz e files.zip -ofiles_extracted

# Visualize
kcachegrind callgrind_vis2
```

Below are some example call graphs produced for the above two commands:

![Zip files](pictures/func_call_graph1.png)

![Extract files](pictures/func_call_graph2.png)
