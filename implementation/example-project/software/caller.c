#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "wavfile_construction/make_wav.h"
#include "driver/audio.h"
 
#define S_RATE  (44100)
#define REAL_S_RATE (44100)
#define BUF_SIZE (S_RATE*5*2) /* 5 second buffer for L/R */
 
long unsigned int buffer[BUF_SIZE];
int idx;
int audio_fd;

/* Read and save samples from the device to our buffer */
void read_samples() {
    audio_arg_t vla;
  
    if (ioctl(audio_fd, AUDIO_READ_SAMPLES, &vla)) {
        perror("ioctl(AUDIO_READ_SAMPLES) failed");
        return;
    }
		
		buffer[idx++] = vla.samples.l;
		buffer[idx++] = vla.samples.r;
}
 
int main(int argc, char ** argv)
{
    idx = 0;

    static const char filename[] = "/dev/audio";

    printf("Audio Userspace program started\n");

    if ( (audio_fd = open(filename, O_RDWR)) == -1) {
        fprintf(stderr, "could not open %s\n", filename);
        return -1;
    }

		printf("buf size: %d\n", BUF_SIZE);
    while(idx < BUF_SIZE){
        read_samples();
		}

		printf("sample read done, before write_wav");
		for (int i = 100; i < 150; i++)
			printf("samp: %lu\n", buffer[i]);
    write_wav("./wavfiles/anonymous_audio.wav", BUF_SIZE, buffer, S_RATE);

    system("./twilio/place_call.sh");

    printf("Audio Userspace program terminating\n");
    return 0;
}
