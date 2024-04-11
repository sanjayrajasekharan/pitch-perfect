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
PHASE_SHIFT_AMOUNT = 2 ** (-12 / 12) # scaling

waveform, samp_rate = librosa.load(sys.argv[1], sr=None, mono=True) # waveform, sr # used to not be mono
num_samples = waveform.shape[0] # og_len

stft_result = librosa.stft(waveform, n_fft=WINDOW_SIZE, hop_length=HOP_LEN, win_length=WINDOW_SIZE) # anls_stft
n_fft_bins, n_fft_frames = stft_result.shape # n_anls_freqs, n_anls_frames, used to also have "channels" count

stft_result = np.transpose(stft_result)

stft_result_scaled = []
prev_anal_phases = np.zeros(n_fft_bins)
prev_synth_phases = np.zeros(n_fft_bins)

for idx, frame in enumerate(stft_result):
    
    if idx == 0:
        pass
    
    mags = np.abs(frame)
    phases = np.angle(frame)

    dphases_from_prev = phases - prev_anal_phases

    bin_center_freqs = np.arange(n_fft_bins) * 2 * np.pi / WINDOW_SIZE
    dphases_from_expected = dphases_from_prev - (bin_center_freqs * HOP_LEN)
    dphases_from_expected = np.mod(dphases_from_expected + (3 * np.pi), 2 * np.pi) - np.pi # wrap to [-pi, pi]

    bin_deviations = (dphases_from_expected * WINDOW_SIZE) / (2 * np.pi * HOP_LEN)
    new_bin_nums = np.rint((np.arange(n_fft_bins) + bin_deviations) * PHASE_SHIFT_AMOUNT)

    synth_mags = np.zeros(n_fft_bins)
    for old_idx, new_bin_num in enumerate(new_bin_nums):
        if new_bin_num >= 0 and new_bin_num < n_fft_bins:
            synth_mags[int(new_bin_num)] += mags[old_idx]

    phase_remainders = ((synth_mags - np.arange(n_fft_bins)) * 2 * np.pi * HOP_LEN) / WINDOW_SIZE
    synth_phases = prev_synth_phases + phase_remainders + (bin_center_freqs * HOP_LEN)
    synth_phases = np.mod(synth_phases + (3 * np.pi), 2 * np.pi) - np.pi # wrap to [-pi, pi]

    stft_result_scaled.append(synth_mags * np.exp(synth_phases * 1j))

    prev_anal_phases = phases
    prev_synth_phases = synth_phases

stft_result_scaled = np.array(stft_result_scaled)
stft_result_scaled = np.transpose(stft_result_scaled)

new_waveform = librosa.istft(stft_result_scaled, n_fft=WINDOW_SIZE, hop_length=HOP_LEN, win_length=WINDOW_SIZE)

sf.write(sys.argv[2], new_waveform, samp_rate, 'PCM_24')