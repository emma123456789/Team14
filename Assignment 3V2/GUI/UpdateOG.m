% % %update OG
%  global OG;
%  OG = zeros(9,11);
% % row = 1;
% % column=1;
% BP='A1';
% 
% [newOG] = UpdateOG1(BP);

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

end