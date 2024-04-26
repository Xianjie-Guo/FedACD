function [CausalS, Time] = FedACD(Datasets, Alpha, Mask_rate, D_type)

% Input:
% Datasets: a cell array of datasets on all clients. Note that the sample size can be different for each dataset but the feature dimensions must be the same.
% Alpha: the significant level for conditional independence tests, e.g. 0.01 or 0.05.
% Mask_rate: The mask rate of the adjacency matrix.
% D_type: the type of used datasets. D_type='dis' represents discrete data, and D_type='con' denotes continuous data.

% Output:
% CausalS: the learned causal structure.
% Time: the running time.

maxK=3;
m=length(Datasets); % m is the number of clients
[~,n_vars]=size(Datasets{1});

%#################################START#################################
start=tic;

skeleton = ones(n_vars,n_vars); % completely undirected graph
skeleton=setdiag(skeleton,0);

% Optimizing federated causal skeleton learning through adaptive variable space selection strategy
for condset_size=0:1:maxK
    mask_skele_n=cell(1,m);
    raw_skele_n=cell(1,m);
    
    if strcmp(D_type,'dis')
        for k=1:m
            [mask_skele_n{k},raw_skele_n{k},is_converg] = ...
                skele_learn_single_layer_d(Datasets{k},skeleton,condset_size,Alpha,Mask_rate);
        end
    elseif strcmp(D_type,'con')
        for k=1:m
            [mask_skele_n{k},raw_skele_n{k},is_converg] = ...
                skele_learn_single_layer_c(Datasets{k},skeleton,condset_size,Alpha,Mask_rate);
        end
    else
        error("Please enter the correct data type!  'dis' or 'con'");
    end
    
    if is_converg
        break; % iterative convergence
    end
    
    % Aggregate the latest skeleton based on current mask_skele_n and raw_skele_n
    [new_skele]=skele_aggre(mask_skele_n,raw_skele_n);
    skeleton=new_skele;
end


% Federate orientation of the global skeleton
if strcmp(D_type,'dis')
    cpm = tril(sparse(skeleton));
    Gs=cell(1,m);
    for k=1:m
        LocalScorer = bdeulocalscorer(Datasets{k}, max(Datasets{k}));
        HillClimber = hillclimber(LocalScorer, 'CandidateParentMatrix', cpm);
        Gs{k} = HillClimber.learnstructure();
        Gs{k}=full(Gs{k});
    end
else
    nEvals = 2500;
    Gs=cell(1,m);
    for k=1:m
        n_samples=size(Datasets{k},1);
        % Use BIC penalty
        penalty = log(n_samples)/2;
        clamped=zeros(n_samples,n_vars); % if there is no intervention data, all are 0
        Gs{k} = DAGsearch(Datasets{k},nEvals,0,penalty,0,clamped,skeleton,0);
        Gs{k} = logical(Gs{k});
    end
end

% merge m DAG Gs
CausalS=dag_aggre(Gs);

Time=toc(start);

end
