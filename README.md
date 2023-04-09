# 390r-debugging-setup

-   Link to `p7zip` repository: https://github.com/jinfeihan57/p7zip

## Build target

```bash
git clone git@github.com:jinfeihan57/p7zip.git
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

###
