import sys
from scipy.io import wavfile

samplerate, data = wavfile.read(sys.argv[1])

with open(sys.argv[2], 'w') as file:
    for sample in data:
        file.write(str(sample[0]) + '\n')