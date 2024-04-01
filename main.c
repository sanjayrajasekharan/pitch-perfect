#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

#define DR_WAV_IMPLEMENTATION
#include "dr_wav.h"

int main(int argc, char** argv) {
    if (argc < 2) {
        return 1;
    }

    const char* filename = argv[1];
    drwav* pWav = drwav_open_file(filename);
    if (pWav == NULL) {
        return 1;
    }

    printf("Channels: %u\n", pWav->channels);
    printf("Sample Rate: %u\n", pWav->sampleRate);
    printf("Bits per sample: %u\n", pWav->bitsPerSample);
    drwav_close(pWav);
    return 0;
}