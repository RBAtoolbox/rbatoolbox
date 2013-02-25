%% RABAT Measurement Demo Script %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This demo script shows the steps for
%   1. Generate logarithmic sine sweep
%   2. Apply time-window function
%   3. Perform measurement
%   3. Save result in wav-file format
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define measurement signal parameters

%  We are interested in reverberation times in octave bands
%   [63 125 250 500 1000 2000 4000 8000]
f1 = 125*2^(-1/2);
f2 = 4000*2^(1/2);

% For applying a time-window the sweep range must be wider than [f1:f2].
% Note that Nyquist frequency must not be exceeded
flow = f1*3/4;
fup = f2*4/3;

% Samplingfrequency should be greater than fup*2. 48kHz is very common
% for built-in soundcards
fs = 48000;

% Define signal type and length of measurement signal in seconds
sig_type = 'logsin';
length_sig = 5;

% Generate measurement signal
[sweep,t] = rbaGenerateSignal(sig_type,fs,flow,fup,length_sig);

% Generate window
L = length(sweep);
win = sweepwin(L,flow,fup,f1,f2,sig_type);

% Apply time-window function
signal = sweep.*win;

% Setup measurement parameters.
N = 16; % Number of averages

%% Perform measurement
measuredResult = rbaAverageMeasurement(signal, fs, N);

%% Save measurement result as 32bit wav-file
savedir = pwd; % Save in current directory
wavwrite(signal, fs,32,[savedir '/ref_' sig_type '_' datestr(now,'dd-mmm_HH-MM_SS') '.wav'])
wavwrite(measuredResult, fs,32,[savedir '/' sig_type '_' datestr(now,'dd-mmm-HH-MM_SS') '.wav'])

%% Compute impulse response
h = sweepdeconv(sweep,measuredResult,f1,f2,fs);

%% Plot results
specgram(measuredResult,min(256,length(measuredResult)),fs)
title('Spectrogram')
plot(0:1/fs:(length(measuredResult)-1)/fs,h)
title('Impulse response')
xlabel('Time / s')
ylabel('Impulse response')
