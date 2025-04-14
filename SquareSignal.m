classdef SquareSignal < Signal
methods
    function c = SquareSignal(X, Freq)
        if (nargin == 2)
            c.X = X;
            c.Freq = Freq;
            c.Y = square(2*pi*c.Freq*c.X);
            c.Type = "square";
        end
    endfunction
end
end