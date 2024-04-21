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

float wrapPhase(float phaseIn)
{
    if (phaseIn >= 0)
        return fmodf(phaseIn + M_PI, 2.0 * M_PI) - M_PI;
    else
        return fmodf(phaseIn - M_PI, -2.0 * M_PI) + M_PI;	
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
            continue;
        }
        else if (realPrev[i] == 0 && imagPrev[i] == 0) {
            dPhase = i * 2 * M_PI * HOP_LENGTH / WINDOW_SIZE;
        }
        else {
            dPhase = phaseDifference(realPrev[i], imagPrev[i], realNew[i], imagNew[i]);
        }

        float expectedDPhase = i * 2 * M_PI * HOP_LENGTH / WINDOW_SIZE;
        float dPhaseFromExpected = dPhase - expectedDPhase; // compute phase remainder
        // dPhaseFromExpected = fmodf(fmodf(dPhaseFromExpected, 2 * M_PI) + (2 * M_PI), 2 * M_PI) - M_PI;
        float binDeviation = wrapPhase(dPhaseFromExpected) * WINDOW_SIZE / (2 * M_PI * HOP_LENGTH);
        float newBin = (i + binDeviation) * phaseScaleAmount;
        int newBinNum = fmax(fmin(round(newBin), WINDOW_SIZE - 1), 0); // round cap at max bin
        float newBinDeviation = newBin - newBinNum;

        synthMags[newBinNum] += sqrt((realNew[i] * realNew[i]) + (imagNew[i] * imagNew[i]));
        synthBinDeviations[newBinNum] += newBinDeviation;
    }

    for (int i = 0; i < WINDOW_SIZE / 2; i++) {
        float newPhase;
        if (synthMags[i] == 0) {
            newPhase = 0;
        }
        else if (realOutPrev[i] == 0 && imagOutPrev[i] == 0) {
            newPhase = synthBinDeviations[i];        }
        else {
            float phaseRemainder = synthBinDeviations[i] * 2 * M_PI * HOP_LENGTH / WINDOW_SIZE;
            newPhase = atan2(imagOutPrev[i], realOutPrev[i]) + phaseRemainder + (i * 2 * M_PI * HOP_LENGTH / WINDOW_SIZE);
        }
        realOutNew[i] = cos(newPhase) * synthMags[i];
        imagOutNew[i] = sin(newPhase) * synthMags[i];
        if (i != 0) {
            realOutNew[WINDOW_SIZE - i] = cos(-newPhase) * synthMags[i];
            imagOutNew[WINDOW_SIZE - i] = sin(-newPhase) * synthMags[i];
        }
    }
}

void simpleTransform(float* realPrev, float* imagPrev, float* realNew,
                        float* imagNew, float* realOutPrev, float* imagOutPrev,
                        float* realOutNew, float* imagOutNew, double phaseScaleAmount) {
    
    for (int i = 0; i < WINDOW_SIZE; i++) {
        synthMags[i] = 0;
    }

    for (int i = 0; i < WINDOW_SIZE / 2; i++) {
        if (realNew[i] == 0 && imagNew[i] == 0) {
            continue;
        }
        int newBinNum = round(i * phaseScaleAmount);
        synthMags[newBinNum] += sqrt((realNew[i] * realNew[i]) + (imagNew[i] * imagNew[i]));
    }

    for (int i = 0; i < WINDOW_SIZE / 2; i++) {
        float newPhase;
        if (synthMags[i] == 0) {
            newPhase = 0;
        }
        else if (realOutPrev[i] == 0 && imagOutPrev[i] == 0) {
            newPhase = 0;
        }
        else {
            newPhase = atan2(imagOutPrev[i], realOutPrev[i]) + (i * 2 * M_PI * HOP_LENGTH / WINDOW_SIZE);
        }
        realOutNew[i] = cos(newPhase) * synthMags[i];
        imagOutNew[i] = sin(newPhase) * synthMags[i];
        if (i != 0) {
            realOutNew[WINDOW_SIZE - i] = cos(-newPhase) * synthMags[i];
            imagOutNew[WINDOW_SIZE - i] = sin(-newPhase) * synthMags[i];
        }
    }
}