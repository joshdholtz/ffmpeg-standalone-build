CORES := 8
TUNE_CPU := core2

help:
	@echo 'Usage: make [OPTIONS]'
	@echo '  Options:'
	@echo '    CORES=n - how many cores to use during compilation'
	@echo '    TUNE_CPU=arch - tune for target architecture (e.g. core2 or skylake)'
	@echo '    ENABLE_NOGPL=yes - enable non-GPL-compatible pieces (makes binary NOT redistributable)'
	@echo '    ENABLE_AVX=1|2 - enable AVX (or AVX and AVX2) extensions'

NONFREE_FLAGS := --enable-nonfree --enable-openssl --enable-libsrt --enable-libfdk-aac
AVX2_FLAGS := --enable-avx --enable-avx2
AVX_FLAGS := --enable-avx

ifeq ($(ENABLE_NOGPL), yes)
#	@echo 'This makes a build NOT REDISTRIBUTABLE'
#	read -r -p "If that is okay for you hit Enter, otherwise hit Ctrl-C to stop"
_NONFREE:=$(NONFREE_FLAGS)
else
_NONFREE:=
endif
ifeq ($(ENABLE_AVX), 2)
_AVX:=$(AVX2_FLAGS)
else ifeq ($(ENABLE_AVX), 1)
_AVX:=$(AVX_FLAGS)
else
_AVX :=
endif

all:
	@if [ ! -z "$(_NONFREE)" ];\
	then \
		echo 'This makes a build NOT REDISTRIBUTABLE' ; \
		read -r -p "If that is okay for you hit Enter, otherwise hit Ctrl-C to stop" _; \
	fi	
	$(MAKE) -f Makefile.internal CORES=$(CORES) TUNE_CPU=$(TUNE_CPU) NONFREE="$(_NONFREE)" AVX="$(_AVX)" package

clean:
	$(MAKE) -f Makefile.internal clean

.PHONY: all clean help
.SILENT:
.DEFAULT_GOAL := all
