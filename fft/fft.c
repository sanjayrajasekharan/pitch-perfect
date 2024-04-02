#include <math.h>
#include <stdio.h>
#include "fft.h"

void rearrange(float real[], float imaginary[], const unsigned int N)
{
    unsigned int target = 0;
    for (unsigned int position = 0; position < N; position++)
    {
        if (target > position)
        {
            const float temp_real = real[target];
            const float temp_imaginary = imaginary[target];
            real[target] = real[position];
            imaginary[target] = imaginary[position];
            real[position] = temp_real;
            imaginary[position] = temp_imaginary;
        }
        unsigned int mask = N;
        while (target & (mask >>= 1))
            target &= ~mask;
        target |= mask;
    }
}

void compute(float real[], float imaginary[], const unsigned int N)
{
    const float pi = -3.14159265358979323846;

    for (unsigned int step = 1; step < N; step <<= 1)
    {
        const unsigned int jump = step << 1;
        const float step_d = (float)step;
        float twiddle_real = 1.0;
        float twiddle_imaginary = 0.0;
        for (unsigned int group = 0; group < step; group++)
        {
            for (unsigned int pair = group; pair < N; pair += jump)
            {
                const unsigned int match = pair + step;
                const float product_real = twiddle_real * real[match] - twiddle_imaginary * imaginary[match];
                const float product_imaginary = twiddle_imaginary * real[match] + twiddle_real * imaginary[match];
                real[match] = real[pair] - product_real;
                imaginary[match] = imaginary[pair] - product_imaginary;
                real[pair] += product_real;
                imaginary[pair] += product_imaginary;
            }

            // we need the factors below for the next iteration
            // if we don't iterate then don't compute
            if (group + 1 == step)
            {
                continue;
            }

            float angle = pi * ((float)group + 1) / step_d;
            twiddle_real = cos(angle);
            twiddle_imaginary = sin(angle);
        }
    }
}

void inverseCompute(float real[], float imaginary[], const unsigned int N)
{
    // Take conjugate of the complex numbers
    for (unsigned int i = 0; i < N; ++i) {
        imaginary[i] = -imaginary[i];
    }

    // Perform forward FFT on the conjugate complex numbers
    rearrange(real, imaginary, N);
    compute(real, imaginary, N);

    // Take conjugate of the result (to get the inverse FFT)
    for (unsigned int i = 0; i < N; ++i) {
        imaginary[i] = -imaginary[i];
    }

    // Scale by 1/N to get the correct result
    const float scale = 1.0f / N;
    for (unsigned int i = 0; i < N; ++i) {
        real[i] *= scale;
        imaginary[i] *= scale;
    }
}







