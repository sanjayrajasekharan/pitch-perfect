#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <math.h>

#define DR_WAV_IMPLEMENTATION
#include "dr_wav.h"

#include "fft/fft.h"


#define WINDOW_SIZE 4096
#define HOP_LENGTH 1024
// pitches up by 5 semitones
#define SEMITONE_SHIFT 24
#define PHASE_SHIFT_AMOUNT pow(2.0, (SEMITONE_SHIFT / 12.0))

drwav_int16* pSamples;
drwav_int16* outputSamples;

drwav* pWav;
int sampleIndex = 0;
int numSamples = 0;

drwav_int16* windows[4]; // 4 windows of 4096 samples

drwav_int16 window0[WINDOW_SIZE];
drwav_int16 window1[WINDOW_SIZE];
drwav_int16 window2[WINDOW_SIZE];
drwav_int16 window3[WINDOW_SIZE];

int windowCursors[4];

float currFFTBufferReal[WINDOW_SIZE];
float prevFFTBufferReal[WINDOW_SIZE];

float currFFTBufferImaginary[WINDOW_SIZE];
float prevFFTBufferImaginary[WINDOW_SIZE];

drwav_int16 outputBuffer[WINDOW_SIZE];
int outputBufferIndex = 0;

double phaseDifference(float real1, float imag1, float real2, float imag2) {
    return atan2(imag2, real2) - atan2(imag1, real1);
}

/* set new vectors to prev vectors shifted by desired amount */
void shiftPhase(float* realPrev, float* imagPrev, float* realNew,
              float* imagNew) {
    for (int i = 0; i < WINDOW_SIZE / 2; i++) {
        float angleDiff = phaseDifference(realPrev[i], imagPrev[i], realNew[i],
                                          imagNew[i]);
        float shiftAngle = PHASE_SHIFT_AMOUNT * angleDiff;
        float cosShift = cos(shiftAngle);
        float sinShift = sin(shiftAngle);
        realNew[i] = realPrev[i] * cosShift - imagPrev[i] * sinShift;
        imagNew[i] = realPrev[i] * sinShift + imagPrev[i] * cosShift;
    }
}

/* scales prev vectors to have length of corresponding new vectors */
void getCorrectMagnitudes(float* realPrev, float* imagPrev,
                         float* realNew, float* imagNew) {
    for (int i = 0; i < WINDOW_SIZE / 2; i++) {
        float magPrev = sqrt(realPrev[i] * realPrev[i] +
                             imagPrev[i] * imagPrev[i]);
        float magNew = sqrt(realNew[i] * realNew[i] + imagNew[i] * imagNew[i]);
        realPrev[i] = realPrev[i] * magPrev / magNew;
        imagPrev[i] = imagPrev[i] * magPrev / magNew;
    }
}

void getPhaseDifferences(float* realPrev, float* imagPrev, float* realNew,
                         float* imagNew, float* phaseDifferences) {
    for (int i = 0; i < WINDOW_SIZE / 2; i++) {
        phaseDifferences[i] = phaseDifference(realPrev[i], imagPrev[i],
                                              realNew[i], imagNew[i]);
    }
}

void applyHannWindow(drwav_int16* samples, float* output, size_t numSamples) {
    for (size_t i = 0; i < numSamples; ++i) {
        float w = 0.5 * (1 - cos(2 * M_PI * i / (numSamples - 1)));
        float windowedSample = samples[i] * w;

        output[i] = windowedSample;
    }
}

int load_samples(const char* filename) {
    pWav = drwav_open_file(filename);
    if (pWav == NULL) {
        perror("Failed to open input file");
        return 1;
    }

    drwav_int16* multiChannel = (drwav_int16*) malloc(pWav->totalSampleCount * sizeof(drwav_int16));
    // pSamples = (drwav_int16*) malloc(pWav->totalSampleCount * sizeof(drwav_int16));


    if (pWav->totalSampleCount != drwav_read_s16(pWav, pWav->totalSampleCount, multiChannel)) {
        perror("Failed to read samples");
        return 1;
    }

    numSamples =  pWav->totalSampleCount/(pWav->channels);
    pSamples = (drwav_int16*) malloc(numSamples * sizeof(drwav_int16));

    // printf("Total samples: %llu\n", pWav->totalSampleCount);
    // printf("Downmixed samples: %d\n", numSamples);

    //downmix to mono
    int sampleIndex = 0;
    drwav_int64 sum;
    for (int i = 0; i < numSamples; i+=pWav->channels) {
        sum = 0;
        for (int j = 0; j < pWav->channels; j++) {
            sum += multiChannel[i + j];
        }

        pSamples[sampleIndex++] = (drwav_int16) (sum / pWav->channels);
    }

    free(multiChannel);

    sampleIndex = 0;

    return 0;
}

