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

    // Test case 4 for FFT and IFFT
    const unsigned int N4 = 8;
    float input_real4[] = {0.34785901, 0.71862502, 0.11248643, 0.59830784, 0.90372152, 0.44128975, 0.29513480, 0.87653024};
    float input_imaginary4[] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    rearrange(input_real4, input_imaginary4, N4);
    compute(input_real4, input_imaginary4, N4);
    printf("FFT Output:\n");
    for (unsigned int i = 0; i < N4; ++i) {
        printf("%f + %fi\n", input_real4[i], input_imaginary4[i]);
    }
    
    // Use the output of FFT as input for IFFT
    inverseCompute(input_real4, input_imaginary4, N4);
    printf("\nIFFT Output:\n");
    for (unsigned int i = 0; i < N4; ++i) {
        printf("%f + %fi\n", input_real4[i], input_imaginary4[i]);
    }

    // Additional test case for reading 4096 numbers from nums.txt
    const unsigned int N5 = 4096;
    float input_real5[N5];
    float input_imaginary5[N5] = {0}; // Initialize with zeros
    FILE *file = fopen("nums.txt", "r");
    if (file != NULL) {
        for (unsigned int i = 0; i < N5; ++i) {
            fscanf(file, "%f", &input_real5[i]);
        }
        fclose(file);

        printf("length of real: %lu", sizeof(input_real5)/sizeof(input_real5[0]));
        
        rearrange(input_real5, input_imaginary5, N5);
        compute(input_real5, input_imaginary5, N5);
        
        // Output FFT results to fft.txt
        FILE *fft_file = fopen("fft.txt", "w");
        if (fft_file != NULL) {
            for (unsigned int i = 0; i < N5; ++i) {
                fprintf(fft_file, "%f + %fi\n", input_real5[i], input_imaginary5[i]);
                //fprintf(fft_file, "%f\n", input_real5[i]);
            }
            fclose(fft_file);
        } else {
            printf("Error opening fft.txt for writing.\n");
        }
    
        // Use the output of FFT as input for IFFT
        inverseCompute(input_real5, input_imaginary5, N5);
        
        // Output IFFT results to ifft.txt
        FILE *ifft_file = fopen("ifft.txt", "w");
        if (ifft_file != NULL) {
            for (unsigned int i = 0; i < N5; ++i) {
                fprintf(ifft_file, "%f + %fi\n", input_real5[i], input_imaginary5[i]);
            }
            fclose(ifft_file);
        } else {
            printf("Error opening ifft.txt for writing.\n");
        }
    }  else {
        printf("Error opening nums.txt for reading.\n");
    }


    return 0;
}
