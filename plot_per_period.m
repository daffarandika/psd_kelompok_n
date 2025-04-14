function plot_per_period(signal_obj, fs)
  figure;
  if isobject(signal_obj)
    periode = 1 / signal_obj.Freq;
    signal_data = signal_obj.Y;
    signal_freq = signal_obj.Freq;
    type = signal_obj.Type;
  endif
  
  rentang_waktu = 4 * periode;
  jumlah_sampel = rentang_waktu * fs;
  jumlah_sampel = min(jumlah_sampel, length(signal_data));
  vektor_waktu = 0:1/fs:(jumlah_sampel - 1)/fs;
  signal_terpotong = signal_data(1:jumlah_sampel);
  
  plot(vektor_waktu, signal_terpotong);
  xlabel("Waktu (detik)");
  ylabel("Amplitudo");
  title(sprintf("%s Signal at %d Hz (4 periods)", type, signal_freq));
  print(sprintf("./image/(1)sampled_%s_%dHz.png", type, signal_freq), '-dpng', '-r900');
endfunction