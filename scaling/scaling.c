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
        if (realPrev[i] == 0 && imagPrev[i] == 0) {
            realOutNew[i] = realNew[i];
            imagOutNew[i] = imagNew[i];
            continue;
        }
        float dPhase = phaseDifference(realPrev[i], imagPrev[i], realNew[i], imagNew[i]);
        float newAngle = atan2(imagOutPrev[i], realOutPrev[i]) + (PHASE_SHIFT_AMOUNT * dPhase);
        float magnitude = sqrt((realNew[i] * realNew[i]) + (imagNew[i] * imagNew[i]));
        realOutNew[i] = cos(newAngle) * magnitude;
        imagOutNew[i] = sin(newAngle) * magnitude;
        // printf("ScaleInP: %f, %f\n", realPrev[i], imagPrev[i]);
        // printf("ScaleInC: %f, %f\n", realNew[i], imagNew[i]);
        // printf("newAngle: %f, magnitude: %f\n", newAngle, magnitude);
        // printf("ScaleOut: %f, %f\n", realOutNew[i], imagOutNew[i]);
    }
}