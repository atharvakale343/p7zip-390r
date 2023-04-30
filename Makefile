AFL_CC = /usr/local/bin/afl-gcc-fast
AFL_CXX = /usr/local/bin/afl-g++-fast
AFL_FUZZ = /usr/local/bin/afl-fuzz

BIN_DEFAULT = 7zz_default
BIN_DEBUG = 7zz_debug
BIN_AFL = 7zz_afl
BIN_AFL_ASAN = 7zz_afl_asan

GH_URL = https://github.com/jinfeihan57/p7zip

default:
	git clone $(GH_URL) $(BIN_DEFAULT)
	cp 7zz-makefiles/7zip_gcc_default.mak $(BIN_DEFAULT)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_DEFAULT)/CPP/7zip/Bundles/Alone2 && make -f makefile.gcc

afl:
	git clone $(GH_URL) $(BIN_AFL)
	cp 7zz-makefiles/7zip_gcc_default.mak $(BIN_AFL)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_AFL)/CPP/7zip/Bundles/Alone2 && CC=$(AFL_CC) make -f makefile.gcc

afl-asan:
	git clone $(GH_URL) $(BIN_AFL_ASAN)
	cp 7zz-makefiles/7zip_gcc_asan.mak $(BIN_AFL_ASAN)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_AFL_ASAN)/CPP/7zip/Bundles/Alone2 && AFL_USE_ASAN=1 CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc

debug:
	git clone $(GH_URL) $(BIN_DEBUG)
	cp 7zz-makefiles/7zip_gcc_dbg.mak $(BIN_DEBUG)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_DEBUG)/CPP/7zip/Bundles/Alone2 && make -f makefile.gcc
