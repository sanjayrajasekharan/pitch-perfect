import wave

def write_samples_to_text(wav_file, text_file):
    # Open the .wav file
    with wave.open(wav_file, 'rb') as wav:
        # Get the number of frames (samples) in the .wav file
        num_frames = wav.getnframes()

        # Read all the frames (samples) from the .wav file
        frames = wav.readframes(num_frames)

        # Convert the frames to a list of samples
        samples = list(frames)

    # Open the text file in write mode
    with open(text_file, 'w') as txt:
        # Write each sample to a new line in the text file
        for sample in samples:
            txt.write(str(sample) + '\n')

if __name__ == '__main__':
    import sys
    write_samples_to_text(sys.argv[1], sys.argv[2])
