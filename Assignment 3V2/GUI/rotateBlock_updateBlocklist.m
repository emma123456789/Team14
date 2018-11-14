% This function updates all block information to TableBlockData and removes 
% prior BP info that is incorrect for all rotateBlock moves. 
function rotateBlock_updateBlocklist(x1,y1)
    % accessing the index of the block that is being rotated
    global Rotate_index;
    % global array of the table block information
    global tableBlockData;

    % splitting up the string of block information
    stringSplit = strsplit(tableBlockData(Rotate_index)); 
    
    % adding new BP information in the form: x y theta type BP
    delimiters = [" "," "," "," "];
    newBlockInfo = join([x1, y1, 0, stringSplit(4), stringSplit(5)], delimiters); % x y theta type BP
    % add new block information onto global table block data
    if isempty(tableBlockData)
        tableBlockData = newBlockInfo;
    else
        tableBlockData = [tableBlockData; newBlockInfo];
    end
    
    % deleting prior block information
    tableBlockData(Rotate_index) = [];
    
end