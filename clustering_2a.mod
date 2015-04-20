## HW 4 (2a) Clustering implementation

## Sets
set K; #set of clusters
set V; #set of vertices
set E within {V cross V}; #set of edges between vertices

## Parameters
param cap;
param eweights{E} > 0;
param nweights {V} default 1; #what is this supposed to do????
param gender{V} binary;
param males;
param females;
var cluster_assign{V,K} binary; #matrix assigning vertices to clusters

## Objective Function
maximize Weights_Within:
sum{(i,j) in E, k in K} eweights[i,j]*cluster_assign[i,k]*cluster_assign[j,k];

#sum{i in V, j in V, k in K} eweights[i,j]*cluster_assign[i,k]*cluster_assign[j,k];


## Constraints

# ensure every cluster is of *exactly* cap nodes (uses full capacity)
subject to Capacity{k in K}:
sum{i in V} cluster_assign[i,k] = cap;

# ensure each cluster has at most the specified # of males allowed
subject to Males{k in K}:
sum{i in V} cluster_assign[i,k]*gender[i]<=males;

# ensure each cluster has at most the specified # of females allowed
subject to Females{k in K}:
sum{i in V} cluster_assign[i,k]*(1-gender[i])<=females;

