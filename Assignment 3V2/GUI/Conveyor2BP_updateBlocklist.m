% This function updates all block information to TableBlockData and removes 
% prior conveyor info info that is incorrect for all Conveyor2BP moves. 
function Conveyor2BP_updateBlocklist(BP2BP_number,BP2BP_letter, x2, y2)
    % accessing the index of the block that is being moved
    global Conveyor2BP_index;
    % global array of the conveyor block information
    global conveyorBlockData;
    % global array of the table block information
    global tableBlockData;
    
    % splitting up the string of block information
    stringSplit = strsplit(conveyorBlockData(Conveyor2BP_index)); 
    
    % adding new BP information in the form: x y theta type BP
    delimiters = [" "," "," "," ",""];
    newBlockInfo = join([x2, y2, stringSplit(3), stringSplit(4), BP2BP_letter, BP2BP_number], delimiters); % x y theta type BP
    % add new block information onto global table block data
    if isempty(tableBlockData)
        tableBlockData = newBlockInfo;
    else
        tableBlockData = [tableBlockData; newBlockInfo];
    end
    
    % deleting prior block information
    conveyorBlockData(Conveyor2BP_index) = [];
 
end