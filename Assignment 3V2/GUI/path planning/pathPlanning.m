% start and end being bp position eg 'A1', 'A2' etc
% must have quotation marks

function [p] = pathPlanning(start, goal)
    G = createNodes();
    Gnew = removeNodes(G);
    
    start = char(start);
    goal = char(goal);
    p = shortestpath(Gnew, start, goal);
    %disp(p)
end
