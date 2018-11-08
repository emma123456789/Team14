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

 
% code = {'A1' 'A2' 'A3' 'A4' 'A5' 'A6'}';
EdgeTable = table([s' t'], ...
    'VariableNames',{'EndNodes'})
G = graph(EdgeTable);

a = [1:9];
x = [a a a a a a a a a];
b = ones(1,9);
y = [b*1 b*2 b*3 b*4 b*5 b*6 b*7 b*8 b*9];

plot(G,'XData',x,'YData',y)

