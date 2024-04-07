#include <stdio.h>
#include <math.h>
#include "scaling.h"

#define WINDOW_SIZE 4096

int approx(float a, float b) {
    if (!(fabs(a - b) < 0.001)) {
        printf("%f neq %f", a, b);
    }
    return fabs(a - b) < 0.001;
}

int main(int argc, char** argv) {

    float testReal1[WINDOW_SIZE]; // previous FFT transform
    float testImag1[WINDOW_SIZE];
    float testReal2[WINDOW_SIZE]; // current FFT transform
    float testImag2[WINDOW_SIZE];
    float testPrevReal[WINDOW_SIZE]; // previous pitch scaled
    float testPrevImag[WINDOW_SIZE];
    float testOutReal[WINDOW_SIZE]; // current output
    float testOutImag[WINDOW_SIZE];

    printf("Test 1: No change\n");
    int passed = 1;
    for (int i = 0; i < WINDOW_SIZE; i++) {
        testReal1[i] = 1.0;
        testImag1[i] = 0.0;
        testReal2[i] = 1.0;
        testImag2[i] = 0.0;
        testPrevReal[i] = 1.0;
        testPrevImag[i] = 0.0;
    }
    processTransformed(testReal1, testImag1, testReal2, testImag2,
                       testPrevReal, testPrevImag, testOutReal, testOutImag,
                       pow(2.0, 0.0));
    for (int i = 0; i < WINDOW_SIZE; i++) {
        if (!approx(testOutReal[i], 1.0) || !approx(testOutImag[i], 0.0)) {
            printf(" for i = %d\n", i);
            passed = 0;
            break;
        }
    }
    if (passed) {
        printf("Passed\n");
    } else {
        printf("Failed\n");
    }

    printf("Test 2: Simple rotation\n");
    passed = 1;
    for (int i = 0; i < WINDOW_SIZE; i++) {
        testReal1[i] = 1.0;
        testImag1[i] = 0.0;
        testReal2[i] = 0.0;
        testImag2[i] = 1.0;
        testPrevReal[i] = 0.0;
        testPrevImag[i] = 1.0;
    }
    processTransformed(testReal1, testImag1, testReal2, testImag2,
                       testPrevReal, testPrevImag, testOutReal, testOutImag,
                       pow(2.0, 0.0));
    for (int i = 0; i < WINDOW_SIZE; i++) {
        if (!approx(testOutReal[i], -1.0) || !approx(testOutImag[i], 0.0)) {
            printf(" for i = %d\n", i);
            passed = 0;
            break;
        }
    }
    if (passed) {
        printf("Passed\n");
    } else {
        printf("Failed\n");
    }

    printf("Test 3: Shifted start\n");
    passed = 1;
    for (int i = 0; i < WINDOW_SIZE; i++) {
        testReal1[i] = 1.0;
        testImag1[i] = 0.0;
        testReal2[i] = 0.0;
        testImag2[i] = 1.0;
        testPrevReal[i] = -1.0;
        testPrevImag[i] = 0.0;
    }
    processTransformed(testReal1, testImag1, testReal2, testImag2,
                       testPrevReal, testPrevImag, testOutReal, testOutImag,
                       pow(2.0, 0.0));
    for (int i = 0; i < WINDOW_SIZE; i++) {
        if (!approx(testOutReal[i], 0.0) || !approx(testOutImag[i], -1.0)) {
            printf(" for i = %d\n", i);
            passed = 0;
            break;
        }
    }
    if (passed) {
        printf("Passed\n");
    } else {
        printf("Failed\n");
    }

    printf("Test 4: Different Magnitudes\n");
    passed = 1;
    for (int i = 0; i < WINDOW_SIZE; i++) {
        testReal1[i] = 1.0;
        testImag1[i] = 0.0;
        testReal2[i] = 0.0;
        testImag2[i] = 2.0;
        testPrevReal[i] = -1.0;
        testPrevImag[i] = 0.0;
    }
    processTransformed(testReal1, testImag1, testReal2, testImag2,
                       testPrevReal, testPrevImag, testOutReal, testOutImag,
                       pow(2.0, 0.0));
    for (int i = 0; i < WINDOW_SIZE; i++) {
        if (!approx(testOutReal[i], 0.0) || !approx(testOutImag[i], -2.0)) {
            printf(" for i = %d\n", i);
            passed = 0;
            break;
        }
    }
    if (passed) {
        printf("Passed\n");
    } else {
        printf("Failed\n");
    }

    printf("Test 5: Scaled shifts up\n");
    passed = 1;
    for (int i = 0; i < WINDOW_SIZE; i++) {
        testReal1[i] = 1.5;
        testImag1[i] = 1.5;
        testReal2[i] = 0.0;
        testImag2[i] = 2.0;
        testPrevReal[i] = -3.5;
        testPrevImag[i] = -3.5;
    }
    processTransformed(testReal1, testImag1, testReal2, testImag2,
                       testPrevReal, testPrevImag, testOutReal, testOutImag,
                       pow(2.0, 1.0));
    for (int i = 0; i < WINDOW_SIZE; i++) {
        if (!approx(testOutReal[i], sqrt(2)) || !approx(testOutImag[i], -sqrt(2))) {
            printf(" for i = %d\n", i);
            passed = 0;
            break;
        }
    }
    if (passed) {
        printf("Passed\n");
    } else {
        printf("Failed\n");
    }

    printf("Test 6: Scaled shifts down\n");
    passed = 1;
    for (int i = 0; i < WINDOW_SIZE; i++) {
        testReal1[i] = 0.4;
        testImag1[i] = 0.4;
        testReal2[i] = -0.6;
        testImag2[i] = -0.6;
        testPrevReal[i] = -1.0;
        testPrevImag[i] = 0.0;
    }
    processTransformed(testReal1, testImag1, testReal2, testImag2,
                       testPrevReal, testPrevImag, testOutReal, testOutImag,
                       pow(2.0, -1.0));
    for (int i = 0; i < WINDOW_SIZE; i++) {
        if (!approx(testOutReal[i], 0.0) || !approx(testOutImag[i], sqrt(0.72))) {
            printf(" for i = %d\n", i);
            passed = 0;
            break;
        }
    }
    if (passed) {
        printf("Passed\n");
    } else {
        printf("Failed\n");
    }

    printf("Test 7: Shifting backwards\n");
    passed = 1;
    for (int i = 0; i < WINDOW_SIZE; i++) {
        testReal1[i] = 0.0;
        testImag1[i] = 1.0;
        testReal2[i] = 1.0;
        testImag2[i] = 0.0;
        testPrevReal[i] = 0.0;
        testPrevImag[i] = -1.0;
    }
    processTransformed(testReal1, testImag1, testReal2, testImag2,
                       testPrevReal, testPrevImag, testOutReal, testOutImag,
                       pow(2.0, 0.0));
    for (int i = 0; i < WINDOW_SIZE; i++) {
        if (!approx(testOutReal[i], -1.0) || !approx(testOutImag[i], 0.0)) {
            printf(" for i = %d\n", i);
            passed = 0;
            break;
        }
    }
    if (passed) {
        printf("Passed\n");
    } else {
        printf("Failed\n");
    }

    printf("Test 8: Prev FFT 0\n");
    passed = 1;
    for (int i = 0; i < WINDOW_SIZE; i++) {
        testReal1[i] = 0.0;
        testImag1[i] = 0.0;
        testReal2[i] = 1.2;
        testImag2[i] = -3.4;
        testPrevReal[i] = -5.6;
        testPrevImag[i] = 7.8;
    }
    processTransformed(testReal1, testImag1, testReal2, testImag2,
                       testPrevReal, testPrevImag, testOutReal, testOutImag,
                       pow(2.0, 1.2));
    for (int i = 0; i < WINDOW_SIZE; i++) {
        if (!approx(testOutReal[i], 1.2) || !approx(testOutImag[i], -3.4)) {
            printf(" for i = %d\n", i);
            passed = 0;
            break;
        }
    }
    if (passed) {
        printf("Passed\n");
    } else {
        printf("Failed\n");
    }

    printf("Test 9: Prev output 0\n");
    passed = 1;
    for (int i = 0; i < WINDOW_SIZE; i++) {
        testReal1[i] = 1.2;
        testImag1[i] = 3.4;
        testReal2[i] = -5.6;
        testImag2[i] = -7.8;
        testPrevReal[i] = 0.0;
        testPrevImag[i] = 0.0;
    }
    processTransformed(testReal1, testImag1, testReal2, testImag2,
                       testPrevReal, testPrevImag, testOutReal, testOutImag,
                       pow(2.0, 0.0));
    for (int i = 0; i < WINDOW_SIZE; i++) {
        if (!approx(testOutReal[i], -5.6) || !approx(testOutImag[i], -7.8)) {
            printf(" for i = %d\n", i);
            passed = 0;
            break;
        }
    }
    if (passed) {
        printf("Passed\n");
    } else {
        printf("Failed\n");
    }

}