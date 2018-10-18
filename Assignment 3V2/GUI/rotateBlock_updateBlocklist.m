% This function add update block information to TableBlockData and removes 
% prior BP info that is incorrect. 

function rotateBlock_updateBlocklist(x1,y1)
    % changing the BP INFO
    global Rotate_index;
    global tableBlockData;
    %global tableBlockData;
    stringSplit = strsplit(tableBlockData(Rotate_index)); 
    
    % adding new BP: x y theta type BP
    delimiters = [" "," "," "," "];
    newBlockInfo = join([x1, y1, 0, stringSplit(4), stringSplit(5)], delimiters); % x y theta type BP
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