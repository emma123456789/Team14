function [path] = pathPlanning(start, goal)
    G = createNodes();
    Gnew = removeNodes(G);
    
    start = char(start);
    goal = char(goal);
    path = shortestpath(Gnew, start, goal);
    disp(path)
end