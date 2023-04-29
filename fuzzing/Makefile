AFL_FUZZ = /usr/local/bin/afl-fuzz

BIN_OUTPUT_PATH = ../p7zip/CPP/7zip/Bundles/Alone2/_o/bin
BIN_OUTPUT = $(BIN_OUTPUT_PATH)/7zz
BIN_DEFAULT = $(BIN_OUTPUT_PATH)/7zz_default
BIN_DEBUG = $(BIN_OUTPUT_PATH)/7zz_debug
BIN_INSTRUMENTED = $(BIN_OUTPUT_PATH)/7zz_afl
BIN_INSTRUMENTED_ASAN = $(BIN_OUTPUT_PATH)/7zz_afl_asan

get-inputs:
	rm -rf in_raw fuzzing-corpus && mkdir in_raw

	git clone -n --depth=1 --filter=tree:0 git@github.com:strongcourage/fuzzing-corpus.git
	cd fuzzing-corpus && git sparse-checkout set --no-cone zip gzip/go-fuzz lrzip jar && git checkout
	mv fuzzing-corpus/zip/go-fuzz/* in_raw
	mv fuzzing-corpus/jar/* in_raw
	mv fuzzing-corpus/gzip/go-fuzz/* in_raw
	mv fuzzing-corpus/lrzip/* in_raw

fuzz: 
	AFL_SKIP_CPUFREQ=1 AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 $(AFL_FUZZ) -t 2000 -i in -o out -- $(BIN_INSTRUMENTED) e -y @@

fuzz-asan: 
	AFL_SKIP_CPUFREQ=1 AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 $(AFL_FUZZ) -t 2000 -i in -o out -- $(BIN_INSTRUMENTED_ASAN) e -y @@

minimize:
	rm -rf in_unique in
	afl-cmin -i in_raw -o in_unique -- $(BIN_INSTRUMENTED) e -y @@
	mkdir in
	cd in_unique; for i in *; do afl-tmin -i "$$i" -o "../in/$$i" -- ../$(BIN_INSTRUMENTED) e -y @@; done

minimize-asan:
	rm -rf in_unique in
	afl-cmin -i in_raw -o in_unique -- $(BIN_INSTRUMENTED_ASAN) e -y @@
	mkdir in
	cd in_unique; for i in *; do afl-tmin -i "$$i" -o "../in/$$i" -- ../$(BIN_INSTRUMENTED_ASAN) e -y @@; done