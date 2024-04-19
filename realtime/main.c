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
#define SEMITONE_SHIFT 5
#define PHASE_SHIFT_AMOUNT pow(2.0, (SEMITONE_SHIFT / 12.0))

void hannify(float* inputSamples, int startIdx, float* output) {
    for (size_t i = 0; i < WINDOW_SIZE; ++i) {
        float w = 0.5 * (1 - cos(2 * M_PI * i / WINDOW_SIZE));
        output[i] = inputSamples[(i + startIdx) % (WINDOW_SIZE + HOP_LENGTH)] * w;
    }
}

float inputSamples[WINDOW_SIZE + HOP_LENGTH];
int inputWindowStart = 0;
int inputCurIdx = 0;
float postHann[WINDOW_SIZE];
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

int main(int argc, char** argv)
{

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
        inputSamples[inputCurIdx] = strtof(curLine, NULL);

        // Abstraction: assume all processing takes place in span of 1 sample
        if (inputCurIdx == (inputWindowStart + WINDOW_SIZE) % 
                            (WINDOW_SIZE + HOP_LENGTH)) {
            
            hannify(inputSamples, inputWindowStart, postHann);

            for (int i = 0; i < WINDOW_SIZE; i++) {
                fftRealBufs[fftBufIdx][i] = postHann[i];
                fftImagBufs[fftBufIdx][i] = 0;
            }
            rearrange(fftRealBufs[fftBufIdx], fftImagBufs[fftBufIdx], WINDOW_SIZE);
            compute(fftRealBufs[fftBufIdx], fftImagBufs[fftBufIdx], WINDOW_SIZE);

            for (int i = 0; i < WINDOW_SIZE; i++) {
                // printf("Pre-transform: %f, %f\n", fftRealBufs[fftBufIdx][i], fftImagBufs[fftBufIdx][i]);
            }

            // Shift phase
            simpleTransform(fftRealBufs[(fftBufIdx + 1) % 2],
                               fftImagBufs[(fftBufIdx + 1) % 2],
                               fftRealBufs[fftBufIdx],
                               fftImagBufs[fftBufIdx],
                               shiftRealBufs[(fftBufIdx + 1) % 2],
                               shiftImagBufs[(fftBufIdx + 1) % 2],
                               shiftRealBufs[fftBufIdx],
                               shiftImagBufs[fftBufIdx], PHASE_SHIFT_AMOUNT);

            for (int i = 0; i < WINDOW_SIZE; i++) {
                ifftReal[i] = shiftRealBufs[fftBufIdx][i];
                ifftImag[i] = shiftImagBufs[fftBufIdx][i];
                // printf("Pre-transform bin %d: %f, %f\n", i, ifftReal[i], ifftImag[i]);
            }

            // Perform IFFT
            inverseCompute(ifftReal, ifftImag, WINDOW_SIZE);

            for (int i = 0; i < WINDOW_SIZE; i++) {
                // printf("Post-transform bin %d: %f, %f\n", i, ifftReal[i], ifftImag[i]);
            }
            
            // hannify(ifftReal, 0, postHann);
            // // Add outputs to stitcher
            // for (int i = 0; i < WINDOW_SIZE; i++) {
            //     if (i < WINDOW_SIZE - HOP_LENGTH)
            //         stitcher[(stitcherPtr + i) % WINDOW_SIZE] += 
            //         (postHann[i] / 2.0);
            //     else
            //         stitcher[(stitcherPtr + i) % WINDOW_SIZE] = 
            //         (postHann[i] / 2.0);
            // }

            // float total = 0;
            for (int i = 0; i < WINDOW_SIZE; i++) {
                if (i < WINDOW_SIZE - HOP_LENGTH)
                    stitcher[(stitcherPtr + i) % WINDOW_SIZE] += (ifftReal[i] / 2.0);
                else
                    stitcher[(stitcherPtr + i) % WINDOW_SIZE] = (ifftReal[i] / 2.0);
                // total += fabsf(ifftReal[i]);
            }
            // printf("Total: %f\n", total);
            // printf("new\n");
            // for (int i = 0; i < 3; i++) {
            //     printf("first: %f\n", ifftReal[i]);
            //     printf("last: %f\n", ifftReal[WINDOW_SIZE - i]);
            // }

            // Output completed stitches to stdout
            // float total = 0;
            for (int i = 0; i < HOP_LENGTH; i++) {
                printf("%f\n", stitcher[stitcherPtr + i]);
                // total += fabsf(stitcher[stitcherPtr + i]);
            }
            // printf("Total: %f\n", total);

            // Increment position-tracking pointers
            inputWindowStart = (inputWindowStart + HOP_LENGTH) % 
                               (WINDOW_SIZE + HOP_LENGTH);
            fftBufIdx = (fftBufIdx + 1) % 2;
            stitcherPtr = (stitcherPtr + HOP_LENGTH) % WINDOW_SIZE;

        }

        inputCurIdx = (inputCurIdx + 1) % (WINDOW_SIZE + HOP_LENGTH);

    }

}