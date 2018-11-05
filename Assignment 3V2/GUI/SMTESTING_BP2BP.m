%Function sends the appropriate functions to robot studio to move a block
%from one BP to another
function SMTESTING_BP2BP(X1, Y1, X2, Y2, GuiHandle)
    global queue;
    fast = 'v500';
    regular = 'v100';
    slow = 'v50';
    table_height = 147;
    block_height = 5;
    move_height = table_height + block_height * 6;
    grip_height = table_height + block_height;
    
    % This allows us to change gui in external function
    handles = guidata(GuiHandle);
    
    
    %first avoid collision with table
    %WIP
    %WIP
    
    %move to block position
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,move_height,0,180,0,fast);
    queue.add(commandStr);
    
    %turn on vacuum
    commandStr = sprintf('vacuumPumpOn');
    queue.add(commandStr);
    
    %move down to block
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,grip_height,0,180,0,regular);
    queue.add(commandStr);
    
    %turn on solenoid
    commandStr = sprintf('vacuumSolenoidOn');
    queue.add(commandStr);
    
    %lift block
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,move_height,0,180,0,fast);
    queue.add(commandStr);
    
    %move to new BP
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X2,Y2,move_height,0,180,0,fast);
    queue.add(commandStr);
    
    %move down to block
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X2,Y2,grip_height,0,180,0,regular);
    queue.add(commandStr);
    
    %turn off solenoid
    commandStr = sprintf('vacuumSolenoidOff');
    queue.add(commandStr);
    
    % wait and then find the robot pose position
    pause(5); % dont know how long to pause for
    % Find the robot pose position!!!!!!!!!!!!!!!!!!!!
    
    set(handles.RPXvalue,'string', '0');
    set(handles.RPYvalue,'string', '0');
    set(handles.RPZvalue,'string','0');
    % cannot find angle using robot pose position
    %set(handles.RPAnglevalue,'string', '0');
    
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
    pause(5); % dont know how long to pause for
    % Find the computer vision position!!!!!!!!!!!!!!!!!!!
    
    set(handles.CVXvalue,'string', '0');
    set(handles.CVYvalue,'string', '0');
    set(handles.CVZvalue,'string','0');
    set(handles.CVAnglevalue,'string', '0');
    
end