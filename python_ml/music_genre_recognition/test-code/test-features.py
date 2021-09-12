# FEATURE EXTRACTION TEST
# Extracting features from wav files with librosa library


# Import modules and packages
import numpy, scipy, matplotlib.pyplot as plt, pandas, librosa
from glob import glob

# For visualisation and to play audio files (ipd can also play videos, sheet music and +)
import librosa.display
import IPython.display as ipd


# glob helps to import selected files from folder
# librosa.load() method loads and decodes audio: 
# y is a time serie and sr is the sampling rate of y. by default 22500Hz

# To get all wav files from one folder
data_folder = './music'
audio_files = glob(data_folder + '/*.wav')

len(audio_files)
print(str(audio_files))

# Load audio file
y, sr = librosa.load('./music/classical.00001.wav')

# Play audio file
ipd.Audio(y, rate=sr)

# Get infos about tempo and beat
tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr)
print('Estimated tempo: {:.2f} beats per minute'.format(tempo))

# Converts beat_frames into timings. Probably not useful for genre detection.
beat_times = librosa.frames_to_time(beat_frames, sr=sr)
i = 1
for el in beat_times:
    time = str(el)
    print("Beat n°" + str(i) + " " + str(el))
    i+=1

# Mel-scaled power spectogramm 
MS = librosa.feature.melspectrogram(y, sr=sr)
# Convert to DB
log_MS = librosa.power_to_db(MS)
librosa.display.specshow(log_MS, sr=sr, x_axis='time', y_axis='hz')

# Chromagram: intensity of each 12 notes at a specific point in time
test_chroma = librosa.feature.chroma_stft(y, sr=sr)
librosa.display.specshow(test_chroma, x_axis = 'time', y_axis='chroma')

# Central spectroid
CS = librosa.feature.spectral_centroid(y)
print(CS)

# Fourrier transform
Y = scipy.fft(y)
Y_mag = numpy.absolute(Y)
f = numpy.linspace(0, sr, len(Y_mag))
plt.figure(figsize=(13, 5))
plt.plot(f, Y_mag)
plt.ylabel('Frequency (Hz)')