
%% Example: Car selection
 
% (The numbers are random!)
%
%
%% Simple AHP
% We are interested to buy a new car. We have three alternative options:
% Toyota, Nissan, Honda
% and three selection criteria
% Safety, Design, Performance
 
% First, we compare the cars according to each of the selection criteria
 
% M1: Safety
% Toyota is worse than Nissan to a large extent: 1/8
% Toyota is worse than Honda to a moderate extent: 1/5
% Nissan is better than Honda to a small extent: 3
 
M1 = [1/8; 1/5; 3];
 
% M2: Design
% Toyota is as good as Nissan: 1
% Toyota is worse than Honda to a moderate extent: 1/4
% Nissan is worse than Honda to a moderate extent: 1/4
 
M2 = [1; 4; 4];
 
% M3: Performance
% Toyota is better than Nissan to a large extent: 7
% Toyota is better than Honda to a small extent: 3
% Nissan is worse than Honda to a small extent: 1/2
 
M3 = [7; 3; 1/2];
 
% The overall comparison matrix of the alternatives is:
 
M = [M1, M2, M3];
 
% Now we compare the selection criteria according to their importance.
% Safety is more important than Design to a large extent: 8
% Safety is more important than Performance to a moderate extend: 5
% Design is less important than Performance to a small extent: 1/2
 
% The criteria comparison vector is:
 
C = [8; 5; 1/2];
 
% We are ready to use the ahp function
 
h = ahp(M,C)
 
% We can use the function to receive the hierarchy of the criteria the hierarchy
% of the alternatives according to each criterion separately
 
[h, c, a] = ahp(M,C)
 
% We can add the names of the alternatives and the criteria
 
names = {'Toyota';'Nissan';'Honda'};
 
criteria_names = {'Safety';'Design';'Performance'};
 
[h, c, a] = ahp(M,C,'names',names,'criterianames',criteria_names)

% We can put the results in order according to the estimated weights or the
% names of the alternative optios
[h, c, a] = ahp(M,C,'names',names,'criterianames',criteria_names,'order','weights')
% and
h = ahp(M,C,'names',names,'criterianames',criteria_names,'order','alternatives')
%
%

%% Fuzzy AHP
 
% If we are uncertain about the criteria and alternatives pairwise
% comparison scores, we can use the Fuzzy AHP option
 
[h, ~, a] = ahp(M,C,'fuzzy',true,'names',names,'criterianames',criteria_names)
%
%
%% Quantitative criteria
 
% Let's assume by the term performance we mean acceleration, as the number of seconds
% required to reach 60mph. This is something that is expressed quantitatively, and
% it can be introduced in the function like this, avoiding the
% relative comparison by the decision makers. In our example, the 
% performance of the three cars is
 
% Toyota: 10.6 sec
% Nissan: 11.3 sec
% Honda: 11.9 sec
 
NB = [10.6; 11.3; 11.9];
 
% Also, performance is a non-beneficial criterion, i.e. the less time the better.
% We can also have beneficial criteria, i.e. the greater number the better, e.g.
% fuel economy, miles per gallon. In our example
 
% Toyota: 51 mpg
% Nissan: 58 mpg
% Honda: 62 mpg
 
B = [51; 58; 62];
 
% To include them in the function, we should update our original
% alternative comparison matrix (we should remove the performance to avoid
% double counting), and the criteria comparison vector (we should include
% fuel economy.
 
M(:,3) = [];
% We can update the criteria names
 
criteria_names = {'Safety';'Design';'Fuel Economy';'Performance'}; % in the function, we should put qualitative criteria first,
% then beneficial quantitative criteria and finaly non-beneficial
% quantitative criteria
 
% Safety is more important than Fuel Economy to a moderate extent: 5
% Design is less important than Fuel Economy to a large extend: 1/7
% Fuel Economy is less important than Performance to a small extent: 1/2
 
C2 = [5; 1/7; 1/2];
 
% we use the old C vector and put the elements of the new in the right
% position
C = [C(1); C2(1); C(2); C2(2); C(3); C2(3)];
 
[h, c, a] = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'names',names,'criterianames',criteria_names)
 
% and the Fuzzy AHP option
[h, c, a] = ahp(M,C,'fuzzy',true,'beneficial',B,'nonbeneficial',NB,'names',names,'criterianames',criteria_names)
%
%
%% Simulation
% We can use the simulation and compare the results with the simple AHP
% method
 
[h, c, a] = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'simulation',true,'names',names,'criterianames',criteria_names)
% In addition to the mean, we can pick percentiles, e.g. 1%, 50% (median),
% and 99%.
[h, c, a] = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'simulation',true,'percentiles',[1; 50; 99],'names',names,'criterianames',criteria_names)
% We can visualize the volatility of the hierarchy we receive from
% the simulation
 
[h, c, a] = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'simulation',true,'percentiles',[1; 50; 99],'charts',true,'names',names,'criterianames',criteria_names)
 
% We can increase the sensitivity level (standard deviation) of the
% simulation, e.g. from 1 to 3, and the number of trials, e.g. from 1,000
% to 10,000
 
