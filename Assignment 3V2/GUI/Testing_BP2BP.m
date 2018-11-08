% Testing function for BP2BP

function Testing_BP2BP(GuiHandle) 
    global tableBlockData;
	global BP2BP_index;
    %tableBlockData = '120 80 9 2 B2';
    
    % This allows us to change gui in external function
    handles = guidata(GuiHandle);
    
    letter = 'F';
    number = 6;
    [X2,Y2] = gameboardConversion(number,letter); 
    
    % Split up string
    % assume there is only one block in tableBlockData
    stringSplit = strsplit(tableBlockData(1)); 
    X1 = stringSplit(1);
    Y1 = stringSplit(2);
	
    BP2BP_index = 1;
	
    % Update SM Function name and Location aims text
    set(handles.CurrentSM,'string','BP to BP Simple Move');
    set(handles.LAXvalue,'string', num2str(X2));
    set(handles.LAYvalue,'string', num2str(Y2));
    set(handles.LAZvalue,'string','147');
    set(handles.LAAnglevalue,'string', stringSplit(3));
    
    % Move using SM BP2BP modified so it will pause and move away
    SMTESTING_BP2BP(X1, Y1, X2, Y2, GuiHandle);
%     findTableBlockIndex(letter, number);
    BP2BP_updateBlocklist(number, letter, X2, Y2);
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
end 
