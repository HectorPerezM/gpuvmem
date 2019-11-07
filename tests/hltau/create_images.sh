#!/bin/bash
echo "lambda: 1e-8"
../../bin/gpuvmem \
	-X 16 \
	-Y 16 \
	-V 256 \
	-i ./hltau_reducido.ms \
	-I ./input.dat \
	-o ./residuals.ms \
	-O ./hltau_00000001_nogrid.fits \
	-m ./hltau5_whead.fits \
	-p ./mem/ \
	-f ./hltau_00000001_nogrid.txt \
	-z 0.00000001 \
	-Z 0.00000001,0.0 \

echo "lambda: 1e-6"
../../bin/gpuvmem \
	-X 16 \
	-Y 16 \
	-V 256 \
	-i ./hltau_reducido.ms \
	-I ./input.dat \
	-o ./residuals.ms \
	-O ./hltau_000001_nogrid.fits \
	-m ./hltau5_whead.fits \
	-p ./mem/ \
	-f ./hltau_000001_nogrid.txt \
	-z 0.000001 \
	-Z 0.000001,0.0 \

echo "lamda: 1e-4"
../../bin/gpuvmem \
	-X 16 \
	-Y 16 \
	-V 256 \
	-i ./hltau_reducido.ms \
	-I ./input.dat \
	-o ./residuals.ms \
	-O ./hltau_0001_nogrid.fits \
	-m ./hltau5_whead.fits \
	-p ./mem/ \
	-f ./hltau_0001_nogrid.txt \
	-z 0.0001 \
	-Z 0.0001,0.0 \

echo "lambda: 1e-2"
../../bin/gpuvmem \
	-X 16 \
	-Y 16 \
	-V 256 \
	-i ./hltau_reducido.ms \
	-I ./input.dat \
	-o ./residuals.ms \
	-O ./hltau_01_nogrid.fits \
	-m ./hltau5_whead.fits \
	-p ./mem/ \
	-f ./hltau_01_nogrid.txt \
	-z 0.01 \
	-Z 0.01,0.0 \

echo "lambda: 1" 
../../bin/gpuvmem \
	-X 16 \
	-Y 16 \
	-V 256 \
	-i ./hltau_reducido.ms \
	-I ./input.dat \
	-o ./residuals.ms \
	-O ./hltau_1_nogrid.fits \
	-m ./hltau5_whead.fits \
	-p ./mem/ \
	-f ./hltau_1_nogrid.txt \
	-z 1 \
	-Z 1,0.0 \
echo "finished"
