%Function sends the appropriate functions to robot studio to move a block
%from one BP to another
function SM_BP2BP(X1, Y1, X2, Y2)
    global queue;
    global done_flag;
    fast = 'v500';
    regular = 'v100';
    slow = 'v50';
    done_flag = 0;
    blockHeight = 15;
    moveHeight = blockHeight * 2.5;
    
    
    %first avoid collision with table
    %WIP
    %WIP
    
    %move to block position
    commandStr = sprintf('moveert %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,moveHeight,0,180,0,fast);
    queue.add(commandStr);
    waitForRobotDone;
    
    %turn on vacuum
    commandStr = sprintf('vacuumPumpOn');
    queue.add(commandStr);
    waitForRobotDone;
    
    %move down to block
    commandStr = sprintf('moveert %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,blockHeight,0,180,0,regular);
    queue.add(commandStr);
    waitForRobotDone;
    
    %turn on solenoid
    commandStr = sprintf('vacuumSolenoidOn');
    queue.add(commandStr);
    waitForRobotDone;
    
    %lift block
    commandStr = sprintf('moveert %.3f %.3f %.3f %.3f %.3f %.3f %s', X1,Y1,moveHeight,0,180,0,fast);
    queue.add(commandStr);
    waitForRobotDone;
    
    %move to new BP
    commandStr = sprintf('moveert %.3f %.3f %.3f %.3f %.3f %.3f %s', X2,Y2,moveHeight,0,180,0,fast);
    queue.add(commandStr);
    waitForRobotDone;
    
    %move down to block
    commandStr = sprintf('moveert %.3f %.3f %.3f %.3f %.3f %.3f %s', X2,Y2,blockHeight,0,180,0,regular);
    queue.add(commandStr);
    waitForRobotDone;
    
    %turn off solenoid
    commandStr = sprintf('vacuumSolenoidOff');
    queue.add(commandStr);
    waitForRobotDone;
    
    %move to calib
    commandStr = sprintf('movejas %.3f %.3f %.3f %.3f %.3f %.3f %s',-90,0,0,0,0,0,fast);
    queue.add(commandStr);
    waitForRobotDone;
    
    
    
    
    
   
    
    
    
    
    
    

end