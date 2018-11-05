function [G_out] = removeNodes(G_original)
    G_out = G_original;
    %node_number = x+(y-1)*9;
    %G_out = rmnode(G_out, node_number);
    % p = shortestpath(G_out, )
    
    global tableBlockData
    data = tableBlockData;
    
    %get the bp of blocks acting as obstacles
    %loop removes the respective node of the obstacle
    nodeCount = length(data);
    bpPosition = 5;
    bpArray = [];
    for row = 1:nodeCount
        rowData = strsplit(data(row));
		bp = char(rowData(bpPosition));
        bpArray = [bpArray bp];
        G_out = rmnode(G_out, bp);
    end
    
    disp(G);
    
end

