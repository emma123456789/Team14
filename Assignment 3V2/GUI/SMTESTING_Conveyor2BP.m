%Function sends the appropriate functions to robot studio to move a block
%from one BP to another
function SMTESTING_Conveyor2BP(X1, Y1, X2, Y2, GuiHandle)
    global queue;
    global tableBlockData;
    fast = 'v500';
    regular = 'v100';
    slow = 'v50';
    table_height = 147;
    conveyor_height = 22;
    block_height = 5;
    move_height = table_height + block_height * 6;
    grip_height = table_height + block_height;
    conveyor_grip_height = conveyor_height + block_height;
    
    % This allows us to change gui in external function
    handles = guidata(GuiHandle);
	
    %first avoid collision with table
    %WIP
    %WIP
    
    %move to conveyor position
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,move_height,0,180,0,fast);
    queue.add(commandStr);
    
    %turn on vacuum
    commandStr = sprintf('vacuumPumpOn');
    queue.add(commandStr);
    
    %move down to conveyor
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,conveyor_grip_height,0,180,0,regular);
    queue.add(commandStr);
    
    %turn on solenoid
    commandStr = sprintf('vacuumSolenoidOn');
    queue.add(commandStr);
    
    %lift block
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,move_height,0,180,0,fast);
    queue.add(commandStr);
    
    %move to BP
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X2,Y2,move_height,0,180,0,fast);
    queue.add(commandStr);
    
    %move down to block
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X2,Y2,grip_height,0,180,0,regular);
    queue.add(commandStr);
    
    %turn off solenoid
    commandStr = sprintf('vacuumSolenoidOff');
    queue.add(commandStr);
	
	% wait and then find the robot pose position
    pause; % press enter to continue
    % Find the robot pose position
    robot_pose_x = get(handles.XStatus,'String');
	robot_pose_y = get(handles.YStatus,'String');
	robot_pose_z = get(handles.ZStatus,'String');
	% I'm not sure if this is the orientation! Or we might need to
	% calculate it using the matrix and 6 joint angles?
	robot_pose_rot = get(handles.Joint6Status,'String');
	
    set(handles.RPXvalue,'string', robot_pose_x);
    set(handles.RPYvalue,'string', robot_pose_y);
    set(handles.RPZvalue,'string', robot_pose_z);
    set(handles.RPAnglevalue,'string', robot_pose_rot);	
    
    %move up to move height
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X2,Y2,move_height,0,180,0,regular);
    queue.add(commandStr);
    
    %turn off pump
    commandStr = sprintf('vacuumPumpOff');
    queue.add(commandStr);
	
	%move robot away from table so computer vision position can be
    %calculated (eg. move to conveyor)
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', 0,409,move_height,0,180,0,fast);
    queue.add(commandStr);
    
    % wait and then find the computer vision position
    pause; % press enter to continue
    % Find the computer vision position!!!!!!!!!!!!!!!!!!!
    getBlocks_Callback(hObject, eventdata, handles)
    testingBlocks = strsplit(tableBlockData(1));
    
    set(handles.CVXvalue,'string', testingBlocks(1));
    set(handles.CVYvalue,'string', testingBlocks(2));
    set(handles.CVZvalue,'string','147');
    set(handles.CVAnglevalue,'string', testingBlocks(3));
    

end