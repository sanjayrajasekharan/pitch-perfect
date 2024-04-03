// #include <stdlib.h>
// #include <stdint.h>
#include <stdio.h>
#include <math.h>

#define DR_WAV_IMPLEMENTATION
#include "../dr_wav.h"

#include "../fft/fft.h"


#define WINDOW_SIZE 4096
#define HOP_LENGTH 1024
// pitches up by 5 semitones
#define PHASE_SHIFT_AMOUNT pow(2.0, (5.0 / 12.0))

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

float inputSamples[WINDOW_SIZE * 4];
int inputWindowStart = 0;
int inputCurIdx = 0;
float hannBuf[WINDOW_SIZE];
float *realBufs[2];
float *imagBufs[2];
int fftBufIdx = 0;
float realBuf1[WINDOW_SIZE];
float realBuf2[WINDOW_SIZE];
float imagBuf1[WINDOW_SIZE];
float imagBuf2[WINDOW_SIZE];


int main(int argc, char** argv)
{

    realBufs[0] = realBuf1;
    realBufs[1] = realBuf2;
    imagBufs[0] = imagBuf1;
    imagBufs[1] = imagBuf2;

    for (;;) {

        // Read in 1 sample from stdin
        fread(&inputSamples[inputCurIdx], sizeof(float), 1, stdin);

        // Abstraction: assume all processing takes place in span of 1 sample
        if (inputCurIdx == (inputWindowStart + WINDOW_SIZE) % (WINDOW_SIZE * 2)) {
            applyHannWindow(&inputSamples[inputWindowStart], hannBuf, WINDOW_SIZE);

            // Perform FFT
            for (int i = 0; i < WINDOW_SIZE; i++) {
                realBufs[fftBufIdx][i] = hannBuf[i];
            }
            rearrange(realBufs[fftBufIdx], imagBufs[fftBufIdx], WINDOW_SIZE);
            compute(realBufs[fftBufIdx], imagBufs[fftBufIdx], WINDOW_SIZE);
            for (int i = 0; i < WINDOW_SIZE; i++) {
                real_bufs[fft_buf_idx][i] = hann_bufs[hann_buf_idx][i];
            }
            hann_buf_idx = (hann_buf_idx + 1) % 2;
            fft_buf_idx = (fft_buf_idx + 1) % 2;

            // Shift phase
            getCorrectMagnitudes(real_bufs[(fft_buf_idx + 1) % 2],
                                 imag_bufs[(fft_buf_idx + 1) % 2],
                                 real_bufs[fft_buf_idx],
                                 imag_bufs[fft_buf_idx]);
            shiftPhase(real_bufs[(fft_buf_idx + 1) % 2], 
                       imag_bufs[(fft_buf_idx + 1) % 2],
                       real_bufs[fft_buf_idx], imag_bufs[fft_buf_idx]);

            // Perform IFFT
            rearrange(real_bufs[fft_buf_idx], imag_bufs[fft_buf_idx], 
                      WINDOW_SIZE);
            inverseCompute(real_bufs[fft_buf_idx], imag_bufs[fft_buf_idx], 
                           WINDOW_SIZE);
            
            // Output the processed samples
            fwrite(real_bufs[fft_buf_idx], sizeof(float), WINDOW_SIZE, stdout);

            // Slide the window
            cur_window_start += HOP_LENGTH;
            cur_input_idx = (inputCurIdx + 1) % WINDOW_SIZE;
        }

    }

}