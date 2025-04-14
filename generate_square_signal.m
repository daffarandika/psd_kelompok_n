function [sq_wave, harmonics] = generate_square_signal(t, fundamental_freq, num_harmonics)
  A = 1;
  sq_wave = A/2;
  harmonics = cell(num_harmonics, 1);
  
  for n = 1:num_harmonics
    harmonic_num = 2*n - 1;
    harmonic_freq = fundamental_freq * harmonic_num;
    amplitude = (2*A/pi) * (1/harmonic_num);
    
    harmonic = amplitude * sin(2*pi*harmonic_freq*t);
    
    harmonics{n} = struct('signal', harmonic, 'frequency', harmonic_freq, 'amplitude', amplitude);
    
    sq_wave = sq_wave + harmonic;
  end
end