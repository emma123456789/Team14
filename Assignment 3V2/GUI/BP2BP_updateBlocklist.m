% This function updates all block information to TableBlockData and removes 
% prior BP info that is incorrect for all BP2BP moves. 
function BP2BP_updateBlocklist(conveyor2BP_number,conveyor2BP_letter, x2, y2)
    % accessing the index of the block that is being moved
    global BP2BP_index;
    % global array of the table block information
    global tableBlockData;
    % splitting up the string of block information
    stringSplit = strsplit(tableBlockData(BP2BP_index)); 
    
    % adding new BP information in the form: x y theta type BP
    delimiters = [" "," "," "," ",""];
    newBlockInfo = join([x2, y2, stringSplit(3), stringSplit(4), conveyor2BP_letter, conveyor2BP_number], delimiters); % x y theta type BP
    % add new block information onto global table block data
    if isempty(tableBlockData)
        tableBlockData = newBlockInfo;
    else
        tableBlockData = [tableBlockData; newBlockInfo];
    end
    
    % deleting prior block information
    tableBlockData(BP2BP_index) = [];

end