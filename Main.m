%% ========================================================================
%   Ladybug Beetle Optimization (LBO) algorithm
%
%   Developed in MATLAB R2019a
%
%   Author and programmer: Saadat Safiri
%
%         e-Mail: saadatsafiri@gmail.com
%
%
%   Main paper:
%   "..."
%
%   In order to use this optimization algorithm code, only change the
%   'Cost_Function.m' code as you wish ?
% =========================================================================

%%
clear;      % clear all previous variables in the Workspace 
clc;        % clear the Command Window
close all;  % close all previous figures

%% NFE defenition
% define Number Function Evaluation (NFE) as a global variable
% terminating the algorithm by satisfying the maximum NFE
global NFE;
NFE   = 0;

%% the parameters of the optimization problem
nVar   = 30;    % the number of the decision vector variables
VarMin = -100;  % lower bound of the decision vector variables
VarMax =  100;  % upper bound of the decision vector variables

fobj   = @(x) Cost_Function(x); % the definition of the cost function 

%% the parameters of the LBO algorithm
nPop          = 10;   % population size
Max_NFE       = 5.0e4;  % the maximum number of function evaluation (the termination condition)

%% call LBO algorithm to optimize the problem
[Best_solution,Best_Cost] = LBO(nPop,Max_NFE,VarMin,VarMax,nVar,fobj);

%% show results
disp('================RESULTS================')
disp('')
disp(['The best cost function is: ',num2str(Best_Cost)])
disp('----------------------------------')
disp(['The best solution is: ',num2str(Best_solution)])
disp('')
disp('=======================================')
