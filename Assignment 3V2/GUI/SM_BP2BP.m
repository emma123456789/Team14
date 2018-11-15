%SM_BP2BP adds the appropriate commands to the send queue to move a
%block from a table BP to another BP.
%
%X1, Y1 indicate the position of the block on the table
%X2, Y2 indicate the position to move the block to on the table
%
%The order of commands is:
%1. Move quickly to position above block to be moved (high enough to be clear of all collisions)
%2. Turn on the vacuum pump
%3. Move slowly down to the block position
%4. Turn on vacuum solenoid
%5. Move quickly back up to clearance height 
%6. Move quickly to position above new BP at the same height
%7. Move slowly down to table
%8. Turn off vacuum solenoid
%9. Move back up to clearance height
%10. Turn off the vacuum pump
%
%The clearance height is 6 times the block height.

function SM_BP2BP(X1, Y1, X2, Y2)
    global queue;
    global OG;
    fast = 'v500';
    regular = 'v100';
    slow = 'v50';
    table_height = 147;
    block_height = 5;
    move_height = table_height + block_height * 6;
    grip_height = table_height + block_height;
    
    %strcat
    [letter,number] = Coordinates2BP(X2,Y2);
    BP = strcat(letter,number);
%     [OGflg,row,column] = CheckOG(BP);
    
%     if OGflg ==0
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
    
    %move up to move height
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', X2,Y2,move_height,0,180,0,regular);
    queue.add(commandStr);
    
    %turn off pump
    commandStr = sprintf('vacuumPumpOff');
    queue.add(commandStr);
    
%     [newOG] = UpdateOG(BP);
%     else
%         disp('BP is already in use');
%     end
end