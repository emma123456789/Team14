% This function updates the occupancy grid after each time the simple
% move functions are called.

function [newOG] = UpdateOG(BP)

global OG;
    if length(BP)==2
        
            row =double(BP(2))-48;
    
    if double(BP(1))>=65 && double(BP(1))<=73
        
        column = double(BP(1))-63;
        
    elseif double(BP(1))==80
        
        column = 1;
        
    elseif double(BP(1))==81
        
        column = 11;
        
        
    end
        
        
        
        OG(row,column)=1;
        newOG=OG;
    end
 newOG=OG;
end