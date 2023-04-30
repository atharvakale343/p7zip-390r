AFL_FUZZ = /usr/local/bin/afl-fuzz

BIN_OUTPUT_PATH = CPP/7zip/Bundles/Alone2/_o/bin/7zz

REPO_AFL = 7zz_afl
REPO_AFL_ASAN = 7zz_afl_asan

BIN_AFL = ../../$(REPO_AFL)/$(BIN_OUTPUT_PATH)
BIN_AFL_ASAN = ../../$(REPO_AFL_ASAN)/$(BIN_OUTPUT_PATH)


get-inputs:
	rm -rf in_raw fuzzing-corpus && mkdir in_raw

	git clone -n --depth=1 --filter=tree:0 git@github.com:strongcourage/fuzzing-corpus.git
	cd fuzzing-corpus && git sparse-checkout set --no-cone zip gzip/go-fuzz lrzip jar && git checkout
	mv fuzzing-corpus/zip/go-fuzz/* in_raw
	mv fuzzing-corpus/jar/* in_raw
	mv fuzzing-corpus/gzip/go-fuzz/* in_raw
	mv fuzzing-corpus/lrzip/* in_raw

fuzz-afl: 
	AFL_SKIP_CPUFREQ=1 AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 $(AFL_FUZZ) -t 2000 -i in -o out -- $(BIN_AFL) e -y @@

fuzz-afl-asan: 
	AFL_SKIP_CPUFREQ=1 AFL_I_DONT_CARE_ABOUT_MISSING_CRASHES=1 $(AFL_FUZZ) -t 2000 -i in -o out -- $(BIN_AFL_ASAN) e -y @@


minimize-afl:
	rm -rf in_unique in
	afl-cmin -i in_raw -o in_unique -- $(BIN_AFL) e -y @@
	mkdir in
	cd in_unique; for i in *; do afl-tmin -i "$$i" -o "../in/$$i" -- ../$(BIN_AFL) e -y @@; done

minimize-afl-asan:
	rm -rf in_unique in
	afl-cmin -i in_raw -o in_unique -- $(BIN_AFL_ASAN) e -y @@
	mkdir in
	cd in_unique; for i in *; do afl-tmin -i "$$i" -o "../in/$$i" -- ../$(BIN_AFL_ASAN) e -y @@; done