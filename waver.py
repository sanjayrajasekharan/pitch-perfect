import numpy as np
import wave

def read_samples_from_file(filename):
    with open(filename, 'r') as file:
        samples = [float(sample) for sample in file.readlines()]
    return np.array(samples)

def write_wav_file(samples, filename, sample_rate=48000, amplitude=32767):
    wav_file = wave.open(filename, 'w')
    wav_file.setparams((1, 2, sample_rate, len(samples), 'NONE', 'not compressed'))

    # Scale samples to fit within amplitude range
    scaled_samples = np.int16(samples * amplitude)

    # Convert the samples to bytes
    samples_bytes = scaled_samples.tobytes()

    # Write the bytes to the wav file
    wav_file.writeframes(samples_bytes)

    # Close the wav file
    wav_file.close()

if __name__ == "__main__":
    # Change this to the path of your input file
    input_filename = "wavList.txt"

    # Change this to the desired output filename
    output_filename = "pyout.wav"

    # Read samples from input file
    samples = read_samples_from_file(input_filename)

    # Write samples to output wav file
    write_wav_file(samples, output_filename)

    print("WAV file generated successfully.")