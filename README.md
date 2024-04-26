[Sample Quality Heterogeneity-aware Federated Causal Discovery through Adaptive Variable Space Selection](https://xianjie-guo.github.io/EnHome.html) <br>

# Usage
"FedACD.m" is main function. <br>
Note that the current code has only been debugged on Matlab (2018a) with a 64-bit Windows system.<br>
----------------------------------------------
function [CausalS, Time] = FedACD(Datasets, Alpha, Mask_rate, D_type) <br>
* INPUT: <br>
```Matlab
Datasets: a cell array of datasets on all clients. Note that the sample size can be different for each dataset but the feature dimensions must be the same.
Alpha: the significant level for conditional independence tests, e.g. 0.01 or 0.05.
Mask_rate: The mask rate of the adjacency matrix.
D_type: the type of used datasets. D_type='dis' represents discrete data, and D_type='con' denotes continuous data.
```
* OUTPUT: <br>
```Matlab
CausalS: the learned causal structure.
Time: the running time.
```

# Example for discrete dataset
```Matlab
clear;
clc;
addpath(genpath('com_func/'));

graph_path='./dataset/discrete_data/Child_graph.txt';
data_path='./dataset/discrete_data/Child_5000samples.txt';

alpha=0.01; % the significant level.
client_num=5; % the number of clients.
mask_rate=0.6; % the mask rate of the adjacency matrix.
ground_truth=load(graph_path);
data=importdata(data_path)+1;
[datasets] = split_dataset(data, client_num);
[dag,time]=FedACD(datasets,alpha, mask_rate, 'dis'); % dag is the learned causal structure.

% evaluate the learned causal structure.
[fdr,tpr,fpr,SHD,reverse,miss,extra,undirected,ar_f1,ar_precision,ar_recall]=eva_DAG(ground_truth,dag);
```

# Example for continuous dataset
```Matlab
clear;
clc;
addpath(genpath('com_func/'));

graph_path='./dataset/continuous_data/REGED_node8_graph.txt';
data_path='./dataset/continuous_data/REGED_node8_1000samples.txt';

alpha=0.01; % the significant level.
client_num=5; % the number of clients.
mask_rate=0.6; % the mask rate of the adjacency matrix.
ground_truth=load(graph_path);
data=importdata(data_path)+1;
[datasets] = split_dataset(data, client_num);
[dag,time]=FedACD(datasets,alpha, mask_rate, 'con'); % dag is the learned causal structure.

% evaluate the learned causal structure.
[fdr,tpr,fpr,SHD,reverse,miss,extra,undirected,ar_f1,ar_precision,ar_recall]=eva_DAG(ground_truth,dag);
```

# Reference
* Guo, Xianjie, et al. "Sample Quality Heterogeneity-aware Federated Causal Discovery through Adaptive Variable Space Selection." *Proceedings of the 33rd International Joint Conference on Artificial Intelligence (IJCAI'24)* (2024).
