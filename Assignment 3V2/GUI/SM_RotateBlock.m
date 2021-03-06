%SM_RotateBlock adds the appropriate commands to the send queue to pick up
%a block and rotate it to align with the home coordinate system.
%
%X1, Y1 indicate the position of the block on the table
%rot indicates the currnet rotation of the block
%
%The order of commands is:
%1. Move quickly to position above block to be moved (high enough to be clear of all collisions)
%2. Turn on the vacuum pump
%3. Move slowly down to the block position
%4. Turn on vacuum solenoid
%5. Move quickly back up to clearance height 
%6. Rotate block by rot
%7. Move back down to table
%8. Turn off vacuum solenoid
%9. Move back up to clearance height
%10. Turn off the vacuum pump
%
%The clearance height is 6 times the block height.

function SM_RotateBlock(X1, Y1, rot)
    global queue;
    fast = 'v500';
    regular = 'v100';
    slow = 'v50';
    table_height = 147;
    block_height = 5;
    move_height = table_height + block_height * 6;
    grip_height = table_height + block_height;
    
    
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
    
    %rotate block by rot
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,move_height,rot,180,0,fast);
    queue.add(commandStr);
    
    %place back on the table
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,grip_height,rot,180,0,fast);
    queue.add(commandStr);
   
    %turn off solenoid
    commandStr = sprintf('vacuumSolenoidOff');
    queue.add(commandStr);
    
    %move up to move height
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,move_height,0,180,0,regular);
    queue.add(commandStr);
    
    %turn off pump
    commandStr = sprintf('vacuumPumpOff');
    queue.add(commandStr);
    
 

end