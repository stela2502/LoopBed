# LoopBed

LoopBed is a file format that simply contains two bed file entries in one line.
It thereby describes a loop between the two areas.

A loop bed file can contain any number of additional entries, that are entirely project specific.

This package re-codes the [HOMER](http://homer.ucsd.edu/homer/interactions2/HiCTADsAndLoops.html) merge2Dbed.pl script that does produce different results for every run.

The merge2Dbed_mod.pl script lacks support for the tad input files.

## Install

git clone https://github.com/stela2502/LoopBed.git
cd LoopBed
perl Makefile.PL
make
make install

You can remove the folder afterwards.

## Usage

merge2Dbed_mod.pl

```
	merge2Dbed.pl [options] <2D BED file1> <2D BED file2> [2D BED file3]...

	Options:
		-res <#> (maximum distance between endpoints to merge, default: 15000)
			Usually for loops -res should be set to the window/superRes size, for TADs 2x window/superRes
		-loop (treat 2D bed input files as loops, default)
		-tad (treat 2D bed input files as TADs)
		-prefix <filePrefix> (output venn diagram overlaps to separate files)
```
		