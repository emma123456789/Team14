% start and end being bp position eg 'A1', 'A2' etc
% must have quotation marks

function [p] = pathPlanning(start, goal)
    [G, pPlot] = createNodes();
    Gnew = removeNodes(G);
    
    start = char(start);
    goal = char(goal);
    p = shortestpath(Gnew, start, goal);
    s = size(p);
    
    if s == 0
        fprintf('There is no available path for the robot to move from start to goal.\n')
        % robot should not move at all
    else
        fprintf('Path available... Robot will move now!\n')
        %robot should then move to start bp above the blocks
        %before lowering itself to height = 5mm above table
        highlight(pPlot,p,'EdgeColor','g')
    end
    
end