% This funciton calls simple move functions and clears the table.
% Requirements: Move all reachable blocks on the table into an empty box. 
% Up to 16 blocks will be on the table in this case. Blocks may be 
% scattered over the table at locations outside of BP. There is no 
% requirement on where the blocks need to be placed in the box, except 
% see assumption 6.

function CM_ClearTable()
	% Read the block list
    global tableBlockData;
    x2 = 0;
    y2 = 409;
	
	% Check each block in the table block list
	len = length(tableBlockData);
	for i = 1:len
		stringSplit = strsplit(tableBlockData(i));
		x1 = char(stringSplit(1));
        y1 = char(stringSplit(2));
        SM_BP2ConveyorModified(x1, y1, x2, y2)
    end

end