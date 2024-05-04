// #include <stdlib.h>
// #include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <errno.h>

#include "../fft/fft.h"
#include "../scaling/scaling.h"

#define WINDOW_SIZE 4096
#define HOP_LENGTH 1024
#define PHASE_SHIFT_AMOUNT(x) pow(2.0, (x / 12.0))

void hannify(float* inputSamples, int startIdx, float* output) {
    for (size_t i = 0; i < WINDOW_SIZE; ++i) {
        float w = 0.5 * (1 - cos(2 * M_PI * i / WINDOW_SIZE));
        output[i] = inputSamples[(i + startIdx) % (WINDOW_SIZE + HOP_LENGTH)] * w;
    }
}

float inputSamples[WINDOW_SIZE + HOP_LENGTH];
int inputWindowStart = 0;
int inputCurIdx = 0;
float hanned1[WINDOW_SIZE];
float hanned2[WINDOW_SIZE];
float *fftRealBufs[2];
float *fftImagBufs[2];
float *shiftRealBufs[2];
float *shiftImagBufs[2];
int fftBufIdx = 0;
float fftReal1[WINDOW_SIZE];
float fftImag1[WINDOW_SIZE];
float fftReal2[WINDOW_SIZE];
float fftImag2[WINDOW_SIZE];
float shiftReal1[WINDOW_SIZE];
float shiftImag1[WINDOW_SIZE];
float shiftReal2[WINDOW_SIZE];
float shiftImag2[WINDOW_SIZE];
float ifftReal[WINDOW_SIZE];
float ifftImag[WINDOW_SIZE];
float stitcher[WINDOW_SIZE];
int stitcherPtr = 0;
char *curLine;
size_t curLineLen = 0;

void convertToPolar(float* real, float* imag) {
    // in place conversion
    for (int i = 0; i < WINDOW_SIZE / 2; i++) {
        float mag = sqrt((real[i] * real[i]) + (imag[i] * imag[i]));
        float phase = atan2(imag[i], real[i]);
        real[i] = mag;
        imag[i] = phase;
    }
}

void convertToCart(float* mag, float* phase, float* real, float* imag) {
    for (int i = 0; i < WINDOW_SIZE / 2; i++) {
        real[i] = mag[i] * cos(phase[i]);
        imag[i] = mag[i] * sin(phase[i]);
    
    }
}

int main(int argc, char** argv)
{

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <semitone-shift> \n", argv[0]);
        return 1;
    }

    int semitoneShift = strtol(argv[1], NULL, 10);

    fftRealBufs[0] = fftReal1;
    fftImagBufs[0] = fftImag1;
    fftRealBufs[1] = fftReal2;
    fftImagBufs[1] = fftImag2;
    shiftRealBufs[0] = shiftReal1;
    shiftImagBufs[0] = shiftImag1;
    shiftRealBufs[1] = shiftReal2;
    shiftImagBufs[1] = shiftImag2;

    for (int i = 0; i < WINDOW_SIZE; i++) {
        fftReal1[i] = 0;
        fftImag1[i] = 0;
        fftReal2[i] = 0;
        fftImag2[i] = 0;
        shiftReal1[i] = 1;
        shiftImag1[i] = 1;
        shiftReal2[i] = 1;
        shiftImag2[i] = 1;
        ifftReal[i] = 0;
        ifftImag[i] = 0;
        stitcher[i] = 0;
    }

    while (-1 != getline(&curLine, &curLineLen, stdin)) {

        // Convert curLine to float
        inputSamples[inputCurIdx] = strtof(curLine, NULL) * 0.8; // to prevent clipping

        // Abstraction: assume all processing takes place in span of 1 sample
        if (inputCurIdx == (inputWindowStart + WINDOW_SIZE) % 
                            (WINDOW_SIZE + HOP_LENGTH)) {
            
            // Initial Hann Windowing
            hannify(inputSamples, inputWindowStart, hanned1);

            // Perform FFT
            for (int i = 0; i < WINDOW_SIZE; i++) {
                fftRealBufs[fftBufIdx][i] = hanned1[i];
                fftImagBufs[fftBufIdx][i] = 0;
            }
            rearrange(fftRealBufs[fftBufIdx], fftImagBufs[fftBufIdx], WINDOW_SIZE);
            compute(fftRealBufs[fftBufIdx], fftImagBufs[fftBufIdx], WINDOW_SIZE);

            // Convert to polar
            convertToPolar(fftRealBufs[fftBufIdx], fftImagBufs[fftBufIdx]);

            // Shift phase
            processTransformed(fftRealBufs[(fftBufIdx + 1) % 2],
                               fftImagBufs[(fftBufIdx + 1) % 2],
                               fftRealBufs[fftBufIdx],
                               fftImagBufs[fftBufIdx],
                               shiftRealBufs[(fftBufIdx + 1) % 2],
                               shiftImagBufs[(fftBufIdx + 1) % 2],
                               shiftRealBufs[fftBufIdx],
                               shiftImagBufs[fftBufIdx], PHASE_SHIFT_AMOUNT(semitoneShift));

            // Perform IFFT
            convertToCart(shiftRealBufs[fftBufIdx], shiftImagBufs[fftBufIdx], 
                          ifftReal, ifftImag);
            inverseCompute(ifftReal, ifftImag, WINDOW_SIZE);
            
            // Second Hann Windowing to prevent popping
            hannify(ifftReal, 0, hanned2);

            // Add outputs to stitcher
            for (int i = 0; i < WINDOW_SIZE; i++) {
                if (i < WINDOW_SIZE - HOP_LENGTH)
                    stitcher[(stitcherPtr + i) % WINDOW_SIZE] += 
                    (hanned2[i] / 2.0);
                else
                    stitcher[(stitcherPtr + i) % WINDOW_SIZE] = 
                    (hanned2[i] / 2.0);
            }

            // Yield completed stitches to stdout
            for (int i = 0; i < HOP_LENGTH; i++) {
                printf("%f\n", stitcher[stitcherPtr + i]);
            }

            // Increment position-tracking pointers
            inputWindowStart = (inputWindowStart + HOP_LENGTH) % 
                               (WINDOW_SIZE + HOP_LENGTH);
            fftBufIdx = (fftBufIdx + 1) % 2;
            stitcherPtr = (stitcherPtr + HOP_LENGTH) % WINDOW_SIZE;

        }

        inputCurIdx = (inputCurIdx + 1) % (WINDOW_SIZE + HOP_LENGTH);

    }

}