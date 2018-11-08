function [G_out] = removeNodes(G_original,x, y)
G_out = G_original;
node_number = x+(y-1)*9;
G_out = rmnode(G_out, node_number);
% p = shortestpath(G_out, )



end