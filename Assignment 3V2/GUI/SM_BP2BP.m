%Function sends the appropriate functions to robot studio to move a block
%from one BP to another
function SM_BP2BP(X1, Y1, X2, Y2)
    global queue;
    fast = 'v500';
    regular = 'v100';
    slow = 'v50';
    block_height = 8;
    move_height = block_height * 2.5;
    
    
    %first avoid collision with table
    %WIP
    %WIP
    
    %move to block position
    commandStr = sprintf('moveert %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,move_height,0,180,0,fast);
    queue.add(commandStr);
    
    %turn on vacuum
    commandStr = sprintf('vacuumPumpOn');
    queue.add(commandStr);
    
    %move down to block
    commandStr = sprintf('moveert %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,block_height,0,180,0,regular);
    queue.add(commandStr);
    
    %turn on solenoid
    commandStr = sprintf('vacuumSolenoidOn');
    queue.add(commandStr);
    
    %lift block
    commandStr = sprintf('moveert %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,move_height,0,180,0,fast);
    queue.add(commandStr);
    
    %move to new BP
    commandStr = sprintf('moveert %.3f %.3f %.3f %.3f %.3f %.3f %s', X2,Y2,move_height,0,180,0,fast);
    queue.add(commandStr);
    
    %move down to block
    commandStr = sprintf('moveert %.3f %.3f %.3f %.3f %.3f %.3f %s', X2,Y2,block_height,0,180,0,regular);
    queue.add(commandStr);
    
    %turn off solenoid
    commandStr = sprintf('vacuumSolenoidOff');
    queue.add(commandStr);
    
    %move up to move height
    commandStr = sprintf('moveert %.3f %.3f %.3f %.3f %.3f %.3f %s', X2,Y2,move_height,0,180,0,regular);
    queue.add(commandStr);
    
    %turn off pump
    commandStr = sprintf('vacuumPumpOff');
    queue.add(commandStr);
    
    %move to calib
    commandStr = sprintf('movejas %.3f %.3f %.3f %.3f %.3f %.3f %s',-90,0,0,0,0,0,fast);
    queue.add(commandStr);   

end