int getNextSample() {
    // printf("Getting sample %d\n", sampleIndex);
    if (sampleIndex < 0) {
        printf("Invalid sample index\n");
        return -1;
    }

    if (sampleIndex >= numSamples) {
        // printf("Reached end of samples %d >= %d\n", sampleIndex, numSamples);
        return -1;
    }

    drwav_int16 sample = pSamples[sampleIndex];
    if (sample == -1)
        return 0;
    
    return sample;
}

int main(int argc, char** argv) {
    if (argc < 3) {
        printf("Usage: %s <input.wav> <output.wav>\n", argv[0]);
        return 1;
    }

    const char* input_filename = argv[1];
    const char* output_filename = argv[2];

    if (load_samples(input_filename) != 0) {
        return 1;
    }

    windows[0] = window0;
    windows[1] = window1;
    windows[2] = window2;
    windows[3] = window3;

    outputSamples = (drwav_int16*) malloc(numSamples * sizeof(drwav_int16) * 4);

    drwav_int16 sample;
    int outputSampleIndex = 0;
    int nextWindow = 0;
    
    while ((sample = getNextSample()) != -1) {
        // printf("Processing sample %d\n", sampleIndex);
        // printf("Window cursors: %d %d %d %d\n", windowCursors[0], windowCursors[1], windowCursors[2], windowCursors[3]);
        // check if any windows are full and process them        
        for (int i = 0; i < 4; i++) {
            if (windowCursors[i] == WINDOW_SIZE) {
                // process window, perhapse we should fork here
                // printf("Processing window %d\n", i);
                
                // copy from curr_fft_buffer to prev_fft_buffer
                for (int j = 0; j < WINDOW_SIZE; j++) {
                    prevFFTBufferReal[j] = currFFTBufferReal[j];
                    prevFFTBufferImaginary[j] = currFFTBufferImaginary[j];
                }

                applyHannWindow(windows[i], currFFTBufferReal, WINDOW_SIZE);
                
                // perform fft
                for (int j = 0; j < WINDOW_SIZE; j++) {
                    currFFTBufferImaginary[j] = 0.0;
                }
                rearrange(currFFTBufferReal, currFFTBufferImaginary, WINDOW_SIZE);
                compute(currFFTBufferReal, currFFTBufferImaginary, WINDOW_SIZE);

                // perform pitch scaling
                /* first, scale prevs in-place to have magnitudes of curr */
                getCorrectMagnitudes(prevFFTBufferReal,
                                     prevFFTBufferImaginary,
                                     currFFTBufferReal,
                                     currFFTBufferImaginary);
                /* then, shift phases by desired amount and store in curr */
                shiftPhase(prevFFTBufferReal, prevFFTBufferImaginary,
                           currFFTBufferReal, currFFTBufferImaginary);

                // perform ifft
                rearrange(currFFTBufferReal, currFFTBufferImaginary, WINDOW_SIZE);
                inverseCompute(currFFTBufferReal, currFFTBufferImaginary, WINDOW_SIZE);

                // // copy samples to output buffer
                for (int j = 0; j < WINDOW_SIZE; j++) {
                    // right now we are just copying the samples
                    outputSamples[outputSampleIndex + j] = windows[i][j];
                }

                outputSampleIndex = outputSampleIndex + WINDOW_SIZE;
                // printf("outputSampleIndex: %d\n", outputSampleIndex);

                // ring buffer
                int j = 0;
                while(j < WINDOW_SIZE) {
                    outputBuffer[(outputBufferIndex + j) % WINDOW_SIZE] = windows[i][j];
                    j++;
                }

                for (int j = 0; j < HOP_LENGTH; j++) {
                    printf("%d\n", outputBuffer[outputBufferIndex + j]);
                    outputBuffer[outputBufferIndex + j] = 0;
                }

                outputBufferIndex = (outputBufferIndex + HOP_LENGTH) % WINDOW_SIZE;

                break;
            }
            // printf("Window %d failed, cursor = %d\n", i, window_cursors[i]);
        }

        // fill windows
        if (sampleIndex % HOP_LENGTH == 0) {
            windowCursors[nextWindow] = 0;
            nextWindow = (nextWindow + 1) % 4;
        }
        
        for (int i = 0; i < 4; i++) {
            int j = windowCursors[i];
            windows[i][j] = sample;
            windowCursors[i]++;
        }

        sampleIndex++;
        // printf("Sample Index: %d\n", sampleIndex);
    }

    // printf("finished samples\n");
    // printf("outputSampleIndex: %d\n", outputSampleIndex);

    // for (int i = 0; i < outputSampleIndex; i++) {
    //     printf("%d\n", outputSamples[i]);
    // }


    // free memory
    free(pSamples);
    free(outputSamples);

    return 0;
}