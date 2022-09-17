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
%   .....
%% ------------------------------------------------------------------------  

function z = Cost_Function(x)

%% NFE defenition
% define Number Function Evaluation (NFE) as a global variable
% terminating the algorithm by satisfying the maximum NFE
global NFE;
NFE = NFE+1;


%% calculate the cost function value

% 'z' is a scalar value, the value of the objective function 
z = sum(x.^2); % sphare function

