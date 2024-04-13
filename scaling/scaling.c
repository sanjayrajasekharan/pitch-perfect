#include <stdio.h>
#include <math.h>
#include "scaling.h"

#define WINDOW_SIZE 4096
#define HOP_LENGTH 1024

float synthMags[WINDOW_SIZE / 2];
float synthBinDeviations[WINDOW_SIZE / 2];

double phaseDifference(float real1, float imag1, float real2, float imag2) {
    return atan2(imag2, real2) - atan2(imag1, real1);
}

void processTransformed(float* realPrev, float* imagPrev, float* realNew,
                        float* imagNew, float* realOutPrev, float* imagOutPrev,
                        float* realOutNew, float* imagOutNew, double phaseScaleAmount) {
    
    for (int i = 0; i < WINDOW_SIZE / 2; i++) {
        synthMags[i] = 0;
        synthBinDeviations[i] = 0;
    }

    for (int i = 0; i < WINDOW_SIZE / 2; i++) {
        float binDeviation;
        if (realNew[i] == 0 && imagNew[i] == 0) {
            continue;
        }
        else if ((realPrev[i] == 0 && imagPrev[i] == 0) || 
                 (realOutPrev[i] == 0 && imagOutPrev[i] == 0)) {
            binDeviation = atan2(imagNew[i], realNew[i]);
        }
        else {
            float dPhase = phaseDifference(realPrev[i], imagPrev[i], realNew[i], imagNew[i]);
            float expectedDPhase = i * 2 * M_PI * HOP_LENGTH / WINDOW_SIZE;
            float dPhaseFromExpected = dPhase - expectedDPhase;
            dPhaseFromExpected = fmod(dPhaseFromExpected + (3 * M_PI), 2 * M_PI) - M_PI;
            binDeviation = dPhaseFromExpected * WINDOW_SIZE / (2 * M_PI * HOP_LENGTH);
        }

        float newBin = (i + binDeviation) * phaseScaleAmount;
        int newBinNum = round(newBin);
        float newBinDeviation = newBinNum - newBin;

        synthMags[newBinNum] += sqrt((realNew[i] * realNew[i]) + (imagNew[i] * imagNew[i]));
        synthBinDeviations[newBinNum] += newBinDeviation;
        
        /* Old implementation - did it all in one loop */
        // float dPhase = phaseDifference(realPrev[i], imagPrev[i], realNew[i], imagNew[i]);
        // float newAngle = atan2(imagOutPrev[i], realOutPrev[i]) + (phaseScaleAmount * dPhase);
        // float magnitude = sqrt((realNew[i] * realNew[i]) + (imagNew[i] * imagNew[i]));
        // realOutNew[i] = cos(newAngle) * magnitude;
        // imagOutNew[i] = sin(newAngle) * magnitude;
    }

    for (int i = 0; i < WINDOW_SIZE / 2; i++) {
        float newPhase;
        if (synthMags[i] == 0) {
            newPhase = 0;
        }
        else if (realOutPrev[i] == 0 && imagOutPrev[i] == 0) {
            newPhase = synthBinDeviations[i];
        }
        else {
            float phaseRemainder = synthBinDeviations[i] * 2 * M_PI * HOP_LENGTH / WINDOW_SIZE;
            newPhase = atan2(imagOutPrev[i], realOutPrev[i]) + phaseRemainder + (i * 2 * M_PI * HOP_LENGTH / WINDOW_SIZE);
        }
        realOutNew[i] = cos(newPhase) * synthMags[i];
        imagOutNew[i] = sin(newPhase) * synthMags[i];
        realOutNew[i + WINDOW_SIZE / 2] = cos(-newPhase) * synthMags[i];
        imagOutNew[i + WINDOW_SIZE / 2] = sin(-newPhase) * synthMags[i];
        // printf("ScaleInP: %f, %f\n", realPrev[i], imagPrev[i]);
        // printf("ScaleInC: %f, %f\n", realNew[i], imagNew[i]);
        // printf("newAngle: %f, magnitude: %f\n", newAngle, magnitude);
        // printf("ScaleOut: %f, %f\n", realOutNew[i], imagOutNew[i]);
    }
}