function [G, pPlot] = createNodes()
    s = [];
    t = [];
    % G = graph([1,2], [2,1])
     for i = 1:9
        for j = 1:8
            %horizontal connections
            s = [s j+(9*(i-1))];
            t = [t j+(9*(i-1))+1];
        end
        if i>1
            for j = 1:9
                %vertical connections
                s = [s j+(9*(i-2))];
                t = [t j+(9*(i-1))];
                %vertical
            end
        end
     end

    EdgeTable = table([s' t'], ...
        'VariableNames',{'EndNodes'});
    
    G = graph(EdgeTable);

    a = [1:9];
    x = [a a a a a a a a a];
    b = ones(1,9);
    y = [b*1 b*2 b*3 b*4 b*5 b*6 b*7 b*8 b*9];

    BP = {'A9' 'B9' 'C9' 'D9' 'E9' 'F9' 'G9' 'H9' 'I9'...
        'A8' 'B8' 'C8' 'D8' 'E8' 'F8' 'G8' 'H8' 'I8'...
        'A7' 'B7' 'C7' 'D7' 'E7' 'F7' 'G7' 'H7' 'I7'...
        'A6' 'B6' 'C6' 'D6' 'E6' 'F6' 'G6' 'H6' 'I6'...
        'A5' 'B5' 'C5' 'D5' 'E5' 'F5' 'G5' 'H5' 'I5'...
        'A4' 'B4' 'C4' 'D4' 'E4' 'F4' 'G4' 'H4' 'I4'...
        'A3' 'B3' 'C3' 'D3' 'E3' 'F3' 'G3' 'H3' 'I3'...
        'A2' 'B2' 'C2' 'D2' 'E2' 'F2' 'G2' 'H2' 'I2'...
        'A1' 'B1' 'C1' 'D1' 'E1' 'F1' 'G1' 'H1' 'I1'}';

    G.Nodes.Name = BP;
    figure;
    pPlot = plot(G,'XData',x,'YData',y);
    
    %%testing
%     bp = {'B1' 'C1' 'D1' 'B2' 'C2' 'D2'};
%     Gnew = rmnode(G, bp);
%     
%     
%     start = char('A1');
%     goal = char('I1');
%     p = shortestpath(Gnew, start, goal);
%     disp(p)
end
   