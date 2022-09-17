%% ------------------------------------------------------------------------
%  Ladybug Beetle Optimization (LBO) algorithm
%
%  Developed in MATLAB R2019a
%
%  Author and programmer: Saadat Safiri
%
%         e-Mail: saadatsafiri@gmail.com
%
%
%   Main paper:
%   "Ladybug Beetle Optimization algorithm: application for real‑world problems"
%% ------------------------------------------------------------------------  

function i=RouletteWheelSelection(P)

    r=rand;
    
    c=cumsum(P);
    
    i=find(r<=c,1,'first');

end