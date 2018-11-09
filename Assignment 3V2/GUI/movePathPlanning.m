function movePathPlanning(bpPath)
    global queue;
    fast = 'v500';
    regular = 'v100';
    slow = 'v50';
    table_height = 147;
    block_height = 5;
    move_height = table_height + block_height * 6;
    grip_height = table_height + block_height;
    
    start = split(bpPath{1,1});
%     start = num2cells(start);
    [x,y] = gameboardConversion(str2num(start{1}(2)),start{1}(1));
    %move to start block position
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', x, y,move_height,0,180,0,fast);
    queue.add(commandStr);

    
    %bring down to 5mm above table height and move along path
    length = size(bpPath{1,:});
    for i = 1:length
        position = split(bpPath{1,i});
        [x,y] = gameboardConversion(str2num(position{1}(2)),position{1}(1));
        commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', x, y,grip_height,0,180,0,fast);
        queue.add(commandStr);
    end
    
    %move ee back up to height above the blocks at the goal position
    commandStr = sprintf('moveerb %.3f %.3f %.3f %.3f %.3f %.3f %s', x, y,move_height,0,180,0,fast);
    queue.add(commandStr);
    
    %% to change in StartMaze function
%     global ppStartLetter ppStartNumber 
%     global ppGoalLetter ppGoalNumber
% 
%     %code to combine letter with number 
%     ppStart = strcat(ppStartLetter, ppStartNumber);
%     ppGoal = strcat(ppGoalLetter,ppGoalNumber);
% 
%     %display the start and end BPs
%     disp(ppStart);
%     disp(ppGoal);
% 
%     %does path planning with start and goal gui inputs
%     ppBpPath = pathPlanning(ppStart, ppGoal);
% 
%     noPath = 'Path not available!';
%     yesPath = 'Path available - moving now!';
% 
%     %checks if there is a path available or not
%     if isempty(ppBpPath)
%         %prints on gui there is no path
%         set(handles.PathPlanningText, 'String', noPath);
%     else
%         %prints on gui there is a path available
%         set(handles.PathPlanningText, 'String', yesPath);
%         %moves robot along path
%         movePathPlanning(ppBpPath);
%     end
end