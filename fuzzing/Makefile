AFL_FUZZ = /usr/local/bin/afl-fuzz

BIN_OUTPUT_PATH = CPP/7zip/Bundles/Alone2/_o/bin/7zz

REPO_AFL = 7zz_afl
REPO_AFL_ASAN = 7zz_afl_asan
REPO_AFL_MSAN = 7zz_afl_msan
REPO_AFL_UBSAN = 7zz_afl_ubsan
REPO_AFL_TSAN = 7zz_afl_tsan

BIN_AFL = ../../$(REPO_AFL)/$(BIN_OUTPUT_PATH)
BIN_AFL_HARNESS = ../../$(REPO_AFL)_harness/$(BIN_OUTPUT_PATH)
BIN_AFL_ASAN = ../../$(REPO_AFL_ASAN)/$(BIN_OUTPUT_PATH)
BIN_AFL_ASAN_HARNESS = ../../$(REPO_AFL_ASAN)_harness/$(BIN_OUTPUT_PATH)
BIN_AFL_MSAN = ../../$(REPO_AFL_MSAN)/$(BIN_OUTPUT_PATH)
BIN_AFL_UBSAN = ../../$(REPO_AFL_UBSAN)/$(BIN_OUTPUT_PATH)
BIN_AFL_TSAN = ../../$(REPO_AFL_TSAN)/$(BIN_OUTPUT_PATH)

HARNESS_ARCHIVE = ../harness

get-inputs:
	rm -rf in_raw fuzzing-corpus && mkdir in_raw

	git clone -n --depth=1 --filter=tree:0 https://github.com/strongcourage/fuzzing-corpus.git
	cd fuzzing-corpus && git sparse-checkout set --no-cone zip gzip/go-fuzz lrzip jar && git checkout
	mv fuzzing-corpus/zip/go-fuzz/* in_raw
	mv fuzzing-corpus/jar/* in_raw
	mv fuzzing-corpus/gzip/go-fuzz/* in_raw
	mv fuzzing-corpus/lrzip/* in_raw

get-inputs-for-archive:
	rm -rf in_raw fuzzing-corpus && mkdir in_raw

	git clone -n --depth=1 --filter=tree:0 https://github.com/strongcourage/fuzzing-corpus.git
	cd fuzzing-corpus && git sparse-checkout set --no-cone txt/mopt && git checkout
	mv fuzzing-corpus/txt/mopt/* in_raw

fuzz-afl: 
	AFL_SKIP_CPUFREQ=1 AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 $(AFL_FUZZ) -M main-afl-$(HOSTNAME) -t 30000 -i in -o out -- $(BIN_AFL) e -y @@

fuzz-afl-archive: 
	AFL_SKIP_CPUFREQ=1 AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 $(AFL_FUZZ) -M main-afl-$(HOSTNAME) -t 30000 -i in -o out -- $(BIN_AFL_HARNESS) @@

fuzz-afl-asan:
	AFL_SKIP_CPUFREQ=1 AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 $(AFL_FUZZ) -S variant-afl-asan -t 30000 -i in -o out -- $(BIN_AFL_ASAN) e -y @@

fuzz-afl-asan-archive:
	AFL_SKIP_CPUFREQ=1 AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 $(AFL_FUZZ) -S variant-afl-asan -t 30000 -i in -o out -- $(BIN_AFL_ASAN_HARNESS) @@

fuzz-afl-msan:
	AFL_SKIP_CPUFREQ=1 AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 $(AFL_FUZZ) -S variant-afl-msan -t 30000 -i in -o out -- $(BIN_AFL_MSAN) e -y @@

fuzz-afl-ubsan:
	AFL_SKIP_CPUFREQ=1 AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 $(AFL_FUZZ) -S variant-afl-ubsan -t 30000 -i in -o out -- $(BIN_AFL_UBSAN) e -y @@

fuzz-afl-tsan:
	AFL_SKIP_CPUFREQ=1 AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 $(AFL_FUZZ) -S variant-afl-tsan -t 30000 -i in -o out -- $(BIN_AFL_TSAN) e -y @@

minimize-afl:
	rm -rf in_unique in
	afl-cmin -i in_raw -o in_unique -- $(BIN_AFL) e -y @@
	mkdir in
	cd in_unique; for i in *; do afl-tmin -i "$$i" -o "../in/$$i" -- ../$(BIN_AFL) e -y @@; done

minimize-afl-asan:
	rm -rf in_unique in
	afl-cmin -T all -i in_raw -o in_unique -- $(BIN_AFL_ASAN) e -y @@
	mv in_unique in

harness: harness.c
	gcc harness.c -o harness && cp harness fuzzing-work
#	mkdir in
#	cd in_unique; for i in *; do afl-tmin -i "$$i" -o "../in/$$i" -- ../$(BIN_AFL_ASAN) e -y @@; done
