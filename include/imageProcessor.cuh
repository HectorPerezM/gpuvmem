#ifndef IMAGE_PROCESSOR_CUH
#define IMAGE_PROCESSOR_CUH

#include "framework.cuh"
#include "functions.cuh"

class ImageProcessor : public VirtualImageProcessor
{
public:
  ImageProcessor();
  void clip(float *I);
  void clip(cufftComplex *I);
  void clipWNoise(float *I);
  void apply_beam(cufftComplex *image, float xobs, float yobs, float freq);
  void calculateInu(cufftComplex *image, float *I, float freq);
  void chainRule(float *I, float freq);
  void configure(int I);
};

#endif