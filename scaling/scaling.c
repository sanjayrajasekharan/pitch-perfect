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
    
    for (int i = 0; i < WINDOW_SIZE; i++) {
        synthMags[i] = 0;
        synthBinDeviations[i] = 0;
    }

    for (int i = 0; i < WINDOW_SIZE / 2; i++) {
        float dPhase;
        if (realNew[i] == 0 && imagNew[i] == 0) {
            // printf("cur 0s\n");
            continue;
        }
        else if (realPrev[i] == 0 && imagPrev[i] == 0) {
            // dPhase = atan2(imagNew[i], realNew[i]);
            dPhase = i * 2 * M_PI * HOP_LENGTH / WINDOW_SIZE;
            // printf("prev 0s\n");
        }
        else {
            // printf("no 0s\n");
            dPhase = phaseDifference(realPrev[i], imagPrev[i], realNew[i], imagNew[i]);
        }

        float expectedDPhase = i * 2 * M_PI * HOP_LENGTH / WINDOW_SIZE;
        float dPhaseFromExpected = dPhase - expectedDPhase;
        dPhaseFromExpected = fmod(dPhaseFromExpected + (3 * M_PI), 2 * M_PI) - M_PI;
        float binDeviation = dPhaseFromExpected * WINDOW_SIZE / (2 * M_PI * HOP_LENGTH);
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
            // printf("mags 0\n");
        }
        else if (realOutPrev[i] == 0 && imagOutPrev[i] == 0) {
            newPhase = synthBinDeviations[i];
            // printf("prev 0\n");
        }
        else {
            // printf("no 0 2\n");
            float phaseRemainder = synthBinDeviations[i] * 2 * M_PI * HOP_LENGTH / WINDOW_SIZE;
            newPhase = atan2(imagOutPrev[i], realOutPrev[i]) + phaseRemainder + (i * 2 * M_PI * 2 * M_PI * HOP_LENGTH / WINDOW_SIZE);
            // newPhase = atan2(imagOutPrev[i], realOutPrev[i]) + (i * 2 * M_PI * HOP_LENGTH / WINDOW_SIZE);
        }
        realOutNew[i] = cos(newPhase) * synthMags[i];
        imagOutNew[i] = sin(newPhase) * synthMags[i];
        if (i != 0) {
            realOutNew[WINDOW_SIZE - i] = cos(-newPhase) * synthMags[i];
            imagOutNew[WINDOW_SIZE - i] = sin(-newPhase) * synthMags[i];
        }
        if (i == 61) {
            // printf("61 prev phase: %f\n", atan2(imagOutPrev[i], realOutPrev[i]));
            // // printf("61 mag: %f\n", synthMags[i]);
            // printf("61 phase mod: %f\n", atan2(imagOutNew[i], realOutNew[i]));
            // printf("61 expect next phase: %f\n", fmod(newPhase + (61 * 2 * M_PI * HOP_LENGTH / WINDOW_SIZE), 2 * M_PI));
        }
        // printf("ScaleInP: %f, %f\n", realPrev[i], imagPrev[i]);
        // printf("ScaleInC: %f, %f\n", realNew[i], imagNew[i]);
        // printf("newAngle: %f, magnitude: %f\n", newAngle, magnitude);
        // printf("ScaleOut: %f, %f\n", realOutNew[i], imagOutNew[i]);
    }

    // for (int i = 50; i < 70; i++) {
    //     printf("Bin %d mag: %f\n", i, sqrt((imagOutNew[i] * imagOutNew[i]) + (realOutNew[i] * realOutNew[i])));
    // }

    realOutNew[0] = realNew[0];
    imagOutNew[0] = imagNew[0];
}