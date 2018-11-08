function [G_out] = removeNodes(G_original)
    G_out = G_original;
    
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
    

    %testing: removes a cell of bps alr defined
    %bp = {'B1' 'C1' 'D1' 'B2' 'C2' 'D2'};
    %bp = {'A1' 'B2' 'C3' 'D4' 'E5' 'F6' 'G7' 'H8' 'I9'};
    %bp = {'A2' 'B1'};
%     bp = {'A9' 'B9' 'C9' 'D9' 'E9' 'F9' 'G9' 'H9' 'I9'...
%         'A8' 'B8' 'C8' 'H8' 'I8'...
%         'A7' 'B7' 'C7' 'E7' 'F7'...
%         'A6' 'B6' 'C6' 'E6' 'F6' 'G6' 'H6' 'I6'...
%         'A5' 'E5' 'F5' 'G5' 'H5' 'I5'...
%         'A4' 'C4' 'D4' 'E4' 'F4' 'G4' 'H4' 'I4'...
%         'A3' 'C3' 'D3' 'E3' 'F3' 'G3' 'H3' 'I3'...
%         'A2' 'C2' 'D2' 'E2' 'F2' 'G2' 'H2' 'I2'...
%         'A1' 'B1' 'C1' 'D1' 'E1' 'F1' 'G1' 'H1' 'I1'};
    G_out = rmnode(G_out, bp);
 
end

