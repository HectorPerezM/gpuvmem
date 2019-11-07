echo "Running Hltau with gridding!"
../../bin/gpuvmem -X 16 -Y 16 -V 256 \
-i ./hltau_reducido.ms \
-I ./input.dat \
-o ./residuals.ms \
-O ./simulated.fits \
-m ./hltau5_whead.fits \
-p ./mem/ \
-f ./values.txt \
-z 0.001 -Z 0.001,0.0 \
-g 1 \
--verbose
