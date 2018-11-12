% %check OG
%  global OG;
% global OGflag;
%  OG = zeros(9,11);
%  OG(1,11) =1;
% %'1' = 49
% %'A' = 65
% %p = 80
%  BP = 'Q1';
%  [OGflag] = CheckOG1(BP);

 function [OGflg] = CheckOG(BP)
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