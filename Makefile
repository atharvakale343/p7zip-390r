AFL_CC = /usr/local/bin/afl-clang-fast
AFL_CXX = /usr/local/bin/afl-clang-fast++
AFL_FUZZ = /usr/local/bin/afl-fuzz

BIN_DEFAULT = 7zz_default
BIN_DEBUG = 7zz_debug
BIN_AFL = 7zz_afl
BIN_AFL_ASAN = 7zz_afl_asan
BIN_AFL_MSAN = 7zz_afl_msan
BIN_AFL_UBSAN = 7zz_afl_ubsan
BIN_AFL_CFISAN = 7zz_afl_cfisan
BIN_AFL_TSAN = 7zz_afl_tsan

GH_URL = https://github.com/jinfeihan57/p7zip

default:
	rm -rf $(BIN_DEFAULT)
	git clone $(GH_URL) $(BIN_DEFAULT)
	cp 7zz-makefiles/$(BIN_DEFAULT).mak $(BIN_DEFAULT)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_DEFAULT)/CPP/7zip/Bundles/Alone2 && make -f makefile.gcc

afl:
	rm -rf $(BIN_AFL)
	git clone $(GH_URL) $(BIN_AFL)
	cp 7zz-makefiles/$(BIN_DEFAULT).mak $(BIN_AFL)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_AFL)/CPP/7zip/Bundles/Alone2 && CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc

afl-asan:
	rm -rf $(BIN_AFL_ASAN)
	git clone $(GH_URL) $(BIN_AFL_ASAN)
	cp 7zz-makefiles/$(BIN_AFL_ASAN).mak $(BIN_AFL_ASAN)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_AFL_ASAN)/CPP/7zip/Bundles/Alone2 && AFL_USE_ASAN=1 CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc

afl-msan:
	rm -rf $(BIN_AFL_MSAN)
	git clone $(GH_URL) $(BIN_AFL_MSAN)
	cp 7zz-makefiles/$(BIN_AFL_MSAN).mak $(BIN_AFL_MSAN)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_AFL_MSAN)/CPP/7zip/Bundles/Alone2 && AFL_USE_MSAN=1 CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc

afl-ubsan:
	rm -rf $(BIN_AFL_UBSAN)
	git clone $(GH_URL) $(BIN_AFL_UBSAN)
	cp 7zz-makefiles/$(BIN_AFL_UBSAN).mak $(BIN_AFL_UBSAN)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_AFL_UBSAN)/CPP/7zip/Bundles/Alone2 && AFL_USE_UBSAN=1 CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc

afl-cfisan:
	rm -rf $(BIN_AFL_CFISAN)
	git clone $(GH_URL) $(BIN_AFL_CFISAN)
	cp 7zz-makefiles/$(BIN_AFL_CFISAN).mak $(BIN_AFL_CFISAN)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_AFL_CFISAN)/CPP/7zip/Bundles/Alone2 && AFL_USE_CFISAN=1 CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc

afl-tsan:
	rm -rf $(BIN_AFL_TSAN)
	git clone $(GH_URL) $(BIN_AFL_TSAN)
	cp 7zz-makefiles/$(BIN_AFL_TSAN).mak $(BIN_AFL_TSAN)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_AFL_TSAN)/CPP/7zip/Bundles/Alone2 && AFL_USE_TSAN=1 CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc

debug:
	git clone $(GH_URL) $(BIN_DEBUG)
	cp 7zz-makefiles/$(BIN_DEBUG).mak $(BIN_DEBUG)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_DEBUG)/CPP/7zip/Bundles/Alone2 && make -f makefile.gcc
