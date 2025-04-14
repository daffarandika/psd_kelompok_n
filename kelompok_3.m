% Main script for square wave Fourier analysis

pkg load signal;

% Setup parameters
fs = 44100;  % Sampling frequency (Hz)
f0 = 1000;   % Fundamental frequency (Hz)
T = 1;       % Total duration (s)
t = 0:1/fs:T-1/fs;  % Time vector

harmonic_sets = [1, 3, 5, 7, 9, 11];
wave_labels = {'I', 'II', 'III', 'IV', 'V', 'VI'};

for i = 1:length(harmonic_sets)
  num_harmonics = harmonic_sets(i);
  label = wave_labels{i};
  
  [sq_wave, harmonics] = generate_square_signal(t, f0, num_harmonics);
  
  signal_title = sprintf("Square_%d_harmonics", num_harmonics);
  audiowrite(sprintf("./audio/%s.wav", signal_title), sq_wave, fs);
  
  period = 1/f0;
  duration = 4 * period;
  samples = ceil(duration * fs);
  samples = min(samples, length(t));
  t_plot = t(1:samples);
  
  figure;
  for j = 1:num_harmonics
    subplot(num_harmonics, 1, j);
    plot(t_plot, harmonics{j}.signal(1:samples));
    harmonic_num = 2*j - 1;
    title(sprintf('Harmonic %d (%d Hz)', harmonic_num, harmonics{j}.frequency));
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
  end
  print(sprintf('./image/(3)case_%s_harmonics.png', label), '-dpng', '-S3200,1800');
  
  figure;
  plot(t_plot, sq_wave(1:samples));
  title(sprintf('Case %s: Square Wave with %d Harmonics', label, num_harmonics));
  xlabel('Time (s)');
  ylabel('Amplitude');
  grid on;
  print(sprintf('./image/(3)case_%s_waveform.png', label), '-dpng', '-S3200,1800');
  
  N = min(1024, length(sq_wave));
  signal_segment = sq_wave(1:N);
  
  window = hanning(N);
  signal_windowed = signal_segment(:) .* window;
  
  fft_result = fft(signal_windowed);
  magnitude = abs(fft_result / N);
  magnitude(2:end-1) = 2 * magnitude(2:end-1);
  
  f = (0:N-1) * fs / N;
  
  half_idx = ceil(N/2);
  f = f(1:half_idx);
  magnitude = magnitude(1:half_idx);
  
  figure;
  stem(f, magnitude, 'LineWidth', 1.2);
  title(sprintf('Case %s: Spectrum of Square Wave (%d harmonics)', label, num_harmonics));
  xlabel('Frequency (Hz)');
  ylabel('Magnitude');
  grid on;
  xlim([0, f0 * (2 * num_harmonics + 1)]);
  
  hold on;
  for j = 1:num_harmonics
    harmonic_freq = f0 * (2*j - 1);
    line([harmonic_freq, harmonic_freq], [0, max(magnitude)], 'Color', 'r', 'LineStyle', '--');
  end
  hold off;
  
  print(sprintf('./image/(3)case_%s_spectrum.png', label), '-dpng', '-S3200,1800');
  
  fprintf('Processed Case %s: Square wave with %d harmonics\n', label, num_harmonics);
end

perfect_square = 0.5 + 0.5 * square(2*pi*f0*t);
audiowrite('./audio/perfect_square.wav', perfect_square, fs);

fprintf('Analysis complete! Generated %d different square wave approximations.\n', length(harmonic_sets));