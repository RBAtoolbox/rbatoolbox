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

%  Always define the sweep range as large as possible, since noise
%  otherwise will be amplified at high frequencies.
f1 = 10;
f2 = 22050; % Fny

% For applying a time-window the sweep range must be wider than [f1:f2].
% Note that Nyquist frequency must not be exceeded
flow = f1/2;
fup = f2*2;

% Samplingfrequency should be greater than fup*2. 44.1kHz is very common
% for built-in soundcards
fs = 44.1e3;

% Define signal type and length of measurement signal in seconds
sig_type = 'logsin';
length_sig = 5;

% Generate measurement signal
[y,t] = rbaGenerateSignal(sig_type,fs,flow,fup,length_sig);

% Generate window
L = length(y);
win = sweepwin(L,flow,fup,f1,f2,sig_type);

% Apply time-window function
signal = y.*win;

% Setup measurement parameters.
N = 1; % Number of averages
estimatedRT = 2; % Estimated reverberation time

measuredResult = rbaMeasurement(signal, fs, N, estimatedRT);

% Save measurement result as 32bit wav-file
savedir = pwd; % Save in current directory
wavwrite(signal, fs,32,[savedir '/ref_' sig_type '_' datestr(now,'dd-mmm_HH-MM') '.wav'])
wavwrite(measuredResult, fs,32,[savedir '/' sig_type '_' datestr(now,'dd-mmm-HH-MM') '.wav'])
