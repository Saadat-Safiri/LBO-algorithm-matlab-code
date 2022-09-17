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

function [Best_Solution,Best_Cost] = LBO(nPop,Max_NFE,VarMin,VarMax,nVar,fobj)

%% Parameters
% NFE definition (termination condition)
global NFE;
NFE = 0;

% iteration variable
it = 0;

% specify the size of decision variables matrix
VarSize=[1 nVar];

% store the initial population size
nPop_init = nPop;

%% Initialization
% specify a part of memory for the population of the algorithm
empty.Position = [];
empty.Cost = [];
pop = repmat(empty,nPop,1);

% define the initial cost of the best solution
BestSol.Cost = Inf;

% initialize the population location in the search space and specify their
% cost functions
for i=1:nPop
    % determine randomly the position of the ith member of the population
    pop(i).Position = unifrnd(VarMin,VarMax,VarSize);
    
    % calculate the cost of the ith member of the population
    pop(i).Cost     = fobj(pop(i).Position);
    
    % Update Global Best
    if pop(i).Cost<BestSol.Cost
        BestSol=pop(i);
    end
    
end

% sort the population based on their cost values
[Costs,SortOrder] = sort([pop.Cost]);
pop               = pop(SortOrder);

% determine the worst member
WorstCost = sign(pop(end).Cost)*max(abs([pop.Cost]));

% specify the selection pressure value
beta = 8; 

%% LBSO Main Loop

while NFE<Max_NFE  % if 'NFE' reaches 'Max_NFE', the LBO algorithm terminates 
    
    it = it+1; % update iteration number
    
    newpop = repmat(empty,nPop,1); % specify memory for new population
    
    SoC = sum([pop.Cost])/nPop; % calculate Sume of Costs (SoC)
    
    % calculate selection probabilities
    P=exp(-beta*Costs/WorstCost);
    P=P/sum(P);
    if sum(Costs)==0
        P=exp(-beta*(Costs+eps)/(WorstCost+eps));
        P=P/sum(P);
    end
    
    % specify new population
    for i=1:nPop
        newpop(i).Position = [];         % initialize the position of the new i-th member
        newpop(i).Cost = inf;            % initialize the cost of the new i-th member
        newsol.Position = zeros(1,nVar); % initialize the local variable for the i-th member
     
        % call the Roulette-Wheel-Selection function to select ...
        % ... a member of population (j), utilized in the process of updating the i-th member
        j=0;
        while (j<2 || j>nPop)
            j = RouletteWheelSelection(P);
            j = min(j,nPop);
        end
        
        % update the i-th member by the j-th member of population
        if rand>0.1 
        newsol.Position = pop(j).Position+ ...
                rand(1,nVar).*(pop(j).Position-pop(i).Position)+ ...
                rand(1,nVar).*(pop(j-1).Position-pop(j).Position)+...
                ((abs(pop(i).Cost/SoC)^-(it/nPop))).*randc(1,1).*(pop(j).Position./VarMax);
        
        % mutate the i-th member
        else
               newsol.Position = pop(i).Position;
              
               nmu=ceil(0.05*nVar); % mutate only 5% of variables of the i-th member 

               k=randsample(nVar,nmu)'; % specify the 5% of variables of the i-th member

               sigma=0.1*(VarMax-VarMin); % determine sigma

               newsol.Position(k)=pop(j).Position(k)+sigma*randn(size(k)); % mutate
        end
            newsol.Position = min(max(newsol.Position,VarMin),VarMax); % Limit the new solution to the feasible region
            
            newsol.Cost = fobj(newsol.Position); % calculate the cost of new member
            
            % replace the new member, if it is a better one
            if newsol.Cost<newpop(i).Cost 
                newpop(i) = newsol;
                if newpop(i).Cost<BestSol.Cost
                    BestSol = newpop(i);
                end
            end
        
        
    end
    
    % update the population size
    nPop = nPop-.1*rand*nPop*(NFE/Max_NFE);
    nPop = round(nPop);
    nPop = max(floor(nPop_init/4),nPop); % the minimum population size is 25% of the initial population size
    
    % gather the new and previous population
    pop = [pop;
           newpop];
    
    % sort the gathered new and previous population
    [Costs,SortOrder] = sort([pop.Cost]);
    pop = pop(SortOrder);
    
    % ignore the worst members of the population
    pop = pop(1:nPop);
    Costs=Costs(1:nPop);
    
    % update the worst member of the population
    WorstCost=max(WorstCost,sign(pop(end).Cost)*max(abs([pop.Cost])));

end

Best_Solution = BestSol.Position; % return the best solution
Best_Cost = BestSol.Cost;         % return the best cost function

