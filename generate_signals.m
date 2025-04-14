function signals = generate_signals(t, frequencies, fs, signal_class)
  signals = {};
  figure;
  freq_index = 1;
  
  for freq = frequencies
    % Create signal object of the specified class
    signal = feval(signal_class, t, freq);
    signals{end+1} = signal;
    
    % Plot the signal
    subplot(3,1,freq_index);
    plot(t, signal.Y);
    xlabel('Waktu');
    ylabel('Amplitudo');
    
    % Use the Type property from the signal object for naming
    signal_title = sprintf("Fungsi %s %d Hz", signal.Type, freq);
    
    % Save audio file
    audiowrite(sprintf("./audio/%s.wav", signal_title), signal.Y, fs);
    title(signal_title);
    
    freq_index = freq_index+1;
  endfor
  
  % Save image file with type name in filename
  print(sprintf("./image/(1)%s_awal.png", signal.Type), '-dpng', '-S3200,1800');
endfunction