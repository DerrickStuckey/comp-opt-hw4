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
var edge_cluster_assign{E,K} binary; #matrix assigning edges to clusters

## Objective Function
maximize Weights_Within:
sum{(i,j) in E, k in K} eweights[i,j]*edge_cluster_assign[i,j,k];

## Constraints

# ensure consistency between cluster_assign, edge_cluster_assign
subject to Consistent1{(i,j) in E, k in K}:
edge_cluster_assign[i,j,k] <= cluster_assign[i,k];

subject to Consistent2{(i,j) in E, k in K}:
edge_cluster_assign[i,j,k] <= cluster_assign[j,k];

subject to Consistent3{(i,j) in E, k in K}:
edge_cluster_assign[i,j,k] >= cluster_assign[i,k] + cluster_assign[j,k] - 1;

# ensure each node belongs to one cluster
subject to Coverage{i in V}:
sum{k in K} cluster_assign[i,k] = 1;

# ensure every cluster is of *exactly* cap nodes (uses full capacity)
subject to Capacity{k in K}:
sum{i in V} cluster_assign[i,k] = cap;

# ensure each cluster has at most the specified # of males allowed
subject to Males{k in K}:
sum{i in V} cluster_assign[i,k]*gender[i]<=males;

# ensure each cluster has at most the specified # of females allowed
subject to Females{k in K}:
sum{i in V} cluster_assign[i,k]*(1-gender[i])<=females;

