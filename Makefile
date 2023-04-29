AFL_CC = /usr/local/bin/afl-gcc-fast
AFL_CXX = /usr/local/bin/afl-g++-fast
AFL_FUZZ = /usr/local/bin/afl-fuzz

BIN_OUTPUT_PATH = ./p7zip/CPP/7zip/Bundles/Alone2/_o/bin
BIN_OUTPUT = $(BIN_OUTPUT_PATH)/7zz
BIN_DEFAULT = ./7zz_default
BIN_DEBUG = ./7zz_debug
BIN_INSTRUMENTED = ./7zz_afl
BIN_INSTRUMENTED_ASAN = ./7zz_afl_asan

default:
	cp 7zz-makefiles/7zip_gcc_default.mak p7zip/CPP/7zip/7zip_gcc.mak
	cd p7zip/CPP/7zip/Bundles/Alone2 && make -f makefile.gcc
	cp $(BIN_OUTPUT) $(BIN_DEBUG)
	make move-all

afl:
	cp 7zz-makefiles/7zip_gcc_default.mak p7zip/CPP/7zip/7zip_gcc.mak
	cd p7zip/CPP/7zip/Bundles/Alone2 && CC=$(AFL_CC) make -f makefile.gcc
	cp $(BIN_OUTPUT) $(BIN_INSTRUMENTED)
	make move-all
	

afl-asan:
	cp 7zz-makefiles/7zip_gcc_asan.mak p7zip/CPP/7zip/7zip_gcc.mak
	cd p7zip/CPP/7zip/Bundles/Alone2 && AFL_USE_ASAN=1 CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc
	cp $(BIN_OUTPUT) $(BIN_INSTRUMENTED_ASAN)
	make move-all

debug:
	cp 7zz-makefiles/7zip_gcc_dbg.mak p7zip/CPP/7zip/7zip_gcc.mak
	cd p7zip/CPP/7zip/Bundles/Alone2 && make -f makefile.gcc
	cp $(BIN_OUTPUT) $(BIN_DEBUG)
	make move-all

move-all:
	-cp $(BIN_DEFAULT) $(BIN_OUTPUT_PATH)
	-cp $(BIN_DEBUG) $(BIN_OUTPUT_PATH)
	-cp $(BIN_INSTRUMENTED) $(BIN_OUTPUT_PATH)
	-cp $(BIN_INSTRUMENTED_ASAN) $(BIN_OUTPUT_PATH)