#!/bin/bash
echo "lambda: 50"
../../bin/gpuvmem \
	-X 16 \
	-Y 16 \
	-V 256 \
	-i ./hltau_reducido.ms \
	-I ./input.dat \
	-o ./residuals.ms \
	-O ./hltau_50_nogrid.fits \
	-m ./hltau5_whead.fits \
	-p ./mem/ \
	-f ./hltau_50_nogrid.txt \
	-z 50.0 \
	-Z 50.0,0.0 \

echo "lambda: 25"
../../bin/gpuvmem \
	-X 16 \
	-Y 16 \
	-V 256 \
	-i ./hltau_reducido.ms \
	-I ./input.dat \
	-o ./residuals.ms \
	-O ./hltau_25_nogrid.fits \
	-m ./hltau5_whead.fits \
	-p ./mem/ \
	-f ./hltau_25_nogrid.txt \
	-z 25 \
	-Z 25,0.0 \

echo "lamda: 0"
../../bin/gpuvmem \
	-X 16 \
	-Y 16 \
	-V 256 \
	-i ./hltau_reducido.ms \
	-I ./input.dat \
	-o ./residuals.ms \
	-O ./hltau_0_nogrid.fits \
	-m ./hltau5_whead.fits \
	-p ./mem/ \
	-f ./hltau_0_nogrid.txt \
	-z 0.0 \
	-Z 0.0,0.0 \

echo "lambda: 25e-3"
../../bin/gpuvmem \
	-X 16 \
	-Y 16 \
	-V 256 \
	-i ./hltau_reducido.ms \
	-I ./input.dat \
	-o ./residuals.ms \
	-O ./hltau_00025_nogrid.fits \
	-m ./hltau5_whead.fits \
	-p ./mem/ \
	-f ./hltau_00025_nogrid.txt \
	-z 0.00025 \
	-Z 0.00025,0.0 \

echo "lambda: 25e-8"
../../bin/gpuvmem \
	-X 16 \
	-Y 16 \
	-V 256 \
	-i ./hltau_reducido.ms \
	-I ./input.dat \
	-o ./residuals.ms \
	-O ./hltau_0000000025_nogrid.fits \
	-m ./hltau5_whead.fits \
	-p ./mem/ \
	-f ./hltau_0000000025_nogrid.txt \
	-z 0.0000000025 \
	-Z 0.0000000025,0.0 \
echo "finished"
