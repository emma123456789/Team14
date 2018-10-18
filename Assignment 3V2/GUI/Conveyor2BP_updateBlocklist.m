% This function add update block information to TableBlockData and removes 
% prior conveyor info that is incorrect. 

function Conveyor2BP_updateBlocklist(BP2BP_number,BP2BP_letter, x2, y2)
    % changing the BP INFO
    global Conveyor2BP_index;
    global conveyorBlockData;
    global tableBlockData;
    
    %global tableBlockData;
    stringSplit = strsplit(conveyorBlockData(Conveyor2BP_index)); 
    
    % adding new BP: x y theta type BP
    delimiters = [" "," "," "," ",""];
    newBlockInfo = join([x2, y2, stringSplit(3), stringSplit(4), BP2BP_letter, BP2BP_number], delimiters); % x y theta type BP
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