[h, c, a] = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'simulation',true,'percentiles',[1; 50; 99],'charts',true,'sensitivity',3,'trials',10000,'names',names,'criterianames',criteria_names)
% Instead of setting one level of sensitivity, we can pick different levels
% of sensitivity for each pairwise comparison. e.g.:
% Sensitivity of criteria pairwise comparisons
SC = [5; 2; 4; 7; 2; 1];
% Sensitivity of alternatives pairwise comparisons
SA = [3, 2; 6, 1; 4,5];
[h, c, a] = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'simulation',true,'percentiles',[1; 50; 99],'charts',true,'senscriteria',SC,'sensalts',SA,'trials',10000,'names',names,'criterianames',criteria_names)
%
%
%% Analytic Network Process
% If we want to use Analytic Network Process, we need to create the comparison matrix
% of each criterion subject to each of the alternatives
 
% W1: Toyota
% Safety is more prevalent than Design to a moderate/large extent: 6
% Safety is less prevalent than Fuel Economy to a small extent: 1/2
% Safety is more prevalent than Performance to a very large extent: 9
% Design is more prevalent than Fuel Economy to a very large extent: 8
% Design is more prevalent than Performance to a moderate/large extent: 7
% Fuel Economy is more prevalent than Performance to a small extent: 3
 
W1 = [6; 1/2; 9; 8; 7; 3];
 
% W2: Nissan
% Safety is more prevalent than Design to a moderate extent: 4
% Safety is as prevalent as Fuel Economy: 1
% Safety is more prevalent than Performance to a small extent: 2
% Design is more prevalent than Fuel Economy to a small extent: 3
% Design is more prevalent than Performance to a moderate extent: 5
% Fuel Economy is more prevalent than Performance to a small extent: 2
 
W2 = [4; 1; 2; 3; 5; 2];
 
% W3: Honda
% Safety is less prevalent than Design to a large extent: 1/7
% Safety is more prevalent than Performance to a moderate/large extent: 6
% Safety is less prevalent than Performance to a very large extent: 1/9
% Design is less prevalent than Fuel Economy to a small extent: 1/3
% Design is less prevalent than Performance to a moderate extent: 1/5
% Fuel Economy is less prevalent than Performance to a small extent: 1/3
 
W3 = [1/7; 6; 1/9; 1/3; 1/5; 1/3];
 
% The overall alternatives comparison matrix is:
 
W = [W1, W2, W3];
 
% Now we can run the function and obtain the individual criteria
% comparison weights. 
[h, c, a, f] = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'feedback',W,'names',names,'criterianames',criteria_names)
% We can use the Fuzzy ANP option
[h, c, a, f] = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'feedback',W,'fuzzy',true,'names',names,'criterianames',criteria_names)
% and the simulation option. We can add sensitivities of feedback (prevalence) pairwise comparisons
SW = [6, 1, 5; 1, 7, 3; 8, 2, 3; 6, 1, 5; 1, 7, 3; 8, 2, 3];
[h, c, a, f] = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'feedback',W,'simulation',true,'percentiles',[1; 50; 99],...
    'senscriteria',SC,'sensalts',SA,'sensfeedback',SW,'names',names,'criterianames',criteria_names)
%
%
%% Cost-Benefit analysis
% AHP allows us to quantitatively express the benefit we receive from each
% option. If we assign costs to each option, we can perform cost benefit
% analysis. If the prices of the cars are:
% Toyota: $45,000
% Nissan: $32,000
% Honda: $25,000
Costs = [45000; 32000; 25000];
h = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'cost',Costs,'costbenefit',true,'names',names,'criterianames',criteria_names)
% We can introduce more than one cost measures, e.g. annual maintenance cost
% Toyota: $1,000
% Nissan: $500
% Honda: $700
Costs = [Costs, [1000; 500; 700]];
h = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'cost',Costs,'costbenefit',true,'names',names,'criterianames',criteria_names)
% This option works under the assumption that both costs are of equal
% importance. Alternatively, we can do a pairwise comparison of the two
% costs (as above). e.g. Price is less important than maintenance cost to a
% small extent: 1/3
costWeights = 1/3;
h = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'cost',Costs,'costbenefit',true,'costweights',costWeights,'names',names,'criterianames',criteria_names)
% Also, instead of a pairwise comparison, we can assign importance weights
% for each type of cost. e.g. Price scores 30% and maintenance cost scores
% 70%
costWeights = [.3; .7];
% In addition, we can put the results in order according to the
% cost-benefit analysis
h = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'cost',Costs,'costbenefit',true,'costweights',costWeights,'order','costbenefit','names',names,'criterianames',criteria_names)
% ('costbenefit' works with analytic network process, and 'fuzzy' and
% 'simulation' options too)
%
%
%% Optimization
% Let's assume that we are car collectors and we have a fixed budget to
% spend on car purchases, which we are happy to spend in more than one car.
% If our budget to buy cars is $72,000 and our annual maintenance budget is $1,600
budget = [72000, 1600];
%
% the optimization option gives us the optimal allocation of budget
h = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'cost',Costs,'optimization',budget,'names',names,'criterianames',criteria_names)
% The options that score 1 in the are the optimal combination of options to select
% We can ask the function to remove the non-selected alternatives and adjust the hierarchy weights accordingly.
h = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'cost',Costs,'optimization',budget,'optimadjust',true,'names',names,'criterianames',criteria_names)
%
% Finaly, we can run an ANP example with different simulation
% sensitivities, optimization (with adjustment), and cost-benefit analysis.
[h, c, a, w] = ahp(M,C,'beneficial',B,'nonbeneficial',NB,'feedback',W,'simulation',true,'percentiles',[1;50;99],...
    'senscriteria',SC,'sensalts',SA,'sensfeedback',SW,'cost',Costs,'optimization',budget,'optimadjust',true,'costbenefit',true,'order','use',...
    'names',names,'criterianames',criteria_names)
%
%
%% End of the example
