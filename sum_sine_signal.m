function sum_signal = sum_sine_signal(signal1, signal2, signal3, fs)
  if ~isobject(signal1) || ~isobject(signal2) || ~isobject(signal3)
    error('All inputs must be Signal objects');
  endif
  
  y1 = signal1.Y;
  y2 = signal2.Y;
  y3 = signal3.Y;
  
  f1 = signal1.Freq;
  f2 = signal2.Freq;
  f3 = signal3.Freq;
  
  t = signal1.X;
  
  y_sum = y1 + y2 + y3;
  
  sum_signal = Signal(t, y_sum, [f1, f2, f3]);
  sum_signal.Type = "summed_sine";
  
  min_freq = min([f1, f2, f3]);
  period = 1 / min_freq;
  duration_to_plot = 4 * period;  % 4 periods
  
  samples_to_plot = ceil(duration_to_plot * fs);
  if samples_to_plot > length(y_sum)
    samples_to_plot = length(y_sum);
  endif
  
  t_plot = t(1:samples_to_plot);
  y_plot = y_sum(1:samples_to_plot);
  
  figure;
  plot(t_plot, y_plot);
  title(sprintf('Sum of 3 Sine Waves (%d Hz, %d Hz, %d Hz)', f1, f2, f3));
  xlabel('Time (s)');
  ylabel('Amplitude');
  grid on;
  
  print("./image/(2)summed_sine_wave.png", '-dpng', '-S3200,1800');
  
  num_samples = min(512, length(y1));
  
  win_rect = ones(num_samples, 1);
  win_tri = triang(num_samples);
  win_hamm = hamming(num_samples);
  win_hann = hanning(num_samples);
  
  process_signal_spectrum(y1(1:num_samples), fs, f1, "sine1", win_rect, win_tri, win_hamm, win_hann);
  process_signal_spectrum(y2(1:num_samples), fs, f2, "sine2", win_rect, win_tri, win_hamm, win_hann);
  process_signal_spectrum(y3(1:num_samples), fs, f3, "sine3", win_rect, win_tri, win_hamm, win_hann);
  process_signal_spectrum(y_sum(1:num_samples), fs, [f1, f2, f3], "summed", win_rect, win_tri, win_hamm, win_hann);
  
  return;
endfunction

function process_signal_spectrum(signal, fs, freq, signal_name, win_rect, win_tri, win_hamm, win_hann)
  signal_rect = signal(:) .* win_rect;
  signal_tri = signal(:) .* win_tri;
  signal_hamm = signal(:) .* win_hamm;
  signal_hann = signal(:) .* win_hann;
  N = length(signal);
  fft_rect = fft(signal_rect);
  fft_tri = fft(signal_tri);
  fft_hamm = fft(signal_hamm);
  fft_hann = fft(signal_hann);
  f = (0:N-1) * fs / N;
  half_idx = ceil(N/2);
  f = f(1:half_idx);
  fft_rect = fft_rect(1:half_idx);
  fft_tri = fft_tri(1:half_idx);
  fft_hamm = fft_hamm(1:half_idx);
  fft_hann = fft_hann(1:half_idx);
  
  fft_rect = fft_rect / N;
  fft_tri = fft_tri / N;
  fft_hamm = fft_hamm / N;
  fft_hann = fft_hann / N;
  
  if half_idx > 1
    fft_rect(2:end-1) = 2 * fft_rect(2:end-1);
    fft_tri(2:end-1) = 2 * fft_tri(2:end-1);
    fft_hamm(2:end-1) = 2 * fft_hamm(2:end-1);
    fft_hann(2:end-1) = 2 * fft_hann(2:end-1);
  endif
  
  amp_rect = abs(fft_rect);
  amp_tri = abs(fft_tri);
  amp_hamm = abs(fft_hamm);
  amp_hann = abs(fft_hann);
  
  pow_rect = amp_rect.^2;
  pow_tri = amp_tri.^2;
  pow_hamm = amp_hamm.^2;
  pow_hann = amp_hann.^2;
  
  figure;
  subplot(2, 2, 1);
  plot(f, amp_rect);
  title(sprintf('%s - Amplitude Spectrum (Rectangular)', signal_name));
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  grid on;
  
  subplot(2, 2, 2);
  plot(f, amp_tri);
  title(sprintf('%s - Amplitude Spectrum (Triangular)', signal_name));
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  grid on;
  
  subplot(2, 2, 3);
  plot(f, amp_hamm);
  title(sprintf('%s - Amplitude Spectrum (Hamming)', signal_name));
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  grid on;
  
  subplot(2, 2, 4);
  plot(f, amp_hann);
  title(sprintf('%s - Amplitude Spectrum (Hanning)', signal_name));
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  grid on;
  
  print(sprintf("./image/2%s_amplitude_spectrum.png", signal_name), '-dpng', '-S3200,1800');
  
  figure;
  subplot(2, 2, 1);
  plot(f, pow_rect);
  title(sprintf('%s - Power Spectrum (Rectangular)', signal_name));
  xlabel('Frequency (Hz)');
  ylabel('Power');
  grid on;
  
  subplot(2, 2, 2);
  plot(f, pow_tri);
  title(sprintf('%s - Power Spectrum (Triangular)', signal_name));
  xlabel('Frequency (Hz)');
  ylabel('Power');
  grid on;
  
  subplot(2, 2, 3);
  plot(f, pow_hamm);
  title(sprintf('%s - Power Spectrum (Hamming)', signal_name));
  xlabel('Frequency (Hz)');
  ylabel('Power');
  grid on;
  
  subplot(2, 2, 4);
  plot(f, pow_hann);
  title(sprintf('%s - Power Spectrum (Hanning)', signal_name));
  xlabel('Frequency (Hz)');
  ylabel('Power');
  grid on;
  
  print(sprintf("./image/%s_power_spectrum.png", signal_name), '-dpng', '-S3200,1800');
endfunction