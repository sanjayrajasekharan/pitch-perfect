#include <stdio.h>
#include "scaling.h"

#define WINDOW_SIZE 4096

int main(int argc, char** argv) {

    float testReal1[WINDOW_SIZE]; // previous FFT transform
    float testImag1[WINDOW_SIZE];
    float testReal2[WINDOW_SIZE]; // current FFT transform
    float testImag2[WINDOW_SIZE];
    float testPrevReal[WINDOW_SIZE]; // previous pitch scaled
    float testPrevImag[WINDOW_SIZE];
    float testOutReal[WINDOW_SIZE]; // current output
    float testOutImag[WINDOW_SIZE];

    for (int i = 0; i < WINDOW_SIZE; i++) {
        testReal1[i] = 1.0;
        testImag1[i] = 0.0;
        testReal2[i] = 0.0;
        testImag2[i] = 2.0;
        testPrevReal[i] = 1.0;
        testPrevImag[i] = 0.0;
    }

    processTransformed(testReal1, testImag1, testReal2, testImag2,
                       testPrevReal, testPrevImag, testOutReal, testOutImag);

    for (int i = 0; i < WINDOW_SIZE; i++) {
        printf("test1: (%f, %f)\n", testReal1[i], testImag1[i]);
        printf("test2: (%f, %f)\n", testReal2[i], testImag2[i]);
        printf("prev: (%f, %f)\n", testPrevReal[i], testPrevImag[i]);
        printf("out: (%f, %f)\n", testOutReal[i], testOutImag[i]);
    }

}