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