#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <math.h>
#include <getopt.h>

#define DR_WAV_IMPLEMENTATION
#include "dr_wav.h"

#include "fft/fft.h"
#include "scaling/scaling.h"


#define WINDOW_SIZE 4096
#define HOP_LENGTH 1024
#define HOPS_PER_WINDOW (WINDOW_SIZE / HOP_LENGTH + (WINDOW_SIZE % HOP_LENGTH != 0)) 

// pitches up by 5 semitones
#define SEMITONE_SHIFT 24
#define PHASE_SHIFT_AMOUNT pow(2.0, (SEMITONE_SHIFT / 12.0))

drwav_int16* pSamples;

drwav* pWav;
int sampleIndex = 0;
int numSamples = 0;

drwav_int16 windows[HOPS_PER_WINDOW][WINDOW_SIZE] = {{0}};

int windowCursors[HOPS_PER_WINDOW];

float currFFTBufferReal[WINDOW_SIZE];
float prevFFTBufferReal[WINDOW_SIZE];

float currFFTBufferImaginary[WINDOW_SIZE];
float prevFFTBufferImaginary[WINDOW_SIZE];
float currScaledReal[WINDOW_SIZE];
float currScaledImag[WINDOW_SIZE];
float prevScaledReal[WINDOW_SIZE];
float prevScaledImag[WINDOW_SIZE];

drwav_int16 outputBuffer[WINDOW_SIZE];
int outputBufferIndex = 0;

int print_windows_flag = 0;

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

void print_usage(char* arg_name) {
    printf("Usage: %s <input.wav> <output.wav> [--print_windows]\n", arg_name);
}

int main(int argc, char** argv) {
    if (argc < 3) {
        // usage with flags and options
        print_usage(argv[0]);
        return 1;
    }

    const char* input_filename = argv[1];
    const char* output_filename = argv[2];

    static struct option long_options[] = {
        {"print_windows", no_argument, &print_windows_flag, 1},
        {0, 0, 0, 0} // End of options
    };

    int opt;
    int option_index = 0;

    while ((opt = getopt_long(argc, argv, "", long_options, &option_index)) != -1) {
        switch (opt) {
        case 0:
            break;
        case '?':
            //print error message here
            fprintf(stderr, "Invalid parameter: %s\n", optarg);
            return 1;
        default:
            abort();
        }
    }

    if (load_samples(input_filename) != 0) {
        return 1;
    }

    // open file to write windows
    FILE* computedWindowsFile = NULL;
    FILE* expectedWindowsFile = NULL;
    if (print_windows_flag) {
        computedWindowsFile = fopen("computed_windows.txt", "w");
        expectedWindowsFile = fopen("expected_windows.txt", "w");

        int i;
        for (i = 0; i < numSamples; i+=HOP_LENGTH) {
            fprintf(expectedWindowsFile, "Window %d:", i/HOP_LENGTH);
            for (int j = 0; j < WINDOW_SIZE; j++) {
                if (i + j >= numSamples) {
                    break;
                }
                fprintf(expectedWindowsFile, " %d", pSamples[i + j]);
            }
            fprintf(expectedWindowsFile, "\n");
        }
    }

    for (int i = 0; i < WINDOW_SIZE; i++) {
        prevScaledReal[i] = 0.0;
        prevScaledImag[i] = 0.0;
        currFFTBufferReal[i] = 0.0;
        currFFTBufferImaginary[i] = 0.0;
    }

    drwav_int16 sample;
    int nextWindow = 0;
    
    while ((sample = getNextSample()) != -1) {
        // printf("Processing sample %d\n", sampleIndex);
        // printf("Window cursors: %d %d %d %d\n", windowCursors[0], windowCursors[1], windowCursors[2], windowCursors[3]);
        // check if any windows are full and process them        
        for (int i = 0; i < HOPS_PER_WINDOW; i++) {
            if (windowCursors[i] == WINDOW_SIZE) {
                // write window to file
                if (print_windows_flag) {
                    fprintf(computedWindowsFile, "Window %d:", i);
                    for (int j = 0; j < WINDOW_SIZE; j++) {
                        fprintf(computedWindowsFile, " %d", windows[i][j]);
                    }

                    fprintf(computedWindowsFile, "\n");
                }
                
                // copy from curr_fft_buffer to prev_fft_buffer
                for (int j = 0; j < WINDOW_SIZE; j++) {
                    prevFFTBufferReal[j] = currFFTBufferReal[j];
                    prevFFTBufferImaginary[j] = currFFTBufferImaginary[j];
                    prevScaledReal[j] = currScaledReal[j];
                    prevScaledImag[j] = currScaledImag[j];
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
                processTransformed(prevFFTBufferReal, prevFFTBufferImaginary,
                                currFFTBufferReal,currFFTBufferImaginary,
                                prevScaledReal, prevScaledImag,
                                currScaledReal, currScaledImag);

                // perform ifft
                inverseCompute(currScaledReal, currScaledImag, WINDOW_SIZE);

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

                // reset window cursor
                windowCursors[i] = 0;

                break;
            }
            // printf("Window %d failed, cursor = %d\n", i, window_cursors[i]);
        }

        // fill windows
        if (sampleIndex % HOP_LENGTH == 0) {
            windowCursors[nextWindow] = 0;
            nextWindow = (nextWindow + 1) % HOPS_PER_WINDOW;
        }
        
        for (int i = 0; i < HOPS_PER_WINDOW; i++) {
            int j = windowCursors[i];
            windows[i][j] = sample;
            windowCursors[i]++;
        }

        sampleIndex++;
    }

    // free memory
    free(pSamples);

    return 0;
}