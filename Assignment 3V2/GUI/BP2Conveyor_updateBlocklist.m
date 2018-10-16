% This function add update block information to conveyorBlockData and removes 
% prior BP info that is incorrect. 

function BP2Conveyor_updateBlocklist(x2,y2)
    % changing the BP INFO
    global conveyorIndexSelected;
    global conveyorBlockData;
    global tableBlockData;
    
    %global tableBlockData;
    stringSplit = strsplit(conveyorBlockData(conveyorIndexSelected)); 
    
    % adding new BP: x y theta type BP
    delimiters = [" "," "," "," ",""];
    newBlockInfo = join([x2, y2, stringSplit(3), stringSplit(4), 0, 0], delimiters); % x y theta type BP
    if isempty(tableBlockData)
        tableBlockData = newBlockInfo;
    else
        tableBlockData = [tableBlockData; newBlockInfo];
    end
    
    % deleting orginal BP
    conveyorBlockData(conveyorIndexSelected) = [];

    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    set(handles.ConveyortoBPBlockList, 'String', conveyorBlockData);
    set(handles.ConveyorBlocksListbox, 'String', conveyorBlockData);
    
end