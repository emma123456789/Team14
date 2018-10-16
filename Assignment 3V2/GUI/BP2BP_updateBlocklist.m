% This function add update block information to TableBlockData and removes 
% prior BP info that is incorrect. 

function BP2BP_updateBlocklist(conveyor2BP_number,conveyor2BP_letter, x2, y2)
    % changing the BP INFO
    global tableIndexSelected;
    global tableBlockData;
    %global tableBlockData;
    stringSplit = strsplit(tableBlockData(tableIndexSelected)); 
    
    % adding new BP: x y theta type BP
    delimiters = [" "," "," "," ",""];
    newBlockInfo = join([x2, y2, stringSplit(3), stringSplit(4), conveyor2BP_letter, conveyor2BP_number], delimiters); % x y theta type BP
    if isempty(tableBlockData)
        tableBlockData = newBlockInfo;
    else
        tableBlockData = [tableBlockData; newBlockInfo];
    end
    
    % deleting orginal BP
    tableBlockData(tableIndexSelected) = [];

    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
end