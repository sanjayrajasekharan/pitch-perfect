"""
vocoder2.py
Time stretching algorithm from the following github repo, resampled to pitch
shift without time stretching.

Based on https://github.com/JentGent/pitch-shift/blob/main/audios.ipynb
"""

import librosa
import numpy as np
import soundfile as sf
import sys

def interpolate_time(idxs: np.ndarray, arr):
    start = (idxs + 0.5).astype(int)
    frac = (idxs - (idxs).astype(int))[None, None, :] # changed slightly
    shifted_arr = np.concatenate((arr[:, :, 1:], np.zeros((arr.shape[0], arr.shape[1], 1))), axis=2)
    # print("shifted_arr:", shifted_arr.size, shifted_arr)
    # print(shifted_arr.size, shifted_arr[0].size, shifted_arr[0][0].size)
    # print(arr.shape)
    ret = arr[:, :, start] * (1 - frac) + shifted_arr[:, :, start] * frac
    # print(ret.shape)
    return arr[:, :, start] * (1 - frac) + shifted_arr[:, :, start] * frac

waveform, sr = librosa.load(sys.argv[1], sr=None, mono=False)
channels, og_len = waveform.shape

win_len = 4096 # FFT works best with powers of 2
n_fft = 4096
hop_len = 256
anls_stft = librosa.stft(waveform, n_fft=n_fft, hop_length=hop_len, win_length=win_len)
channels, n_anls_freqs, n_anls_frames = anls_stft.shape

scaling = 2 ** (12 / 12)
freqs = np.arange(n_anls_freqs)
anls_frames = np.arange(n_anls_frames)
n_synth_frames = np.floor(n_anls_frames * scaling).astype(int)
synth_frames = np.arange(n_synth_frames)
og_idxs = np.minimum(synth_frames / scaling, n_anls_frames - 1)

mags = np.abs(anls_stft)
phases = np.angle(anls_stft)

phase_diffs = phases - np.concatenate((np.zeros((channels, n_anls_freqs, 1)), phases[:, :, :-1]), axis=2)
phase_diffs = np.mod(phase_diffs, np.pi * 2)

shifted_mags = interpolate_time(og_idxs, mags)
shifted_phase_diffs = interpolate_time(og_idxs, phase_diffs)

shifted_phases = np.cumsum(shifted_phase_diffs, axis=2)

synth_stft = shifted_mags * np.exp(shifted_phases * 1j)

new_waveform = librosa.istft(synth_stft, hop_length=hop_len, win_length=win_len, n_fft=n_fft)

newer_waveform = new_waveform[0]

newest_waveform = []

for sample in newer_waveform:
    if scaling > 1:
        prob = np.random.rand() * scaling
        if prob < 1:
            newest_waveform.append(sample)

sf.write(sys.argv[2], newest_waveform, sr, 'PCM_24')