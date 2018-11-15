% Function moves robot move away from camera by sending a string to
% robotstudio
function Move2Home()
    global queue;
    fast = 'v500';
    regular = 'v100';
    slow = 'v50';
    table_height = 147;
    block_height = 5;
    move_height = table_height + block_height * 6;
    grip_height = table_height + block_height;
    
    %lift block
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', 0,-409,move_height,0,180,0,fast);
    queue.add(commandStr);
    

end