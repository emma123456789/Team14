% Testing function for BP2BP: it compares the expected results with the
% robot pose to verify that BP2BP move works. It will display a success or
% failure on the GUI.
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
	rot = stringSplit(3);
    BP2BP_index = 1;
	
    % Update SM Function name and Location aims text
    set(handles.CurrentSM,'string','BP to BP Simple Move');
    set(handles.LAXvalue,'string', num2str(X2));
    set(handles.LAYvalue,'string', num2str(Y2));
    set(handles.LAZvalue,'string','147');
    set(handles.LAAnglevalue,'string', stringSplit(3));
    
    % Move using SM BP2BP modified so it will pause and move away
    SMTESTING_BP2BP(X1, Y1, rot, X2, Y2, GuiHandle);
%     findTableBlockIndex(letter, number);
    BP2BP_updateBlocklist(number, letter, X2, Y2);
    
    % updating info to all lists  
    set(handles.TableBlocksListbox, 'String', tableBlockData);
    set(handles.BPtoConveyorBlockList, 'String', tableBlockData);
    set(handles.BPtoBPBlockList, 'String', tableBlockData);
    set(handles.RotateBlockBlockList, 'String', tableBlockData);
    
	% Analyse results
	t = 5; % Tolerance
	robot_pose_x = get(handles.RPXvalue,'String');
	robot_pose_y = get(handles.RPYvalue,'String');
	robot_pose_z = get(handles.RPZvalue,'String');
	robot_pose_rot = get(handles.RPAnglevalue,'String');
	
	difference_RP_x = abs(str2double(robot_pose_x)-X2);
	difference_RP_y = abs(str2double(robot_pose_y)-Y2);
	difference_RP_z = abs(str2double(robot_pose_z)-147);
	difference_RP_rot = abs(str2double(robot_pose_rot)-str2double(rot));
	
	if (difference_RP_x<t && difference_RP_y<t && difference_RP_z<t && difference_RP_rot<t)
		set(handles.SuccessOrFailure, 'String', 'SUCCESS');
	else
		set(handles.SuccessOrFailure, 'String', 'FAILURE');
	end
end 
