import sys
from scipy.io import wavfile

samplerate, data = wavfile.read(sys.argv[1])

# print line count
print(data.shape)
if len(sys.argv) > 2:
    with open(sys.argv[2], 'w') as file:
        for sample in data:
            # if sample is a list, write the first element
            if isinstance(sample, list):
                file.write(str(sample[0]) + '\n')
            else:
                file.write(str(sample) + '\n')
else:
    for sample in data:
        if isinstance(sample, list):
            print(sample[0])
        else:
            print(sample)