% Testing function for RotateBlock: it compares the expected results with the
% robot pose to verify that RotateBlock move works. It will display a success or
% failure on the GUI.

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
    set(handles.LAXvalue,'string', X1);
    set(handles.LAYvalue,'string', Y1);
    set(handles.LAZvalue,'string','147');
    set(handles.LAAnglevalue,'string', '0');
    
    % Move using SM BP2Conveyor modified so it will pause and move away
    SMTESTING_RotateBlock(X1, Y1, rot, GuiHandle);
    rotateBlock_updateBlocklist(X1, Y1);
    
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
	difference_RP_rot = abs(str2double(robot_pose_rot)-0);
	
	if (difference_RP_x<t && difference_RP_y<t && difference_RP_z<t && difference_RP_rot<t)
		set(handles.SuccessOrFailure, 'String', 'SUCCESS');
	else
		set(handles.SuccessOrFailure, 'String', 'FAILURE');
	end
    
end 

