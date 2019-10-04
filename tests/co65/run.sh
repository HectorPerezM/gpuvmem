echo "Running co65 with gridding!"
../../bin/gpuvmem -X 16 -Y 16 -V 256 \
-i ./co65.ms \
-I ./input.dat \
-o ./residuals.ms \
-O ./simulated.fits \
-m ./mod_in_0.fits \
-p ./mem/ \
-f ./values.txt \
-z 0.001 -Z 0.005,0.0 \
#-g 4\
# --verbose
