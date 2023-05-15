AFL_CC = /usr/local/bin/afl-gcc-fast
AFL_CXX = /usr/local/bin/afl-g++-fast
AFL_FUZZ = /usr/local/bin/afl-fuzz

BIN_DEFAULT = 7zz_default
BIN_DEFAULT_HARNESS = 7zz_default_harness
BIN_DEBUG = 7zz_debug
BIN_DEBUG_HARNESS = 7zz_debug_harness
BIN_AFL = 7zz_afl
BIN_AFL_HARNESS = 7zz_afl_harness
BIN_AFL_ASAN = 7zz_afl_asan
BIN_AFL_ASAN_HARNESS = 7zz_afl_asan_harness
BIN_AFL_ASAN_DBG = 7zz_afl_asan_dbg
BIN_AFL_ASAN_DBG_HARNESS = 7zz_afl_asan_dbg_harness
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

default-harness:
	rm -rf $(BIN_DEFAULT_HARNESS)
	git clone $(GH_URL) $(BIN_DEFAULT_HARNESS)
	cp 7zz-makefiles/$(BIN_DEFAULT).mak $(BIN_DEFAULT_HARNESS)/CPP/7zip/7zip_gcc.mak
	cp fuzzing/harness.cpp $(BIN_DEFAULT_HARNESS)/CPP/7zip/UI/Console/MainAr.cpp
	cd $(BIN_DEFAULT_HARNESS)/CPP/7zip/Bundles/Alone2 && make -f makefile.gcc

afl:
	rm -rf $(BIN_AFL)
	git clone $(GH_URL) $(BIN_AFL)
	cp 7zz-makefiles/$(BIN_DEFAULT).mak $(BIN_AFL)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_AFL)/CPP/7zip/Bundles/Alone2 && CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc

afl-harness:
	rm -rf $(BIN_AFL_HARNESS)
	git clone $(GH_URL) $(BIN_AFL_HARNESS)
	cp 7zz-makefiles/$(BIN_DEFAULT).mak $(BIN_AFL_HARNESS)/CPP/7zip/7zip_gcc.mak
	cp fuzzing/harness.cpp $(BIN_AFL_HARNESS)/CPP/7zip/UI/Console/MainAr.cpp
	cd $(BIN_AFL_HARNESS)/CPP/7zip/Bundles/Alone2 && CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc

update-afl-harness:
	CXX=$(AFL_CXX) ./update_harness.sh $(BIN_AFL_HARNESS)

afl-asan:
	rm -rf $(BIN_AFL_ASAN)
	git clone $(GH_URL) $(BIN_AFL_ASAN)
	cp 7zz-makefiles/$(BIN_AFL_ASAN).mak $(BIN_AFL_ASAN)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_AFL_ASAN)/CPP/7zip/Bundles/Alone2 && AFL_USE_ASAN=1 CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc

afl-asan-harness:
	rm -rf $(BIN_AFL_ASAN_HARNESS)
	git clone $(GH_URL) $(BIN_AFL_ASAN_HARNESS)
	cp 7zz-makefiles/$(BIN_AFL_ASAN).mak $(BIN_AFL_ASAN_HARNESS)/CPP/7zip/7zip_gcc.mak
	cp fuzzing/harness.cpp $(BIN_AFL_ASAN_HARNESS)/CPP/7zip/UI/Console/MainAr.cpp
	cd $(BIN_AFL_ASAN_HARNESS)/CPP/7zip/Bundles/Alone2 && AFL_USE_ASAN=1 CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc

update-afl-asan-harness:
	CXX=$(AFL_CXX) CFLAGS="-fsanitize=address -lasan" ./update_harness.sh $(BIN_AFL_ASAN_HARNESS)

afl-asan-dbg:
	rm -rf $(BIN_AFL_ASAN_DBG)
	git clone $(GH_URL) $(BIN_AFL_ASAN_DBG)
	cp 7zz-makefiles/$(BIN_AFL_ASAN_DBG).mak $(BIN_AFL_ASAN_DBG)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_AFL_ASAN_DBG)/CPP/7zip/Bundles/Alone2 && AFL_USE_ASAN=1 CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc

update-afl-asan-dbg-harness:
	CXX=$(AFL_CXX) CFLAGS="-g -O0 -fsanitize=address -lasan" ./update_harness.sh $(BIN_AFL_ASAN_DBG_HARNESS)

afl-asan-dbg-harness:
	rm -rf $(BIN_AFL_ASAN_DBG_HARNESS)
	git clone $(GH_URL) $(BIN_AFL_ASAN_DBG_HARNESS)
	cp 7zz-makefiles/$(BIN_AFL_ASAN_DBG).mak $(BIN_AFL_ASAN_DBG_HARNESS)/CPP/7zip/7zip_gcc.mak
	cp fuzzing/harness.cpp $(BIN_AFL_ASAN_DBG_HARNESS)/CPP/7zip/UI/Console/MainAr.cpp
	cd $(BIN_AFL_ASAN_DBG_HARNESS)/CPP/7zip/Bundles/Alone2 && AFL_USE_ASAN=1 CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc

afl-msan:
	rm -rf $(BIN_AFL_MSAN)
	git clone $(GH_URL) $(BIN_AFL_MSAN)
	cp 7zz-makefiles/$(BIN_AFL_MSAN).mak $(BIN_AFL_MSAN)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_AFL_MSAN)/CPP/7zip/Bundles/Alone2 && AFL_CC_COMPILER=LLVM AFL_USE_MSAN=1 CC=$(AFL_CC) CXX=$(AFL_CXX) make -f makefile.gcc

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
	rm -fr $(BIN_DEBUG)
	git clone $(GH_URL) $(BIN_DEBUG)
	cp 7zz-makefiles/$(BIN_DEBUG).mak $(BIN_DEBUG)/CPP/7zip/7zip_gcc.mak
	cd $(BIN_DEBUG)/CPP/7zip/Bundles/Alone2 && make -f makefile.gcc

debug-harness:
	rm -fr $(BIN_DEBUG_HARNESS)
	git clone $(GH_URL) $(BIN_DEBUG_HARNESS)
	cp 7zz-makefiles/$(BIN_DEBUG).mak $(BIN_DEBUG_HARNESS)/CPP/7zip/7zip_gcc.mak
	cp fuzzing/harness.cpp $(BIN_DEBUG_HARNESS)/CPP/7zip/UI/Console/MainAr.cpp
	cd $(BIN_DEBUG_HARNESS)/CPP/7zip/Bundles/Alone2 && make -f makefile.gcc

update-debug-harness:
	CXX="/usr/bin/g++" CFLAGS="-O0 -g" ./update_harness.sh $(BIN_DEBUG_HARNESS)
