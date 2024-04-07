#include <stdio.h>
#include <math.h>
#include "scaling.h"

#define WINDOW_SIZE 4096
#define HOP_LENGTH 1024
#define SEMITONE_SHIFT 6
#define PHASE_SHIFT_AMOUNT pow(2.0, (SEMITONE_SHIFT / 12.0))

double phaseDifference(float real1, float imag1, float real2, float imag2) {
    return atan2(imag2, real2) - atan2(imag1, real1);
}

void processTransformed(float* realPrev, float* imagPrev, float* realNew,
                        float* imagNew, float* realOutPrev, float* imagOutPrev,
                        float* realOutNew, float* imagOutNew) {
    for (int i = 0; i < WINDOW_SIZE; i++) {
        float dPhase = phaseDifference(realPrev[i], imagPrev[i], realNew[i], 
                                       imagNew[i]);
        float shiftAngle = PHASE_SHIFT_AMOUNT * dPhase;
        float cosShift = cos(shiftAngle);
        float sinShift = sin(shiftAngle);
        float magScale = sqrt(realNew[i] * realNew[i] + 
                              imagNew[i] * imagNew[i]) /
                         sqrt(realPrev[i] * realPrev[i] +
                              imagPrev[i] * imagPrev[i]);
        realOutNew[i] = (realOutPrev[i] * cosShift - imagOutPrev[i] * sinShift)
                        * magScale;
        imagOutNew[i] = (realOutPrev[i] * sinShift + imagOutPrev[i] * cosShift)
                        * magScale;
        // printf("realPrev: %f, imagPrev: %f\n", realPrev[i], imagPrev[i]);
        // printf("Diff: %f, Shift: %f, MagScale: %f\n", dPhase, shiftAngle, magScale);
    }
}