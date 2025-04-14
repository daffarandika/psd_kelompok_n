classdef TriangleSignal < Signal
methods
    function c = TriangleSignal(X, Freq)
        if (nargin == 2)
            c.X = X;
            c.Freq = Freq;
            c.Y = sawtooth(2*pi*c.Freq*c.X, 0.5);
            c.Type = "triangle";
        end
    endfunction
end
end