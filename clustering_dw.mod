## HW 4 (2c) Clustering implementation

# sets
set K;
set V;
set E within {V cross V};

# defined parameters
param cap;
param eweights{E} > 0;
param gender {V} binary;
param males;
param females;
param nweights {V} default 1;
param nCOL integer >= 0;
set COLS := 1..nCOL;
param weights{COLS} default 0;
param nbr {V,COLS} binary; #coefficients of each column generated

## RMP ##

# Decision variables
var Artf_V{V} >= 0;
var Artf_C >= 0; #Artf_Vficial var for convexity constraint
var lambda {COLS} binary; #defined as binary but will be relaxed

# When this is 0, have feasible starting solution
maximize Art_Weights:
-(sum{i in V} Artf_V[i] + Artf_C);

# RMP formulation
maximize WeightsInClusters:
sum {j in COLS} weights[j]*lambda[j];

# ensure every node covered by cluster or artificial var
subject to Fill {i in V}:
sum{j in COLS} nbr[i,j] * lambda[j] + Artf_V[i] = 1;

# ensure exactly K clusters exist
subject to Clusters:
sum {j in COLS} lambda[j] + Artf_C = card(K);

## Sub-Problem ## 

# dual vars
param price{V} default 0.0;
param priceclusters default 0.0;

# sub-problem decision vars
var y{V} binary; #1 if column includes node
var w{E} binary; #1 if column includes edge

# artificial reduced cost
maximize Art_Reduced_Cost:
- sum{i in V} price[i]*y[i] - priceclusters;

# Pricing Problem Formulation
maximize Red_Cost:
sum{(i,j) in E} w[i,j]*eweights[i,j] - sum{i in V} price[i]*y[i] - priceclusters;

subject to Feas1 {(i,j) in E}:
w[i,j] <= y[i];

subject to Feas2 {(i,j) in E}:
w[i,j] <= y[j];

subject to Feas3 {(i,j) in E}:
w[i,j] >= y[i] + y[j] - 1;

# ensure every cluster is of *exactly* cap nodes (uses full capacity)
subject to Capacity:
sum{i in V} y[i]*nweights[i]=cap;

# already ensured w/ Feas constraints, but speeds up search of solution space
subject to Capacity1:
sum{(i,j) in E} w[i,j]=cap*(cap-1)/2;

subject to Males:
sum{i in V} y[i]*gender[i]<=males;

subject to Females:
sum{i in V} y[i]*(1-gender[i])<=females;





