% start and end being bp position eg 'A1', 'A2' etc
% must have quotation marks
% moveFlag: 0=no path, 1=yes path, 2=start/goal on obstacle, no path 

function [p, moveFlag] = pathPlanning(start, goal)
    [G, pPlot] = createNodes();
    Gnew = removeNodes(G);
    
    start = char(start);
    goal = char(goal);
    
    startIndex = []; 
    goalIndex = [];
    startIndex = findnode(Gnew, {start});
    goalIndex = findnode(Gnew, {goal});
    %startIsObstacle = size(startIndex); %empty if on obstacle
    %goalIsObstacle = size(goalIndex); %empty if on obstacle
    
    if (startIndex == 0) | (goalIndex == 0)
        %means either start/goal is an obstacle
        %and path planning should no longer work
        fprintf('Start/Goal is an obstacle!\n')
        moveFlag = 2;
        p = [];
    else
        %means start and goal bp is not on an obstacle 
        %hence can get shortest path
        p = shortestpath(Gnew, start, goal); %array of bps
        s = size(p); %gives the size of bps
        
        %checks if there is even a path created. If no path, s = 0
        if s == 0
            % robot should not move at all
            fprintf('There is no available path for the robot to move from start to goal.\n')
            moveFlag = 0; %no path
        else
            %robot should then move to start bp above the blocks
            %before lowering itself to height = 5mm above table
            fprintf('Path available... Robot will move now!\n')
            highlight(pPlot,p,'EdgeColor','g')
            moveFlag = 1;
        end
    end
    
    

    
end
