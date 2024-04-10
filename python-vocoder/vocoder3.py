"""
vocoder3.py

Pitch scaling algorithm following
https://github.com/BelaPlatform/bela-online-course/blob/master/lectures/lecture-20/code-examples/fft-pitchshift.zip
using Python based on https://github.com/JentGent/pitch-shift/blob/main/audios.ipynb
"""

import librosa
import numpy as np
import soundfile as sf
import sys

WINDOW_SIZE = 4096 # win_len, n_fft
HOP_LEN = 1024 # hop_len
PHASE_SHIFT_AMOUNT = 2 ** (5 / 12) # scaling

waveform, samp_rate = librosa.load(sys.argv[1], sr=None, mono=True) # waveform, sr # used to not be mono
num_samples = waveform.shape[0] # og_len
print("Number of samples in the input wav:", num_samples)
print("Sampling rate of the input wav:", samp_rate)

stft_result = librosa.stft(waveform, n_fft=WINDOW_SIZE, hop_length=HOP_LEN, win_length=WINDOW_SIZE) # anls_stft
n_fft_bins, n_fft_frames = stft_result.shape # n_anls_freqs, n_anls_frames, used to also have "channels" count
print("Number of FFT frames:", n_fft_frames)
print("Number of frequency bins in each FFT:", n_fft_bins)

# fft_freqs = np.arange(n_fft_bins) # anls_freqs [0, 1, ..., n_fft_bins - 1]
# new_n_fft_bins = int(min(n_fft_bins, n_fft_bins * PHASE_SHIFT_AMOUNT)) # apparently this throws away anything above nyquist?
# synth_fft_freqs = np.arange(new_n_fft_bins) # synth_freqs [0, 1, ..., (min(n_fft_bins, n_fft_bins * PHASE_SHIFT_AMOUNT) - 1]
# og_idxs = synth_fft_freqs / PHASE_SHIFT_AMOUNT # og_idxs

mags = np.abs(stft_result)
phases = np.angle(stft_result)

prev_phases = np.concatenate((np.zeros((n_fft_bins, 1)), phases[:, :-1]), axis=1)
# print(phases.shape, phases[:, :-1].shape)
# print(prev_phases[500,100])
# print(phases[500,99])
# print((phases[500,100] - phases[500,99] + (2 * np.pi)) % (2 * np.pi))
# print((phases[500,99] - phases[500,98] + (2 * np.pi)) % (2 * np.pi))
# print((phases[500,98] - phases[500,97] + (2 * np.pi)) % (2 * np.pi))
# print((phases[500,97] - phases[500,96] + (2 * np.pi)) % (2 * np.pi))
dphase_from_prev = phases - prev_phases
dphase_from_prev = np.mod(dphase_from_prev, 2 * np.pi)
scaled_phase_shifts = dphase_from_prev * PHASE_SHIFT_AMOUNT
total_phase_shifts = np.cumsum(scaled_phase_shifts, axis=1)

stft_result_scaled = mags * np.exp(total_phase_shifts * 1j)

new_waveform = librosa.istft(stft_result_scaled, n_fft=WINDOW_SIZE, hop_length=HOP_LEN, win_length=WINDOW_SIZE)

sf.write(sys.argv[2], new_waveform, samp_rate, 'PCM_24')