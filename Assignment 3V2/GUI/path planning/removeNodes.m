function [G_out] = removeNodes(G_original)
    G_out = G_original;
    
%     global tableBlockData
%     data = tableBlockData;
    
    %get the bp of blocks acting as obstacles
    %loop removes the respective node of the obstacle
%     nodeCount = length(data);
%     bpPosition = 5;
%     bpArray = [];
%     for row = 1:nodeCount
%         rowData = strsplit(data(row));
% 		bp = char(rowData(bpPosition));
%         bpArray = [bpArray bp];
%         G_out = rmnode(G_out, bp);
%     end
    

    %testing: removes a cell of bps alr defined
    bp = {'B1' 'C1' 'D1' 'B2' 'C2' 'D2'};
    G_out = rmnode(G_out, bp);
    
   
    
end

