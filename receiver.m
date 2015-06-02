%% 
clc
clear
close all
Ft = 20000; % points transmitted per second
Fr = Ft;
fs_h = 1000;         % 4000 HZ sinusoidal signal for sending
fs_l = 2000;             % 3000 HZ sinusoidal signal for

w = 10;
bit_time = 0.09;
bit_len = round(bit_time*Fr);
rec_time = 140;
filter_order = 8000;


filter_h = designfilt('bandpassfir','FilterOrder', filter_order, ...
    'CutoffFrequency1',fs_h - w,'CutoffFrequency2', fs_h + w, ...
    'SampleRate',Fr);

filter_l = designfilt('bandpassfir','FilterOrder', filter_order, ...
    'CutoffFrequency1',fs_l - w,'CutoffFrequency2', fs_l + w, ...
    'SampleRate',Fr);

%% get the signals' evelop (demodulation)

recObj = audiorecorder(Fr, 8, 1);
disp('Start speaking.')
recordblocking(recObj, rec_time);
disp('End of Recording.');
sig_raw = getaudiodata(recObj);

%load('sig_raw.mat');

sig_h_ini = filter(filter_h, sig_raw);
sig_l_ini = filter(filter_l, sig_raw);

%mean_h = mean(abs(sig_h_ini));
%mean_l = mean(abs(sig_l_ini));

%if(mean_h > mean_l)
%    sig_l = sig_l_ini.*(mean_h/mean_l);
%    sig_h = sig_h_ini;
%else
%    sig_h = sig_h_ini.*(mean_l/mean_h);
%    sig_l = sig_l_ini;
%end

sig_h = sig_h_ini;
sig_l = sig_l_ini;

sig_h_env = envelope(sig_h, Fr);
sig_l_env = envelope(sig_l, Fr);

envelopes = sig_h_env - sig_l_env;
plot(envelopes);

%% sampling and decode from the envelope
msg = decode(envelopes, bit_len);
disp(msg);





    
