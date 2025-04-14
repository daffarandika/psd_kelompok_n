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
squares = generate_signals(t, frequencies, fs, "SquareSignal");
sawtooths = generate_signals(t, frequencies, fs, "SawtoothSignal");
triangles = generate_signals(t, frequencies, fs, "TriangleSignal");

for i = 1:3
  plot_per_period(sins{i}, fs);
  plot_per_period(squares{i}, fs);
  plot_per_period(sawtooths{i}, fs);
  plot_per_period(triangles{i}, fs);

  plot_signal_spectrum(sins{i}, fs);
  plot_signal_spectrum(squares{i}, fs);
  plot_signal_spectrum(sawtooths{i}, fs);
  plot_signal_spectrum(triangles{i}, fs);
end