classdef SawtoothSignal < Signal
methods
    function c = SawtoothSignal(X, Freq)
        if (nargin == 2)
            c.X = X;
            c.Freq = Freq;
            c.Y = sawtooth(2*pi*c.Freq*c.X);
            c.Type = "sawtooth";
        end
    endfunction
end
end