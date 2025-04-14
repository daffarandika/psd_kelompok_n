classdef Signal
properties
    X;
    Y;
    Freq;
    Type;
endproperties

methods
    function c = Signal(X, Y, Freq)
        if (nargin == 3)
            c.X = X;
            c.Y = Y;
            c.Freq = Freq;
            c.Type = 'undefined'
        end
    endfunction
end
end
