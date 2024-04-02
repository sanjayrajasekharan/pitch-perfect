#ifndef FFT_H
#define FFT_H

#include <stddef.h> // for size_t

struct complex_num {
    float real;
    float imsag;
};

void rearrange(float real[], float imaginary[], const unsigned int N); 
void compute(float real[], float imaginary[], const unsigned int N);
void inverseCompute(float real[], float imaginary[], const unsigned int N);

#endif
