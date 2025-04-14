function analyze_square_waves()
  fs = 44100;
  f0 = 1000;
  T = 1;
  t = 0:1/fs:T-1/fs;
  
  harmonic_counts = [1, 3, 5, 7, 9, 11];
  
  for i = 1:length(harmonic_counts)
    num_harmonics = harmonic_counts(i);
    
    [sq_wave, harmonics] = generate_square_wave(t, f0, num_harmonics);
    
    plot_components_and_wave(t, f0, sq_wave, harmonics, fs);
    
    analyze_spectrum(sq_wave, fs, f0, num_harmonics);
  end
end

function plot_components_and_wave(t, f0, sq_wave, harmonics, fs)
  
  period = 1/f0;
  duration = 4 * period;
  samples = ceil(duration * fs);
  
  if samples > length(t)
    samples = length(t);
  end
  
  t_plot = t(1:samples);
  
  figure;
  
  num_harmonics = length(harmonics);
  for i = 1:num_harmonics
    subplot(num_harmonics + 1, 1, i);
    plot(t_plot, harmonics{i}.signal(1:samples));
    title(sprintf('Harmonic %d (%d Hz)', 2*i-1, harmonics{i}.frequency));
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
  end
  
  subplot(num_harmonics + 1, 1, num_harmonics + 1);
  plot(t_plot, sq_wave(1:samples));
  title(sprintf('Square Wave Approximation (%d harmonics)', num_harmonics));
  xlabel('Time (s)');
  ylabel('Amplitude');
  grid on;
  
  print(sprintf('./image/square_wave_%d_harmonics_time.png', num_harmonics), '-dpng', '-S3200,1800');
end

function analyze_spectrum(signal, fs, f0, num_harmonics)
  N = min(1024, length(signal));
  signal_segment = signal(1:N);
  
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
  title(sprintf('Spectrum of Square Wave Approximation (%d harmonics)', num_harmonics));
  xlabel('Frequency (Hz)');
  ylabel('Magnitude');
  grid on;
  
  xlim([0, f0 * (2 * num_harmonics + 1)]);
  
  hold on;
  for i = 1:num_harmonics
    harmonic_freq = f0 * (2*i - 1);
    line([harmonic_freq, harmonic_freq], [0, max(magnitude)], 'Color', 'r', 'LineStyle', '--');
  end
  hold off;
  
  print(sprintf('./image/square_wave_%d_harmonics_spectrum.png', num_harmonics), '-dpng', '-S3200,1800');
  
  figure;
  magnitude_db = 20 * log10(magnitude + 1e-10);
  stem(f, magnitude_db, 'LineWidth', 1.2);
  title(sprintf('Log Spectrum of Square Wave Approximation (%d harmonics)', num_harmonics));
  xlabel('Frequency (Hz)');
  ylabel('Magnitude (dB)');
  grid on;
  
  xlim([0, f0 * (2 * num_harmonics + 1)]);
  
  hold on;
  for i = 1:num_harmonics
    harmonic_freq = f0 * (2*i - 1);
    line([harmonic_freq, harmonic_freq], [min(magnitude_db), max(magnitude_db)], 'Color', 'r', 'LineStyle', '--');
  end
  hold off;
  
  print(sprintf('./image/square_wave_%d_harmonics_log_spectrum.png', num_harmonics), '-dpng', '-S3200,1800');
end