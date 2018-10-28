% This funciton calls simple move functions and clears the table.
% Requirements: Move all reachable blocks on the table into an empty box. 
% Up to 16 blocks will be on the table in this case. Blocks may be 
% scattered over the table at locations outside of BP. There is no 
% requirement on where the blocks need to be placed in the box, except 
% see assumption 6.

function CM_ClearTable()
	% Read the block list
    global tableBlockData;
    global BP2Conveyor_index;
    global boxX;
    global boxY;
    boxX = 0;
    boxY = 409;
	
	% Check each block in the table block list
	len = length(tableBlockData);
	for i = 1:len
        BP2Conveyor_index = i;
		stringSplit = strsplit(tableBlockData(i));
		x1 = str2double(stringSplit(1));
        y1 = str2double(stringSplit(2));
        if (isReachable(x1, y1) == true)
            SM_BP2ConveyorModified(x1, y1, boxX, boxY)
            BP2Conveyor_updateBlocklist(boxX,boxY)
        end
        
    end

end

 function reachable = isReachable(x, y)
    %zeroPosition = [805, 25.5943];
    %radius = 832.405697; 
    radius = 548.6;
    
    % Check if block is within reachable radius of robot
    if((x)^2+(y)^2<radius^2)
        reachable = true;
    else
        reachable = false;
    end
end