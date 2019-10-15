function vq = LinearInterpWithClipExtrap(x,v,xq)
% Like INTERP1 function, but clip extrapolated results to available data.
% Input V must be a vector, this function does not work yet if V is a
% multi-dimensional array.

    vq = interp1(x,v,xq);

    [XMax, idxVMax] = max(x);
    [XMin, idxVMin] = min(x);

    idxMax = xq > XMax;
    idxMin = xq < XMin;

    vq(idxMax) = v(idxVMax);
    vq(idxMin) = v(idxVMin);
    
end