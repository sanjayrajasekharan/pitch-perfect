#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <math.h>

#define DR_WAV_IMPLEMENTATION
#include "dr_wav.h"

#include "fft/fft.h"


#define WINDOW_SIZE 4096
#define HOP_LENGTH 1024

drwav_int16* pSamples;
drwav_int16* output_samples;

drwav* pWav;
int sampleIndex = 0;
int numSamples = 0;

drwav_int16* windows[4]; // 4 windows of 4096 samples
int window_cursors[4];

float* curr_fft_buffer_real;
float* prev_fft_buffer_real;

float* curr_fft_buffer_imaginary;
float* prev_fft_buffer_imaginary;


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

    drwav_int16* multi_channel = (drwav_int16*) malloc(pWav->totalSampleCount * sizeof(drwav_int16));
    // pSamples = (drwav_int16*) malloc(pWav->totalSampleCount * sizeof(drwav_int16));


    if (pWav->totalSampleCount != drwav_read_s16(pWav, pWav->totalSampleCount, multi_channel)) {
        perror("Failed to read samples");
        return 1;
    }

    numSamples =  pWav->totalSampleCount/(pWav->channels);
    pSamples = (drwav_int16*) malloc(numSamples * sizeof(drwav_int16));

    printf("Total samples: %llu\n", pWav->totalSampleCount);
    printf("Downmixed samples: %d\n", numSamples);

    //downmix to mono
    int sample_index = 0;
    drwav_int64 sum;
    for (int i = 0; i < numSamples; i+=pWav->channels) {
        sum = 0;
        for (int j = 0; j < pWav->channels; j++) {
            sum += multi_channel[i + j];
        }

        pSamples[sample_index++] = (drwav_int16) (sum / pWav->channels);
    }

    free(multi_channel);

    sampleIndex = 0;

    return 0;
}

int get_next_sample() {
    if (sampleIndex < 0) {
        printf("Invalid sample index\n");
        return -1;
    }

    if (sampleIndex >= numSamples) {
        printf("Reached end of samples\n");
        return -1;
    }

    printf("quack\n");

    drwav_int16 sample = pSamples[sampleIndex++];
    if (sample == -1)
        return 0;
    
    printf("Sample: %d\n", sample);
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

    // initialize windows and buffers

    // allocate memory for windows
    for (int i = 0; i < 4; i++) {
        windows[i] = (drwav_int16*) malloc(WINDOW_SIZE * sizeof(drwav_int16));
    }

    //allocate memory for fft  buffers
    curr_fft_buffer_real = (float*) malloc(WINDOW_SIZE * sizeof(float));
    prev_fft_buffer_real = (float*) malloc(WINDOW_SIZE * sizeof(float));

    curr_fft_buffer_imaginary = (float*) malloc(WINDOW_SIZE * sizeof(float));
    prev_fft_buffer_imaginary = (float*) malloc(WINDOW_SIZE * sizeof(float));

    output_samples = (drwav_int16*) malloc(numSamples * sizeof(drwav_int16));

    drwav_int16 sample;
    int output_sample_index = 0;
    int next_window = 0;
    
    while ((sample = get_next_sample()) != -1) {
        // printf("Processing sample %d\n", sampleIndex);
        // printf("Window cursors: %d %d %d %d\n", window_cursors[0], window_cursors[1], window_cursors[2], window_cursors[3]);
        // check if any windows are full and process them
        for (int i = 0; i < 4; i++) {
            if (window_cursors[i] == WINDOW_SIZE) {
                // process window, perhapse we should fork here
                
                // copy from curr_fft_buffer to prev_fft_buffer
                for (int j = 0; j < WINDOW_SIZE; j++) {
                    prev_fft_buffer_real[j] = curr_fft_buffer_real[j];
                    prev_fft_buffer_imaginary[j] = curr_fft_buffer_imaginary[j];
                }

                applyHannWindow(windows[i], curr_fft_buffer_real, WINDOW_SIZE);
                
                // perform fft
                for (int j = 0; j < WINDOW_SIZE; j++) {
                    curr_fft_buffer_imaginary[j] = 0.0;
                }

                rearrange(curr_fft_buffer_real, curr_fft_buffer_imaginary, WINDOW_SIZE);
                compute(curr_fft_buffer_real, curr_fft_buffer_imaginary, WINDOW_SIZE);


                // TODO: @stevenwinnick --> perform pitch scaling

                // copy samples to output buffer
                printf("Copying samples to output buffer\n");
                 for (int j = 0; j < WINDOW_SIZE; j++) {
                    //right now we are just copying the samples
                    output_samples[output_sample_index + j] = windows[i][j];
                }

                output_sample_index += WINDOW_SIZE;
                break;
            }
        }

        // fill windows
        if (sampleIndex % HOP_LENGTH == 0) {
            window_cursors[next_window] = 0;
            next_window = (next_window + 1) % 4;
        }
        
        for (int i = 0; i < 4; i++) {
            int j = window_cursors[i];
            windows[i][j] = sample;
            window_cursors[i]++;
        }

        sampleIndex++;
    }

    printf("finished samples\n");


    //write output_samples to wav file

    pWav = drwav_open_file(input_filename);

    drwav_int16* multi_channel = (drwav_int16*) malloc(pWav->totalSampleCount * sizeof(drwav_int16));
    if (pWav->totalSampleCount != drwav_read_s16(pWav, pWav->totalSampleCount, multi_channel)) {
        perror("Failed to read samples");
        return 1;
    }
    
    drwav_close(pWav);

    drwav_data_format format;
    format.container = drwav_container_riff;     // <-- drwav_container_riff = normal WAV files, drwav_container_w64 = Sony Wave64.
    format.format = DR_WAVE_FORMAT_PCM;          // <-- Any of the DR_WAVE_FORMAT_* codes.
    format.channels = pWav->channels;
    format.sampleRate = pWav->sampleRate;
    format.bitsPerSample = pWav->bitsPerSample;
    drwav* output_wav;
    
    if(!(output_wav = drwav_open_file_write(output_filename, &format))) {
        perror("Failed to open output file");
        return 1;
    }
    
    drwav_uint64 framesWrittten = drwav_write(output_wav, pWav->totalSampleCount, multi_channel);
    if (framesWrittten != pWav->totalSampleCount) {
        perror("Failed to write output samples");
        return 1;
    }
    // drwav_write(output_wav, pWav->totalSampleCount, multi_channel);

    free(multi_channel);
    
    drwav_close(output_wav);

    printf("Wrote output samples to %s\n", output_filename);


    // free memory
    for (int i = 0; i < 4; i++) {
        free(windows[i]);
    }
    
    free(curr_fft_buffer_real);
    free(prev_fft_buffer_real);

    free(curr_fft_buffer_imaginary);
    free(prev_fft_buffer_imaginary);

    free(pSamples);
    free(output_samples);

    return 0;
}