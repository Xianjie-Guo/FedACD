function [new_skele] = skele_aggre(mask_skele_n,raw_skele_n)
% Aggregating the masked adjacency matrices returned from multiple clients

n_vars=size(mask_skele_n{1},1);
m=length(mask_skele_n);
new_skele=zeros(n_vars,n_vars);

for i=1:n_vars
    for j=1:i-1
        cout_0=0;
        cout_1=0;
        for k=1:m
            switch mask_skele_n{k}(i,j)
                case 0
                    cout_0=cout_0+1;
                case 1
                    cout_1=cout_1+1;
                case -1
                    continue;
            end
        end
        if cout_1>=cout_0
            new_skele(i,j)=1;
            new_skele(j,i)=1;
        end
    end
end

end

