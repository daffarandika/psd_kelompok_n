function plot_signal_spectrum(signal_obj, fs)
  if isobject(signal_obj)
    signal_data = signal_obj.Y;
    signal_freq = signal_obj.Freq;
    signal_type = signal_obj.Type;
  else
    signal_data = signal_obj;
    signal_freq = -1; % Unknown frequency
    signal_type = "unknown";
  endif
  
  N = length(signal_data);
  
  win_rect = ones(N, 1); 
  win_tri = triang(N);   
  win_hamm = hamming(N); 
  win_hann = hanning(N); 
  
  signal_rect = signal_data(:) .* win_rect;
  signal_tri = signal_data(:) .* win_tri;
  signal_hamm = signal_data(:) .* win_hamm;
  signal_hann = signal_data(:) .* win_hann;
  
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
  title('Rectangular Window - Amplitude Spectrum');
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  grid on;
  
  subplot(2, 2, 2);
  plot(f, amp_tri);
  title('Triangular Window - Amplitude Spectrum');
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  grid on;
  
  subplot(2, 2, 3);
  plot(f, amp_hamm);
  title('Hamming Window - Amplitude Spectrum');
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  grid on;
  
  subplot(2, 2, 4);
  plot(f, amp_hann);
  title('Hanning Window - Amplitude Spectrum');
  xlabel('Frequency (Hz)');
  ylabel('Amplitude');
  grid on;
  
  print(sprintf("./image/(1)%s_amplitude_spectrum_%dHz.png", signal_type, signal_freq), 
        '-dpng', '-S3200,1800');
  
  figure;
  subplot(2, 2, 1);
  plot(f, pow_rect);
  title('Rectangular Window - Power Spectrum');
  xlabel('Frequency (Hz)');
  ylabel('Power');
  grid on;
  
  subplot(2, 2, 2);
  plot(f, pow_tri);
  title('Triangular Window - Power Spectrum');
  xlabel('Frequency (Hz)');
  ylabel('Power');
  grid on;
  
  subplot(2, 2, 3);
  plot(f, pow_hamm);
  title('Hamming Window - Power Spectrum');
  xlabel('Frequency (Hz)');
  ylabel('Power');
  grid on;
  
  subplot(2, 2, 4);
  plot(f, pow_hann);
  title('Hanning Window - Power Spectrum');
  xlabel('Frequency (Hz)');
  ylabel('Power');
  grid on;
  
  print(sprintf("./image/(1)%s_power_spectrum_%dHz.png", signal_type, signal_freq), 
        '-dpng', '-S3200,1800');
  
  figure;
  subplot(2, 2, 1);
  plot(win_rect);
  title('Rectangular Window');
  xlabel('Sample');
  ylabel('Amplitude');
  grid on;
  
  subplot(2, 2, 2);
  plot(win_tri);
  title('Triangular Window');
  xlabel('Sample');
  ylabel('Amplitude');
  grid on;
  
  subplot(2, 2, 3);
  plot(win_hamm);
  title('Hamming Window');
  xlabel('Sample');
  ylabel('Amplitude');
  grid on;
  
  subplot(2, 2, 4);
  plot(win_hann);
  title('Hanning Window');
  xlabel('Sample');
  ylabel('Amplitude');
  grid on;
  
  print(sprintf("./image/(1)window_functions.png"), '-dpng', '-S3200,1800');
  
  spectrum_data = struct();
  spectrum_data.frequency = f;
  spectrum_data.amplitude = struct('rect', amp_rect, 'tri', amp_tri, 
                                  'hamm', amp_hamm, 'hann', amp_hann);
  spectrum_data.power = struct('rect', pow_rect, 'tri', pow_tri, 
                              'hamm', pow_hamm, 'hann', pow_hann);
                              
  return;
endfunction