#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include "math_constants.h"
#include <string>
#include <tables/Tables/Table.h>
#include <tables/Tables/TableRow.h>
#include <tables/Tables/TableIter.h>
#include <tables/Tables/ScalarColumn.h>
#include <tables/Tables/ArrayColumn.h>
#include <casa/Arrays/Vector.h>
#include <casa/Arrays/Matrix.h>
#include <casa/Arrays/Slicer.h>
#include <casa/Arrays/ArrayMath.h>
#include <tables/Tables/TableParse.h>
#include <ms/MeasurementSets.h>
#include <tables/Tables/ColumnDesc.h>
#include <tables/Tables/ScaColDesc.h>
#include <tables/Tables/ArrColDesc.h>
#include <ms/MeasurementSets/MSMainColumns.h>
#include <tables/Tables/TableDesc.h>
#include <ms/MeasurementSets/MSAntennaColumns.h>
#include <fitsio.h>
#include "rngs.cuh"
#include "rvgs.cuh"
#include <cufft.h>

#define FLOAT_IMG   -32
#define DOUBLE_IMG  -64

#define TSTRING      16
#define TLONG        41
#define TINT         31
#define TFLOAT       42
#define TDOUBLE      82
#define TCOMPLEX     83
#define TDBLCOMPLEX 163

const float PI = CUDART_PI_F;
const double PI_D = CUDART_PI;

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
        if (code != cudaSuccess)
        {
                fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
                if (abort) exit(code);
        }
}

//Included variable from Makefile using "make NEWCASA=1"
#ifdef NEWCASA
namespace casa = casacore;
#endif

typedef struct freqData {
        int n_internal_frequencies;
        int total_frequencies;
        int *channels;
        int nfields;
        int nsamples;
        int nstokes;
        int max_number_visibilities_in_channel;
}freqData;

typedef struct observedVisibilities {
        float *u;
        float *v;
        float *weight;
        cufftComplex *Vo;
        cufftComplex *Vm;
        cufftComplex *Vr;
        int *S;
        float freq;
        long numVisibilities;

        int *stokes;
        int threadsPerBlockUV;
        int numBlocksUV;
}Vis;

typedef struct field {
        int valid_frequencies;
        double ref_ra, ref_dec;
        double phs_ra, phs_dec;
        float ref_xobs, ref_yobs;
        float phs_xobs, phs_yobs;
        long *numVisibilitiesPerFreq;
        long *backup_numVisibilitiesPerFreq;
        Vis *visibilities;
        Vis *device_visibilities;
        Vis *gridded_visibilities;
        Vis *backup_visibilities;
}Field;

typedef struct canvas_variables {
        float DELTAX, DELTAY;
        double ra, dec;
        double crpix1, crpix2;
        long M, N;
        float beam_bmaj, beam_bmin;
        float beam_noise;
}canvasVariables;

__host__ freqData countVisibilities(char * MS_name, Field *&fields, int gridding);
__host__ canvasVariables readCanvas(char *canvas_name, fitsfile *&canvas, float b_noise_aux, int status_canvas, int verbose_flag);
__host__ void readFITSImageValues(char *imageName, fitsfile *file, float *&values, int status, long M, long N);

__host__ void readMSMCNoise(char *MS_name, Field *fields, freqData data);
__host__ void readSubsampledMS(char *MS_name, Field *fields, freqData data, float random_probability);
__host__ void readMCNoiseSubsampledMS(char *MS_name, Field *fields, freqData data, float random_probability);
__host__ void readMS(char *MS_name, Field *fields, freqData data);

__host__ void MScopy(char const *in_dir, char const *in_dir_dest, int verbose_flag);

__host__ void residualsToHost(Field *fields, freqData data, int num_gpus, int firstgpu);
__host__ void readMS(char *file, char *file2, Field *fields);
__host__ void writeMS(char *infile, char *outfile, Field *fields, freqData data, float random_probability, int verbose_flag);
__host__ void writeMSSIM(char *infile, char *outfile, Field *fields, freqData data, int verbose_flag);
__host__ void writeMSSIMMC(char *infile, char *outfile, Field *fields, freqData data, int verbose_flag);
__host__ void writeMSSIMSubsampled(char *infile, char *outfile, Field *fields, freqData data, float random_probability, int verbose_flag);
__host__ void writeMSSIMSubsampledMC(char *infile, char *outfile, Field *fields, freqData data, float random_probability, int verbose_flag);

__host__ void fitsOutputCufftComplex(cufftComplex *I, fitsfile *canvas, char *out_image, char *mempath, int iteration, float fg_scale, long M, long N, int option);
__host__ void OFITS(float *I, fitsfile *canvas, char *path, char *name_image, char *units, int iteration, int index, float fg_scale, long M, long N);
__host__ void fitsOutputFloat(float *I, fitsfile *canvas, char *mempath, int iteration, long M, long N, int option);
__host__ void fitsOutputCufftComplex(float *I, fitsfile *canvas, char *out_image, char *mempath, int iteration, float fg_scale, long M, long N, int option);
__host__ void float2toImage(float *I, fitsfile *canvas, char *out_image, char*mempath, int iteration, float fg_scale, long M, long N, int option);
__host__ void float3toImage(float3 *I, fitsfile *canvas, char *out_image, char*mempath, int iteration, long M, long N, int option);
__host__ void closeCanvas(fitsfile *canvas);
