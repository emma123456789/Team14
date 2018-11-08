% Testing function for RotateBlock

function Testing_RotateBlock(GuiHandle) 
    global tableBlockData;
	global Rotate_index;
    %tableBlockData = '120 80 9 2 B2';
    
    % This allows us to change gui in external function
    handles = guidata(GuiHandle);
    
    % Split up string
    % assume there is only one block in tableBlockData
    stringSplit = strsplit(tableBlockData(1)); 
    X1 = stringSplit(1);
    Y1 = stringSplit(2);
	rot = stringSplit(3);
	Rotate_index = 1;
    
    % Update SM Function name and Location aims text
    set(handles.CurrentSM,'string','Rotate Block Simple Move');
    set(handles.LAXvalue,'string', num2str(X1));
    set(handles.LAYvalue,'string', num2str(Y1));
    set(handles.LAZvalue,'string','147');
    set(handles.LAAnglevalue,'string', rot);
    
    % Move using SM BP2Conveyor modified so it will pause and move away
    SMTESTING_RotateBlock(X1, Y1, rot, GuiHandle);
    rotateBlock_updateBlocklist(X1, Y1);
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
end 

