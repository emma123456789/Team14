% This function returns the location of the BP in the occupancy grid
% and check if the OG location is occupied.

 function [OGflg,row,column] = CheckOG(BP)
     global OG;
    
    row =double(BP(2))-48;
    
    if double(BP(1))>=65 && double(BP(1))<=73
        
        column = double(BP(1))-63;
        
    elseif double(BP(1))==80
        
        column = 1;
        
    elseif double(BP(1))==81
        
        column = 11;
        
        
    end
    
    if OG(row,column) ==1
        
       OGflg=1; 
    else
       OGflg=0;
    end


 end
