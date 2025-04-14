pkg load signal;
NIM_1 = 65;
NIM_2 = 77;
NIM_3 = 89;
aa = mod(NIM_1, 16);
bb = mod(NIM_2, 16);
cc = mod(NIM_3, 16);
fs = 44100;
T = 1;
t = 0:1/fs:T-1/fs;
frequencies = [aa, bb, cc] * 1000;
sins = generate_signals(t, frequencies, fs, "SinSignal");
sum_sine_signal(sins{1}, sins{2}, sins{3}, fs)