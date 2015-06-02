clc
clear
close all

Ft = 20000; % points transmitted per second
fs_h = 1000         % 2000 HZ sinusoidal signal for sending
fs_l = 2000             % 1000 HZ sinusoidal signal for 

bit_time = 0.09;
bit_len = int16(bit_time*Ft);

msg = textread('group21.txt', '%s', 'whitespace', '');
msg = msg{1};

%msg = 'Rabitts jump and they live for 8 years. Dogs run and lives for 15 years. Turtles do nothing and they live for 150 years. Lesson learned!';

bin_code = dec2bin(msg, 8);

%% play bin_code

start_sign = dec2bin('#######', 8);
end_sign = dec2bin('%%%%%', 8);
bin_code = [start_sign; bin_code; end_sign];
bin_code = bin_code';
bin_snd = bin_code(:)';
bin_code = bin_code';
bin_snd = bin_snd - '0';

bin_extend = bin_snd'*ones(1, bit_len);
bin_extend = bin_extend';
bin_extend = bin_extend(:);

carrier = 1:length(bin_extend);
carrier_h = sin(2*pi*fs_h*carrier/Ft);
carrier_l = sin(2*pi*fs_l*carrier/Ft);
clear carrier;

sig_h = bin_extend'.*carrier_h;

sig_l = (bin_extend == 0)'.*(carrier_l);

sig_snd = sig_h  + sig_l;
%increase Fs value to speed up the sound, decrease to slow it down
player = audioplayer(sig_snd, Ft);
play(player)




