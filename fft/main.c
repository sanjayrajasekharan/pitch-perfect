#include <stdio.h>
#include "fft.h"

int main() {
    // Test case 1 for FFT and IFFT
    const unsigned int N1 = 8;
    float input_real1[] = {1.5, 0.0, 2.3, 0.0, 3.4, 0.0, 4.2, 0.0};
    float input_imaginary1[] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    rearrange(input_real1, input_imaginary1, N1);
    compute(input_real1, input_imaginary1, N1);
    printf("FFT Output:\n");
    for (unsigned int i = 0; i < N1; ++i) {
        printf("%f + %fi\n", input_real1[i], input_imaginary1[i]);
    }
    
    // Use the output of FFT as input for IFFT
    inverseCompute(input_real1, input_imaginary1, N1);
    printf("\nIFFT Output:\n");
    for (unsigned int i = 0; i < N1; ++i) {
        printf("%f + %fi\n", input_real1[i], input_imaginary1[i]);
    }
    
    // Test case 2 for FFT and IFFT
    const unsigned int N2 = 4;
    float input_real2[] = {1.0, 2.0, 3.0, 4.0};
    float input_imaginary2[] = {0.0, 0.0, 0.0, 0.0};
    rearrange(input_real2, input_imaginary2, N2);
    compute(input_real2, input_imaginary2, N2);
    printf("\nFFT Output:\n");
    for (unsigned int i = 0; i < N2; ++i) {
        printf("%f + %fi\n", input_real2[i], input_imaginary2[i]);
    }
    
    // Use the output of FFT as input for IFFT
    inverseCompute(input_real2, input_imaginary2, N2);
    printf("\nIFFT Output:\n");
    for (unsigned int i = 0; i < N2; ++i) {
        printf("%f + %fi\n", input_real2[i], input_imaginary2[i]);
    }

    // Test case 3 for FFT and IFFT
    const unsigned int N3 = 8;
    float input_real3[] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0};
    float input_imaginary3[] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    rearrange(input_real3, input_imaginary3, N3);
    compute(input_real3, input_imaginary3, N3);
    printf("\nFFT Output:\n");
    for (unsigned int i = 0; i < N3; ++i) {
        printf("%f + %fi\n", input_real3[i], input_imaginary3[i]);
    }
    
    // Use the output of FFT as input for IFFT
    inverseCompute(input_real3, input_imaginary3, N3);
    printf("\nIFFT Output:\n");
    for (unsigned int i = 0; i < N3; ++i) {
        printf("%f + %fi\n", input_real3[i], input_imaginary3[i]);
    }

    return 0;
}
