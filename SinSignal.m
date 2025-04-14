classdef SinSignal < Signal
methods
    function c = SinSignal(X, Freq)
        if (nargin == 2)
            c.X = X;
            c.Freq = Freq;
            c.Y = sin(2*pi*c.Freq*c.X);
            c.Type = "sin"
        end
    endfunction
end
end