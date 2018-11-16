% This function updates all block information to conveyorBlockData and removes 
% prior BP info that is incorrect for all BP2Conveyor moves. 
function BP2Conveyor_updateBlocklist(x2,y2)
    % accessing the index of the block that is being moved
    global BP2Conveyor_index;
    % global array of the conveyor block information
    global conveyorBlockData;
    % global array of the table block information
    global tableBlockData;
    
    % splitting up the string of block information
    stringSplit = strsplit(tableBlockData(BP2Conveyor_index)); 
    
    % adding new BP information in the form: x y theta type BP
    delimiters = [" "," "," "];
    newBlockInfo = join([x2, y2, stringSplit(3), stringSplit(4)], delimiters); % x y theta type BP
    % add new block information onto global conveyor block data
    if isempty(conveyorBlockData)
        conveyorBlockData = newBlockInfo;
    else
        conveyorBlockData = [conveyorBlockData; newBlockInfo];
    end
    
    % deleting prior block information
    tableBlockData(BP2Conveyor_index) = [];

    
end

